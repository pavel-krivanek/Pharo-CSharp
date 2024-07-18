Class {
	#name : 'PharoCSharpMessageSendArgument',
	#superclass : 'PharoCSharpNode',
	#instVars : [
		'keyword',
		'expression'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpMessageSendArgument >> acceptVisitor: aVisitor [
	^ aVisitor visitMessageSendArgumentNode: self
]

{ #category : 'accessing' }
PharoCSharpMessageSendArgument >> expression [

	^ expression
]

{ #category : 'accessing' }
PharoCSharpMessageSendArgument >> expression: anObject [

	expression := anObject.
	expression parent: self.
]

{ #category : 'accessing' }
PharoCSharpMessageSendArgument >> keyword [

	^ keyword
]

{ #category : 'accessing' }
PharoCSharpMessageSendArgument >> keyword: anObject [

	keyword := anObject
]
