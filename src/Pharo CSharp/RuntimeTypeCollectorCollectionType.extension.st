Extension { #name : #RuntimeTypeCollectorCollectionType }

{ #category : #'*Pharo CSharp' }
RuntimeTypeCollectorCollectionType >> mergeWith: collectorType [

	| premergedToCommonSuperclass|

	premergedToCommonSuperclass := self mergedSimplyOrNilWith: collectorType.
	premergedToCommonSuperclass key ifNotNil: [ :merged | ^ merged ].
			
	^ self class 
		fromClass: premergedToCommonSuperclass value 
		itemClasses: (self class mergeAll: self itemClasses with: collectorType itemClasses)
		nullable: (self nullable or: collectorType nullable)
		
]

{ #category : #'*Pharo CSharp' }
RuntimeTypeCollectorCollectionType >> preMerge [ 

	| merged |
	
	merged := self copy.
	
	merged itemClasses: (self class mergeAll: self itemClasses).
	
	^ merged 
]
