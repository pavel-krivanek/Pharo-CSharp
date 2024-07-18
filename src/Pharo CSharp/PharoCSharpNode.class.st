"
The base for nodes of reduced C# AST.
"
Class {
	#name : 'PharoCSharpNode',
	#superclass : 'Object',
	#instVars : [
		'parent',
		'comments',
		'hasParentheses'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'instance creation' }
PharoCSharpNode class >> from: anRBNode [ 

	^ self new
		from: anRBNode;
		yourself
]

{ #category : 'visiting' }
PharoCSharpNode >> acceptVisitor: aProgramNodeVisitor [
	self subclassResponsibility
]

{ #category : 'accessing' }
PharoCSharpNode >> addComment: aComment [ 

	comments add: aComment
]

{ #category : 'accessing' }
PharoCSharpNode >> comments [

	^ comments
]

{ #category : 'accessing' }
PharoCSharpNode >> comments: anObject [

	comments := anObject
]

{ #category : 'testing' }
PharoCSharpNode >> doNotUseParenthesesForChildren [ 

	^ false
]

{ #category : 'accessing' }
PharoCSharpNode >> from: anRBNode [ 

	anRBNode ifNil: [ ^ self ].
	
	comments := anRBNode comments.
	self hasParentheses: anRBNode parentheses notEmpty.


	
]

{ #category : 'accessing' }
PharoCSharpNode >> hasParentheses [

	(self parent notNil 
		and: [ self parent isExpression
		and: [ self isExpression 
		and: [ self requiresParenthesesIfInsideExpression 
		and: [ self parent doNotUseParenthesesForChildren not ]]] ]) 
			ifTrue: [ ^ true ].

	^ hasParentheses
]

{ #category : 'accessing' }
PharoCSharpNode >> hasParentheses: anObject [

	hasParentheses := anObject
]

{ #category : 'accessing' }
PharoCSharpNode >> initialize [ 

	super initialize.
	comments := OrderedCollection new.
	hasParentheses := false.
]

{ #category : 'testing' }
PharoCSharpNode >> isEmptyNode [

	^ false
]

{ #category : 'accessing' }
PharoCSharpNode >> isExpression [ 

	^ false
]

{ #category : 'accessing' }
PharoCSharpNode >> isSimpleExpression [ 

	^ false
]

{ #category : 'accessing' }
PharoCSharpNode >> isStatement [ 

	^ false
]

{ #category : 'accessing' }
PharoCSharpNode >> isThis [ 

	^ false
]

{ #category : 'accessing' }
PharoCSharpNode >> parent [

	^ parent
]

{ #category : 'accessing' }
PharoCSharpNode >> parent: anObject [

	parent := anObject
]

{ #category : 'testing' }
PharoCSharpNode >> requiresParenthesesIfInsideExpression [ 

	^ true
]
