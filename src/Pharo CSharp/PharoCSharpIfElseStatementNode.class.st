Class {
	#name : #PharoCSharpIfElseStatementNode,
	#superclass : #PharoCSharpIfStatementNode,
	#instVars : [
		'elseStatements'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpIfElseStatementNode >> acceptVisitor: aVisitor [
	^ aVisitor visitIfElseStatementNode: self
]

{ #category : #accessing }
PharoCSharpIfElseStatementNode >> elseStatements [

	^ elseStatements
]

{ #category : #accessing }
PharoCSharpIfElseStatementNode >> elseStatements: anObject [

	elseStatements := anObject.
	elseStatements do: [ :each | each parent: self ].
]
