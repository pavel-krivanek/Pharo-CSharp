Class {
	#name : #PharoCSharpUnaryExpressionNode,
	#superclass : #PharoCSharpExpressionNode,
	#instVars : [
		'expression',
		'operator',
		'forceParentheses'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpUnaryExpressionNode >> acceptVisitor: aVisitor [
	^ aVisitor visitUnaryExpressionNode: self
]

{ #category : #accessing }
PharoCSharpUnaryExpressionNode >> expression [

	^ expression
]

{ #category : #accessing }
PharoCSharpUnaryExpressionNode >> expression: anObject [

	expression := anObject.
	expression parent: self.
]

{ #category : #accessing }
PharoCSharpUnaryExpressionNode >> forceParentheses [

	^ forceParentheses
]

{ #category : #accessing }
PharoCSharpUnaryExpressionNode >> forceParentheses: anObject [

	forceParentheses := anObject
]

{ #category : #accessing }
PharoCSharpUnaryExpressionNode >> initialize [ 

	super initialize.
	forceParentheses := false.
]

{ #category : #accessing }
PharoCSharpUnaryExpressionNode >> operator [

	^ operator
]

{ #category : #accessing }
PharoCSharpUnaryExpressionNode >> operator: anObject [

	operator := anObject
]
