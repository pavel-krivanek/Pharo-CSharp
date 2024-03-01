Class {
	#name : #PharoCSharpInvocationNode,
	#superclass : #PharoCSharpExpressionNode,
	#instVars : [
		'expression'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpInvocationNode >> acceptVisitor: aVisitor [
	^ aVisitor visitInvocationNode: self
]

{ #category : #accessing }
PharoCSharpInvocationNode >> expression [

	^ expression
]

{ #category : #accessing }
PharoCSharpInvocationNode >> expression: anObject [

	expression := anObject
]
