Extension { #name : 'ASTMessageNode' }

{ #category : '*Pharo CSharp' }
ASTMessageNode >> originalSelector [

	^ self propertyAt: #originalSelector ifAbsent: [ self selector ]
]
