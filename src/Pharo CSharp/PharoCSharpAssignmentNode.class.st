"
C# assignment node expression
"
Class {
	#name : 'PharoCSharpAssignmentNode',
	#superclass : 'PharoCSharpExpressionNode',
	#instVars : [
		'variable',
		'expression'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpAssignmentNode >> acceptVisitor: aVisitor [
	^ aVisitor visitAssignmentNode: self
]

{ #category : 'accessing' }
PharoCSharpAssignmentNode >> doNotUseParenthesesForChildren [ 

	^ true
]

{ #category : 'accessing' }
PharoCSharpAssignmentNode >> expression [

	^ expression
]

{ #category : 'accessing' }
PharoCSharpAssignmentNode >> expression: anObject [

	expression := anObject.
	expression parent: self.
]

{ #category : 'accessing' }
PharoCSharpAssignmentNode >> requiresParenthesesIfInsideExpression [

	^ true
]

{ #category : 'accessing' }
PharoCSharpAssignmentNode >> variable [

	^ variable
]

{ #category : 'accessing' }
PharoCSharpAssignmentNode >> variable: anObject [

	variable := anObject.
]
