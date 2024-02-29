Class {
	#name : 'PharoCSharpGenerator',
	#superclass : 'Object',
	#category : 'Pharo CSharp-Support',
	#package : 'Pharo CSharp',
	#tag : 'Support'
}

{ #category : 'as yet unclassified' }
PharoCSharpGenerator class >> annotateAccessorsInClass [ 

	<script>
	
	| cls |
	cls := PharoCSharpExample01.
	self annotateReadersInClass: cls.
	self annotateWritersInClass: cls.
]

{ #category : 'as yet unclassified' }
PharoCSharpGenerator class >> annotateReadersInClass: cls [

	<script>
	| statements typeName pragmaManager |

		cls methods do: [ :m |
			statements := m ast body statements.
			(statements size = 1
			and: [ m ast arguments size = 0
			and: [ statements first isReturn
			and: [ statements first value isVariable 
			and: [ statements first value variable isInstanceVariable ]]]])
			ifTrue: [ 
				statements first value variable name.

				typeName := cls runtimeTypeCollectorSlotTypeOf: statements first value variable name.
				typeName ifNotNil: [ 
					pragmaManager := (RuntimeTypeCollectorPragmaManager for: m).
					pragmaManager replacePragma: #returns:generated: with: ('<returns: {1} generated: true>' format: { typeName storeString }).	 
				]
			]
		].

]

{ #category : 'as yet unclassified' }
PharoCSharpGenerator class >> annotateWritersInClass: cls [

	| statements typeName pragmaManager |

		cls methods do: [ :m |
			statements := m ast body statements.
			(statements size = 1
			and: [ m ast arguments size = 1
			and: [ statements first isAssignment
			and: [ statements first variable isVariable 
			and: [ statements first variable isInstanceVariable 
			and: [ statements first value isVariable 
			and: [ statements first value isArgumentVariable 
				]]]]]] )
			ifTrue: [ 
				statements first variable name.
				typeName := cls runtimeTypeCollectorSlotTypeOf:statements first variable name.
				typeName ifNotNil: [ 
						pragmaManager := (RuntimeTypeCollectorPragmaManager for: m).
						pragmaManager replacePragma: #arg:type:generated: with: ('<arg: {1} type: {2} generated: true>' format: { statements first value variable name asSymbol storeString. typeName storeString }).	
"						pragmaManager replacePragma: #returns:generated: with: ('<returns: {1} generated: true>' format: { cls name storeString}).	"

				]
			]
		].

]

{ #category : 'as yet unclassified' }
PharoCSharpGenerator class >> detectClassSideOverrides [

	<script>

	| methods |
	methods := 'Pharo CSharp-Example' asPackage classes flatCollect: [ :cls | 
		cls classSide methods select: [ :m | m isOverriding and: [ m origin ~= TraitedClass ] ] ].
	
	ClyQueryBrowserMorph browseMethods: methods
]

{ #category : 'as yet unclassified' }
PharoCSharpGenerator class >> generate [ 

	<script>
	
	| basePath |
	basePath := 'C:\repos\playground\' asFileReference.
	
	self 
		generatePackage: 'Pharo CSharp-Example' 
		head: self headDocumapsDirectSystem 
		file: basePath / 'PharoCSharp-Example' / 'PharoCSharpExample.cs'.
		
		
								
]

{ #category : 'as yet unclassified' }
PharoCSharpGenerator class >> generatePackage: packageName head: head [
	| visitor ast printer |
	visitor := PharoCSharpASTBuildingVisitor new.
	ast := visitor 
		visitPackage: packageName asPackage
		headDefinitions: head.
	printer := PharoCSharpPrintingVisitor new 
		visitFileNode: ast.
	^ printer contents.

]

{ #category : 'as yet unclassified' }
PharoCSharpGenerator class >> generatePackage: packageName head: head file: aFileReference [ 

	| content |
	content := self generatePackage: packageName head: head.
	aFileReference ensureDelete.
	aFileReference writeStreamDo: [ :stream |
		stream nextPutAll: content ].
]

{ #category : 'as yet unclassified' }
PharoCSharpGenerator class >> headDocumapsDirectSystem [

	^'
using System;

using PharoUtils;

namespace PharoCSharpExample;
'
]

{ #category : 'as yet unclassified' }
PharoCSharpGenerator class >> openTranlator [ 

	<script>

	SpButtonPresenter new action: [ 
		self generate.
	];
		label: 'Generate';
		open.
]
