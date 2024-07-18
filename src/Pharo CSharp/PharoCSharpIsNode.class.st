Class {
	#name : 'PharoCSharpIsNode',
	#superclass : 'PharoCSharpNode',
	#instVars : [
		'expression',
		'type'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpIsNode >> acceptVisitor: aVisitor [
	^ aVisitor visitIsNode: self
]

{ #category : 'accessing' }
PharoCSharpIsNode >> expression [

	^ expression
]

{ #category : 'accessing' }
PharoCSharpIsNode >> expression: anObject [

	expression := anObject
]

{ #category : 'accessing' }
PharoCSharpIsNode >> type [

	^ type
]

{ #category : 'accessing' }
PharoCSharpIsNode >> type: anObject [

	type := anObject
]
