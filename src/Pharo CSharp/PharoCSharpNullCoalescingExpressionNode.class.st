Class {
	#name : #PharoCSharpNullCoalescingExpressionNode,
	#superclass : #PharoCSharpExpressionNode,
	#instVars : [
		'receiver',
		'nullExpression'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpNullCoalescingExpressionNode >> acceptVisitor: aVisitor [
	^ aVisitor visitNullCoalescingExpressionNode: self
]

{ #category : #accessing }
PharoCSharpNullCoalescingExpressionNode >> nullExpression [

	^ nullExpression
]

{ #category : #accessing }
PharoCSharpNullCoalescingExpressionNode >> nullExpression: anObject [

	nullExpression := anObject.
	nullExpression parent: self.
]

{ #category : #accessing }
PharoCSharpNullCoalescingExpressionNode >> receiver [

	^ receiver
]

{ #category : #accessing }
PharoCSharpNullCoalescingExpressionNode >> receiver: anObject [

	receiver := anObject.
	receiver parent: self.
]
