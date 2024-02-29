Class {
	#name : 'PharoCSharpWhileStatementNode',
	#superclass : 'PharoCSharpStatementNode',
	#instVars : [
		'booleanExpression',
		'statements'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpWhileStatementNode >> acceptVisitor: aVisitor [
	^ aVisitor visitWhileStatementNode: self
]

{ #category : 'accessing' }
PharoCSharpWhileStatementNode >> booleanExpression [

	^ booleanExpression
]

{ #category : 'accessing' }
PharoCSharpWhileStatementNode >> booleanExpression: anObject [

	booleanExpression := anObject.
	booleanExpression parent: self.
]

{ #category : 'accessing' }
PharoCSharpWhileStatementNode >> statements [

	^ statements
]

{ #category : 'accessing' }
PharoCSharpWhileStatementNode >> statements: anObject [

	statements := anObject.
	statements do: [ :each | each parent: self ]
]
