Class {
	#name : 'PharoCSharpIfStatementNode',
	#superclass : 'PharoCSharpStatementNode',
	#instVars : [
		'booleanExpression',
		'ifStatements'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpIfStatementNode >> acceptVisitor: aVisitor [
	^ aVisitor visitIfStatementNode: self
]

{ #category : 'accessing' }
PharoCSharpIfStatementNode >> booleanExpression [

	^ booleanExpression
]

{ #category : 'accessing' }
PharoCSharpIfStatementNode >> booleanExpression: anObject [

	booleanExpression := anObject.
	booleanExpression parent: self.
]

{ #category : 'accessing' }
PharoCSharpIfStatementNode >> ifStatements [

	^ ifStatements
]

{ #category : 'accessing' }
PharoCSharpIfStatementNode >> ifStatements: anObject [

	ifStatements := anObject.
	anObject do: [ :each | each parent: self ]
]
