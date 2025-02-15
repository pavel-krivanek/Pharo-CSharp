Extension { #name : 'OCProgramNode' }

{ #category : '*Pharo CSharp' }
OCProgramNode >> allChildrenWithoutBlocks [
	| children |
	children := OrderedCollection new.
	self nonBlockNodesDo: [ :each | children addLast: each ].
	^ children
]

{ #category : '*Pharo CSharp' }
OCProgramNode >> declaresMustBeExpression [

	^ self propertyAt: #mustBeExpression ifAbsent: [ false ].
]

{ #category : '*Pharo CSharp' }
OCProgramNode >> mustBeExpression [

	self mustBeExpression: true.
]

{ #category : '*Pharo CSharp' }
OCProgramNode >> mustBeExpression: aBoolean [

	self propertyAt: #mustBeExpression put: aBoolean.
]

{ #category : '*Pharo CSharp' }
OCProgramNode >> nonBlockNodesDo: aBlock [
	"Evaluate aBlock on self and all chindren nodes, including comments"

	aBlock value: self.
	self childrenAndComments do: [ :each | 
		each isBlock ifFalse: [ 
			each nonBlockNodesDo: aBlock ] ]
]
