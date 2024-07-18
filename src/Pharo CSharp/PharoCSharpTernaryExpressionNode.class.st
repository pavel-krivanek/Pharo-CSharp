Class {
	#name : 'PharoCSharpTernaryExpressionNode',
	#superclass : 'PharoCSharpExpressionNode',
	#instVars : [
		'booleanExpression',
		'ifExpression',
		'elseExpression'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpTernaryExpressionNode >> acceptVisitor: aVisitor [
	^ aVisitor visitTernaryExpressionNode: self
]

{ #category : 'accessing' }
PharoCSharpTernaryExpressionNode >> booleanExpression [

	^ booleanExpression
]

{ #category : 'accessing' }
PharoCSharpTernaryExpressionNode >> booleanExpression: anObject [

	booleanExpression := anObject.
	booleanExpression parent: self.
]

{ #category : 'accessing' }
PharoCSharpTernaryExpressionNode >> elseExpression [

	^ elseExpression
]

{ #category : 'accessing' }
PharoCSharpTernaryExpressionNode >> elseExpression: anObject [

	elseExpression := anObject.
	elseExpression parent: self.
]

{ #category : 'accessing' }
PharoCSharpTernaryExpressionNode >> ifExpression [

	^ ifExpression
]

{ #category : 'accessing' }
PharoCSharpTernaryExpressionNode >> ifExpression: anObject [

	ifExpression := anObject.
	ifExpression parent: self.
]

{ #category : 'accessing' }
PharoCSharpTernaryExpressionNode >> requiresParenthesesIfInsideExpression [

	^ true
]
