Class {
	#name : #PharoCSharpForWithObjectStatementNode,
	#superclass : #PharoCSharpForeachStatementNode,
	#instVars : [
		'indexType',
		'indexName'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpForWithObjectStatementNode >> acceptVisitor: aVisitor [
	^ aVisitor visitForWithObjectStatementNode: self
]

{ #category : #accessing }
PharoCSharpForWithObjectStatementNode >> indexName [

	^ indexName
]

{ #category : #accessing }
PharoCSharpForWithObjectStatementNode >> indexName: anObject [

	indexName := anObject
]

{ #category : #accessing }
PharoCSharpForWithObjectStatementNode >> indexType [

	^ indexType
]

{ #category : #accessing }
PharoCSharpForWithObjectStatementNode >> indexType: anObject [

	indexType := anObject
]
