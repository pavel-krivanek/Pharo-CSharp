"
A node for C# enumerations
"
Class {
	#name : 'PharoCSharpEnumNode',
	#superclass : 'PharoCSharpNode',
	#instVars : [
		'visibility',
		'name',
		'values'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpEnumNode >> acceptVisitor: aVisitor [
	^ aVisitor visitEnumNode: self
]

{ #category : 'accessing' }
PharoCSharpEnumNode >> initialize [ 

	super initialize.
	visibility := 'public '
]

{ #category : 'accessing' }
PharoCSharpEnumNode >> name [

	^ name
]

{ #category : 'accessing' }
PharoCSharpEnumNode >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
PharoCSharpEnumNode >> values [

	^ values
]

{ #category : 'accessing' }
PharoCSharpEnumNode >> values: anObject [

	values := anObject
]

{ #category : 'accessing' }
PharoCSharpEnumNode >> visibility [

	^ visibility
]

{ #category : 'accessing' }
PharoCSharpEnumNode >> visibility: anObject [

	visibility := anObject
]
