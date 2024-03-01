Class {
	#name : #PharoCSharpStatementNode,
	#superclass : #PharoCSharpNode,
	#category : 'Pharo CSharp-AST'
}

{ #category : #visiting }
PharoCSharpStatementNode >> acceptVisitor: aVisitor [
	^ aVisitor visitStatementNode: self
]

{ #category : #visiting }
PharoCSharpStatementNode >> isExpressionStatement [

	 ^ false
]

{ #category : #visiting }
PharoCSharpStatementNode >> isStatement [ 

	^ true
]
