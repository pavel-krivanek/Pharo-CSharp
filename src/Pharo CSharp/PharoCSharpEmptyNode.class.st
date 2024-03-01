"
An utility node, mostly to preserver comments of the original Smalltalk nodes that are not transformed into C#
"
Class {
	#name : #PharoCSharpEmptyNode,
	#superclass : #PharoCSharpNode,
	#category : #'Pharo CSharp-AST'
}

{ #category : #visiting }
PharoCSharpEmptyNode >> acceptVisitor: aVisitor [
	^ aVisitor visitEmptyNode: self
]

{ #category : #visiting }
PharoCSharpEmptyNode >> isEmptyNode [

	^ true
]
