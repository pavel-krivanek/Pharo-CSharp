Class {
	#name : 'PharoCSharpMessageSendNode',
	#superclass : 'PharoCSharpExpressionNode',
	#instVars : [
		'receiver',
		'name',
		'arguments',
		'cast',
		'genericTypeArgument'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'visiting' }
PharoCSharpMessageSendNode >> acceptVisitor: aVisitor [
	^ aVisitor visitMessageSendNode: self
]

{ #category : 'visiting' }
PharoCSharpMessageSendNode >> addArgument: argument [ 

	argument parent: self.
	arguments add: argument
]

{ #category : 'accessing' }
PharoCSharpMessageSendNode >> arguments [

	^ arguments
]

{ #category : 'accessing' }
PharoCSharpMessageSendNode >> arguments: anObject [

	arguments := anObject.
	arguments do: [ :each | each parent: self ]
]

{ #category : 'accessing' }
PharoCSharpMessageSendNode >> cast [

	^ cast
]

{ #category : 'accessing' }
PharoCSharpMessageSendNode >> cast: anObject [

	cast := anObject
]

{ #category : 'accessing' }
PharoCSharpMessageSendNode >> genericTypeArgument [

	^ genericTypeArgument
]

{ #category : 'accessing' }
PharoCSharpMessageSendNode >> genericTypeArgument: anObject [

	genericTypeArgument := anObject
]

{ #category : 'accessing' }
PharoCSharpMessageSendNode >> initialize [ 

	super initialize.
	
	arguments := OrderedCollection new.
]

{ #category : 'accessing' }
PharoCSharpMessageSendNode >> name [

	^ name
]

{ #category : 'accessing' }
PharoCSharpMessageSendNode >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
PharoCSharpMessageSendNode >> receiver [

	^ receiver
]

{ #category : 'accessing' }
PharoCSharpMessageSendNode >> receiver: anObject [

	receiver := anObject
]
