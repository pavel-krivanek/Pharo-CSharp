Class {
	#name : #PharoCSharpCastDirectNode,
	#superclass : #PharoCSharpExpressionNode,
	#instVars : [
		'expression',
		'type'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpCastDirectNode >> acceptVisitor: aVisitor [
	^ aVisitor visitCastDirectNode: self
]

{ #category : #accessing }
PharoCSharpCastDirectNode >> expression [

	^ expression
]

{ #category : #accessing }
PharoCSharpCastDirectNode >> expression: anObject [

	expression := anObject
]

{ #category : #accessing }
PharoCSharpCastDirectNode >> type [

	^ type
]

{ #category : #accessing }
PharoCSharpCastDirectNode >> type: anObject [

	type := anObject
]
