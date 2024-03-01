Class {
	#name : #PharoCSharpAtIfPresentIfAbsentStatementNode,
	#superclass : #PharoCSharpStatementNode,
	#instVars : [
		'receiverExpression',
		'atExpression',
		'ifPresentStatements',
		'ifPresentArgName',
		'ifPresentArgType',
		'ifAbsentStatements'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpAtIfPresentIfAbsentStatementNode >> acceptVisitor: aVisitor [
	^ aVisitor visitAtIfPresentIfAbsentStatementNode: self
]

{ #category : #accessing }
PharoCSharpAtIfPresentIfAbsentStatementNode >> atExpression [

	^ atExpression
]

{ #category : #accessing }
PharoCSharpAtIfPresentIfAbsentStatementNode >> atExpression: anObject [

	atExpression := anObject
]

{ #category : #accessing }
PharoCSharpAtIfPresentIfAbsentStatementNode >> ifAbsentStatements [

	^ ifAbsentStatements
]

{ #category : #accessing }
PharoCSharpAtIfPresentIfAbsentStatementNode >> ifAbsentStatements: anObject [

	ifAbsentStatements := anObject
]

{ #category : #accessing }
PharoCSharpAtIfPresentIfAbsentStatementNode >> ifPresentArgName [

	^ ifPresentArgName
]

{ #category : #accessing }
PharoCSharpAtIfPresentIfAbsentStatementNode >> ifPresentArgName: anObject [

	ifPresentArgName := anObject
]

{ #category : #accessing }
PharoCSharpAtIfPresentIfAbsentStatementNode >> ifPresentArgType [

	^ ifPresentArgType
]

{ #category : #accessing }
PharoCSharpAtIfPresentIfAbsentStatementNode >> ifPresentArgType: anObject [

	ifPresentArgType := anObject
]

{ #category : #accessing }
PharoCSharpAtIfPresentIfAbsentStatementNode >> ifPresentStatements [

	^ ifPresentStatements
]

{ #category : #accessing }
PharoCSharpAtIfPresentIfAbsentStatementNode >> ifPresentStatements: anObject [

	ifPresentStatements := anObject
]

{ #category : #accessing }
PharoCSharpAtIfPresentIfAbsentStatementNode >> receiverExpression [

	^ receiverExpression
]

{ #category : #accessing }
PharoCSharpAtIfPresentIfAbsentStatementNode >> receiverExpression: anObject [

	receiverExpression := anObject
]
