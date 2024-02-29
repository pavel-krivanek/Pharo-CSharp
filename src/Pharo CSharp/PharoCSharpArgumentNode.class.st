Class {
	#name : 'PharoCSharpArgumentNode',
	#superclass : 'PharoCSharpNode',
	#instVars : [
		'type',
		'name'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpArgumentNode >> acceptVisitor: aVisitor [
	^ aVisitor visitArgumentNode: self
]

{ #category : 'accessing' }
PharoCSharpArgumentNode >> name [

	^ name
]

{ #category : 'accessing' }
PharoCSharpArgumentNode >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
PharoCSharpArgumentNode >> type [

	^ type
]

{ #category : 'accessing' }
PharoCSharpArgumentNode >> type: anObject [

	type := anObject
]
