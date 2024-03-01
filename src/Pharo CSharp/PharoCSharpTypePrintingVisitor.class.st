Class {
	#name : #PharoCSharpTypePrintingVisitor,
	#superclass : #Object,
	#category : 'Pharo CSharp-Visitors'
}

{ #category : #accessing }
PharoCSharpTypePrintingVisitor >> mapType: pharoType [ 

	pharoType = Void ifTrue: [ ^ #void ].	
	pharoType = Var ifTrue: [ ^ #var ].	
	pharoType = Object ifTrue: [ ^ #object ].
	pharoType = Integer ifTrue: [ ^ #long ].
	pharoType = SmallInteger ifTrue: [ ^ #long ].	
	pharoType = Boolean ifTrue: [ ^ #bool ].	
	pharoType = True ifTrue: [ ^ #bool ].	
	pharoType = False ifTrue: [ ^ #bool ].	
	pharoType = Symbol ifTrue: [ ^ #string ].	
	pharoType = ByteSymbol ifTrue: [ ^ #string ].	
	pharoType = WideSymbol ifTrue: [ ^ #string ].	
	pharoType = String ifTrue: [ ^ #string ].	
	pharoType = ByteString ifTrue: [ ^ #string ].	
	pharoType = WideString ifTrue: [ ^ #string ].
	pharoType = ScaledDecimal ifTrue: [ ^ #Decimal ].	
	pharoType = Character ifTrue: [ ^ #Char ].	
	pharoType = ZnCharacterWriteStream ifTrue: [ ^ #FileStream ].	
			
	^ pharoType name
]

{ #category : #accessing }
PharoCSharpTypePrintingVisitor >> unknownTypeName [ 

	^ 'unknown'
]

{ #category : #accessing }
PharoCSharpTypePrintingVisitor >> visitAssociationType: aType [ 

	^  'Association<{1}, {2}>{3}' format: { 
		aType keyClasses 
			ifEmpty: [ self unknownTypeName ] 
			ifNotEmpty: [ aType keyClasses anyOne acceptVisitor: self ].
		aType valueClasses 
			ifEmpty: [ self unknownTypeName ] 
			ifNotEmpty: [ aType valueClasses anyOne acceptVisitor: self ].
		aType nullable ifTrue: [ '?' ] ifFalse: [ '' ]
	}.
]

{ #category : #accessing }
PharoCSharpTypePrintingVisitor >> visitBlockType: aType [ 

	^  'Func<{1}{2}>{3}' format: { 
		(aType argumentClasses collect: [ :aTypeSet | 
			aTypeSet 
				ifEmpty: [ self unknownTypeName ] 
				ifNotEmpty: [ aTypeSet anyOne acceptVisitor: self ] ]) joinUsing: ', '.			
		(aType argumentClasses ifEmpty: '' ifNotEmpty: ', '),
		(aType returnClasses 
			ifEmpty: [ self unknownTypeName ] 
			ifNotEmpty: [ aType returnClasses anyOne acceptVisitor: self ]).
		aType nullable ifTrue: [ '?' ] ifFalse: [ '' ]
		}
]

{ #category : #accessing }
PharoCSharpTypePrintingVisitor >> visitCollectionType: aType [ 

	({ OrderedCollection. Array. ByteArray } includes: aType typeClass) ifTrue: [ 
		| listClass |
		listClass := aType itemClasses asArray
			ifEmpty: [ self unknownTypeName ]
			ifNotEmpty: [ aType itemClasses anyOne acceptVisitor: self ].
		^ 'List<', listClass, '>', (aType nullable ifTrue: [ '?' ] ifFalse: [ '' ]).
	].

	({ IEnumerable} includes: aType typeClass) ifTrue: [ 
		| listClass |
		listClass := aType itemClasses asArray
			ifEmpty: [ self unknownTypeName ]
			ifNotEmpty: [ aType itemClasses anyOne acceptVisitor: self ].
		^ 'IEnumerable<', listClass, '>', (aType nullable ifTrue: [ '?' ] ifFalse: [ '' ]).
	].

	^ '{1}[]' format: { 
		aType itemClasses anyOne acceptVisitor: self. }.
]

{ #category : #accessing }
PharoCSharpTypePrintingVisitor >> visitDictionaryType: aType [ 

	^ 'Dictionary<{1}, {2}>{3}' format: { 
		aType keyClasses 
			ifEmpty: [ self unknownTypeName ] 
			ifNotEmpty: [ aType keyClasses anyOne acceptVisitor: self ].
		aType itemClasses 
			ifEmpty: [ self unknownTypeName ] 
			ifNotEmpty: [ aType itemClasses anyOne acceptVisitor: self ]. 
		aType nullable ifTrue: [ '?' ] ifFalse: [ '' ]
	}.
]

{ #category : #accessing }
PharoCSharpTypePrintingVisitor >> visitSimpleType: aType [ 

	^ (self mapType: aType typeClass), (aType nullable ifTrue: [ '?' ] ifFalse: [ '' ])

]

{ #category : #accessing }
PharoCSharpTypePrintingVisitor >> visitType: aType [ 

	^ aType acceptVisitor: self
]

{ #category : #accessing }
PharoCSharpTypePrintingVisitor >> visitTypeSet: aTypeSet [

	aTypeSet ifEmpty: [ ^ self unknownTypeName ].
	
	^ self visitType: aTypeSet anyOne
]
