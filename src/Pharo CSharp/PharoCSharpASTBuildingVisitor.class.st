Class {
	#name : #PharoCSharpASTBuildingVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'ast',
		'method',
		'tempVarTypes',
		'methodReturnType',
		'argumentTypes',
		'cascadesRegistry',
		'slotTypes',
		'collectErrors',
		'skipWellKnownErrors',
		'collectedErrors',
		'prefixStatements',
		'temporariesRegistry',
		'blockArgumentTypes',
		'blockInformation',
		'collectedSymbols',
		'exportSymbols'
	],
	#category : 'Pharo CSharp-Visitors'
}

{ #category : #examples }
PharoCSharpASTBuildingVisitor class >> cSharpKeywords [

	"does not include contextual keywords"

	^ #(abstract
as
base
bool
break
byte
case
catch
char
checked
class
const
continue
decimal
default
delegate
do
double
else
enum

event
explicit
extern
false
finally
fixed
float
for
foreach
goto
if
implicit
in
int
interface
internal
is
lock
long

namespace
new
null
object
operator
out
override
params
private
protected
public
readonly
ref
return
sbyte
sealed
short
sizeof
stackalloc

static
string
struct
switch
this
throw
true
try
typeof
uint
ulong
unchecked
unsafe
ushort
using
virtual
void
volatile
while)
]

{ #category : #utility }
PharoCSharpASTBuildingVisitor class >> canBeConstructor: aMethod [ 

	| body return selector | 
	
	(aMethod hasPragmaNamed: #ignoreInCSharp) ifTrue: [ ^ false ].
		
	aMethod method methodClass isClassSide ifFalse: [ ^ false ].
	aMethod ast arguments size < 1 ifTrue: [ ^ false ].
	
	body := aMethod ast body.
	(body statements size = 1) ifFalse: [ ^ false ].	
	return := body statements first.
	return isReturn ifFalse: [ ^ false ].
	return value isCascade ifFalse: [ ^ false ].
	return value receiver isSelfSend ifFalse: [ ^ false ].
	selector := return value receiver selector.
	(#(new basicNew) includes: selector) ifFalse: [ ^ false ].
	
	^ true
	
]

{ #category : #examples }
PharoCSharpASTBuildingVisitor class >> collectAllErrors [

	<script>
	| visitor ast |
	visitor := self new.
	visitor collectErrors: true.
	ast := visitor visitPackage: 'Documaps Commands' asPackage.
	visitor collectedErrors inspect.

	ClyQueryBrowserMorph browseMethods: (visitor collectedErrors collect: [ :each | each key ])
]

{ #category : #examples }
PharoCSharpASTBuildingVisitor class >> collectMethodsWithMultiStatementAssignedBlocks [

	<script>
	| visitor ast remaining |
	visitor := self new.
	visitor collectErrors: true.
	ast := visitor visitPackage: 'Documaps Base Localization' asPackage.
	remaining := visitor collectedErrors select: [ :assoc |
		assoc value messageText = 'The block must have only one statement.'
	] thenCollect: [ :assoc | assoc key ].
	
	ClyQueryBrowserMorph browseMethods: remaining
]

{ #category : #examples }
PharoCSharpASTBuildingVisitor class >> detectBlockTemporaries [

	<script>

	| package collected |
	package := 'Documaps Explorer Commands-Tests' asPackage.
	collected := package methods select: [ :each | 
		each ast blockNodes anySatisfy: [ :block | block temporaries notEmpty ]
		 ].
	ClyQueryBrowserMorph browseMethods: collected.
]

{ #category : #examples }
PharoCSharpASTBuildingVisitor class >> detectDoAsNotStandaloneStatements [

	<script>
	
	| collected |

	collected := RPackageOrganizer default packages  flatCollect: [ :package |
		package methods select: [ :method |
			((method ast allChildren select: [ :each | each isMessage and: [ each selector = #do: ] ])
				select: [ :send | send parent isSequence not ]) notEmpty
		].
	].
	ClyQueryBrowserMorph browseMethods: collected
]

{ #category : #examples }
PharoCSharpASTBuildingVisitor class >> detectInsideDoLoops [

	<script>
	| collected |
	
	collected := RPackageOrganizer default packages flatCollect: [ :package |
		package methods select: [ :method |
			((method ast allChildren select: [ :each | each isMessage and: [ each selector = #do: ] ])
				select: [ :send | send parent isSequence not ]) notEmpty
		].
	].
	ClyQueryBrowserMorph browseMethods: collected
]

{ #category : #examples }
PharoCSharpASTBuildingVisitor class >> detectInstanceAndClassSideCollisions [

	<script>
	
	PharoCSharpObject withAllSubclasses do: [ :cls | 
		| intersection |
		intersection := cls instanceSide selectors intersection: cls classSide selectors.
		intersection ifNotEmpty: [ 
			cls traceCr.
			intersection do: [ :sel |
				'    ' trace. (cls>>sel) name traceCr.
				'    ' trace. (cls class>>sel) name traceCr.
			]	
		]
	]
]

{ #category : #examples }
PharoCSharpASTBuildingVisitor class >> detectKeywordsCollisions [

	<script>

	| package collected |
	package := 'Documaps Base Support' asPackage.	
	collected := package methods select: [ :method | 
		| varCollisions keywordCollisions hasCollisions |
		varCollisions := method allTempAndArgNames intersection: self cSharpKeywords.
		keywordCollisions := method argumentNames size > 1
			ifFalse: [ #() ]
			ifTrue: [ ((self basicNew extraKeywordsAndArgumentsFrom: method ast) collect: #key) intersection: self cSharpKeywords  ].
		hasCollisions := varCollisions notEmpty or: [ keywordCollisions notEmpty ].
		hasCollisions ifTrue: [ 
			method name traceCr.
			varCollisions ifNotEmpty: [ 
				Transcript show: '  Variables collisions: '; show: varCollisions; cr ].
			keywordCollisions ifNotEmpty: [ 
				Transcript show: '  Keyword collisions: '; show: keywordCollisions; cr ]
		].
		hasCollisions
	].
	ClyQueryBrowserMorph browseMethods: collected.
]

{ #category : #examples }
PharoCSharpASTBuildingVisitor class >> detectKeywordsCollisionsWithSymbols [

	<script>

	| package collected |
	package := 'Documaps Base Support' asPackage.	
	collected := package methods select: [ :method | 
		| symbolCollisions hasCollisions symbols |
		symbols := method ast allChildren select: [:each | each isLiteralNode and: [ each value isSymbol ] ].
		symbolCollisions := (symbols collect: [ :each | each value ]) intersection: self cSharpKeywords.
		hasCollisions := symbolCollisions notEmpty.
		hasCollisions ifTrue: [ 
			method name traceCr.
			symbolCollisions ifNotEmpty: [ 
				Transcript show: '  Symbol collisions: '; show: symbolCollisions; cr ].
		].
		hasCollisions
	].
	ClyQueryBrowserMorph browseMethods: collected.
]

{ #category : #examples }
PharoCSharpASTBuildingVisitor class >> detectNonlocalReturnsTemporaries [

	<script>

	| package collected |
	package := 'Documaps Items' asPackage.
	collected := package methods select: [ :each | 
		PharoCSharpASTBuildingVisitor new hasForbiddenNonlocalReturn: each ].

	ClyQueryBrowserMorph browseMethods: collected.
]

{ #category : #examples }
PharoCSharpASTBuildingVisitor class >> detectTempNamesReusage [

	<script>

	| package collected |
	package := 'Documaps Tasks' asPackage.
	collected := package methods select: [ :method | 
		| names |
		names := 
			(method ast arguments collect: [ :each | each name ])
			, (method ast temporaries collect: [ :each | each name ])
			, ((method ast allChildren asIdentitySet asArray select: [ :each | each isBlock ]) 
				flatCollect: [ :eachBlock | eachBlock arguments collect: [ :arg | arg name ] ]).
		names size ~= names asSet size.
		 ].
	ClyQueryBrowserMorph browseMethods: collected.
]

{ #category : #examples }
PharoCSharpASTBuildingVisitor class >> detectTempNamesReusageInspectFirst [

	<script>

	| package firstFound badNames |
	package := 'Documaps Tasks' asPackage.
	badNames := OrderedCollection new.
	firstFound := package methods detect: [ :method | 
		| names namesBag hasCountGt1 |
		
	"	method = (PdmTask>>#run) ifTrue: [ self halt]."
		names := 
			(method ast arguments collect: [ :each | each name ])
			, (method ast temporaries collect: [ :each | each name ])
			, ((method ast allChildren asIdentitySet asArray select: [ :each | each isBlock ]) 
				flatCollect: [ :eachBlock | eachBlock arguments collect: [ :arg | arg name ] ]).
			
		namesBag := names asBag.
		hasCountGt1 := false.
		namesBag doWithOccurrences: [ :v :count | 
			count > 1 ifTrue: [ 
				hasCountGt1 := true.
				badNames add: v -> count
			] 
		].
		hasCountGt1
	] ifNone: [ ^ nil].
	badNames inspect.
	ClyQueryBrowserMorph browseMethods: { firstFound }.
]

{ #category : #examples }
PharoCSharpASTBuildingVisitor class >> detectUnknownNewTypes [

	<script>
	| package classes potential problems |
	package := 'Documaps Glorp' asPackage.
	classes := { Collection. Association }.

	potential := package methods flatCollect: [ :m |
		(m ast allChildren select: [ :e | e isMessage and: [ e selector = #new ]])
			select: [ :node | 
				node receiver isVariable
				and: [ classes anySatisfy: [ :superclass |
					| aClass |
					aClass := node receiver value variable value.
					aClass isClass and: [ 
					superclass = aClass or: [ aClass inheritsFrom: superclass ] ] ] ] ]].

	problems := (potential reject: [ :n | n parent isAssignment or: [ n parent isReturn ]  ]).
	problems inspect.
	ClyQueryBrowserMorph browseMethods: (problems collect: [ :e | e methodNode method ] as: Set).

]

{ #category : #utility }
PharoCSharpASTBuildingVisitor class >> isConstructor: aMethod [ 

	(aMethod hasPragmaNamed: #constructor) ifFalse: [ ^ false ].
	
	^ self canBeConstructor: aMethod
]

{ #category : #private }
PharoCSharpASTBuildingVisitor >> acceptFirstArgumentStatementsOf: aMessageNode [

	| statements result |
	statements := aMessageNode arguments first body statements.
	statements ifEmpty: [ ^  PharoCSharpSimpleExpressionNode null ].
	statements do: [ :each | each mustBeExpression].
	
	result := statements first acceptVisitor: self.
	^ result
]

{ #category : #private }
PharoCSharpASTBuildingVisitor >> acceptSecondArgumentStatementsOf: aMessageNode [

	| statements result |
	statements := aMessageNode arguments second body statements.
	statements ifEmpty: [ ^ PharoCSharpSimpleExpressionNode null ].
	statements do: [ :each | each mustBeExpression].

	result := statements first acceptVisitor: self.
	result.
	^ result
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> addPrefixStatement: aStatement [

	prefixStatements last add: aStatement
]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> ast [

	^ ast
]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> ast: anObject [

	ast := anObject
]

{ #category : #private }
PharoCSharpASTBuildingVisitor >> block: blockNode receiver: receiver do: block [

	"if given block node has no arguments, pass the receiver to `block`, else pass a temporary variable reference created by a prefix statement"

	| arguments |
	
	self checkIsBlockWithOneStatement: blockNode.
	arguments := self checkedArgumentsOfBlock: blockNode.
	
	^ arguments 
		ifEmpty: [ block value: receiver ] 
		ifNotEmpty: [ 
			self addPrefixStatement: (PharoCSharpInferredVariableAssignmentNode new
					name: arguments first name;
					expression: receiver).
			block value: (PharoCSharpSimpleExpressionNode new content: arguments first name) ]

]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> blockNumber: blockNumber returnsValue: aBoolean [

	| allBlocks blockNode type | 
	
	allBlocks := (method ast allChildren select: [ :each | each isBlock ]) sorted: [ :a :b | a left <= b left ].

	blockNode := (allBlocks at: blockNumber).
	type := RuntimeTypeCollectorBlockType new wasUsed: aBoolean. "stub"
	
	blockInformation at: blockNode put: type.
]

{ #category : #utility }
PharoCSharpASTBuildingVisitor >> blockReturnTypeOrNilOf: aBlockNode [ 

	| statements definition |
	statements := aBlockNode statements.
	statements size < 1 ifTrue: [ ^ nil ].
	
	definition := statements first.
	definition isLiteralArray ifFalse: [ ^ nil ].
	definition isLiteralArray ifFalse: [ ^ nil ].
	
	definition value first = #returns: ifFalse: [ ^ nil ].

	^ SchmidtTypeCollectorType fromLiteral: definition value allButFirst.
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> blockReturnsValue: aBlockNode [ 

	(aBlockNode parent isMessage and: [ RuntimeTypeCollector wellKnownReturningBlockMessages includes: aBlockNode parent originalSelector]) 
		ifTrue: [ ^ true ].

	(aBlockNode parent isMessage and: [ RuntimeTypeCollector wellKnownNotReturningBlockMessages includes: aBlockNode parent originalSelector]) 
		ifTrue: [ ^ false ].

	^ (blockInformation at: aBlockNode ifAbsent: [ ^ false ])
		wasUsed
]

{ #category : #private }
PharoCSharpASTBuildingVisitor >> canExportClass: aClass [ 

	aClass isTrait ifTrue: [ 
		^ (aClass classSide includesSelector: #ignoreInCSharp) not
	].

	(((aClass inheritsFrom: PharoCSharpObject) or: [ aClass inheritsFrom: PharoCSharpObject class ]) 
		or: [ (aClass = PharoCSharpObject) or: [ aClass = PharoCSharpObject class ] ]) ifFalse: [ ^ false ].

	^ aClass withAllSuperclasses noneSatisfy: [ :each | 
		each classSide includesSelector: #ignoreInCSharp ]
]

{ #category : #private }
PharoCSharpASTBuildingVisitor >> canExportMethod: aMethod [ 

	aMethod selector = #'_slotTypes' ifTrue: [ ^ false ].

	^ (aMethod hasPragmaNamed: #ignoreInCSharp) not
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> cascadeFrom: aRBCascadeNode name: name [

	| receiver statements |

	receiver := aRBCascadeNode messages first receiver.
	
	statements := aRBCascadeNode messages
		reject: [ :aMessageNode |
			"skip yourself"
			aMessageNode selector = #yourself.
		] thenCollect: [ :aMessageNode |
		| messageSend |
		messageSend := self messageSendFrom: aMessageNode receiver: (PharoCSharpSimpleExpressionNode new content: name).
		PharoCSharpExpressionStatementNode new expression: messageSend.
	].
	
	^ (PharoCSharpCascadeNode from: aRBCascadeNode)
		name: name;
		expression: (receiver acceptVisitor: self);
		statements: statements;
		yourself

]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> cascadeStatementsFrom: statement [

	| cascadeStatements cascades |
	cascadeStatements := OrderedCollection new.
	cascades := statement allChildrenWithoutBlocks reversed select: [ :each | each isCascade ].
	cascades do: [ :each | 
		| cascadeName |
		cascadeName := self newCascadeName.
		cascadesRegistry at: cascadeName put: each.
		each propertyAt: #cascadeName put: cascadeName.
		cascadeStatements add: (self cascadeFrom: each name: cascadeName) ].
	^  cascadeStatements
]

{ #category : #private }
PharoCSharpASTBuildingVisitor >> checkBothBlocksOf: aMessageNode [ 

	self checkIsBlockWithOneStatement: aMessageNode arguments first.
	self checkIsBlockWithOneStatement: aMessageNode arguments second.

]

{ #category : #private }
PharoCSharpASTBuildingVisitor >> checkFirstBlockOf: aMessageNode [ 

	self checkIsBlockWithOneStatement: aMessageNode arguments first.

]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> checkIsBlockWithOneStatement: aNode [

	aNode isBlock ifFalse: [ self error: 'The first argument must be a block.' ].
	aNode statements ifEmpty: [ ^ self ].
"	aNode statements size = 1 ifFalse: [ self error: 'The block must have only one statement.' ]."

]

{ #category : #private }
PharoCSharpASTBuildingVisitor >> checkedArgumentsOfBlock: aBlock [ 

	| arguments |
	arguments := aBlock arguments.
	arguments size > 1 ifTrue: [ self error: 'Too many arguments' ].
	^ arguments
]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> collectErrors [

	^ collectErrors
]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> collectErrors: anObject [

	collectErrors := anObject.
	skipWellKnownErrors := anObject not.
]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> collectedErrors [

	^ collectedErrors
]

{ #category : #private }
PharoCSharpASTBuildingVisitor >> collectionMessage: aMessageNode receiver: receiver do: aBlock [

 	| name |
	self checkFirstBlockOf: aMessageNode.
	name := self newTemporary.
	self addPrefixStatement: (PharoCSharpInferredVariableAssignmentNode new
		name: name;
		expression: receiver).

	^ aBlock value: name

]

{ #category : #'rewrite statements' }
PharoCSharpASTBuildingVisitor >> containsNonlocalReturns: aMessageNode [

	^ (aMessageNode receiver allChildren anySatisfy: [ :n | n isReturn ]) or: [ 
	(aMessageNode arguments anySatisfy: [ :arg | arg allChildren anySatisfy: [ :n | n isReturn ] ])]
		

]

{ #category : #private }
PharoCSharpASTBuildingVisitor >> convertSelector: aSelector [ 

	| s |
	
	s := self keywordsMapping at: aSelector ifAbsent: [ aSelector ].
	s := s copyUpTo: $:.
	^ s capitalized asSymbol
	
]

{ #category : #'rewrite statements' }
PharoCSharpASTBuildingVisitor >> convertToStatements: aMessageNode receiver: receiver [ 

	"return nil if the conversion is not possible"
	
	| null mustBeExpression receiverType |
	
	receiverType := receiver isSimpleExpression
		ifTrue: [ self knownTypeFor: receiver content ]
		ifFalse: [ nil ].

	mustBeExpression := aMessageNode declaresMustBeExpression.
	mustBeExpression ifTrue: [ 
		^ self convertToTernary: aMessageNode receiver: receiver ].
	
	null := PharoCSharpSimpleExpressionNode null.

	aMessageNode selector = #ifTrue:
		ifTrue: [ 
			^ (PharoCSharpIfStatementNode from: aMessageNode)  
				booleanExpression: receiver;
				ifStatements: (aMessageNode arguments first body acceptVisitor: self)
	].

	aMessageNode selector = #ifFalse:
		ifTrue: [ 
			receiver hasParentheses: true.
			^ (PharoCSharpIfStatementNode from: aMessageNode) 
				booleanExpression: (PharoCSharpUnaryExpressionNode new operator: '!'; expression: receiver);
				ifStatements: (aMessageNode arguments first body acceptVisitor: self)
	].

	aMessageNode selector = #ifTrue:ifFalse:
		ifTrue: [ 
			^ (PharoCSharpIfElseStatementNode  from: aMessageNode) 
				booleanExpression: receiver;
				ifStatements: (aMessageNode arguments first body acceptVisitor: self);
				elseStatements: (aMessageNode arguments second body acceptVisitor: self)
	].
	
	aMessageNode selector = #ifFalse:ifTrue:
		ifTrue: [ 
			^ (PharoCSharpIfElseStatementNode from: aMessageNode) 
				booleanExpression: (PharoCSharpUnaryExpressionNode new operator: '!'; expression: receiver);
				ifStatements: (aMessageNode arguments second body acceptVisitor: self);
				elseStatements: (aMessageNode arguments first body acceptVisitor: self)
	].

	aMessageNode selector = #ifNil:
		ifTrue: [ 
			^ (PharoCSharpIfStatementNode from: aMessageNode) 
				booleanExpression: (PharoCSharpBinaryExpressionNode new operator: '=='; leftExpression: receiver; rightExpression: null; hasParentheses: true);
				ifStatements: (aMessageNode arguments first body acceptVisitor: self)
	].

	aMessageNode selector = #ifNotNil:
		ifTrue: [ 
			| arguments |
			arguments := aMessageNode arguments first arguments.
			arguments ifEmpty: [ 
				^ (PharoCSharpIfStatementNode  from: aMessageNode) 
					booleanExpression: (PharoCSharpBinaryExpressionNode new operator: '!='; leftExpression: receiver; rightExpression: null; hasParentheses: true);
					ifStatements: (aMessageNode arguments first body acceptVisitor: self) ].
			arguments size > 1 ifTrue: [ self error: 'Too many arguments' ].
			^ PharoCSharpIfWithVariableStatementNode new 
					name: arguments first name;
					valueExpression: receiver;
					booleanExpression: (PharoCSharpBinaryExpressionNode new operator: '!='; leftExpression: (PharoCSharpSimpleExpressionNode new content: arguments first name); rightExpression: null; hasParentheses: true);
					ifStatements: (aMessageNode arguments first body acceptVisitor: self).	
	].

	aMessageNode selector = #ifNotNil:ifNil:
		ifTrue: [ 
			| arguments |
			arguments := aMessageNode arguments first arguments.
			arguments ifEmpty: [
				^ (PharoCSharpIfElseStatementNode from: aMessageNode) 
					booleanExpression: (PharoCSharpBinaryExpressionNode new operator: '!='; leftExpression: receiver; rightExpression: null; hasParentheses: true);
					ifStatements: (aMessageNode arguments first body acceptVisitor: self);
					elseStatements: (aMessageNode arguments second body acceptVisitor: self) ].
			arguments size > 1 ifTrue: [ self error: 'Too many arguments' ].
			^ (PharoCSharpIfElseWithVariableStatementNode from: aMessageNode) 
					name: arguments first name;
					valueExpression: receiver;
					booleanExpression: (PharoCSharpBinaryExpressionNode new operator: '!='; leftExpression: (PharoCSharpSimpleExpressionNode new content: arguments first name); rightExpression: null; hasParentheses: true);
					ifStatements: (aMessageNode arguments first body acceptVisitor: self);
					elseStatements: (aMessageNode arguments second body acceptVisitor: self).		
	].

	aMessageNode selector = #ifNil:ifNotNil:
		ifTrue: [ 
			| arguments |
			arguments := aMessageNode arguments second arguments.
			arguments ifEmpty: [			
				^ (PharoCSharpIfElseStatementNode from: aMessageNode) 
					booleanExpression: (PharoCSharpBinaryExpressionNode new operator: '=='; leftExpression: receiver; rightExpression: null; hasParentheses: true);
					ifStatements: (aMessageNode arguments first body acceptVisitor: self);
					elseStatements: (aMessageNode arguments second body acceptVisitor: self) ].
			arguments size > 1 ifTrue: [ self error: 'Too many arguments' ].
			^ PharoCSharpIfElseWithVariableStatementNode new 
					name: arguments first name;
					valueExpression: receiver;
					booleanExpression: (PharoCSharpBinaryExpressionNode new operator: '=='; leftExpression: (PharoCSharpSimpleExpressionNode new content: arguments first name); rightExpression: null);
					ifStatements: (aMessageNode arguments first body acceptVisitor: self);
					elseStatements: (aMessageNode arguments second body acceptVisitor: self).						
	].

	aMessageNode selector = #ifEmpty:
		ifTrue: [ 
			^ (PharoCSharpIfStatementNode from: aMessageNode) 
				booleanExpression: (PharoCSharpUnaryExpressionNode new operator: '!'; expression: (PharoCSharpMessageSendNode new receiver: receiver; name: 'Any'));
				ifStatements: (aMessageNode arguments first body acceptVisitor: self)
	].

	aMessageNode selector = #ifNotEmpty:
		ifTrue: [ 
			| arguments |
			arguments := aMessageNode arguments first arguments.
			arguments ifEmpty: [ 
				^ (PharoCSharpIfStatementNode from: aMessageNode) 
					booleanExpression: (PharoCSharpMessageSendNode new receiver: receiver; name: 'Any');
					ifStatements: (aMessageNode arguments first body acceptVisitor: self) ].
			arguments size > 1 ifTrue: [ self error: 'Too many arguments' ].
			^ PharoCSharpIfWithVariableStatementNode new 
					name: arguments first name;
					valueExpression: receiver;
					booleanExpression: (PharoCSharpMessageSendNode new receiver: (PharoCSharpSimpleExpressionNode new content: arguments first name); name: 'Any');
					ifStatements: (aMessageNode arguments first body acceptVisitor: self).	
	].

	aMessageNode selector = #ifEmpty:ifNotEmpty:
		ifTrue: [ 
			| arguments |
			arguments := aMessageNode arguments second arguments.
			arguments ifEmpty: [ 
				^ (PharoCSharpIfElseStatementNode from: aMessageNode)
					booleanExpression: (PharoCSharpUnaryExpressionNode new operator: '!'; expression: (PharoCSharpMessageSendNode new receiver: receiver; name: 'Any'));
					ifStatements: (aMessageNode arguments first body acceptVisitor: self);
					elseStatements: (aMessageNode arguments second body acceptVisitor: self) ].
			arguments size > 1 ifTrue: [ self error: 'Too many arguments' ].
			^ (PharoCSharpIfElseWithVariableStatementNode from: aMessageNode) 
					name: arguments first name;
					valueExpression: receiver;
					booleanExpression: (PharoCSharpUnaryExpressionNode new operator: '!'; expression: (PharoCSharpMessageSendNode new receiver: (PharoCSharpSimpleExpressionNode new content: arguments first name); name: 'Any'));
					ifStatements: (aMessageNode arguments first body acceptVisitor: self);
					elseStatements: (aMessageNode arguments second body acceptVisitor: self).				
	].

	aMessageNode selector = #ifNotEmpty:ifEmpty:
		ifTrue: [ 
			| arguments |
			arguments := aMessageNode arguments first arguments.
			arguments ifEmpty: [ 
				^ (PharoCSharpIfElseStatementNode from: aMessageNode)
					booleanExpression: (PharoCSharpMessageSendNode new receiver: receiver; name: 'Any');
					ifStatements: (aMessageNode arguments first body acceptVisitor: self);
					elseStatements: (aMessageNode arguments second body acceptVisitor: self) ].
			arguments size > 1 ifTrue: [ self error: 'Too many arguments' ].
			^ (PharoCSharpIfElseWithVariableStatementNode from: aMessageNode) 
					name: arguments first name;
					valueExpression: receiver;
					booleanExpression: (PharoCSharpMessageSendNode new receiver: (PharoCSharpSimpleExpressionNode new content: arguments first name); name: 'Any');
					ifStatements: (aMessageNode arguments first body acceptVisitor: self);
					elseStatements: (aMessageNode arguments second body acceptVisitor: self).							
	].

	aMessageNode selector = #on:do:
		ifTrue: [ 
			| name |
			name := aMessageNode arguments second arguments 
				ifEmpty: [ nil ]
				ifNotEmpty: [ :args | aMessageNode arguments second arguments first name ].
			^ (PharoCSharpTryCatchStatementNode  from: aMessageNode) 
				exceptionName: name;
				tryStatements: (receiver statements);
				catchStatements: (aMessageNode arguments second body acceptVisitor: self);
				exceptionType: (aMessageNode arguments first acceptVisitor: self)
	].


	aMessageNode selector = #ifError:
		ifTrue: [ 
			^ (PharoCSharpIfStatementNode from: aMessageNode) 
				booleanExpression: (PharoCSharpMessageSendNode new receiver: receiver; name: 'hasError');
				ifStatements: (aMessageNode arguments first body acceptVisitor: self)
	].

	aMessageNode selector = #do:
		ifTrue: [ 
			| name |
			name := (aMessageNode arguments first arguments first name).
			^ (PharoCSharpForeachStatementNode from: aMessageNode) 
				name: name;
				type: (self typeStringOf: (blockArgumentTypes at: name ifAbsent: [#()] ));
				collectionExpression: receiver;
				statements: (aMessageNode arguments first body acceptVisitor: self)
	].

	((aMessageNode selector = #withIndexDo:) or: [ aMessageNode selector = #doWithIndex: ])
		ifTrue: [ 
			| name indexName |
			receiver isSimpleExpression ifFalse: [ self error: 'withIndexDo: and doWithIndex: must be called on a simple expression without side-effects' ].
			name := (aMessageNode arguments first arguments first name).
			indexName := (aMessageNode arguments first arguments second name).
			^ (PharoCSharpForWithObjectStatementNode from: aMessageNode) 
				name: name;
				type: (self typeStringOf: (blockArgumentTypes at: name ifAbsent: [#()]));
				indexName: indexName;
				indexType: (self typeStringOf: (blockArgumentTypes at: indexName ifAbsent: [#()]));
				collectionExpression: receiver;
				statements: (aMessageNode arguments first body acceptVisitor: self)
	].

	((aMessageNode selector = #keysAndValuesDo:) and: [ receiverType notNil and: [ self receiverTypeIsDictionary: receiverType ] ])
		ifTrue: [ 
			| name keyName |
			receiver isSimpleExpression ifFalse: [ self error: 'keysAndValuesDo: must be called on a simple expression without side-effects' ].
			keyName := (aMessageNode arguments first arguments first name).
			name := (aMessageNode arguments first arguments second name).
			^ (PharoCSharpForEachKVPStatementNode from: aMessageNode) 
				name: name;
				type: (self typeStringOf: (blockArgumentTypes at: name ifAbsent: [#()]));
				keyName: keyName;
				keyType: (self typeStringOf: (blockArgumentTypes at: keyName ifAbsent: [#()]));
				collectionExpression: receiver;
				statements: (aMessageNode arguments first body acceptVisitor: self)
	].

	aMessageNode selector = #whileTrue:
		ifTrue: [ 
			self assert: (aMessageNode receiver isBlock).
			self assert: (aMessageNode receiver statements size = 1).
			^ (PharoCSharpWhileStatementNode from: aMessageNode) 
				booleanExpression: (aMessageNode receiver statements first acceptVisitor: self);
				statements: (aMessageNode arguments first body acceptVisitor: self)
	].

	((aMessageNode selector = #at:ifPresent:) and: [ aMessageNode arguments second allChildren anySatisfy: [ :each | each isReturn ]  ])
		ifTrue: [ 
			^ (PharoCSharpAtIfPresentIfAbsentStatementNode from: aMessageNode)
				receiverExpression: (aMessageNode receiver acceptVisitor: self);
				atExpression: (aMessageNode arguments first acceptVisitor: self);
				ifPresentStatements: (aMessageNode arguments second body acceptVisitor: self);
				ifPresentArgName: (aMessageNode arguments second arguments ifEmpty: [nil] ifNotEmpty: [ :args | args first name]);
				ifPresentArgType: (aMessageNode arguments second arguments ifEmpty: [nil] ifNotEmpty: [ :args | 
					self typeStringOf: (blockArgumentTypes at: args first name ifAbsent: [#()])
				]).
	].

	^ nil
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> convertToTernary: aMessageNode receiver: receiver [

	| null |
	
	null := PharoCSharpSimpleExpressionNode null.
	
	aMessageNode selector = #ifTrue:ifFalse:
		ifTrue: [ 
			self checkBothBlocksOf: aMessageNode.
			^ (PharoCSharpTernaryExpressionNode from: aMessageNode) 
				booleanExpression: receiver;
				ifExpression: (self acceptFirstArgumentStatementsOf: aMessageNode);
				elseExpression: (self acceptSecondArgumentStatementsOf: aMessageNode).
		].

	aMessageNode selector = #ifFalse:ifTrue:
		ifTrue: [ 
			self checkBothBlocksOf: aMessageNode.
			^ (PharoCSharpTernaryExpressionNode from: aMessageNode) 
				booleanExpression: receiver;
				ifExpression: (self acceptSecondArgumentStatementsOf: aMessageNode);
				elseExpression: (self acceptFirstArgumentStatementsOf: aMessageNode).
		].

	aMessageNode selector = #ifTrue:
		ifTrue: [ 
			self checkFirstBlockOf: aMessageNode.
			^ (PharoCSharpTernaryExpressionNode from: aMessageNode) 
				booleanExpression: receiver;
				ifExpression: (self acceptFirstArgumentStatementsOf: aMessageNode);
				elseExpression: null.
		].

	aMessageNode selector = #ifFalse:
		ifTrue: [ 
			self checkFirstBlockOf: aMessageNode.
			^ (PharoCSharpTernaryExpressionNode from: aMessageNode) 
				booleanExpression: receiver;
				ifExpression: null;
				elseExpression: (self acceptFirstArgumentStatementsOf: aMessageNode)
		].
	
	aMessageNode selector = #ifNil:
		ifTrue: [ 
			self checkFirstBlockOf: aMessageNode.
			^ (PharoCSharpNullCoalescingExpressionNode from: aMessageNode) 
				receiver: receiver;
				nullExpression: (self acceptFirstArgumentStatementsOf: aMessageNode)
		].

	aMessageNode selector = #ifNotNil:
		ifTrue: [ 
			^ self 
				block: aMessageNode arguments first
				receiver: receiver
				do: [ :receiverOrTempVar |
					(PharoCSharpTernaryExpressionNode from: aMessageNode) 
						booleanExpression: (PharoCSharpBinaryExpressionNode new leftExpression: receiverOrTempVar; operator: '=='; rightExpression: null; hasParentheses: true);
						ifExpression: null;
						elseExpression: (self acceptFirstArgumentStatementsOf: aMessageNode ) 
				].
		].
	
	aMessageNode selector = #ifNotNil:ifNil:
		ifTrue: [ 
			^ self 
				block: aMessageNode arguments first
				receiver: receiver
				do: [ :receiverOrTempVar |
					(PharoCSharpTernaryExpressionNode from: aMessageNode) 
						booleanExpression: (PharoCSharpBinaryExpressionNode new leftExpression: receiverOrTempVar; operator: '!='; rightExpression: null; hasParentheses: true);
						ifExpression: (self acceptFirstArgumentStatementsOf: aMessageNode);
						elseExpression: (self acceptSecondArgumentStatementsOf: aMessageNode) 
				].
		].

	aMessageNode selector = #ifNil:ifNotNil:
		ifTrue: [ 
			^ self 
				block: aMessageNode arguments second
				receiver: receiver
				do: [ :receiverOrTempVar |
					(PharoCSharpTernaryExpressionNode from: aMessageNode)
						booleanExpression: (PharoCSharpBinaryExpressionNode new leftExpression: receiverOrTempVar; operator: '=='; rightExpression: null; hasParentheses: true);
						ifExpression: (self acceptFirstArgumentStatementsOf: aMessageNode);
						elseExpression: (self acceptSecondArgumentStatementsOf: aMessageNode)
				].
		].		
			
	aMessageNode selector = #ifEmpty:ifNotEmpty:
		ifTrue: [ 
			^ self 
				block: aMessageNode arguments second
				receiver: receiver
				do: [ :receiverOrTempVar |
					(PharoCSharpTernaryExpressionNode from: aMessageNode)
						booleanExpression: (PharoCSharpUnaryExpressionNode new operator: '!'; expression: (PharoCSharpMessageSendNode new receiver: receiverOrTempVar; name: 'Any'));
						ifExpression: (self acceptFirstArgumentStatementsOf: aMessageNode);
						elseExpression: (self acceptSecondArgumentStatementsOf: aMessageNode).
				].
		].		
			
	aMessageNode selector = #ifEmpty:
		ifTrue: [ 
			^ self  
				collectionMessage: aMessageNode
				receiver: receiver 
				do: [ :name |
					(PharoCSharpTernaryExpressionNode from: aMessageNode)
						booleanExpression: (PharoCSharpUnaryExpressionNode new operator: '!'; expression: (PharoCSharpMessageSendNode new receiver: (PharoCSharpSimpleExpressionNode new content: name); name: 'Any'));
						ifExpression: (self acceptFirstArgumentStatementsOf: aMessageNode);
						elseExpression: (PharoCSharpSimpleExpressionNode new content: name). 
				].
		].
		
	aMessageNode selector = #ifNotEmpty:
		ifTrue: [ 
			^ self  
				collectionMessage: aMessageNode
				receiver: receiver 
				do: [ :name |
					(PharoCSharpTernaryExpressionNode from: aMessageNode)
						booleanExpression: (PharoCSharpMessageSendNode new receiver: (PharoCSharpSimpleExpressionNode new content: name); name: 'Any');
						ifExpression: (self acceptFirstArgumentStatementsOf: aMessageNode);
						elseExpression: (PharoCSharpSimpleExpressionNode new content: name)
				].
		].
		
	aMessageNode selector = #ifEmpty:ifNotEmpty:
		ifTrue: [ 
			^ self 
				block: aMessageNode arguments second
				receiver: receiver
				do: [ :receiverOrTempVar |
					(PharoCSharpTernaryExpressionNode from: aMessageNode)
						booleanExpression: (PharoCSharpUnaryExpressionNode new operator: '!'; expression: (PharoCSharpMessageSendNode new receiver: receiverOrTempVar; name: 'Any'));
						ifExpression: (self acceptFirstArgumentStatementsOf: aMessageNode);
						elseExpression: (self acceptSecondArgumentStatementsOf: aMessageNode).
				].
		].		

	aMessageNode selector = #ifNotEmpty:ifEmpty:
		ifTrue: [ 
			^ self 
				block: aMessageNode arguments first
				receiver: receiver
				do: [ :receiverOrTempVar |
					(PharoCSharpTernaryExpressionNode from: aMessageNode)
						booleanExpression: (PharoCSharpMessageSendNode new receiver: receiverOrTempVar; name: 'Any');
						ifExpression: (self acceptFirstArgumentStatementsOf: aMessageNode);
						elseExpression: (self acceptSecondArgumentStatementsOf: aMessageNode).
				].
		].	


	^ nil
	
		
]

{ #category : #utility }
PharoCSharpASTBuildingVisitor >> detectConstructorsOf: aClass [ 

	^ aClass classSide methods select: [ :aMethod | self class isConstructor: aMethod ]
	
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> exportSymbolsTo: fileNode [

	collectedSymbols ifNotEmpty: [ 
		fileNode addChild: (
			PharoCSharpEnumNode new 
				name: 'Symbol';
				values: collectedSymbols sorted)
	].
]

{ #category : #private }
PharoCSharpASTBuildingVisitor >> extraKeywordsAndArgumentsFrom: aMethodNode [

	| sel keywords all |

	sel := aMethodNode selector.
	keywords := self keywordsFor: sel.

	all := keywords with: aMethodNode arguments collect: [ :keyword :arg | 
		(keyword withoutSuffix: ':') -> arg
	].

	^ all allButFirst

]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> findFirstNonInitialUppercaseOf: aString [
    | firstNonUpperIndex |
    firstNonUpperIndex := 1.

    aString do: [:char | 
        (char isUppercase) ifTrue: [firstNonUpperIndex := firstNonUpperIndex + 1] ifFalse: [^firstNonUpperIndex]].

    (firstNonUpperIndex to: aString size) do: [:index | 
        (aString at: index) isUppercase ifTrue: [^index]].

    ^0
]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> hasForbiddenNonlocalReturn: aMethod [

	| returns |
	
	returns := aMethod ast allChildren select: [ :e | e isReturn ].
	
	^ returns anySatisfy: [ :return |
		| allowed blockOrMethod |
		blockOrMethod := return methodOrBlockNode.
		allowed := (blockOrMethod parent isNil or: [blockOrMethod parent isMethod])
		or: [ 	(blockOrMethod parent isMessage and: [ self statementSelectors includes: blockOrMethod parent selector ] )].
		allowed not ]
]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> initialize [ 

	super initialize.
	
	collectErrors := false.
	collectedErrors := OrderedCollection new.
	blockInformation := Dictionary new.
	skipWellKnownErrors := false.
	collectedSymbols := IdentitySet new.
	exportSymbols := false.
]

{ #category : #testing }
PharoCSharpASTBuildingVisitor >> isAllowedBinarySelector: aSelector [ 

	^ #(+ - * / , = > < <= >= == // \\ ~= ~~) includes: aSelector
]

{ #category : #utility }
PharoCSharpASTBuildingVisitor >> isConstructor: aMethod [ 
	^ self class isConstructor: aMethod 
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> isOverride: aMethodNode [

	| parentMethod |
	aMethodNode compiledMethod methodClass isTrait ifTrue: [ ^ false ].

	parentMethod := aMethodNode compiledMethod methodClass superclass
		                lookupSelector: aMethodNode compiledMethod selector.
	parentMethod ifNil: [ ^ false ].

	^ self canExportClass: parentMethod methodClass
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> isVirtual: aMethodNode [

	aMethodNode compiledMethod methodClass isClassSide ifTrue: [ ^ false ].

	^ aMethodNode compiledMethod isOverridden and: [
		  (self isOverride: aMethodNode) not ]
]

{ #category : #utility }
PharoCSharpASTBuildingVisitor >> keywordsFor: aSelector [ 

	| newSelector | 
		
	newSelector := self keywordsMapping at: aSelector ifAbsent: [ aSelector ].
	
	^ newSelector keywordsStrict collect: [ :keywordPart |
		(self class cSharpKeywords includes: (keywordPart withoutSuffix: ':'))
			ifTrue: [ ('@', keywordPart) asSymbol ] 
			ifFalse: [ keywordPart ]
	]
]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> keywordsMapping [

	^ Dictionary newFrom: {
		#at:putIfNotNil: -> #at_:putIfNotNil:.
	}.

]

{ #category : #utility }
PharoCSharpASTBuildingVisitor >> knownTypeFor: varName [ 

	blockArgumentTypes at: varName ifPresent: [ :type | ^ type ].
	tempVarTypes at: varName ifPresent: [ :type | ^ type ].
	argumentTypes at: varName ifPresent: [ :type | ^ type ].
	slotTypes ifNotNil: [ 
		"slotTypes may be nil if we translate only a single method withot its class context"
		slotTypes at: varName ifPresent: [ :type | ^ type ].
	].
	
	^ nil
	
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> messageSendFrom: aMessageNode receiver: receiver [

	(self rewriteMessageSend: aMessageNode receiver: receiver)
		ifNotNil: [ :node | ^ node ].
	
	^ self 
		privMessageSend: aMessageNode selector
		receiver: receiver 
		node: aMessageNode 
		arguments: aMessageNode arguments
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> methodArgumentNames: aMethodNode [ 

	"for sending of constructors"

	| result args hasExtraKeywords extraKeywordsAndArguments |
	
	args := aMethodNode arguments.
	result := OrderedCollection new.

	(args first: (1 min: args size)) do: [ :arg | 
		result add: (PharoCSharpSimpleExpressionNode new content: arg variable name) ].
	
	hasExtraKeywords := args size > 1.
	
	hasExtraKeywords ifTrue: [ 
		extraKeywordsAndArguments := self extraKeywordsAndArgumentsFrom: aMethodNode.
		extraKeywordsAndArguments do: [ :keywordToArg |
			result add: (PharoCSharpSimpleExpressionNode new content: keywordToArg value variable name) ]
	].
	^ result.

]

{ #category : #utility }
PharoCSharpASTBuildingVisitor >> methodReturnsVoid [ 

	^ methodReturnType size = 1 and: [ methodReturnType anyOne typeClass = Void ]
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> newCascadeName [

	| indexString | 
	
	indexString := cascadesRegistry 
		ifEmpty: [ '' ]
		ifNotEmpty: [ (cascadesRegistry size + 1) asString ].

	^ 'cascade', indexString
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> newTemporary [

	| indexString name | 
	
	indexString := temporariesRegistry 
		ifEmpty: [ '' ]
		ifNotEmpty: [ (temporariesRegistry size + 1) asString ].

	name := 'temporary', indexString.
	temporariesRegistry add: name.
	^ name 

]

{ #category : #utility }
PharoCSharpASTBuildingVisitor >> nodeOrParentMustBeExpression: aNode [ 

	aNode declaresMustBeExpression ifTrue: [ ^ true ].
	^ aNode allParents anySatisfy: [ :each | each declaresMustBeExpression ]
]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> popPrefixStatements [

	^ prefixStatements removeLast
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> privMessageSend: selector receiver: receiver node: aNode arguments: arguments [

	^ self privMessageSend: selector receiver: receiver node: aNode arguments: arguments cast: nil
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> privMessageSend: selector receiver: receiver node: aNode arguments: arguments cast: cast [

	| keywords msg |
	
	keywords := self keywordsFor: selector.

	msg := (PharoCSharpMessageSendNode from: aNode) 
		receiver: receiver;
		name: (self convertSelector: selector);
		arguments: (arguments withIndexCollect: [ :each :index | 
			| arg |
			each mustBeExpression.
			arg := PharoCSharpMessageSendArgument new
				expression: (each acceptVisitor: self).
			index > 1 ifTrue: [ 
				arg keyword: ((keywords at: index) withoutSuffix: ':')].
			arg ]
		);
		yourself.
	
	cast ifNotNil: [ 	
		msg cast: (self typeStringOf: cast) ].
	
	^ msg
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> processBlockStatements: statements to: node originalNode: originalNode [
 
	| returnStatement lastExpression  |

	statements ifEmpty: [ ^ self ].
	
	(self blockReturnsValue: originalNode) 
		ifTrue: [  
			(self processedStatements: statements allButLast) do: [ :statement |
				node addStatement: statement ].

			"while we convert the last statement into the return statement, if it is already a return 
			statement, use just the inner expression"
			lastExpression := statements last isReturn 
				ifTrue: [ statements last value ]
				ifFalse: [ statements last ].
				
			returnStatement := PharoCSharpReturnStatementNode new expression: (lastExpression acceptVisitor: self).
			node addStatement: returnStatement. ]
		ifFalse: [ 
			(self processedStatements: statements) do: [ :statement |
				node addStatement: statement ].			
			 ]
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> processConstructorsIn: aClass node: classNode [
	
	| ownConstructors regionNode usesNew superclassConstructors cascadeStatements |
	
	ownConstructors := self detectConstructorsOf: aClass.
	superclassConstructors := aClass allSuperclasses flatCollect: [ :superclass |
		(self detectConstructorsOf: superclass) ].
	
	(ownConstructors isEmpty and: [superclassConstructors isEmpty ]) ifTrue: [ ^ self ].
	
	regionNode := PharoCSharpRegionNode new name: 'constructors'.
	classNode addRegion: regionNode.

	true ifTrue: [ 
		|  selector visibility |
			
		"generate argument-less constructor"
	
		selector := aClass instanceSide name.
		visibility :=  'public'.

		ast := (PharoCSharpConstructorNode from: nil) 
			name: selector;
			visibility: visibility;
			callsBase: true.
			
		regionNode addMethod: ast.	
	].

	(self detectConstructorsOf: aClass) do: [ :constructor |
		|  aMethodNode selector args visibility messages  |

		method := constructor.
		self readMethodTypes.
		aMethodNode := constructor ast.
		
		selector := aClass instanceSide name.
		visibility :=  'public'.

		ast := (PharoCSharpConstructorNode from: aMethodNode) 
			name: selector;
			visibility: visibility.
			
		args := aMethodNode arguments.
		args do: [ :arg |
			ast addArgument: ((PharoCSharpArgumentNode new) 
				name: arg name;
				type: (self typeStringOf: (argumentTypes at: arg name ifAbsent: [ #() ]));
				yourself).
		].
	
		usesNew := (aMethodNode body statements first value receiver selector = #new).
	
		messages := aMethodNode body statements first value messages.
		usesNew ifTrue: [ 
			ast addStatement: (PharoCSharpExpressionStatementNode new expression: (
				PharoCSharpMessageSendNode new 
					name: #Initialize;
					receiver: PharoCSharpSimpleExpressionNode this) )
		].
	
		cascadeStatements := messages flatCollect: [ :msg | self cascadeStatementsFrom: msg ].
		
		cascadeStatements do: [ :each | ast addStatement:  each ].
		
		messages do: [ :message |
			message selector = #yourself ifFalse: [ 
				ast addStatement: (PharoCSharpExpressionStatementNode new expression: (
					(message acceptVisitor: self)
						receiver: PharoCSharpSimpleExpressionNode this) ) ] 
			].
		regionNode addMethod: ast.
	].

	superclassConstructors do: [ :constructor |
			|  aMethodNode selector args visibility |
			method := constructor.
			self readArgumentTypes.
			aMethodNode := constructor ast.
			
			selector := aClass instanceSide name.
			visibility :=  'public'.

			ast := (PharoCSharpConstructorNode from: aMethodNode) 
				name: selector;
				visibility: visibility;
				callsBase: true.
				
			args := aMethodNode arguments.
			args do: [ :arg |
				ast addArgument: ((PharoCSharpArgumentNode new) 
					name: arg name;
					type: (self typeStringOf: (argumentTypes at: arg name ifAbsent: [ #() ]));
					yourself).
			].
			regionNode addMethod: ast.
		].

	
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> processParetnClassSideConstructorsIn: aClass node: classNode [
	
	| regionNode superclassConstructors currentMethod |
	
	superclassConstructors := aClass allSuperclasses flatCollect: [ :superclass |
		(self detectConstructorsOf: superclass) ].
	
	superclassConstructors ifEmpty: [ ^ self ].
	
	regionNode := PharoCSharpRegionNode new name: 'superclass constructors'.
	classNode addRegion: regionNode.
	
	currentMethod := method.
	
	superclassConstructors do: [ :constructor |
		|  aMethodNode selector args visibility keywords hasExtraKeywords extraKeywordsAndArguments  |

		aMethodNode := constructor ast.
		method := constructor.
		self readMethodTypes.
		selector := self convertSelector: aMethodNode selector.
		selector := self rewriteSelector: selector.
		visibility :=  'public new'.

		ast := (PharoCSharpMethodNode from: aMethodNode) 
			name: selector;
			static: 	aMethodNode method isClassSide;
			visibility: visibility;
			type: (self typeStringOf: { RuntimeTypeCollectorSimpleType fromClass: aClass }).
			
		keywords := self keywordsFor: selector.
		
		args := aMethodNode arguments.
		
		hasExtraKeywords := args size > 1.
		
		(args first: (1 min: args size)) do: [ :arg | 
			ast addArgument: ((PharoCSharpArgumentNode from: arg) 
												name: arg variable name;
												type: (self typeStringOf:(argumentTypes at: arg variable name ifAbsent: [ #()]));
												yourself) ].
		
		hasExtraKeywords ifTrue: [ 
			extraKeywordsAndArguments := self extraKeywordsAndArgumentsFrom: aMethodNode.
			extraKeywordsAndArguments do: [ :keywordToArg |
				ast addArgument: ((PharoCSharpArgumentNode new) 
												name: keywordToArg key;
												type: (self typeStringOf: (argumentTypes at: keywordToArg value variable name ifAbsent: [ #() ]));
												addComment: (keywordToArg value name)
												yourself).
				"convert to real argument name, ignore the arguments with the same name"
				keywordToArg key = keywordToArg value name ifFalse: [ 
					ast addStatement: (PharoCSharpInferredVariableAssignmentNode new
							name: keywordToArg value name;
							expression: (PharoCSharpSimpleExpressionNode new content: keywordToArg key)) ].
			].
		].

		ast addStatement: (PharoCSharpReturnStatementNode new expression: (
			PharoCSharpNewExpressionNode new 
				expression: (PharoCSharpSimpleExpressionNode new content: aClass instanceSide name);
				arguments: (self methodArgumentNames: aMethodNode))).

		regionNode addMethod: ast.
	].

	"restore the original state"
	method := currentMethod.
	self readArgumentTypes.



	
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> processProtocolsIn: aClass node: classNode static: aBoolean [

	| protocols ownProtocols |
	
	ownProtocols := aClass localMethods collect: [ :each | each protocol ] as: Set.
	
	protocols := ownProtocols sorted: [ :a :b | a name <= b name ].
	protocols do: [ :aProtocol | 
		| selectors regionNode |
		selectors := (aClass selectorsInProtocol: aProtocol) sorted.
		selectors ifNotEmpty: [ 
			regionNode := PharoCSharpRegionNode new name: aProtocol name.
			self processSelectors: selectors in: aClass node: regionNode static: aBoolean.
			regionNode methods ifNotEmpty: [ 
				aBoolean
					ifTrue: [ classNode addStaticRegion: regionNode.  ]
					ifFalse: [ classNode addRegion: regionNode.  ]
			]
	]].

]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> processSelectors: selectors in: aClass node: protocolNode static: aBoolean [

	selectors do: [ :selector |
		| aMethod |
		aMethod := aClass >> selector.
		(self canExportMethod: aMethod )
			ifTrue: [ 
				| cSharpMethod |
				cSharpMethod := 
					collectErrors 
						ifTrue: [ 
								[ 
									self visitMethod: aMethod
								] on: Error do: [ :err | 
									collectedErrors add: aMethod -> err.
									nil ] ]
						ifFalse: [ 
							self visitMethod: aMethod
							 ].
				cSharpMethod ifNotNil: [ 
					protocolNode addMethod: cSharpMethod ] ]
	]
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> processedStatements: statements [

	| resultStatements statementOrExpression |
	statements ifEmpty: [ ^ #() ].
	
	resultStatements := OrderedCollection new.
	statements do: [ :statement |
		| mainStatement cascadeStatements |
		
		self pushPrefixStatements.
		cascadeStatements := self cascadeStatementsFrom: statement.
		resultStatements addAll: (self popPrefixStatements).
		resultStatements addAll: cascadeStatements.
		
		self pushPrefixStatements.
		
		statementOrExpression := statement acceptVisitor: self.
		mainStatement := (statementOrExpression isStatement)
			ifTrue: [ 
				statementOrExpression ]
			ifFalse: [ 
				(statement isMessage and: [ statement selector = #pharo:cSharp: ])
				ifTrue: [ 
					"process standalone pharo:cSharp: expressions as standalone so no semicolon is added at the end"
					statement propertyAt: #ownLines put: true.
					statement acceptVisitor: self ]
				ifFalse: [ 
					(PharoCSharpExpressionStatementNode from: statement)
						expression: (statementOrExpression)]].
				
		resultStatements addAll: (self popPrefixStatements).
		resultStatements add: mainStatement.
	].
			
	^ resultStatements
]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> pushPrefixStatements [

	prefixStatements add: OrderedCollection new.
]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> readArgumentTypes [

	argumentTypes := Dictionary new.
	
	method pragmas do: [ :pragma | 
		(#(arg:type: arg:type:generated:) includes: pragma selector) 
			ifTrue: [ 
				argumentTypes at: pragma arguments first put: (SchmidtTypeCollectorType fromLiteral: pragma arguments second)  ]
			]

]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> readBlockArgTypes [

	blockArgumentTypes := Dictionary new.
	
	method pragmas do: [ :pragma | 
		(#(blockArg:type: blockArg:type:generated:) includes: pragma selector) 
			ifTrue: [
				blockArgumentTypes at: pragma arguments first put: (SchmidtTypeCollectorType fromLiteral: pragma arguments second)  ]
			]

]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> readBlockInformation [

	method pragmas 
		do: [ :pragma | 
			(#(block:returnsValue: block:returnsValue:generated:) includes: pragma selector) ifTrue: [ 
				self blockNumber: pragma arguments first returnsValue: pragma arguments second.
			]
		].
]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> readMethodReturnType [

	method pragmas 
		do: [ :pragma | 
			(#(returns: returns:generated:) includes: pragma selector) 
				ifTrue: [ 
					methodReturnType := (SchmidtTypeCollectorType fromLiteral: pragma arguments first).
					^ self ]
				].
			
	(method ast allChildren noneSatisfy: [ :each | each isReturn ])  
		ifTrue: [
			methodReturnType := method methodClass isInstanceSide 
				ifTrue: [ SchmidtTypeCollectorType fromLiteral: method method methodClass name ] 
				ifFalse: [  SchmidtTypeCollectorType fromLiteral: #Void ]. 
			^ self ].
			
	methodReturnType := #()
		

]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> readMethodTypes [
	
	self readTempVarTypes.
	self readArgumentTypes.
	self readBlockArgTypes.
	self readMethodReturnType.
	self readBlockInformation.

]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> readSlotTypesFrom: aClass [

	| result methodName |
	
	result := Dictionary new.
	
	methodName := '_slotTypes' asSymbol.
	
	(aClass includesSelector: methodName) ifFalse: [ ^ result ].
	
	(aClass>>methodName) pragmas do: [ :pragma | 
		(#(slot:type: slot:type:generated:) includes: pragma selector) 
			ifTrue: [ 
				result at: pragma arguments first put: (SchmidtTypeCollectorType fromLiteral: pragma arguments second)  ]
			].
		
	^ result

]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> readTempVarTypes [

	tempVarTypes := Dictionary new.
	
	method pragmas do: [ :pragma | 
		(#(var:type: var:type:generated:) includes: pragma selector) 
			ifTrue: [ 
				tempVarTypes at: pragma arguments first put: (SchmidtTypeCollectorType fromLiteral: pragma arguments second)  ]
			]

]

{ #category : #utility }
PharoCSharpASTBuildingVisitor >> receiverOf: aMessageNode isClass: aClass [ 

	| receiver |
	receiver := aMessageNode receiver.
	receiver isVariable ifFalse: [ ^ false ].
	receiver variable isGlobalVariable ifFalse: [ ^ false ].
	^ receiver variable name asSymbol = aClass name asSymbol
]

{ #category : #utility }
PharoCSharpASTBuildingVisitor >> receiverTypeIsDictionary: receiverTypeSet [

	receiverTypeSet ifEmpty: [ ^ false ].
	
	^ receiverTypeSet anyOne isDictionaryType
]

{ #category : #utility }
PharoCSharpASTBuildingVisitor >> receiverTypeOf: aMessageSendNode satisfies: aBlock [ 

	| receiver knownType |
	receiver := aMessageSendNode receiver.
	receiver isVariable ifFalse: [ ^ false ].
	knownType :=  self knownTypeFor: receiver value name.
	knownType ifNil: [ ^ false ].	
	^ aBlock value: knownType anyOne
]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> resetPrefixStatements [

	prefixStatements := OrderedCollection new.

]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> rewriteAtIfMessageSend: aMessageNode receiver: receiver [

	"aMessageNode selector = #at:ifPresent: 
		ifTrue: [ 
			| msg block | 
			block := aMessageNode arguments second acceptVisitor: self.
			block returnType.
			
			self halt.
			
			msg := aMessageNode copy selector: (RBSelectorNode new value: #'Where:').
			msg propertyAt: #originalSelector put: #select:.
			^ self 
				privMessageSend: #ToList 
				receiver: (msg acceptVisitor: self) 
				node: aMessageNode 
				arguments: #()
		 ]."

														
	^ nil
]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> rewriteBasicMessageSend: aMessageNode receiver: receiver [

	(aMessageNode selector = #new and: [ receiver isSimpleExpression ])
		ifTrue: [
			| type |
			receiver isSimpleExpression ifTrue: [ 
				aMessageNode parent isAssignment ifTrue: [ 
					type := self knownTypeFor: (aMessageNode parent variable name).
				].
				aMessageNode parent isReturn ifTrue: [ 
					type := methodReturnType.
				].].
			(receiver isThis and: [ method methodClass isClassSide])
				ifTrue: [ receiver content: method methodClass instanceSide name ].
			^ PharoCSharpNewExpressionNode new 
				expression: receiver;
				type: (type ifNotNil: [ self typeStringOf: (type ifNil: [#()]) ]).
		].
	
	(aMessageNode selector = #copy and: [ receiver isSimpleExpression ])
		ifTrue: [
			| type | 
			receiver isSimpleExpression ifTrue: [ 
				aMessageNode receiver isVariable ifTrue: [ 
					type := self knownTypeFor: (aMessageNode receiver variable name) ].

				aMessageNode parent isAssignment ifTrue: [ 
					type := self knownTypeFor: (aMessageNode parent variable name).
				].
				aMessageNode parent isReturn ifTrue: [ 
					type := methodReturnType.
				].].
			(receiver isThis)
				ifTrue: [ type := SchmidtTypeCollectorType fromLiteral: method methodClass instanceSide name ].
			type ifNil: [ self error: 'unknown copy type' ].
			^ PharoCSharpCopyExpressionNode new 
				expression: receiver;
				type: (self typeStringOf: type).
		].	
	
	(aMessageNode selector = #new: and: [ receiver isSimpleExpression ])
		ifTrue: [
			| type |
			receiver isSimpleExpression ifTrue: [ 
				aMessageNode parent isAssignment ifTrue: [ 
					type := self knownTypeFor: (aMessageNode parent variable name).
				].
				aMessageNode parent isReturn ifTrue: [ 
					type := methodReturnType.
				].].
			(receiver isThis and: [ method methodClass isClassSide])
				ifTrue: [ receiver content: method methodClass instanceSide name ].
			^ PharoCSharpNewExpressionNode new 
				expression: receiver;
				size: (aMessageNode arguments first acceptVisitor: self);
				type: (self typeStringOf: type).
		].	
		
	(aMessageNode selector = #with: and: [ receiver isSimpleExpression ])
		ifTrue: [
			| type |
			receiver isSimpleExpression ifTrue: [ 
				aMessageNode parent isAssignment ifTrue: [ 
					type := self knownTypeFor: (aMessageNode parent variable name).
				].
				aMessageNode parent isReturn ifTrue: [ 
					type := methodReturnType.
				].].
			type ifNotNil: [ 
				(receiver isThis and: [ method methodClass isClassSide])
					ifTrue: [ receiver content: method methodClass instanceSide name ].
				^ PharoCSharpNewExpressionNode new 
					expression: receiver;
					type: (self typeStringOf: type);
					initializingValue: (aMessageNode arguments first acceptVisitor: self) ]
		].			

	(aMessageNode selector = #class) ifTrue: [
		^ (aMessageNode receiver acceptVisitor: self).
	].

	aMessageNode selector = #isKindOf: 
		ifTrue: [
			^ (PharoCSharpIsNode from: aMessageNode)
				expression: receiver;
				type: (aMessageNode arguments first acceptVisitor: self)
		].	
															
	^ nil
]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> rewriteBinaryMessageSend: aMessageNode receiver: receiver [

	aMessageNode selector = #<< 
		ifTrue: [ 
			^ self 
				privMessageSend: #NextPutAll:
				receiver: receiver 
				node: aMessageNode 
				arguments: aMessageNode arguments		
		].	
		
	aMessageNode selector = #-> 
		ifTrue: [ 
			| type keyType valueType |
			aMessageNode parent isAssignment ifTrue: [ 
					type := self knownTypeFor: (aMessageNode parent variable name).
			].
			keyType := valueType := Set new.
			(type notNil and: [ type size = 1 and: [ type anyOne isAssociationType ]]) ifTrue: [ 
					keyType := type anyOne keyClasses.
					valueType := type anyOne valueClasses. ].
			^ (PharoCSharpAssociationNode from: aMessageNode)
				keyType: (self typeStringOf: keyType);
				keyValue: receiver;
				valueType: (self typeStringOf: valueType);
				value:  (aMessageNode arguments first acceptVisitor: self)
	].
															
	^ nil
]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> rewriteBlockMessageSend: aMessageNode receiver: receiver [

	(aMessageNode selector = #value and: [ receiver isSimpleExpression ])
		ifTrue: [
			| type |
			receiver isSimpleExpression ifTrue: [ 
				aMessageNode receiver isVariable ifTrue: [ 
					type := self knownTypeFor: (aMessageNode receiver variable name).
				].
			].
			(type notNil and: [ type anyOne isBlockType ])
				ifTrue: [ 
					^ PharoCSharpInvocationNode new 
						expression: receiver.
			 ]
		].
															
	^ nil
]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> rewriteCastMessageSend: aMessageNode receiver: receiver [
															
	aMessageNode selector = #castAs: 
		ifTrue: [ 
			| literal type |
			literal := aMessageNode arguments first value.
			type := (SchmidtTypeCollectorType fromLiteral: literal).
			
			^ (PharoCSharpCastDirectNode from: aMessageNode)
				expression: receiver;
				type: (self typeStringOf: type).
		].	

	aMessageNode selector = #castOrNilAs: 
		ifTrue: [ 
			| literal type |
			literal := aMessageNode arguments first value.
			type := (SchmidtTypeCollectorType fromLiteral: literal).
			
			^ (PharoCSharpCastAsNode from: aMessageNode)
				expression: receiver;
				type: (self typeStringOf: type).
		].
				
	aMessageNode selector = #asType 
		ifTrue: [ 
			^ (PharoCSharpTypeOfNode from: aMessageNode)
				expression: receiver.
		].
					
	^ nil
]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> rewriteCharacterMessageSend: aMessageNode receiver: receiver [

	(aMessageNode selector = #value: and: [ self receiverOf: aMessageNode isClass: Character ])
		ifTrue: [ 
			^ self 
				privMessageSend: #'value:'
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoCharacter'; hasParentheses: false)
				node: aMessageNode 
				arguments: aMessageNode arguments		
		].				
															
	^ nil
]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> rewriteCollectionMessageSend: aMessageNode receiver: receiver [


	aMessageNode selector = #select: 
		ifTrue: [ 
			| msg | 
			msg := aMessageNode copy selector: (RBSelectorNode new value: #'Where:').
			msg propertyAt: #originalSelector put: #select:.
			^ self 
				privMessageSend: #ToList 
				receiver: (msg acceptVisitor: self) 
				node: aMessageNode 
				arguments: #()
		 ].

	aMessageNode selector = #collect: 
		ifTrue: [ 
			| msg | 
			msg := aMessageNode copy selector: (RBSelectorNode new value: 'Select:').
			msg propertyAt: #originalSelector put: #collect:.
			^ self 
				privMessageSend: #ToList 
				receiver: (msg acceptVisitor: self) 
				node: aMessageNode 
				arguments: #()
		 ].			

	aMessageNode selector = #copyFrom:to: 
		ifTrue: [ 
			^ self 
				privMessageSend: #copyFrom:from:to:
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoCollection'; hasParentheses: false)
				node: aMessageNode 
				arguments: {aMessageNode receiver}, aMessageNode arguments		
		].		
				
	aMessageNode selector = #size 
		ifTrue: [ 
			^ self 
				privMessageSend: #sizeOf:
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoCollection'; hasParentheses: false)
				node: aMessageNode 
				arguments: {aMessageNode receiver}, aMessageNode arguments		
		].			

	aMessageNode selector = #includes: 
		ifTrue: [ 
			^ self 
				privMessageSend: #includes:item:
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoCollection'; hasParentheses: false)
				node: aMessageNode 
				arguments: {aMessageNode receiver}, aMessageNode arguments		
		].			

	aMessageNode selector = #detect: 
		ifTrue: [ 
			^ self 
				privMessageSend: #detect:itemLike:
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoCollection'; hasParentheses: false)
				node: aMessageNode 
				arguments: {aMessageNode receiver}, aMessageNode arguments		
		].
	
	aMessageNode selector = #detect:ifNone:
		ifTrue: [ 
			^ self 
				privMessageSend: #detect:itemLike:ifNone:
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoCollection'; hasParentheses: false)
				node: aMessageNode 
				arguments: {aMessageNode receiver}, aMessageNode arguments		
		].	
		
	aMessageNode selector = #at:ifAbsentPut: 
		ifTrue: [ 
			^ self 
				privMessageSend: #_At:ifAbsentPut:
				receiver: receiver
				node: aMessageNode 
				arguments: aMessageNode arguments		
		].				

	aMessageNode selector = #indexOf: 
		ifTrue: [ 
			^ self 
				privMessageSend: #_IndexOf:
				receiver: receiver
				node: aMessageNode 
				arguments: aMessageNode arguments		
		].		

	aMessageNode selector = #removeAt: 
		ifTrue: [ 
			^ self 
				privMessageSend: #_RemoveAt:
				receiver: receiver
				node: aMessageNode 
				arguments: aMessageNode arguments		
		].																
	^ nil
]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> rewriteCustomMessageSend: aMessageNode receiver: receiver [
		
	aMessageNode selector = #applyOffset:
		ifTrue: [ 
			^ self 
				privMessageSend: #applyOffset:to:
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoDateAndTime'; hasParentheses: false)
				node: aMessageNode 
				arguments: aMessageNode arguments, {aMessageNode receiver}
		].
	
	((#(resultValue: setUcErrorMsg: setUcErrorMsg:arg: setUcErrorMsg:args: setUcErrorMsgFromOtherTracker:) includes: aMessageNode selector)
		and: [ self receiverTypeOf: aMessageNode satisfies: [ :t | t typeClass name = #PdmStatusTracker or: [ t typeClass name = #IStatusTracker ] ] ]
		and: [ aMessageNode parent isSequence not ])
		ifTrue: [ 
			^ self 
				privMessageSend: aMessageNode selector
				receiver: (aMessageNode receiver acceptVisitor: self )
				node: aMessageNode 
				arguments: aMessageNode arguments
				cast: (SchmidtTypeCollectorType mergeAll: methodReturnType)
		].	

	((#(handleErrorMessageFromTracker:) includes: aMessageNode selector)
		and: [ aMessageNode parent isReturn ])
		ifTrue: [ 
			^ self 
				privMessageSend: aMessageNode selector
				receiver: (aMessageNode receiver acceptVisitor: self )
				node: aMessageNode 
				arguments: aMessageNode arguments
				cast: (SchmidtTypeCollectorType mergeAll: methodReturnType)
		].

	(aMessageNode selector = #resultValue: 
		and: [ self receiverTypeOf: aMessageNode satisfies: [ :t | t typeClass name = #PdmStatusTracker or: [ t typeClass name = #IStatusTracker ] ] ]
		and: [ aMessageNode parent isSequence not ])
		ifTrue: [ 
			^ self 
				privMessageSend: aMessageNode selector
				receiver: (aMessageNode receiver acceptVisitor: self )
				node: aMessageNode 
				arguments: aMessageNode arguments
				cast: (SchmidtTypeCollectorType mergeAll: methodReturnType)
		].

	(aMessageNode selector = #newChild:resType: 
		and: [ self receiverTypeOf: aMessageNode satisfies: [ :t | t typeClass name = #PdmStatusTracker or: [ t typeClass name = #IStatusTracker ] ] ])
		ifTrue: [ 
			| typeofNode type |
			type := SchmidtTypeCollectorType fromLiteral: aMessageNode arguments second value.
			typeofNode := (PharoCSharpTypeOfNode from: aMessageNode arguments second)
				expression: (PharoCSharpSimpleExpressionNode new content: (self typeStringOf: type));
				yourself.
			^ (PharoCSharpMessageSendNode from: aMessageNode)	
					receiver: (aMessageNode receiver acceptVisitor: self );
					name: (self convertSelector: #newChild:resType:);
					arguments: { 
						(PharoCSharpMessageSendArgument new expression: (aMessageNode arguments first acceptVisitor: self)).
						(PharoCSharpMessageSendArgument new expression: typeofNode).
					}
				].	

"	(aMessageNode selector = #executeIn:forOwnerKey:tracking: 
		and: [ aMessageNode parent isAssignment ]
		and: [ aMessageNode parent isSequence not ])
		ifTrue: [ 
			| inner cast aType |
			inner := self 
				privMessageSend: aMessageNode selector
				receiver: (aMessageNode receiver acceptVisitor: self )
				node: aMessageNode 
				arguments: aMessageNode arguments.
			cast:= self 
				privMessageSend: #cast:
				receiver: inner
				node: aMessageNode 
				arguments: #().
			aType := (self knownTypeFor: (aMessageNode parent variable name)) anyOne itemClasses.
			cast genericTypeArgument: (self typeStringOf: aType).
			^ self 
				privMessageSend: #toList
				receiver: cast
				node: aMessageNode 
				arguments: #().
		].				
		"
	((#(executeIn:forOwnerKey:tracking: executeReadingOneIn:forOwnerKey:tracking:) includes: 
	(aMessageNode selector)) 
		and: [ aMessageNode parent isAssignment ]
		and: [ aMessageNode parent isSequence not ])
		ifTrue: [ 
			| aType |
			aType := (self knownTypeFor: (aMessageNode parent variable name)).
			^ self 
				privMessageSend: aMessageNode selector
				receiver: (aMessageNode receiver acceptVisitor: self )
				node: aMessageNode 
				arguments: aMessageNode arguments
				cast: aType.
		].																							
	^ nil
]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> rewriteExceptionMessageSend: aMessageNode receiver: receiver [

	(aMessageNode selector = #messageText)
		ifTrue: [ 
			^ self 
				privMessageSend: #'messageText:text:'
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoException'; hasParentheses: false)
				node: aMessageNode 
				arguments: {aMessageNode receiver}, aMessageNode arguments	
		].		

		
															
	^ nil
]

{ #category : #'rewrite globals' }
PharoCSharpASTBuildingVisitor >> rewriteGlobalName: aString [ 

	aString = 'Void' ifTrue: [ ^ 'void' ].
	aString = 'Array' ifTrue: [ ^ 'List' ].
	aString = 'Error' ifTrue: [ ^ 'Exception' ].
	aString = 'Path' ifTrue: [ ^ 'PharoPath' ].
	aString = 'Character' ifTrue: [ ^ 'Char' ].
	aString = 'SmallDictionary' ifTrue: [ ^ 'Dictionary' ].	
	aString = 'OrderedCollection' ifTrue: [ ^ 'List' ].	
	
	^ aString
]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> rewriteLogicalMessageSend: aMessageNode receiver: receiver [

	aMessageNode selector = #and: 
		ifTrue: [
			self assert: aMessageNode arguments first statements size = 1.
			^ (PharoCSharpBinaryExpressionNode from: aMessageNode)
				leftExpression: receiver;
				operator: '&&';
				rightExpression: (aMessageNode arguments first statements first acceptVisitor: self)
		].	

	aMessageNode selector = #or: 
		ifTrue: [
			self assert: aMessageNode arguments first statements size = 1.
			^ (PharoCSharpBinaryExpressionNode from: aMessageNode)
				leftExpression: receiver;
				operator: '||';
				rightExpression: (aMessageNode arguments first statements first acceptVisitor: self)
		].	


	aMessageNode selector = #not 
		ifTrue: [
			^ (PharoCSharpUnaryExpressionNode from: aMessageNode)
				expression: receiver;
				operator: '!';
				forceParentheses: true
		].					
															
	^ nil
]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> rewriteMessageSend: aMessageNode receiver: receiver [

	(self rewriteBasicMessageSend: aMessageNode receiver: receiver)
		ifNotNil: [ :node | ^ node ].
	(self rewriteBinaryMessageSend: aMessageNode receiver: receiver)
		ifNotNil: [ :node | ^ node ].
	(self rewriteBlockMessageSend: aMessageNode receiver: receiver)
		ifNotNil: [ :node | ^ node ].
	(self rewriteCastMessageSend: aMessageNode receiver: receiver)
		ifNotNil: [ :node | ^ node ].
	(self rewriteCharacterMessageSend: aMessageNode receiver: receiver)
		ifNotNil: [ :node | ^ node ].
	(self rewriteCollectionMessageSend: aMessageNode receiver: receiver)
		ifNotNil: [ :node | ^ node ].
	(self rewriteCustomMessageSend: aMessageNode receiver: receiver)
		ifNotNil: [ :node | ^ node ].
	(self rewriteExceptionMessageSend: aMessageNode receiver: receiver)
		ifNotNil: [ :node | ^ node ].
	(self rewriteLogicalMessageSend: aMessageNode receiver: receiver)
		ifNotNil: [ :node | ^ node ].
	(self rewriteNumberMessageSend: aMessageNode receiver: receiver)
		ifNotNil: [ :node | ^ node ].
	(self rewriteObjectMessageSend: aMessageNode receiver: receiver)
		ifNotNil: [ :node | ^ node ].
	(self rewriteStringMessageSend: aMessageNode receiver: receiver)
		ifNotNil: [ :node | ^ node ].
	(self rewriteAtIfMessageSend: aMessageNode receiver: receiver)
		ifNotNil: [ :node | ^ node ].
															
	^ nil
]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> rewriteNumberMessageSend: aMessageNode receiver: receiver [

	aMessageNode selector = #to:do:
		ifTrue: [ 
			^ self 
				privMessageSend: #'from:to:@do:'
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoNumber'; hasParentheses: false)
				node: aMessageNode 
				arguments: {aMessageNode receiver}, aMessageNode arguments		
		].		

	aMessageNode selector = #max:
		ifTrue: [ 
			^ self 
				privMessageSend: #'max:other:'
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoNumber'; hasParentheses: false)
				node: aMessageNode 
				arguments: {aMessageNode receiver}, aMessageNode arguments		
		].			
															
	^ nil
]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> rewriteObjectMessageSend: aMessageNode receiver: receiver [
		
	(#(asString fullPrintString) includes: aMessageNode selector)
		ifTrue: [ 
			^ self 
				privMessageSend: #toString
				receiver: receiver
				node: aMessageNode 
				arguments: aMessageNode arguments		
		].	

	aMessageNode selector = #printString 
		ifTrue: [ 
			^ self 
				privMessageSend: #toString
				receiver: receiver
				node: aMessageNode 
				arguments: aMessageNode arguments		
		].	
				
	aMessageNode selector = #isInteger 
		ifTrue: [ 
			^ self 
				privMessageSend: #isInteger:
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoObject'; hasParentheses: false)
				node: aMessageNode 
				arguments: {aMessageNode receiver}, aMessageNode arguments		
		].		

	aMessageNode selector = #isNil
		ifTrue: [ 
			^ self 
				privMessageSend: #isNil:
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoObject'; hasParentheses: false)
				node: aMessageNode 
				arguments: {aMessageNode receiver}, aMessageNode arguments		
		].		

	aMessageNode selector = #notNil
		ifTrue: [ 
			^ self 
				privMessageSend: #notNil:
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoObject'; hasParentheses: false)
				node: aMessageNode 
				arguments: {aMessageNode receiver}, aMessageNode arguments		
		].		

	aMessageNode selector = #isNotNil
		ifTrue: [ 
			^ self 
				privMessageSend: #notNil:
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoObject'; hasParentheses: false)
				node: aMessageNode 
				arguments: {aMessageNode receiver}, aMessageNode arguments		
		].		
															
	^ nil
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> rewriteSelector: selector [ 

	selector = #= ifTrue: [ 
		^ #Equals ].
	^ selector
]

{ #category : #'rewrite messages' }
PharoCSharpASTBuildingVisitor >> rewriteStringMessageSend: aMessageNode receiver: receiver [		
				
	aMessageNode selector = #streamContents: 
		ifTrue: [ 
			(receiver isSimpleExpression and: [ receiver content = 'String' ])
				ifTrue: [ receiver content: 'PharoString' ].
			^ self 
				privMessageSend: #streamContents:
				receiver: receiver 
				node: aMessageNode 
				arguments: aMessageNode arguments		
		].				
		
	aMessageNode selector = #match:
		ifTrue: [ 
			^ self 
				privMessageSend: #match:to:
				receiver: ((PharoCSharpSimpleExpressionNode from: aMessageNode) content: 'PharoString'; hasParentheses: false)
				node: aMessageNode 
				arguments: {aMessageNode receiver}, aMessageNode arguments		
		].		
															
	^ nil
]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> skipWellKnownErrors [

	^ skipWellKnownErrors
]

{ #category : #accessing }
PharoCSharpASTBuildingVisitor >> skipWellKnownErrors: anObject [

	skipWellKnownErrors := anObject
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> sortedClassesAndTraits: classesAndTraits [ 

	| result |
	
	result := OrderedCollection new.

	result addAll: ((classesAndTraits select: [ :each | each isTrait ]) sorted: [ :a :b | a name <= b name ]).
	
	result addAll: ((classesAndTraits select: [ :each | each isTrait not ]) sorted: [ :a :b | a name <= b name ]).
	"sorted: [ :a :b | 
	(a allSubclasses includes: b) ifFalse: [ a name <= b name ] ifTrue: [ true ] ])."
	
	^ result.
]

{ #category : #'rewrite statements' }
PharoCSharpASTBuildingVisitor >> statementSelectors [
	
	^ #(ifTrue: ifFalse: ifTrue:ifFalse: ifFalse:ifTrue: ifNil: ifNotNil: ifNotNil:ifNil: ifNil:ifNotNil: on:do: ifEmpty: ifNotEmpty: ifEmpty:ifNotEmpty: ifNotEmpty:ifEmpty: ifError: do: withIndexDo: doWithIndex: whileTrue: keysAndValuesDo: at:ifPresent: ).
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> superclassNamesFor: aClassOrTrait [ 

	aClassOrTrait isTrait ifTrue: [ ^ #() ].
	
	^ { aClassOrTrait superclass name }
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> typeOfArrayTemp: tempName [ 

	^ tempVarTypes at: tempName ifAbsent: [ #() ]
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> typeOfTemp: tempName [ 

	^ tempVarTypes at: tempName ifAbsent: [ #() ]
]

{ #category : #utility }
PharoCSharpASTBuildingVisitor >> typeSetWith: typeOrTypes [

	| set |
	
	set := Set new.
	
	typeOrTypes isCollection 
		ifTrue: [ set addAll: typeOrTypes ]
		ifFalse: [ set add: typeOrTypes ].
	
	^ set
		
]

{ #category : #utility }
PharoCSharpASTBuildingVisitor >> typeStringOf: aTypeSet [ 

	| merged |
	
	merged := aTypeSet  
		ifNotEmpty: [ SchmidtTypeCollectorType mergeAll: aTypeSet ]
		ifEmpty: [ aTypeSet ].
		
	^ PharoCSharpTypePrintingVisitor new 
		visitTypeSet: merged
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> unknownTypeName [ 

	^ 'unknown'
]

{ #category : #utility }
PharoCSharpASTBuildingVisitor >> validateConstructor: aMethod [ 

	self assert: (self class isConstructor: aMethod)
	
]

{ #category : #utility }
PharoCSharpASTBuildingVisitor >> varialbe: varName isPropertyOf: aClass [ 

	^ (aClass respondsTo: #cSharpProperties) and: [ aClass cSharpProperties includes: varName ]
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitArgumentVariableNode: aNode [

	^ (PharoCSharpSimpleExpressionNode from: aNode) 
		content: aNode name
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitArrayNode: anArrayNode [

	| name type |
	name := self newTemporary.
	type := self typeOfArrayTemp: name.
	type ifEmpty: [ 
		type := SchmidtTypeCollectorType fromLiteral: #Var ].

	self addPrefixStatement: (PharoCSharpInferredVariableAssignmentNode new
		name: name;
		type: (self typeStringOf: type);
		expression: ((PharoCSharpArrayNode from: anArrayNode) 
			content: (anArrayNode statements collect: [:each | 
				each value asCSharpLiteralIn: self ]  )) ).
				
	^ (PharoCSharpSimpleExpressionNode from: anArrayNode) 
		content: name
		

]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitAssignmentNode: anAssignmentNode [

	anAssignmentNode value mustBeExpression.

	^ (PharoCSharpAssignmentNode from: anAssignmentNode) 
			variable: anAssignmentNode variable name;
			expression: (
				anAssignmentNode value acceptVisitor: self
			)
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitBlockNode: aBlockNode [

	| node singleExpressionBlock returnType bodySize | 
	
	node := PharoCSharpLambdaNode new.

	node arguments: (aBlockNode arguments collect: [ :arg | 
		(PharoCSharpArgumentNode from: aBlockNode) 
			name: arg variable name;
			type: (self typeStringOf: (blockArgumentTypes at: arg variable name ifAbsent: [ #()]));
			yourself
		]).
	
	returnType := self blockReturnTypeOrNilOf: aBlockNode.
	node returnType: returnType.

	bodySize := aBlockNode body statements size.
	singleExpressionBlock := returnType
		ifNil: [ bodySize <= 1 ]
		ifNotNil: [ aBlockNode body statements size = 2 ].
		
	(singleExpressionBlock and: [ (self blockReturnsValue: aBlockNode) or: [ returnType notNil ] ]) ifTrue: [ 
		aBlockNode body statements first mustBeExpression.
	].
	
	node isSingleExpression: singleExpressionBlock.
	
	aBlockNode body
		ifNotNil: [ :body | 
			singleExpressionBlock 
				ifFalse: [
					self processBlockStatements: body statements to: node originalNode: aBlockNode
				] ifTrue: [
					node statements: (body acceptVisitor: self).
					node statements ifEmpty: [ 
						 node statements: { PharoCSharpExpressionStatementNode new expression: PharoCSharpSimpleExpressionNode null } 
					]
			]
	 ].
			
	^ node



]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitCascadeNode: aRBCascadeNode [

	| name |
	
	name := aRBCascadeNode propertyAt: #cascadeName ifAbsent: [ self error: #unknownCascade ].
	
	aRBCascadeNode parent isSequence 
		ifTrue: [
			"cascade used as standalone statement, we do not need to print it again"
			^ PharoCSharpEmptyNode from: aRBCascadeNode ].
	
	^ (PharoCSharpSimpleExpressionNode from: aRBCascadeNode) 
		content: name
	

]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitClass: aClass [

	| classNode |
	classNode := (PharoCSharpClassNode from: aClass)
		name: aClass name;
		supertypes: (self superclassNamesFor: aClass), (aClass traits collect: [:each | each name]);
		isInterface: aClass isTrait;
		visibility: #public.
		
	slotTypes := self readSlotTypesFrom: aClass.
		
	aClass instanceVariables do: [ :iVar |
		| isProperty |
		isProperty := self varialbe: iVar name isPropertyOf: aClass.
		classNode addVariable: (
			PharoCSharpInstanceVariableDefinitionNode new 
				name: iVar name;
				visibility: (isProperty ifTrue: [ #public ] ifFalse: [ #protected ]);
				isProperty: isProperty;
				type: (self typeStringOf: (slotTypes at: iVar name asSymbol ifAbsent: [#()]))
		).
	].

	self processConstructorsIn: aClass node: classNode.
	self processProtocolsIn: aClass node: classNode static: false.
	self processParetnClassSideConstructorsIn: aClass node: classNode.
	self processProtocolsIn: aClass classSide node: classNode static: true.

	^ classNode
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitGlobalVariableNode: aNode [

	^ (PharoCSharpSimpleExpressionNode from: aNode) 
		content: (self rewriteGlobalName: aNode name)
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitInstanceVariableNode: aNode [

	^ (PharoCSharpSimpleExpressionNode from: aNode)
		content: aNode name
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitLiteralArrayNode: anArrayNode [

	| name type |

	(anArrayNode parent isMessage and: [ #(castAs: castOrNilAs:) includes: anArrayNode parent selector ])
		ifTrue: [ ^ PharoCSharpSimpleExpressionNode null ].	

	name := self newTemporary.

	type := self typeOfArrayTemp: name.
	type ifEmpty: [ 
		type := SchmidtTypeCollectorType fromLiteral: #Var ].

	self addPrefixStatement: (PharoCSharpInferredVariableAssignmentNode new
		name: name;
		type: (self typeStringOf: type); 
		expression: (PharoCSharpArrayNode new
			content: (anArrayNode contents collect: [:each | 
				PharoCSharpSimpleExpressionNode new content: each value asCSharpLiteral ]  )) ).
				
	^ (PharoCSharpSimpleExpressionNode from: anArrayNode) 
		content: name
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitLiteralNode: aLiteralNode [

	aLiteralNode value isSymbol ifTrue: [ collectedSymbols add: (aLiteralNode value copyReplaceAll: ':' with: '_') asSymbol ].

	^ (PharoCSharpSimpleExpressionNode from: aLiteralNode) 
		content: aLiteralNode value asCSharpLiteral
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitMessageNode: aMessageNode [

	| receiver |
	
	aMessageNode selector = #pharo:cSharp: ifTrue: [ 
		^ PharoCSharpPlainCodeNode new 
			ownLines: (aMessageNode propertyAt: #ownLines ifAbsent: [false]);
			content: aMessageNode arguments second evaluate value.
	].

	((self nodeOrParentMustBeExpression: aMessageNode) and: [ self containsNonlocalReturns: aMessageNode ])
		ifTrue: [ 
			"white list
			({ PdcProjectPreparationPolicy>>#findFirstFreeSequenceNumberAmong:tracking: }
				includes: aMessageNode methodNode method)
					ifFalse: ["
						self error: 'A non-local return in message node that must be an expression' ] .

	receiver := nil.
	(aMessageNode receiver isSelfVariable)
		ifTrue: [ receiver := PharoCSharpSimpleExpressionNode new content: #this ].
	(aMessageNode receiver isSuperVariable)
		ifTrue: [ receiver := PharoCSharpSimpleExpressionNode new content: #base ].
				
	receiver ifNil: [ 
		aMessageNode receiver mustBeExpression.
		receiver := aMessageNode receiver acceptVisitor: self ].
	
	(aMessageNode isBinary and: [ self isAllowedBinarySelector: aMessageNode selector ]) ifTrue: [ 
		| transformedSelector |
		transformedSelector := aMessageNode selector.
		(transformedSelector = '=') ifTrue: [ transformedSelector := '==' ].
		(transformedSelector = ',') ifTrue: [ transformedSelector := '+' ].
		(transformedSelector = '//') ifTrue: [ transformedSelector := '/' ].
		(transformedSelector = '\\') ifTrue: [ transformedSelector := '%' ].
		(transformedSelector = '~=') ifTrue: [ transformedSelector := '!=' ].
		(transformedSelector = '~~') ifTrue: [ transformedSelector := '!=' ].
		^ (PharoCSharpBinaryExpressionNode from: aMessageNode) 
			leftExpression: (aMessageNode receiver mustBeExpression acceptVisitor: self);
			operator: transformedSelector;
			rightExpression: (aMessageNode arguments first mustBeExpression acceptVisitor: self);
			hasParentheses: true
	].
	
	(self convertToStatements: aMessageNode receiver: receiver)
		ifNotNil: [ :statement | ^ statement ].
		
	^ self messageSendFrom: aMessageNode receiver: receiver
	
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitMethod: aCompiledMethod [ 

	method := aCompiledMethod.
	ast := aCompiledMethod ast.
	
	(method pragmaAt: #cSharp:) ifNotNil: [ :pragma |
		^ (PharoCSharpPlainCodeNode from: ast) content: pragma arguments first ].
	
	cascadesRegistry := OrderedDictionary new.
	temporariesRegistry := Set new.
	self resetPrefixStatements.
	
	self readMethodTypes.

	^ self visitMethodNode: ast.
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitMethodNode: aMethodNode [

	| selector keywords hasExtraKeywords args extraKeywordsAndArguments visibility |
	selector := self convertSelector: aMethodNode selector.

	selector := self rewriteSelector: selector.

	visibility := 'public'.
	(self isVirtual: aMethodNode) ifTrue: [
		visibility := visibility , ' virtual' ].
	(self isOverride: aMethodNode) ifTrue: [
		visibility := aMethodNode method methodClass isInstanceSide
			              ifTrue: [ visibility , ' override' ]
			              ifFalse: [ visibility , ' new' ] ].

	ast := (PharoCSharpMethodNode from: aMethodNode)
		       name: selector;
		       static: aMethodNode compiledMethod isClassSide;
		       visibility: visibility;
		       type: (self typeStringOf: methodReturnType).

	keywords := self keywordsFor: selector.

	args := aMethodNode arguments.

	hasExtraKeywords := args size > 1.

	(args first: (1 min: args size)) do: [ :arg |
		ast addArgument: ((PharoCSharpArgumentNode from: arg)
				 name: arg variable name;
				 type: (self typeStringOf:
							  (argumentTypes at: arg variable name ifAbsent: [ #(  ) ]));
				 yourself) ].

	hasExtraKeywords ifTrue: [
		extraKeywordsAndArguments := self extraKeywordsAndArgumentsFrom:
			                             aMethodNode.
		extraKeywordsAndArguments do: [ :keywordToArg |
			ast addArgument: (PharoCSharpArgumentNode new
					 name: keywordToArg key;
					 type: (self typeStringOf: (argumentTypes
									   at: keywordToArg value variable name
									   ifAbsent: [ #(  ) ]));
					 addComment: keywordToArg value name yourself).
			"convert to real argument name, ignore the arguments with the same name"
			keywordToArg key = keywordToArg value name ifFalse: [
				ast addStatement: (PharoCSharpInferredVariableAssignmentNode new
						 name: keywordToArg value name;
						 expression:
							 (PharoCSharpSimpleExpressionNode new content: keywordToArg key)) ] ] ].

	(aMethodNode compiledMethod hasPragmaNamed: #constructor) ifTrue: [
		ast addStatement: (PharoCSharpReturnStatementNode new expression:
				 (PharoCSharpNewExpressionNode new
					  expression: (PharoCSharpSimpleExpressionNode new content:
								   aMethodNode method methodClass instanceSide name);
					  arguments: (self methodArgumentNames: aMethodNode))).
		^ ast ].

	aMethodNode compiledMethod isExplicitlyRequired
		ifFalse: [
			aMethodNode body ifNotNil: [ :body |
				ast addStatements: (body acceptVisitor: self).
				((body statements isEmpty and: [ self methodReturnsVoid not ])
					 or: [
						 body statements notEmpty and: [
							 body statements last isReturn not and: [
								 aMethodNode method methodClass isInstanceSide and: [
									 self methodReturnsVoid not ] ] ] ]) ifTrue: [
					ast addStatement:
						(PharoCSharpReturnStatementNode new expression:
							 PharoCSharpSimpleExpressionNode this) ] ] ]
		ifTrue: [ ast declarationOnly: true ].

	^ ast
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitPackage: aPackage [

	^ self visitPackage: aPackage headDefinitions: nil
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitPackage: aPackage headDefinitions: headDefinitions [

	| fileNode sorted |
		
	fileNode := PharoCSharpFileNode new
		name: aPackage name.
		
	headDefinitions ifNotNil: [ 
		fileNode addChild: (PharoCSharpPlainCodeNode new content: headDefinitions) ].
	
	sorted := self sortedClassesAndTraits: aPackage definedClasses.
	sorted do: [ :aClass |
		(self canExportClass: aClass) ifTrue: [ 
			fileNode addChild: (self visitClass: aClass) ]
	].

	exportSymbols ifTrue: [ 
		self exportSymbolsTo: fileNode ]. 

		
	^ fileNode
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitReturnNode: aReturnNode [

	aReturnNode value mustBeExpression.

	^ (PharoCSharpReturnStatementNode from: aReturnNode)
		expression: (aReturnNode value acceptVisitor: self);
		static: (method methodClass isClassSide or: [ self methodReturnsVoid])
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitSelfNode: aNode [

	^ (PharoCSharpSimpleExpressionNode from: aNode) 
		content: #this
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitSequenceNode: aSequenceNode [

	^(aSequenceNode temporaries collect: [ :each |
		(PharoCSharpVariableDeclarationNode from: aSequenceNode) 
			name: each name;
			type: (self typeStringOf: (self typeOfTemp: each name));
			yourself ])
	, (self processedStatements: aSequenceNode statements).
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitSuperNode: aNode [

	^ (PharoCSharpSimpleExpressionNode from: aNode) 
		content: #base
]

{ #category : #visiting }
PharoCSharpASTBuildingVisitor >> visitTemporaryVariableNode: aNode [

	^ (PharoCSharpSimpleExpressionNode from: aNode) 
		content: aNode name
]
