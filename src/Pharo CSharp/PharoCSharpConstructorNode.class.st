Class {
	#name : #PharoCSharpConstructorNode,
	#superclass : #PharoCSharpMethodNode,
	#instVars : [
		'callsBase'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpConstructorNode >> acceptVisitor: aVisitor [
	^ aVisitor visitConstructorNode: self
]

{ #category : #accessing }
PharoCSharpConstructorNode >> callsBase [

	^ callsBase
]

{ #category : #accessing }
PharoCSharpConstructorNode >> callsBase: anObject [

	callsBase := anObject
]

{ #category : #accessing }
PharoCSharpConstructorNode >> initialize [ 

	super initialize.
	callsBase := false.
]

{ #category : #accessing }
PharoCSharpConstructorNode >> intialize [ 

	super initialize.
	callsBase := false.
]
