Class {
	#name : 'PharoCSharpLambdaNode',
	#superclass : 'PharoCSharpNode',
	#instVars : [
		'arguments',
		'statements',
		'isSingleExpression',
		'returnType'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'visiting' }
PharoCSharpLambdaNode >> acceptVisitor: aVisitor [
	^ aVisitor visitLambdaNode: self
]

{ #category : 'accessing' }
PharoCSharpLambdaNode >> addStatement: aNode [ 

	aNode parent: self.
	^ statements add: aNode
]

{ #category : 'accessing' }
PharoCSharpLambdaNode >> addStatements: nodes [ 

	nodes do: [ :each | each parent: self ].
	^ statements addAll: nodes
]

{ #category : 'accessing' }
PharoCSharpLambdaNode >> arguments [

	^ arguments
]

{ #category : 'accessing' }
PharoCSharpLambdaNode >> arguments: anObject [

	arguments := anObject.
	arguments do: [ :each | each parent: self ]
]

{ #category : 'visiting' }
PharoCSharpLambdaNode >> initialize [ 

	super initialize.
	
	arguments := OrderedCollection new.
	statements := OrderedCollection new.

]

{ #category : 'accessing' }
PharoCSharpLambdaNode >> isSingleExpression [

	^ isSingleExpression
]

{ #category : 'accessing' }
PharoCSharpLambdaNode >> isSingleExpression: anObject [

	isSingleExpression := anObject
]

{ #category : 'accessing' }
PharoCSharpLambdaNode >> returnType [

	^ returnType
]

{ #category : 'accessing' }
PharoCSharpLambdaNode >> returnType: anObject [

	returnType := anObject
]

{ #category : 'accessing' }
PharoCSharpLambdaNode >> statements [

	^ statements
]

{ #category : 'accessing' }
PharoCSharpLambdaNode >> statements: anObject [

	statements := anObject.
	statements do: [ :each | each parent: self ]
]
