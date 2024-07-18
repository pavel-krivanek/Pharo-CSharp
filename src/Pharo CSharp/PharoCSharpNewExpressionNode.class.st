Class {
	#name : 'PharoCSharpNewExpressionNode',
	#superclass : 'PharoCSharpExpressionNode',
	#instVars : [
		'expression',
		'type',
		'arguments',
		'initializingValue'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpNewExpressionNode >> acceptVisitor: aVisitor [
	^ aVisitor visitNewExpressionNode: self
]

{ #category : 'accessing' }
PharoCSharpNewExpressionNode >> arguments [

	^ arguments
]

{ #category : 'accessing' }
PharoCSharpNewExpressionNode >> arguments: anObject [

	arguments := anObject
]

{ #category : 'accessing' }
PharoCSharpNewExpressionNode >> expression [

	^ expression
]

{ #category : 'accessing' }
PharoCSharpNewExpressionNode >> expression: anObject [

	expression := anObject.
	expression parent: self.
]

{ #category : 'accessing' }
PharoCSharpNewExpressionNode >> initialize [ 

	super initialize.
	arguments := OrderedCollection new.
]

{ #category : 'accessing' }
PharoCSharpNewExpressionNode >> initializingValue [

	^ initializingValue
]

{ #category : 'accessing' }
PharoCSharpNewExpressionNode >> initializingValue: anObject [

	initializingValue := anObject
]

{ #category : 'accessing' }
PharoCSharpNewExpressionNode >> size: anObject [

	arguments := { anObject }
]

{ #category : 'accessing' }
PharoCSharpNewExpressionNode >> type [

	^ type
]

{ #category : 'accessing' }
PharoCSharpNewExpressionNode >> type: anObject [

	type := anObject
]
