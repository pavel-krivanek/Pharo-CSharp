Class {
	#name : #PharoCSharpRegionNode,
	#superclass : #PharoCSharpNode,
	#instVars : [
		'name',
		'methods'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpRegionNode >> acceptVisitor: aVisitor [
	^ aVisitor visitRegionNode: self
]

{ #category : #accessing }
PharoCSharpRegionNode >> addMethod: aMethodNode [ 

	aMethodNode parent: self.
	^ methods add: aMethodNode
]

{ #category : #accessing }
PharoCSharpRegionNode >> initialize [ 

	super initialize.
	methods := OrderedCollection new.
]

{ #category : #accessing }
PharoCSharpRegionNode >> methods [

	^ methods
]

{ #category : #accessing }
PharoCSharpRegionNode >> methods: anObject [

	methods := anObject.
	methods do: [ :each | each parent: self ]
]

{ #category : #accessing }
PharoCSharpRegionNode >> name [

	^ name
]

{ #category : #accessing }
PharoCSharpRegionNode >> name: anObject [

	name := anObject
]
