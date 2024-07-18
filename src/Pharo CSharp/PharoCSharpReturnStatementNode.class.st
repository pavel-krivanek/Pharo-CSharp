Class {
	#name : 'PharoCSharpReturnStatementNode',
	#superclass : 'PharoCSharpStatementNode',
	#instVars : [
		'expression',
		'static'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpReturnStatementNode >> acceptVisitor: aVisitor [
	^ aVisitor visitReturnStatementNode: self
]

{ #category : 'accessing' }
PharoCSharpReturnStatementNode >> expression [

	^ expression
]

{ #category : 'accessing' }
PharoCSharpReturnStatementNode >> expression: anObject [

	expression := anObject.
	expression parent: self.
]

{ #category : 'accessing' }
PharoCSharpReturnStatementNode >> initialize [ 
	super initialize.
	static := false.
]

{ #category : 'accessing' }
PharoCSharpReturnStatementNode >> static [

	^ static
]

{ #category : 'accessing' }
PharoCSharpReturnStatementNode >> static: anObject [

	static := anObject
]
