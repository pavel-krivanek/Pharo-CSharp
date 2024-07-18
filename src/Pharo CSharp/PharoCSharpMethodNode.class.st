Class {
	#name : 'PharoCSharpMethodNode',
	#superclass : 'PharoCSharpNode',
	#instVars : [
		'static',
		'visibility',
		'name',
		'type',
		'arguments',
		'statements',
		'declarationOnly',
		'genericArguments'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpMethodNode >> acceptVisitor: aVisitor [
	^ aVisitor visitMethodNode: self
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> addArgument: aNode [ 

	aNode parent: self.
	^ arguments add: aNode
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> addStatement: aNode [ 

	aNode parent: self.
	^ statements add: aNode
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> addStatements: nodes [ 

	nodes do: [ :each | each parent: self ].
	^ statements addAll: nodes
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> arguments [

	^ arguments
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> arguments: anObject [

	arguments := anObject.
	arguments do: [ :each | each parent: self ]
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> declarationOnly [

	^ declarationOnly
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> declarationOnly: anObject [

	declarationOnly := anObject
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> genericArguments [

	^ genericArguments
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> genericArguments: anObject [

	genericArguments := anObject
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> initialize [ 

	super initialize.
	
	static := false.
	visibility := 'public'.
	arguments := OrderedCollection new.
	genericArguments := OrderedCollection new.
	statements := OrderedCollection new.
	declarationOnly := false.
	

]

{ #category : 'accessing' }
PharoCSharpMethodNode >> name [

	^ name
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> statements [

	^ statements
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> statements: anObject [

	statements := anObject.
	statements do: [ :each | each parent: self ]
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> static [

	^ static
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> static: anObject [

	static := anObject
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> type [

	^ type
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> type: anObject [

	type := anObject
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> visibility [

	^ visibility
]

{ #category : 'accessing' }
PharoCSharpMethodNode >> visibility: anObject [

	visibility := anObject
]
