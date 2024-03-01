Class {
	#name : #PharoCSharpForEachKVPStatementNode,
	#superclass : #PharoCSharpStatementNode,
	#instVars : [
		'type',
		'name',
		'keyType',
		'keyName',
		'collectionExpression',
		'statements'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpForEachKVPStatementNode >> acceptVisitor: aVisitor [
	^ aVisitor visitForEachKVPStatementNode: self
]

{ #category : #accessing }
PharoCSharpForEachKVPStatementNode >> collectionExpression [

	^ collectionExpression
]

{ #category : #accessing }
PharoCSharpForEachKVPStatementNode >> collectionExpression: anObject [

	collectionExpression := anObject
]

{ #category : #accessing }
PharoCSharpForEachKVPStatementNode >> keyName [

	^ keyName
]

{ #category : #accessing }
PharoCSharpForEachKVPStatementNode >> keyName: anObject [

	keyName := anObject
]

{ #category : #accessing }
PharoCSharpForEachKVPStatementNode >> keyType [

	^ keyType
]

{ #category : #accessing }
PharoCSharpForEachKVPStatementNode >> keyType: anObject [

	keyType := anObject
]

{ #category : #accessing }
PharoCSharpForEachKVPStatementNode >> name [

	^ name
]

{ #category : #accessing }
PharoCSharpForEachKVPStatementNode >> name: anObject [

	name := anObject
]

{ #category : #accessing }
PharoCSharpForEachKVPStatementNode >> statements [

	^ statements
]

{ #category : #accessing }
PharoCSharpForEachKVPStatementNode >> statements: anObject [

	statements := anObject
]

{ #category : #accessing }
PharoCSharpForEachKVPStatementNode >> type [

	^ type
]

{ #category : #accessing }
PharoCSharpForEachKVPStatementNode >> type: anObject [

	type := anObject
]
