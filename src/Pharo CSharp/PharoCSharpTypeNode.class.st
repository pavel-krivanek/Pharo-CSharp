Class {
	#name : 'PharoCSharpTypeNode',
	#superclass : 'PharoCSharpNode',
	#instVars : [
		'definition'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpTypeNode >> acceptVisitor: aVisitor [
	^ aVisitor visitTypeNode: self
]

{ #category : 'accessing' }
PharoCSharpTypeNode >> definition [

	^ definition
]

{ #category : 'accessing' }
PharoCSharpTypeNode >> definition: anObject [

	definition := anObject
]
