Extension { #name : #RuntimeTypeCollectorAssociationType }

{ #category : #'*Pharo CSharp' }
RuntimeTypeCollectorAssociationType >> mappedUsing: aBuildingVisitor [

	^ 'Association<{1}, {2}>{3}' format: { 
		aBuildingVisitor mapType: keyClasses asArray first.
		aBuildingVisitor mapType: valueClasses asArray first. 
		nullable ifTrue: [ '?' ] ifFalse: [ '' ]
	}.
]

{ #category : #'*Pharo CSharp' }
RuntimeTypeCollectorAssociationType >> mergeWith: collectorType [

	| premergedToCommonSuperclass|
	
	(collectorType isSimpleType and: [ collectorType typeClass = Association ]) 
		ifTrue: [ ^ self ].

	premergedToCommonSuperclass := self mergedSimplyOrNilWith: collectorType.
	premergedToCommonSuperclass key ifNotNil: [ :merged | ^ merged ].
			
	^ self class 
		fromClass: premergedToCommonSuperclass value 
		keyClasses: (self class mergeAll: self keyClasses with: collectorType keyClasses)
		valueClasses: (self class mergeAll: self valueClasses with: collectorType valueClasses)
		nullable: (self nullable or: collectorType nullable)		
		
]
