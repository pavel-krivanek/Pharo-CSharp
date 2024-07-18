Class {
	#name : 'PharoCSharpTupleNode',
	#superclass : 'PharoCSharpNode',
	#instVars : [
		'firstName',
		'firstValue',
		'secondName',
		'secondValue'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpTupleNode >> acceptVisitor: aVisitor [
	^ aVisitor visitTupleNode: self
]

{ #category : 'accessing' }
PharoCSharpTupleNode >> firstName [

	^ firstName
]

{ #category : 'accessing' }
PharoCSharpTupleNode >> firstName: anObject [

	firstName := anObject
]

{ #category : 'accessing' }
PharoCSharpTupleNode >> firstValue [

	^ firstValue
]

{ #category : 'accessing' }
PharoCSharpTupleNode >> firstValue: anObject [

	firstValue := anObject.
	firstValue parent: self
]

{ #category : 'accessing' }
PharoCSharpTupleNode >> secondName [

	^ secondName
]

{ #category : 'accessing' }
PharoCSharpTupleNode >> secondName: anObject [

	secondName := anObject
]

{ #category : 'accessing' }
PharoCSharpTupleNode >> secondValue [

	^ secondValue
]

{ #category : 'accessing' }
PharoCSharpTupleNode >> secondValue: anObject [

	secondValue := anObject.
	firstValue parent: self
]
