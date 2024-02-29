Class {
	#name : 'PharoCSharpCopyExpressionNode',
	#superclass : 'PharoCSharpExpressionNode',
	#instVars : [
		'expression',
		'type'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpCopyExpressionNode >> acceptVisitor: aVisitor [
	^ aVisitor visitCopyExpressionNode: self
]

{ #category : 'accessing' }
PharoCSharpCopyExpressionNode >> expression [

	^ expression
]

{ #category : 'accessing' }
PharoCSharpCopyExpressionNode >> expression: anObject [

	expression := anObject.
	expression parent: self.
]

{ #category : 'accessing' }
PharoCSharpCopyExpressionNode >> type [

	^ type
]

{ #category : 'accessing' }
PharoCSharpCopyExpressionNode >> type: anObject [

	type := anObject
]
