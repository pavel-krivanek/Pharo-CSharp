Extension { #name : #RuntimeTypeCollectorDictionaryType }

{ #category : #'*Pharo CSharp' }
RuntimeTypeCollectorDictionaryType >> mappedUsing: aBuildingVisitor [

	^ 'Dictionary<{1}, {2}>{3}' format: { 
		keyClasses ifEmpty: [ 'unknown' ] ifNotEmpty: [ aBuildingVisitor mapType: keyClasses asArray first ].
		itemClasses ifEmpty: [ 'unknown' ] ifNotEmpty: [ aBuildingVisitor mapType: itemClasses asArray first ]. 
		nullable ifTrue: [ '?' ] ifFalse: [ '' ]
	}.
]

{ #category : #'*Pharo CSharp' }
RuntimeTypeCollectorDictionaryType >> mergeWith: collectorType [

	| premergedToCommonSuperclass|

	premergedToCommonSuperclass := self mergedSimplyOrNilWith: collectorType.
	premergedToCommonSuperclass key ifNotNil: [ :merged | ^ merged ].
			
	^ self class 
			fromClass: premergedToCommonSuperclass value
			itemClasses: (self class mergeAll: self itemClasses with: collectorType itemClasses)
			keyClasses: (self class mergeAll: self keyClasses with: collectorType keyClasses)
			nullable: (self nullable or: collectorType nullable)
]
