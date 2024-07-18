"
Associations are transformed into the Association C# class. This node is for creating of such a ""literal"".
"
Class {
	#name : 'PharoCSharpAssociationNode',
	#superclass : 'PharoCSharpNode',
	#instVars : [
		'keyType',
		'keyValue',
		'valueType',
		'value'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpAssociationNode >> acceptVisitor: aVisitor [
	^ aVisitor visitAssociationNode: self
]

{ #category : 'accessing' }
PharoCSharpAssociationNode >> keyType [

	^ keyType
]

{ #category : 'accessing' }
PharoCSharpAssociationNode >> keyType: anObject [

	keyType := anObject
]

{ #category : 'accessing' }
PharoCSharpAssociationNode >> keyValue [

	^ keyValue
]

{ #category : 'accessing' }
PharoCSharpAssociationNode >> keyValue: anObject [

	keyValue := anObject
]

{ #category : 'accessing' }
PharoCSharpAssociationNode >> value [

	^ value
]

{ #category : 'accessing' }
PharoCSharpAssociationNode >> value: anObject [

	value := anObject
]

{ #category : 'accessing' }
PharoCSharpAssociationNode >> valueType [

	^ valueType
]

{ #category : 'accessing' }
PharoCSharpAssociationNode >> valueType: anObject [

	valueType := anObject
]
