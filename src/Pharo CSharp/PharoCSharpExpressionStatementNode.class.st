Class {
	#name : 'PharoCSharpExpressionStatementNode',
	#superclass : 'PharoCSharpStatementNode',
	#instVars : [
		'expression'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'visiting' }
PharoCSharpExpressionStatementNode >> acceptVisitor: aVisitor [
	^ aVisitor visitExpressionStatementNode: self
]

{ #category : 'accessing' }
PharoCSharpExpressionStatementNode >> expression [

	^ expression
]

{ #category : 'accessing' }
PharoCSharpExpressionStatementNode >> expression: anObject [

	expression := anObject.
	expression parent: self.
]

{ #category : 'accessing' }
PharoCSharpExpressionStatementNode >> isExpressionStatement [

	 ^ true
]
