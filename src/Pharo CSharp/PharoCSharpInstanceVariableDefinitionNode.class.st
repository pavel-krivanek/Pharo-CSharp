Class {
	#name : 'PharoCSharpInstanceVariableDefinitionNode',
	#superclass : 'PharoCSharpNode',
	#instVars : [
		'type',
		'name',
		'visibility',
		'isProperty'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpInstanceVariableDefinitionNode >> acceptVisitor: aVisitor [
	^ aVisitor visitInstanceVariableDefinitionNode: self
]

{ #category : 'accessing' }
PharoCSharpInstanceVariableDefinitionNode >> initialize [ 

	super initialize.
	
	visibility := ''.
	isProperty := false.
]

{ #category : 'accessing' }
PharoCSharpInstanceVariableDefinitionNode >> isProperty [

	^ isProperty
]

{ #category : 'accessing' }
PharoCSharpInstanceVariableDefinitionNode >> isProperty: anObject [

	isProperty := anObject
]

{ #category : 'accessing' }
PharoCSharpInstanceVariableDefinitionNode >> name [

	^ name
]

{ #category : 'accessing' }
PharoCSharpInstanceVariableDefinitionNode >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
PharoCSharpInstanceVariableDefinitionNode >> type [

	^ type
]

{ #category : 'accessing' }
PharoCSharpInstanceVariableDefinitionNode >> type: anObject [

	type := anObject
]

{ #category : 'accessing' }
PharoCSharpInstanceVariableDefinitionNode >> visibility [

	^ visibility
]

{ #category : 'accessing' }
PharoCSharpInstanceVariableDefinitionNode >> visibility: anObject [

	visibility := anObject
]
