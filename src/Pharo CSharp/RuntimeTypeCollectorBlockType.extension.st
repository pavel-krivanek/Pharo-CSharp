Extension { #name : #RuntimeTypeCollectorBlockType }

{ #category : #'*Pharo CSharp' }
RuntimeTypeCollectorBlockType >> mergeWith: collectorType [

	| premergedToCommonSuperclass mergedArguments |

	premergedToCommonSuperclass := self mergedSimplyOrNilWith: collectorType.
	premergedToCommonSuperclass key ifNotNil: [ :merged | ^ merged ].
	
	argumentClasses size = collectorType argumentClasses size 
		ifFalse: [ 
			^ RuntimeTypeCollectorSimpleType fromClass: premergedToCommonSuperclass value
				nullable: (self nullable or: collectorType nullable) ].
			
	mergedArguments := self argumentClasses with: collectorType argumentClasses collect: [ :set1 :set2 |
		 self class mergeAll: set1 with: set2 ].
			
	^ self class 
		fromClass: premergedToCommonSuperclass value
		argumentClasses: mergedArguments
		returnClasses: (self class mergeAll: self returnClasses with: collectorType returnClasses)
		nullable: (self nullable or: collectorType nullable)
			
		
]
