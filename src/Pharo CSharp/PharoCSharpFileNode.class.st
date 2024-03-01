Class {
	#name : #PharoCSharpFileNode,
	#superclass : #PharoCSharpNode,
	#instVars : [
		'name',
		'usings',
		'classes',
		'children'
	],
	#category : 'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpFileNode >> acceptVisitor: aVisitor [
	^ aVisitor visitFileNode: self
]

{ #category : #accessing }
PharoCSharpFileNode >> addChild: aChild [ 

	aChild parent: self.
	^ children add: aChild
]

{ #category : #accessing }
PharoCSharpFileNode >> addUsing: using [

	^ usings add: using
]

{ #category : #accessing }
PharoCSharpFileNode >> children [

	^ children
]

{ #category : #accessing }
PharoCSharpFileNode >> children: anObject [

	children := anObject.
	children do: [ :each | each parent: self ]
]

{ #category : #accessing }
PharoCSharpFileNode >> initialize [ 

	super initialize.
	
	usings := OrderedCollection new.
	children := OrderedCollection new.	
]

{ #category : #accessing }
PharoCSharpFileNode >> name [

	^ name
]

{ #category : #accessing }
PharoCSharpFileNode >> name: anObject [

	name := anObject
]

{ #category : #accessing }
PharoCSharpFileNode >> usings [

	^ usings
]

{ #category : #accessing }
PharoCSharpFileNode >> usings: anObject [

	usings := anObject
]
