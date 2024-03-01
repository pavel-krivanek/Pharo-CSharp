Class {
	#name : #PharoCSharpTryCatchStatementNode,
	#superclass : #PharoCSharpStatementNode,
	#instVars : [
		'tryStatements',
		'catchStatements',
		'exceptionType',
		'exceptionName'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpTryCatchStatementNode >> acceptVisitor: aVisitor [
	^ aVisitor visitTryCatchStatementNode: self
]

{ #category : #accessing }
PharoCSharpTryCatchStatementNode >> catchStatements [

	^ catchStatements
]

{ #category : #accessing }
PharoCSharpTryCatchStatementNode >> catchStatements: anObject [

	catchStatements := anObject.
	catchStatements do: [ :each | each parent: self ]
]

{ #category : #accessing }
PharoCSharpTryCatchStatementNode >> exceptionName [

	^ exceptionName
]

{ #category : #accessing }
PharoCSharpTryCatchStatementNode >> exceptionName: anObject [

	exceptionName := anObject
]

{ #category : #accessing }
PharoCSharpTryCatchStatementNode >> exceptionType [

	^ exceptionType
]

{ #category : #accessing }
PharoCSharpTryCatchStatementNode >> exceptionType: anObject [

	exceptionType := anObject
]

{ #category : #accessing }
PharoCSharpTryCatchStatementNode >> tryStatements [

	^ tryStatements
]

{ #category : #accessing }
PharoCSharpTryCatchStatementNode >> tryStatements: anObject [

	tryStatements := anObject.
	tryStatements do: [ :each | each parent: self ]
]
