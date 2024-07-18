Class {
	#name : 'PharoCSharpCastAsNode',
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
PharoCSharpCastAsNode >> acceptVisitor: aVisitor [
	^ aVisitor visitCastAsNode: self
]

{ #category : 'accessing' }
PharoCSharpCastAsNode >> expression [

	^ expression
]

{ #category : 'accessing' }
PharoCSharpCastAsNode >> expression: anObject [

	expression := anObject
]

{ #category : 'accessing' }
PharoCSharpCastAsNode >> type [

	^ type
]

{ #category : 'accessing' }
PharoCSharpCastAsNode >> type: anObject [

	type := anObject
]
