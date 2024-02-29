Class {
	#name : 'PharoCSharpCascadeNode',
	#superclass : 'PharoCSharpNode',
	#instVars : [
		'name',
		'expression',
		'statements'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpCascadeNode >> acceptVisitor: aVisitor [
	^ aVisitor visitCascadeNode: self
]

{ #category : 'accessing' }
PharoCSharpCascadeNode >> expression [

	^ expression
]

{ #category : 'accessing' }
PharoCSharpCascadeNode >> expression: anObject [

	expression := anObject.
	expression parent: self
]

{ #category : 'accessing' }
PharoCSharpCascadeNode >> name [

	^ name
]

{ #category : 'accessing' }
PharoCSharpCascadeNode >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
PharoCSharpCascadeNode >> statements [

	^ statements
]

{ #category : 'accessing' }
PharoCSharpCascadeNode >> statements: anObject [

	statements := anObject.
	statements do: [ :each | each parent: self ]
]
