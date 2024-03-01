Extension { #name : #RBMessageNode }

{ #category : #'*Pharo CSharp' }
RBMessageNode >> originalSelector [

	^ self propertyAt: #originalSelector ifAbsent: [ self selector ]
]
