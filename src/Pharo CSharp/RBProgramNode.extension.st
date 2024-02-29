Extension { #name : 'RBProgramNode' }

{ #category : '*Pharo CSharp' }
RBProgramNode >> allChildrenWithoutBlocks [
	| children |
	children := OrderedCollection new.
	self nonBlockNodesDo: [ :each | children addLast: each ].
	^ children
]

{ #category : '*Pharo CSharp' }
RBProgramNode >> declaresMustBeExpression [

	^ self propertyAt: #mustBeExpression ifAbsent: [ false ].
]

{ #category : '*Pharo CSharp' }
RBProgramNode >> mustBeExpression [

	self mustBeExpression: true.
]

{ #category : '*Pharo CSharp' }
RBProgramNode >> mustBeExpression: aBoolean [

	self propertyAt: #mustBeExpression put: aBoolean.
]

{ #category : '*Pharo CSharp' }
RBProgramNode >> nonBlockNodesDo: aBlock [
	"Evaluate aBlock on self and all chindren nodes, including comments"

	aBlock value: self.
	self childrenAndComments do: [ :each | 
		each isBlock ifFalse: [ 
			each nonBlockNodesDo: aBlock ] ]
]
