Class {
	#name : 'PharoCSharpPlainCodeNode',
	#superclass : 'PharoCSharpNode',
	#instVars : [
		'content',
		'ownLines'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpPlainCodeNode >> acceptVisitor: aVisitor [
	^ aVisitor visitPlainCodeNode: self
]

{ #category : 'accessing' }
PharoCSharpPlainCodeNode >> content [

	^ content
]

{ #category : 'accessing' }
PharoCSharpPlainCodeNode >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
PharoCSharpPlainCodeNode >> initialize [ 

	super initialize.
	ownLines := true.
]

{ #category : 'accessing' }
PharoCSharpPlainCodeNode >> ownLines [

	^ ownLines
]

{ #category : 'accessing' }
PharoCSharpPlainCodeNode >> ownLines: anObject [

	ownLines := anObject
]
