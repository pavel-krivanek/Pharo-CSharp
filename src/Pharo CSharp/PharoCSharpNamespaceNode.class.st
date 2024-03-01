Class {
	#name : #PharoCSharpNamespaceNode,
	#superclass : #PharoCSharpNode,
	#instVars : [
		'name',
		'children'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #visiting }
PharoCSharpNamespaceNode >> acceptVisitor: aVisitor [
	^ aVisitor visitNamespaceNode: self
]

{ #category : #visiting }
PharoCSharpNamespaceNode >> addChild: aChild [ 

	aChild parent: self.
	^ children add: aChild
]

{ #category : #accessing }
PharoCSharpNamespaceNode >> children [

	^ children
]

{ #category : #accessing }
PharoCSharpNamespaceNode >> children: anObject [

	children := anObject.
	children do: [ :each | each parent: self ]
]

{ #category : #visiting }
PharoCSharpNamespaceNode >> initialize [ 

	super initialize.
	
	children := OrderedCollection new.	
]

{ #category : #accessing }
PharoCSharpNamespaceNode >> name [

	^ name
]

{ #category : #accessing }
PharoCSharpNamespaceNode >> name: anObject [

	name := anObject
]
