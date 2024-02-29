Class {
	#name : 'PharoCSharpEmptyNode',
	#superclass : 'PharoCSharpNode',
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'visiting' }
PharoCSharpEmptyNode >> acceptVisitor: aVisitor [
	^ aVisitor visitEmptyNode: self
]

{ #category : 'visiting' }
PharoCSharpEmptyNode >> isEmptyNode [

	^ true
]
