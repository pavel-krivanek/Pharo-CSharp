Class {
	#name : #PharoCSharpVariableDeclarationNode,
	#superclass : #PharoCSharpStatementNode,
	#instVars : [
		'type',
		'name'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpVariableDeclarationNode >> acceptVisitor: aVisitor [
	^ aVisitor visitVariableDeclarationNode: self
]

{ #category : #accessing }
PharoCSharpVariableDeclarationNode >> name [

	^ name
]

{ #category : #accessing }
PharoCSharpVariableDeclarationNode >> name: anObject [

	name := anObject
]

{ #category : #accessing }
PharoCSharpVariableDeclarationNode >> type [

	^ type
]

{ #category : #accessing }
PharoCSharpVariableDeclarationNode >> type: anObject [

	type := anObject
]
