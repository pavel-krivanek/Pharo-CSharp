Extension { #name : 'OCMessageNode' }

{ #category : '*Pharo CSharp' }
OCMessageNode >> originalSelector [

	^ self propertyAt: #originalSelector ifAbsent: [ self selector ]
]
