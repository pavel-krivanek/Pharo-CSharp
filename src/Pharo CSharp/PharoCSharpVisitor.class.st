Class {
	#name : #PharoCSharpVisitor,
	#superclass : #Object,
	#category : 'Pharo CSharp-Visitors'
}

{ #category : #visiting }
PharoCSharpVisitor >> visitArgumentNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitArrayNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitAssociationNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitBinaryExpressionNode: aNode [

]

{ #category : #visiting }
PharoCSharpVisitor >> visitCastAsNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitCastDirectNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitClassNode: aNode [

	aNode variables do: [ :each | 
		each acceptVisitor: self ].

	aNode methods do: [ :each | 
		each acceptVisitor: self ].
	
	aNode staticMethods do: [ :each | 
		each acceptVisitor: self ]
]

{ #category : #visiting }
PharoCSharpVisitor >> visitConstructorNode: aNode [


]

{ #category : #visiting }
PharoCSharpVisitor >> visitCopyExpressionNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitEmptyNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitEnumNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitExpressionStatementNode: aNode [

	aNode expression acceptVisitor: self
]

{ #category : #visiting }
PharoCSharpVisitor >> visitFileNode: aNode [

	aNode children do: [ :each | 
		each acceptVisitor: self ]
]

{ #category : #visiting }
PharoCSharpVisitor >> visitForEachKVPStatementNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitForEachStatementNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitForWithObjectStatementNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitIfElseStatementNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitIfElseWithVariableStatementNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitIfStatementNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitIfWithVariableStatementNode: aNode [

]

{ #category : #visiting }
PharoCSharpVisitor >> visitInferredVariableAssignmentNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitInstanceVariableDefinitionNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitInvocationNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitIsNode: aNode [

	
]

{ #category : #visiting }
PharoCSharpVisitor >> visitLambdaNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitListLiteralNode: aNode [

	aNode expression acceptVisitor: self
]

{ #category : #visiting }
PharoCSharpVisitor >> visitMessageSendArgumentNode: aNode [

	aNode expression acceptVisitor: self
	

]

{ #category : #visiting }
PharoCSharpVisitor >> visitMessageSendNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitMethodNode: aNode [

	aNode statements do: [ :each | 
		each acceptVisitor: self ]
]

{ #category : #visiting }
PharoCSharpVisitor >> visitNamespaceNode: aNode [

	aNode children do: [ :each | 
		each acceptVisitor: self ]
]

{ #category : #visiting }
PharoCSharpVisitor >> visitNewExpressionNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitNullCoalescingExpressionNode: aNode [

]

{ #category : #visiting }
PharoCSharpVisitor >> visitPlainCodeNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitRegionNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitReturnStatementNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitSimpleExpressionNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitStatementNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitTernaryExpressionNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitTryCatchStatementNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitTupleNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitTypeNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitTypeOfNode: aNode [

]

{ #category : #visiting }
PharoCSharpVisitor >> visitUnaryExpressionNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitVariableDeclarationNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitVariableDefinitionNode: aNode [
]

{ #category : #visiting }
PharoCSharpVisitor >> visitWhileStatementNode: aNode [

	
]
