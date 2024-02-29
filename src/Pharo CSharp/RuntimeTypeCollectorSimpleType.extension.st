Extension { #name : 'RuntimeTypeCollectorSimpleType' }

{ #category : '*Pharo CSharp' }
RuntimeTypeCollectorSimpleType >> mappedUsing: aBuildingVisitor [

	^ (aBuildingVisitor mapType: self typeClass), (nullable ifTrue: [ '?' ] ifFalse: [ '' ])

]

{ #category : '*Pharo CSharp' }
RuntimeTypeCollectorSimpleType >> mergeWith: collectorType [

	| commonSuperclass |
	
	(self typeClass = UndefinedObject) ifTrue: [ ^ collectorType nullable: true ].
	(collectorType typeClass = UndefinedObject) ifTrue: [ ^ self nullable: true ].

	commonSuperclass := self class commonSuperclassOf: {self typeClass. collectorType typeClass}.

	^ self class fromClass: commonSuperclass nullable: (self nullable or: collectorType nullable)
]
