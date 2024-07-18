Class {
	#name : 'PharoCSharpSimpleExpressionNode',
	#superclass : 'PharoCSharpExpressionNode',
	#instVars : [
		'content'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'instance creation' }
PharoCSharpSimpleExpressionNode class >> null [ 

	^ self new content: 'null'
]

{ #category : 'instance creation' }
PharoCSharpSimpleExpressionNode class >> this [ 

	^ self new content: 'this'
]

{ #category : 'accessing' }
PharoCSharpSimpleExpressionNode >> acceptVisitor: aVisitor [
	^ aVisitor visitSimpleExpressionNode: self
]

{ #category : 'accessing' }
PharoCSharpSimpleExpressionNode >> content [

	^ content
]

{ #category : 'accessing' }
PharoCSharpSimpleExpressionNode >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
PharoCSharpSimpleExpressionNode >> isSimpleExpression [ 

	^ true
]

{ #category : 'accessing' }
PharoCSharpSimpleExpressionNode >> isThis [ 

	^ content = #this
]
