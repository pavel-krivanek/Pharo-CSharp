Class {
	#name : 'PharoCSharpForeachStatementNode',
	#superclass : 'PharoCSharpStatementNode',
	#instVars : [
		'type',
		'name',
		'collectionExpression',
		'statements'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpForeachStatementNode >> acceptVisitor: aVisitor [
	^ aVisitor visitForEachStatementNode: self
]

{ #category : 'accessing' }
PharoCSharpForeachStatementNode >> collectionExpression [

	^ collectionExpression
]

{ #category : 'accessing' }
PharoCSharpForeachStatementNode >> collectionExpression: anObject [

	collectionExpression := anObject.
	collectionExpression parent: self.
]

{ #category : 'accessing' }
PharoCSharpForeachStatementNode >> name [

	^ name
]

{ #category : 'accessing' }
PharoCSharpForeachStatementNode >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
PharoCSharpForeachStatementNode >> statements [

	^ statements
]

{ #category : 'accessing' }
PharoCSharpForeachStatementNode >> statements: anObject [

	statements := anObject.
	statements do: [ :each | each parent: self ]
]

{ #category : 'accessing' }
PharoCSharpForeachStatementNode >> type [

	^ type
]

{ #category : 'accessing' }
PharoCSharpForeachStatementNode >> type: anObject [

	type := anObject
]
