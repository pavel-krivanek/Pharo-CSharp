Class {
	#name : #PharoCSharpIfWithVariableStatementNode,
	#superclass : #PharoCSharpIfStatementNode,
	#instVars : [
		'name',
		'valueExpression'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpIfWithVariableStatementNode >> acceptVisitor: aVisitor [
	^ aVisitor visitIfWithVariableStatementNode: self
]

{ #category : #accessing }
PharoCSharpIfWithVariableStatementNode >> name [

	^ name
]

{ #category : #accessing }
PharoCSharpIfWithVariableStatementNode >> name: anObject [

	name := anObject
]

{ #category : #accessing }
PharoCSharpIfWithVariableStatementNode >> valueExpression [

	^ valueExpression
]

{ #category : #accessing }
PharoCSharpIfWithVariableStatementNode >> valueExpression: anObject [

	valueExpression := anObject.
	valueExpression parent: self.
]
