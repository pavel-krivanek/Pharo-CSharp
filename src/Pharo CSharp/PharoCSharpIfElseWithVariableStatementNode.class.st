Class {
	#name : 'PharoCSharpIfElseWithVariableStatementNode',
	#superclass : 'PharoCSharpIfWithVariableStatementNode',
	#instVars : [
		'elseStatements'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpIfElseWithVariableStatementNode >> acceptVisitor: aVisitor [
	^ aVisitor visitIfElseWithVariableStatementNode: self
]

{ #category : 'accessing' }
PharoCSharpIfElseWithVariableStatementNode >> elseStatements [

	^ elseStatements
]

{ #category : 'accessing' }
PharoCSharpIfElseWithVariableStatementNode >> elseStatements: anObject [

	elseStatements := anObject.
	elseStatements do: [ :each | each parent: self ]
]
