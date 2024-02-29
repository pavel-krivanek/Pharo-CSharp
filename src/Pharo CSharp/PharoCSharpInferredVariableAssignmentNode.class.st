Class {
	#name : 'PharoCSharpInferredVariableAssignmentNode',
	#superclass : 'PharoCSharpExpressionNode',
	#instVars : [
		'name',
		'expression',
		'type',
		'modifier'
	],
	#category : 'Pharo CSharp-AST',
	#package : 'Pharo CSharp',
	#tag : 'AST'
}

{ #category : 'accessing' }
PharoCSharpInferredVariableAssignmentNode >> acceptVisitor: aVisitor [
	^ aVisitor visitInferredVariableAssignmentNode: self
]

{ #category : 'accessing' }
PharoCSharpInferredVariableAssignmentNode >> expression [

	^ expression
]

{ #category : 'accessing' }
PharoCSharpInferredVariableAssignmentNode >> expression: anObject [

	expression := anObject.
	expression parent: self.
]

{ #category : 'accessing' }
PharoCSharpInferredVariableAssignmentNode >> initialize [ 

	super initialize.
	type := 'var'.
]

{ #category : 'accessing' }
PharoCSharpInferredVariableAssignmentNode >> modifier [

	^ modifier
]

{ #category : 'accessing' }
PharoCSharpInferredVariableAssignmentNode >> modifier: anObject [

	modifier := anObject
]

{ #category : 'accessing' }
PharoCSharpInferredVariableAssignmentNode >> name [

	^ name
]

{ #category : 'accessing' }
PharoCSharpInferredVariableAssignmentNode >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
PharoCSharpInferredVariableAssignmentNode >> type [

	^ type
]

{ #category : 'accessing' }
PharoCSharpInferredVariableAssignmentNode >> type: anObject [

	type := anObject
]
