Class {
	#name : 'PharoCSharpPrintingVisitor',
	#superclass : 'PharoCSharpVisitor',
	#instVars : [
		'stream',
		'indentation'
	],
	#category : 'Pharo CSharp-Visitors',
	#package : 'Pharo CSharp',
	#tag : 'Visitors'
}

{ #category : 'examples' }
PharoCSharpPrintingVisitor class >> example1 [ 

	<script>
| ast visitor |
ast := PharoCSharpFileNode new
	addUsing: 'System';
	addUsing: 'static System.Net.WebRequestMethods';
	addChild: (
		PharoCSharpNamespaceNode new
			name: 'Some.Namespace';
			addChild: ( 
				PharoCSharpClassNode new 
					name: #MyClass;
					addGenericType: 'T';
					addGenericType: 'S';
					addSupertype: #MySuperclass;
					addSupertype: #IMyInterface;
					addVariable: (
						PharoCSharpInstanceVariableDefinitionNode new 
							visibility: 'protected';
							name: #ivar;
							type: 'int'
						); 
					addMethod: (
						PharoCSharpMethodNode new 
							name: #MyMessage;
							type: 'void';
							addArgument: (
								PharoCSharpArgumentNode new 
									name: #arg;
									type: 'int';
									yourself);
							addArgument: (
								PharoCSharpArgumentNode new 
									name: #secondArg;
									type: 'int';
									yourself);
							addStatement: (
								PharoCSharpVariableDeclarationNode new 
									name: #temp;
									type: 'int';
									yourself);
							addStatement: (
								PharoCSharpAssignmentNode new 
									variable: #temp;
									expression: (
										PharoCSharpMessageSendNode new 
											receiver: #this;
											name: #SomeMessage;
											addArgument: (
												PharoCSharpMessageSendArgument new 
													keyword: #myArg;
													expression: (PharoCSharpSimpleExpressionNode new content: '42')
											);
											addArgument: (
												PharoCSharpMessageSendArgument new 
													expression: (PharoCSharpSimpleExpressionNode new content: '42')
											);
											yourself
									);
									yourself);	
							addStatement: (
								PharoCSharpIfStatementNode new 
									booleanExpression: (PharoCSharpSimpleExpressionNode new content: 'true');
									block: (PharoCSharpExpressionStatementNode new
										expression: (PharoCSharpSimpleExpressionNode new content: '42') 
										)
							);								
							yourself
						); 
					yourself
			);
			yourself			
	);
	yourself.
	
visitor := PharoCSharpPrintingVisitor new 
	visitFileNode: ast.

Clipboard clipboardText: visitor contents.
visitor contents.

	

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> contents [ 

	^ stream contents.
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> indent [

	indentation timesRepeat: [ stream << '    ' ]
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> indent: aBlock [ 

	| saved |
	saved := indentation.
	indentation := indentation + 1.
	aBlock value.
	indentation := saved
	
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> indentation [

	^ String streamContents: [ :s | 
		indentation timesRepeat: [ stream tab ] ].
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> initialize [ 

	super initialize.
	stream := WriteStream on: String new.
	indentation := 0.

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> printLine: aString [ 

	self indent.
	stream << aString printString; cr.
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitArgumentNode: aNode [

	stream << aNode type << ' ' << aNode name.
	
	self writeInlineCommentsOf: aNode.

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitArrayNode: aNode [ 

	self writeInlineCommentsOf: aNode.
	stream << '[ '.
	aNode content 
		do: [ :innerNode | innerNode acceptVisitor: self ]
		betweenDo: [ stream << ', ' ].
	stream << ' ]'.
	
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitAssignmentNode: aNode [

	self writeInlineCommentsOf: aNode.
	aNode hasParentheses ifTrue: [ stream << '(' ].
	stream << aNode variable << ' = '.
	aNode expression acceptVisitor: self.
	aNode hasParentheses ifTrue: [ stream << ')' ].
	
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitAssociationNode: aNode [

	self writeInlineCommentsOf: aNode.

	stream << 'new Association<' << aNode keyType << ', ' << aNode valueType << '>('.
	aNode keyValue acceptVisitor: self.
	stream << ', '.
	aNode value acceptVisitor: self.
	stream << ')'
	
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitAtIfPresentIfAbsentStatementNode: aNode [

	aNode ifPresentArgName ifNotNil: [ 
		self indent. stream << aNode ifPresentArgType  << ' ' << aNode ifPresentArgName << ';'; lf.
	].	
	self indent. stream << 'if ('.
	aNode receiverExpression acceptVisitor: self.
	stream << '.TryGetValue('.
	aNode atExpression acceptVisitor: self.
	stream << ', out '.
	stream << (aNode ifPresentArgName ifNil: [ '_' ]).
	stream << '))'.
	self indent. stream << '{'; lf.
	self indent: [
		aNode ifPresentStatements do: [ :each | 
			each acceptVisitor: self ]
	].
	self indent. stream << '}'; lf.	
	
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitBinaryExpressionNode: aNode [ 

	self writeInlineCommentsOf: aNode.
	aNode hasParentheses ifTrue: [ stream << '(' ].
	aNode leftExpression acceptVisitor: self.
	stream << ' ' << aNode operator << ' '.
	aNode rightExpression acceptVisitor: self.
	aNode hasParentheses ifTrue: [ stream << ')' ].
	
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitCascadeNode: aNode [

	self writeInlineCommentsOf: aNode.
	self indent. stream << 'var ' << aNode name << ' = '.
	aNode expression acceptVisitor: self.
	stream << ';'; lf.
	aNode statements do: [ :each | 
	each acceptVisitor: self ].

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitCastAsNode: aNode [

	self writeInlineCommentsOf: aNode.
	aNode hasParentheses ifTrue: [ stream << '(' ].
	aNode expression acceptVisitor: self.
	stream << ' as '.
	stream << aNode type.
	aNode hasParentheses ifTrue: [ stream << ')' ].

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitCastDirectNode: aNode [

	self writeInlineCommentsOf: aNode.
	aNode hasParentheses ifTrue: [ stream << '(' ].
	stream << '('.
	stream << aNode type.
	stream << ')'.
	aNode expression acceptVisitor: self.
	aNode hasParentheses ifTrue: [ stream << ')' ].

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitClassNode: aNode [

	| classKeyword |
	
	classKeyword := aNode isInterface 
		ifTrue: [ ' interface ' ]
		ifFalse: [ ' class ' ].	

	self writeCommentsOf: aNode.
	self indent. stream << aNode visibility << classKeyword << aNode name.
	aNode hasGenericTypes ifTrue: [ 
		stream << '<'.
		aNode genericTypes 
			do: [ :genericType | stream << genericType ] betweenDo: [ stream << ', ' ].
		stream << '>'.
	].
	aNode hasSupertypes ifTrue: [ 
		stream << ' : '.
		aNode supertypes 
			do: [ :supertype | stream << supertype ] betweenDo: [ stream << ', ' ]
	].
	stream lf.
	
	self indent. stream << '{'; lf.
	self indent: [
		aNode variables do: [ :each | 
			each acceptVisitor: self ].
		(aNode variables notEmpty and: [ aNode regions notEmpty ]) ifTrue: [ stream lf ].

		aNode regions do: [ :each | 
			each acceptVisitor: self ] betweenDo: [ stream lf ].
		(aNode regions notEmpty and: [ aNode staticRegions notEmpty ]) ifTrue: [ stream lf ].
		
		aNode staticRegions do: [ :each | 
			each acceptVisitor: self ]	betweenDo: [ stream lf ].
	 ].
	self indent. stream << '}'; lf.
	
	

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitConstructorNode: aNode [

	aNode declarationOnly 
		ifTrue: [ self writeCommentsOf: aNode].
	
	self indent. 
	stream << aNode visibility << ' ' << aNode name << '('.

	aNode arguments do: [ :arg |
		arg acceptVisitor: self ]	
		betweenDo: [ stream << ', ' ].
	stream << ')'.
	
	aNode callsBase ifTrue: [ 
		stream << ' : base('.		
		aNode arguments do: [ :arg | 
			stream << arg name  ]	
			betweenDo: [ stream << ', ' ].
		stream << ')'.		
		 ].
	
 	stream lf.
	self indent. stream << '{'; lf.
	self indent: [
		self writeCommentsOf: aNode.
		super visitMethodNode: aNode		
	 ].
	self indent. stream << '}'; lf.

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitCopyExpressionNode: aNode [

	self writeInlineCommentsOf: aNode.
	aNode hasParentheses ifTrue: [ stream << '(' ].
	aNode expression acceptVisitor: self.
	stream << '.Copy<'.
	stream << aNode type.
	stream << '>()'.
	aNode hasParentheses ifTrue: [ stream << ')' ].

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitEnumNode: aNode [

	self writeCommentsOf: aNode.
	self indent. stream << aNode visibility << 'enum ' << aNode name.
	stream lf.
	
	self indent. stream << '{'; lf.
	self indent: [
		aNode values do: [ :aValue | 
			stream << aValue.
		] betweenDo: [ :aValue :index |
			stream << ', '.
			((index \\ 5) = 0) ifTrue: [ 
				stream lf. self indent ].
		]
	 ].
	self indent. stream lf; << '}'; lf.
	
	

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitExpressionStatementNode: aNode [

	aNode expression isEmptyNode ifTrue: [ ^ self ].

	self writeInlineCommentsOf: aNode.
	self indent.
	aNode expression acceptVisitor: self.
	stream << ';'; lf.
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitFileNode: aNode [

	self writeInlineCommentsOf: aNode.
	aNode usings do: [ :using |
		self indent. stream << 'using ' << using << ';'; lf. ].

	aNode usings ifNotEmpty: [ 
		stream lf 
	].

	aNode children 
		do: [ :each | 
			each acceptVisitor: self ]
		betweenDo: [ stream lf; lf ]
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitForEachKVPStatementNode: aNode [

	self writeInlineCommentsOf: aNode.
	self indent. stream << 'foreach (var kvp in '.
	aNode collectionExpression acceptVisitor: self.
	stream << ')'; lf.
	self indent. stream << '{'; lf.
	self indent: [
		self indent. stream << aNode keyType << ' ' << aNode keyName << ' = kvp.Key;'; lf.
		self indent. stream << aNode type << ' ' << aNode name << ' = kvp.Value;'; lf.
		aNode statements do: [ :each | 
			each acceptVisitor: self ]
	].
	self indent. stream << '}'; lf.
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitForEachStatementNode: aNode [

	self writeInlineCommentsOf: aNode.
	self indent. stream << 'foreach ('.
	stream << aNode type  << ' ' << aNode name << ' in '.
	aNode collectionExpression acceptVisitor: self.
	stream << ')'; lf.
	self indent. stream << '{'; lf.
	self indent: [
		aNode statements do: [ :each | 
			each acceptVisitor: self ]
	].
	self indent. stream << '}'; lf.
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitForWithObjectStatementNode: aNode [

	self writeInlineCommentsOf: aNode.
	self indent. stream << 'for ('.
	stream << aNode indexType  << ' ' << aNode indexName << ' = 1; '	<< aNode indexName << ' <= '.
	aNode collectionExpression acceptVisitor: self.
	stream << '.Count(); ' << aNode indexName << '++)'; lf.
	self indent. stream << '{'; lf.
	self indent: [
		self indent. stream << aNode type << ' ' << aNode name << ' = '.
		aNode collectionExpression acceptVisitor: self.
		stream << '[(int)' << aNode indexName << '-1];'; lf.
		aNode statements do: [ :each | 
			each acceptVisitor: self ]
	].
	self indent. stream << '}'; lf.
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitIfElseStatementNode: aNode [

	self writeInlineCommentsOf: aNode.
	self indent. stream << 'if ('.
	aNode booleanExpression acceptVisitor: self.
	stream << ')'; lf.
	
	self indent. stream << '{'; lf.
	self indent: [
		aNode ifStatements do: [ :each | 
			each acceptVisitor: self ]
	].
	self indent. stream << '} else {'; lf.
	self indent: [
		aNode elseStatements do: [ :each | 
			each acceptVisitor: self ]
	].
	self indent. stream << '}'; lf.	
	
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitIfElseWithVariableStatementNode: aNode [

	self writeInlineCommentsOf: aNode.
	self indent. stream << 'var ' << aNode name << ' = '.
	aNode valueExpression acceptVisitor: self.
	stream << ';'; lf.
	self indent. stream << 'if ('.
	aNode booleanExpression acceptVisitor: self.
	stream << ')'; lf.
	
	self indent. stream << '{'; lf.
	self indent: [
		aNode ifStatements do: [ :each | 
			each acceptVisitor: self ]
	].
	self indent. stream << '} else {'; lf.
	self indent: [
		aNode elseStatements do: [ :each | 
			each acceptVisitor: self ]
	].
	self indent. stream << '}'; lf.	
	
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitIfStatementNode: aNode [

	self writeInlineCommentsOf: aNode.
	self indent. stream << 'if ('.
	aNode booleanExpression acceptVisitor: self.
	stream << ')'; lf.
	
	self indent. stream << '{'; lf.
	self indent: [
		aNode ifStatements do: [ :each | 
			each acceptVisitor: self ]
	].
	self indent. stream << '}'; lf.
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitIfWithVariableStatementNode: aNode [

	self writeInlineCommentsOf: aNode.
	self indent. stream << 'var ' << aNode name << ' = '.
	aNode valueExpression acceptVisitor: self.
	stream << ';'; lf.
	self indent. stream << 'if ('.
	aNode booleanExpression acceptVisitor: self.
	stream << ')'; lf.
	
	self indent. stream << '{'; lf.
	self indent: [
		aNode ifStatements do: [ :each | 
			each acceptVisitor: self ]
	].
	self indent. stream << '}'; lf.
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitInferredVariableAssignmentNode: aNode [

	self writeInlineCommentsOf: aNode.
	self indent. 
	aNode modifier ifNotNil: [ :modif | stream << modif << ' ' ].
	stream << aNode type << ' ' << aNode name << ' = '.
	aNode expression acceptVisitor: self.
	stream << ';'; lf.

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitInstanceVariableDefinitionNode: aNode [

	self writeInlineCommentsOf: aNode.
	self indent. stream << aNode visibility << ' ' << aNode type << ' ' << aNode name.
	aNode isProperty 
		ifTrue: [ 
			stream << ' { get; set; }'; lf
		] 
		ifFalse: [ 
			stream << ';';  lf.
		]

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitInvocationNode: aNode [

	self writeInlineCommentsOf: aNode.
	aNode hasParentheses ifTrue: [ stream << '(' ].
	aNode expression acceptVisitor: self.
	stream << '()'.
	aNode hasParentheses ifTrue: [ stream << ')' ].

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitIsNode: aNode [

	self writeInlineCommentsOf: aNode.
	aNode hasParentheses ifTrue: [ stream << '(' ].
	aNode expression acceptVisitor: self.
	stream << ' is '.
	aNode type acceptVisitor: self.
	aNode hasParentheses ifTrue: [ stream << ')' ].

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitLambdaNode: aNode [

	self writeInlineCommentsOf: aNode.
	aNode hasParentheses ifTrue: [ stream << '(' ].
	stream << '('.
	aNode arguments do: [ :arg | 
		arg acceptVisitor: self ]	
		betweenDo: [ stream << ', ' ].

	(aNode isSingleExpression and: [ aNode statements size = 1 ])
		ifFalse: [ 
			stream << ') => {'; lf.
			self indent: [
				aNode statements do: [ :each | 
					each acceptVisitor: self ].
			].
			self indent. stream << '}'; lf. ]
	ifTrue: [ 
			stream << ') => '.
			(aNode statements first isExpressionStatement)
				ifTrue:  [ aNode statements first expression acceptVisitor: self ]
				ifFalse: [ aNode statements first acceptVisitor: self ].
		].
	aNode hasParentheses ifTrue: [ stream << ')' ].
		

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitListLiteralNode: aNode [ 

	self writeInlineCommentsOf: aNode.
	stream << 'new List<>[ '.
	aNode content 
		do: [ :innerNode | innerNode acceptVisitor: self ]
		betweenDo: [ stream << ', ' ].
	stream << ' ]'.
	
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitMessageSendArgumentNode: aNode [

	self writeInlineCommentsOf: aNode.
	aNode keyword ifNotNil: [ 
		stream << aNode keyword << ': ' ].
	
	super visitMessageSendArgumentNode: aNode
	

]

{ #category : 'as yet unclassified' }
PharoCSharpPrintingVisitor >> visitMessageSendNode: aNode [

	self writeInlineCommentsOf: aNode.
	aNode hasParentheses ifTrue: [ stream << '(' ].
	aNode cast ifNotNil: [ 
		stream << '(' << aNode cast << ')' ].
	aNode receiver isThis ifFalse: [ 
		aNode receiver ifNotNil: [ :receiver |
			receiver isString  "this, base"
				ifTrue: [ stream << receiver ]
				ifFalse: [ receiver acceptVisitor: self ].
			stream << '.' 
		].
	].
	stream << aNode name.
	aNode genericTypeArgument ifNotNil: [ :genArg |
		stream << '<' << genArg << '>'.		
	].
	stream << '('.
	aNode arguments 
		do: [ :each | each acceptVisitor: self ]
		betweenDo: [ stream << ', ' ].
	stream << ')'.
	aNode hasParentheses ifTrue: [ stream << ')' ].
	
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitMethodNode: aNode [

	aNode declarationOnly 
		ifTrue: [ self writeCommentsOf: aNode].
	
	self indent. 
	aNode static ifTrue: [ 
		stream << 'static '
	].

	stream << aNode visibility << ' ' << aNode type << ' ' << aNode name.
	
	aNode genericArguments ifNotEmpty: [ 
		stream << '<'.
		aNode genericArguments do: [ :arg |
			arg acceptVisitor: self ]	
			betweenDo: [ stream << ', ' ].
		stream << '>'.
	 ].
	
	stream << '('.
	aNode arguments do: [ :arg |
		arg acceptVisitor: self ]	
		betweenDo: [ stream << ', ' ].
	stream << ')'.
	
	aNode declarationOnly 
		ifTrue: [ stream << ';'; lf ]
		ifFalse: [ 
			stream lf.
			self indent. stream << '{'; lf.
			self indent: [
				self writeCommentsOf: aNode.
				super visitMethodNode: aNode		
			 ].
			self indent. stream << '}'; lf.
		]
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitNamespaceNode: aNode [

	self writeCommentsOf: aNode.
	self indent. stream << 'namespace ' << aNode name; lf.
	self indent. stream << '{'; lf.
	self indent: [
		super visitNamespaceNode: aNode		
	 ].
	self indent. stream << '}'; lf.
	
	

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitNewExpressionNode: aNode [

	self writeInlineCommentsOf: aNode.
	aNode hasParentheses ifTrue: [ stream << '(' ].
	stream << 'new '.
	aNode type ifNil: [ 
		aNode expression acceptVisitor: self. ]
		ifNotNil: [ stream << aNode type ].
	stream << '('.
	aNode arguments 
		do: [ :arg | arg acceptVisitor: self. ]
		betweenDo: [ stream << ', ' ].
	stream << ')'.
	aNode initializingValue ifNotNil: [ 
		stream << ' { '.
		aNode initializingValue acceptVisitor: self. 
		stream << ' }'.
	].
	aNode hasParentheses ifTrue: [ stream << ')' ].

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitNullCoalescingExpressionNode: aNode [

	self writeInlineCommentsOf: aNode.

	aNode hasParentheses ifTrue: [ stream << '(' ].
	aNode receiver acceptVisitor: self.
	stream << ' ?? '.
	aNode nullExpression acceptVisitor: self.
	aNode hasParentheses ifTrue: [ stream << ')' ].

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitPlainCodeNode: aNode [

	aNode ownLines ifTrue: [ 
		aNode content lines do: [ :line |
			self indent. stream << line; lf ].
		^ self
	].
	stream << aNode content.
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitRegionNode: aNode [

	self indent. stream << '#region ' << aNode name; lf.
	aNode methods do: [ :each | each acceptVisitor: self ].
	self indent. stream << '#endregion'; lf
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitReturnStatementNode: aNode [

	self writeInlineCommentsOf: aNode.
	self indent. stream << 'return'.
	(aNode expression isThis and: [ aNode static ])
		ifFalse: [ 
			stream << ' '.
			aNode expression acceptVisitor: self.
		].
	stream << ';'; lf.
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitSimpleExpressionNode: aNode [ 

	aNode hasParentheses ifTrue: [ stream << '(' ].
	self writeInlineCommentsOf: aNode.
	stream << aNode content.
	aNode hasParentheses ifTrue: [ stream << ')' ].

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitTernaryExpressionNode: aNode [

	self writeInlineCommentsOf: aNode.

	aNode hasParentheses ifTrue: [ stream << '(' ].
	aNode booleanExpression acceptVisitor: self.
	stream << ' ? '.
	aNode ifExpression acceptVisitor: self.
	stream << ' : '.
	aNode elseExpression acceptVisitor: self.
	aNode hasParentheses ifTrue: [ stream << ')' ].
	
	
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitTryCatchStatementNode: aNode [

	self writeInlineCommentsOf: aNode.
	self indent. stream << 'try {'; lf.

	self indent: [
		aNode tryStatements do: [ :each | 
			each acceptVisitor: self ]
	].
	self indent. stream << '}' ; lf.
	self indent. stream << 'catch ('.
	aNode exceptionType acceptVisitor: self.
	stream << ' ' << (aNode exceptionName ifNil: ['_']).
	stream << ')'; lf.
	self indent. stream << '{'; lf.
	self indent: [
		aNode catchStatements do: [ :each | 
			each acceptVisitor: self ]
	].
	self indent. stream << '}'; lf.	
	
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitTupleNode: aNode [

	self writeInlineCommentsOf: aNode.

	stream << '(' << aNode firstName << ': '.
	aNode firstValue acceptVisitor: self.
	stream << ', ' << aNode secondName << ': '.
	aNode secondValue acceptVisitor: self.
	stream << ')'
	
	

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitTypeOfNode: aNode [

	self writeInlineCommentsOf: aNode.
	aNode hasParentheses ifTrue: [ stream << '(' ].
	stream << 'typeof('.
	aNode expression acceptVisitor: self.
	stream << ')'.
	aNode hasParentheses ifTrue: [ stream << ')' ].

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitUnaryExpressionNode: aNode [

	self writeInlineCommentsOf: aNode.
	stream << aNode operator.
	aNode forceParentheses ifTrue: [ stream << '(' ].
	aNode expression acceptVisitor: self.
	aNode forceParentheses ifTrue: [ stream << ')' ].

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitVariableDeclarationNode: aNode [

	self writeInlineCommentsOf: aNode.
	self indent. stream << aNode type << ' ' << aNode name << ';'; lf.	
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> visitWhileStatementNode: aNode [

	self writeInlineCommentsOf: aNode.
	self indent. stream << 'while ('.
	aNode booleanExpression acceptVisitor: self.
	stream << ')'; lf.
	
	self indent. stream << '{'; lf.
	self indent: [
		aNode statements do: [ :each | 
			each acceptVisitor: self ]
	].
	self indent. stream << '}'; lf.
]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> writeCommentsOf: aNode [
	
	aNode comments do: [ :each | 
		each contents lines do: [ :line |
		self indent. stream << '// ' << line; lf ]
	].

]

{ #category : 'accessing' }
PharoCSharpPrintingVisitor >> writeInlineCommentsOf: aNode [
	
	aNode comments do: [ :each | 
		each contents lines do: [ :line |
		stream << ' /* ' << line << ' */ ' ]
	].

]
