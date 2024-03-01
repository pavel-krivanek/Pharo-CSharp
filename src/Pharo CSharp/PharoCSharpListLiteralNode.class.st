Class {
	#name : #PharoCSharpListLiteralNode,
	#superclass : #PharoCSharpExpressionNode,
	#instVars : [
		'content'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpListLiteralNode >> acceptVisitor: aVisitor [
	^ aVisitor visitListLiteralNode: self
]

{ #category : #accessing }
PharoCSharpListLiteralNode >> content [

	^ content
]

{ #category : #accessing }
PharoCSharpListLiteralNode >> content: anObject [

	content := anObject
]
