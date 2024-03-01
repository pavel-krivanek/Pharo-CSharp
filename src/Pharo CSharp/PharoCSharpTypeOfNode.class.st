Class {
	#name : #PharoCSharpTypeOfNode,
	#superclass : #PharoCSharpExpressionNode,
	#instVars : [
		'expression'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpTypeOfNode >> acceptVisitor: aVisitor [
	^ aVisitor visitTypeOfNode: self
]

{ #category : #accessing }
PharoCSharpTypeOfNode >> expression [

	^ expression
]

{ #category : #accessing }
PharoCSharpTypeOfNode >> expression: anObject [

	expression := anObject
]
