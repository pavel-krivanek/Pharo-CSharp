Class {
	#name : 'PharoCSharpTypeOfNode',
	#superclass : 'PharoCSharpExpressionNode',
	#instVars : [
		'expression'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpTypeOfNode >> acceptVisitor: aVisitor [
	^ aVisitor visitTypeOfNode: self
]

{ #category : 'accessing' }
PharoCSharpTypeOfNode >> expression [

	^ expression
]

{ #category : 'accessing' }
PharoCSharpTypeOfNode >> expression: anObject [

	expression := anObject
]
