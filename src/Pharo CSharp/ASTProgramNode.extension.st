Extension { #name : 'ASTProgramNode' }

{ #category : '*Pharo CSharp' }
ASTProgramNode >> allChildrenWithoutBlocks [
	| children |
	children := OrderedCollection new.
	self nonBlockNodesDo: [ :each | children addLast: each ].
	^ children
]

{ #category : '*Pharo CSharp' }
ASTProgramNode >> declaresMustBeExpression [

	^ self propertyAt: #mustBeExpression ifAbsent: [ false ].
]

{ #category : '*Pharo CSharp' }
ASTProgramNode >> mustBeExpression [

	self mustBeExpression: true.
]

{ #category : '*Pharo CSharp' }
ASTProgramNode >> mustBeExpression: aBoolean [

	self propertyAt: #mustBeExpression put: aBoolean.
]

{ #category : '*Pharo CSharp' }
ASTProgramNode >> nonBlockNodesDo: aBlock [
	"Evaluate aBlock on self and all chindren nodes, including comments"

	aBlock value: self.
	self childrenAndComments do: [ :each | 
		each isBlock ifFalse: [ 
			each nonBlockNodesDo: aBlock ] ]
]
