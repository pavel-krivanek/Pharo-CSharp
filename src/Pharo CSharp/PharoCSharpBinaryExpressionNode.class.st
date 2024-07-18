"
C# expressions with binary operators
"
Class {
	#name : 'PharoCSharpBinaryExpressionNode',
	#superclass : 'PharoCSharpExpressionNode',
	#instVars : [
		'leftExpression',
		'operator',
		'rightExpression'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpBinaryExpressionNode >> acceptVisitor: aVisitor [
	^ aVisitor visitBinaryExpressionNode: self
]

{ #category : 'accessing' }
PharoCSharpBinaryExpressionNode >> leftExpression [

	^ leftExpression
]

{ #category : 'accessing' }
PharoCSharpBinaryExpressionNode >> leftExpression: anObject [

	leftExpression := anObject.
	leftExpression parent: self.
]

{ #category : 'accessing' }
PharoCSharpBinaryExpressionNode >> operator [

	^ operator
]

{ #category : 'accessing' }
PharoCSharpBinaryExpressionNode >> operator: anObject [

	operator := anObject
]

{ #category : 'accessing' }
PharoCSharpBinaryExpressionNode >> rightExpression [

	^ rightExpression
]

{ #category : 'accessing' }
PharoCSharpBinaryExpressionNode >> rightExpression: anObject [

	rightExpression := anObject.
	rightExpression parent: self.
]
