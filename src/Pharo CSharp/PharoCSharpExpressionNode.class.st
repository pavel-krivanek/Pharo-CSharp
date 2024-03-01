"
An abstract superclass for C# expression nodes.
"
Class {
	#name : #PharoCSharpExpressionNode,
	#superclass : #PharoCSharpNode,
	#category : #'Pharo CSharp-AST'
}

{ #category : #testing }
PharoCSharpExpressionNode >> isExpression [ 

	^ true
]

{ #category : #testing }
PharoCSharpExpressionNode >> requiresParenthesesIfInsideExpression [

	^ false
]
