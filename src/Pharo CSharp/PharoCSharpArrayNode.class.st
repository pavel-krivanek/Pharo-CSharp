Class {
	#name : 'PharoCSharpArrayNode',
	#superclass : 'PharoCSharpExpressionNode',
	#instVars : [
		'content'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'visiting' }
PharoCSharpArrayNode >> acceptVisitor: aVisitor [
	^ aVisitor visitArrayNode: self
]

{ #category : 'accessing' }
PharoCSharpArrayNode >> content [

	^ content
]

{ #category : 'accessing' }
PharoCSharpArrayNode >> content: anObject [

	content := anObject.
	content do: [ :each | each parent: self ].
]
