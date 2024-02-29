Class {
	#name : 'PharoCSharpExpressionNode',
	#superclass : 'PharoCSharpNode',
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'testing' }
PharoCSharpExpressionNode >> isExpression [ 

	^ true
]

{ #category : 'testing' }
PharoCSharpExpressionNode >> requiresParenthesesIfInsideExpression [

	^ false
]
