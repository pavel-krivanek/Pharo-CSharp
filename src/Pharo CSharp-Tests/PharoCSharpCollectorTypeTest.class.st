Class {
	#name : 'PharoCSharpCollectorTypeTest',
	#superclass : 'TestCase',
	#category : 'Pharo CSharp-Tests',
	#package : 'Pharo CSharp-Tests'
}

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testLiteralsAssociation [

	| type | 
	type := SchmidtTypeCollectorType fromLiteral: #(Association key String value Integer).
	self assert: type isCollection.
	self assert: type anyOne isAssociationType.
	self assert: type anyOne typeClass equals: Association.
	self assert: type anyOne keyClasses anyOne isSimpleType.
	self assert: type anyOne keyClasses anyOne typeClass equals: String.
	self assert: type anyOne valueClasses anyOne isSimpleType.
	self assert: type anyOne valueClasses anyOne typeClass equals: Integer.

	type := SchmidtTypeCollectorType fromLiteral: #((Association key String value Integer)).
	self assert: type isCollection.
	self assert: type anyOne isAssociationType.
	self assert: type anyOne typeClass equals: Association.
	self assert: type anyOne keyClasses anyOne isSimpleType.
	self assert: type anyOne keyClasses anyOne typeClass equals: String.
	self assert: type anyOne valueClasses anyOne isSimpleType.
	self assert: type anyOne valueClasses anyOne typeClass equals: Integer.

	type := SchmidtTypeCollectorType fromLiteral: #(Association key (String Integer) value #(Object UndefinedObject )).
	self assert: type isCollection.
	self assert: type anyOne isAssociationType.
	self assert: type anyOne typeClass equals: Association.
	self assert: (type anyOne keyClasses allSatisfy: [ :each | each isSimpleType ]).
	self assert: (type anyOne keyClasses collect: [ :each | each typeClass ]) equals: { Integer. String } asSet.
	self assert: (type anyOne valueClasses allSatisfy: [ :each | each isSimpleType ]).
	self assert: (type anyOne valueClasses collect: [ :each | each typeClass ]) equals: { Object. UndefinedObject } asSet.
	

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testLiteralsBlockArguments [

	| type | 
	type := SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments Integer).
	self assert: type isCollection.
	self assert: type anyOne isBlockType.
	self assert: type anyOne typeClass equals: FullBlockClosure.
	self assert: type anyOne returnClasses isEmpty.
	self assert: type anyOne argumentClasses isSequenceable.
.	self assert: (type anyOne argumentClasses first isKindOf: Set).
	self assert: type anyOne argumentClasses anyOne anyOne isSimpleType.
	self assert: type anyOne argumentClasses anyOne anyOne typeClass equals: Integer.

	type := SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments #(Integer String)).
	self assert: type isCollection.
	self assert: type anyOne isBlockType.
	self assert: type anyOne typeClass equals: FullBlockClosure.
	self assert: type anyOne returnClasses isEmpty.
	self assert: type anyOne argumentClasses isSequenceable.
	self assert: (type anyOne argumentClasses allSatisfy: [ :each | each anyOne isSimpleType ]).
	self assert: (type anyOne argumentClasses collect: [ :each | each anyOne typeClass ]) equals: { Integer. String }.
	
	type := SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments ((Array of String))).
	self assert: type isCollection.
	self assert: type anyOne isBlockType.
	self assert: type anyOne typeClass equals: FullBlockClosure.
	self assert: type anyOne returnClasses isEmpty.
	self assert: type anyOne argumentClasses isSequenceable.
	self assert: type anyOne argumentClasses first anyOne isCollectionType.
	self assert: type anyOne argumentClasses first anyOne itemClasses anyOne typeClass equals: String.
]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testLiteralsBlockArgumentsReturning [

	| type | 
	type := SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments Integer returning String).
	self assert: type isCollection.
	self assert: type anyOne isBlockType.
	self assert: type anyOne typeClass equals: FullBlockClosure.
	self assert: type anyOne argumentClasses isSequenceable.
	self assert: type anyOne argumentClasses first anyOne isSimpleType.
	self assert: type anyOne argumentClasses first anyOne typeClass equals: Integer.
	self assert: type anyOne returnClasses anyOne isSimpleType.
	self assert: type anyOne returnClasses anyOne typeClass equals: String.

	type := SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments #(Integer String) returning #(Object UndefinedObject)).
	self assert: type isCollection.
	self assert: type anyOne isBlockType.
	self assert: type anyOne typeClass equals: FullBlockClosure.
	self assert: type anyOne argumentClasses isSequenceable.
	self assert: (type anyOne argumentClasses allSatisfy: [ :each | each anyOne isSimpleType ]).
	self assert: (type anyOne argumentClasses collect: [ :each | each anyOne typeClass ]) equals: { Integer. String }.
	self assert: (type anyOne returnClasses allSatisfy: [ :each | each isSimpleType ]).
	self assert: (type anyOne returnClasses collect: [ :each | each typeClass ]) equals: { Object. UndefinedObject } asSet.
	
	type := SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments ((Collection of String)) returning #(Object UndefinedObject)).
	self assert: type isCollection.
	self assert: type anyOne isBlockType.
	self assert: type anyOne typeClass equals: FullBlockClosure.
	self assert: type anyOne argumentClasses isSequenceable.
	self assert: type anyOne argumentClasses first anyOne isCollectionType.
	self assert: type anyOne argumentClasses first anyOne itemClasses anyOne typeClass equals: String.
	self assert: (type anyOne returnClasses allSatisfy: [ :each | each isSimpleType ]).
	self assert: (type anyOne returnClasses collect: [ :each | each typeClass ]) equals: { Object. UndefinedObject } asSet.
		
]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testLiteralsBlocksReturing [

	| type | 
	type := SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure returning Integer).
	self assert: type isCollection.
	self assert: type anyOne isBlockType.
	self assert: type anyOne argumentClasses isEmpty.
	self assert: type anyOne typeClass equals: FullBlockClosure.
	self assert: type anyOne returnClasses anyOne isSimpleType.
	self assert: type anyOne returnClasses anyOne typeClass equals: Integer.

	type := SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure returning #(Integer String)).
	self assert: type isCollection.
	self assert: type anyOne isBlockType.
	self assert: type anyOne argumentClasses isEmpty.
	self assert: type anyOne typeClass equals: FullBlockClosure.
	self assert: (type anyOne returnClasses allSatisfy: [ :each | each isSimpleType ]).
	self assert: (type anyOne returnClasses collect: [ :each | each typeClass ]) equals: { Integer. String } asSet

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testLiteralsCollection [

	| type | 
	type := SchmidtTypeCollectorType fromLiteral: #(Array of String).
	self assert: type isCollection.
	self assert: type anyOne isCollectionType.
	self assert: type anyOne typeClass equals: Array.
	self assert: type anyOne itemClasses anyOne isSimpleType.
	self assert: type anyOne itemClasses anyOne typeClass equals: String.

	type := SchmidtTypeCollectorType fromLiteral: #((Array of String)).
	self assert: type isCollection.
	self assert: type anyOne isCollectionType.
	self assert: type anyOne itemClasses anyOne isSimpleType.
	self assert: type anyOne itemClasses anyOne typeClass equals: String.

	type := SchmidtTypeCollectorType fromLiteral: #(Array of (String Integer) ).
	self assert: type isCollection.
	self assert: type anyOne isCollectionType.
	self assert: (type anyOne itemClasses allSatisfy: [ :each | each isSimpleType ]).
	self assert: (type anyOne itemClasses collect: [ :each | each typeClass ]) equals: { Integer. String } asSet

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testLiteralsDictionary [

	| type | 
	type := SchmidtTypeCollectorType fromLiteral: #(Dictionary of String keys Integer).
	self assert: type isCollection.
	self assert: type anyOne isDictionaryType.
	self assert: type anyOne typeClass equals: Dictionary.
	self assert: type anyOne itemClasses anyOne isSimpleType.
	self assert: type anyOne itemClasses anyOne typeClass equals: String.
	self assert: type anyOne keyClasses anyOne isSimpleType.
	self assert: type anyOne keyClasses anyOne typeClass equals: Integer.

	type := SchmidtTypeCollectorType fromLiteral: #((Dictionary of String keys Integer)).
	self assert: type isCollection.
	self assert: type anyOne isDictionaryType.
	self assert: type anyOne typeClass equals: Dictionary.
	self assert: type anyOne itemClasses anyOne isSimpleType.
	self assert: type anyOne itemClasses anyOne typeClass equals: String.
	self assert: type anyOne keyClasses anyOne isSimpleType.
	self assert: type anyOne keyClasses anyOne typeClass equals: Integer.

	type := SchmidtTypeCollectorType fromLiteral: #(SmallDictionary of (String Integer) keys #(Object UndefinedObject )).
	self assert: type isCollection.
	self assert: type anyOne isDictionaryType.
	self assert: type anyOne typeClass equals: SmallDictionary.
	self assert: (type anyOne itemClasses allSatisfy: [ :each | each isSimpleType ]).
	self assert: (type anyOne itemClasses collect: [ :each | each typeClass ]) equals: { Integer. String } asSet.
	self assert: (type anyOne keyClasses allSatisfy: [ :each | each isSimpleType ]).
	self assert: (type anyOne keyClasses collect: [ :each | each typeClass ]) equals: { Object. UndefinedObject } asSet.
	

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testLiteralsSimple [

	| type | 
	type := SchmidtTypeCollectorType fromLiteral: #String.
	self assert: type isCollection.
	self assert: type anyOne isSimpleType.
	self assert: type anyOne typeClass equals: String.

	type := SchmidtTypeCollectorType fromLiteral: #(String).
	self assert: type isCollection.
	self assert: type anyOne isSimpleType.
	self assert: type anyOne typeClass equals: String.

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeAssociation01 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #(Association key SmallInteger value String)) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #(Association key LargeInteger value Symbol)) anyOne.

	merged := type1 mergeWith: type2.

	self assert: merged isAssociationType.
	self assert: merged typeClass equals: Association.
	self assert: merged keyClasses anyOne typeClass equals: Integer.
	self assert: merged valueClasses anyOne typeClass equals: String.
	self deny: merged nullable.

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeBlock01 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments (String SmallInteger) returning String)) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments (Symbol LargeInteger) returning Number)) anyOne.

	merged := type1 mergeWith: type2.

	self assert: merged isBlockType.
	self assert: merged typeClass equals: FullBlockClosure.
	self assert: (merged argumentClasses collect: [ :each | each anyOne typeClass ]) equals: {String. Integer}.
	self assert: merged returnClasses anyOne typeClass equals: Object.
	self deny: merged nullable.

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeBlock02 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments (String SmallInteger) returning String)) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments (Symbol LargeInteger Integer) returning Number)) anyOne.

	merged := type1 mergeWith: type2.

	self assert: merged isSimpleType.

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeBlock03 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments () returning String)) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments () returning Number)) anyOne.

	merged := type1 mergeWith: type2.

	self assert: merged typeClass equals: FullBlockClosure.
	self assert: merged argumentClasses isEmpty.
]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeCollection01 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #(Array of String)) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #(Array of String)) anyOne.
	merged := type1 mergeWith: type2.

	self assert: merged isCollectionType.
	self assert: merged typeClass equals: Array.
	self assert: merged itemClasses anyOne typeClass equals: String.

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeCollection02 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #(Array of String)) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #(OrderedCollection of String)) anyOne.
	merged := type1 mergeWith: type2.

	self assert: merged isCollectionType.
	self assert: merged typeClass equals: SequenceableCollection.
	self assert: merged itemClasses anyOne typeClass equals: String.
	self deny: merged nullable.

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeDictionary01 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #(Dictionary of SmallInteger keys String)) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #(Dictionary of LargeInteger keys Symbol)) anyOne.

	merged := type1 mergeWith: type2.

	self assert: merged isDictionaryType.
	self assert: merged typeClass equals: Dictionary.
	self assert: merged itemClasses anyOne typeClass equals: Integer.
	self assert: merged keyClasses anyOne typeClass equals: String.
	self deny: merged nullable.

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeDictionary02 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #(Dictionary of SmallInteger keys String)) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #(SmallDictionary of LargeInteger keys Symbol)) anyOne.

	merged := type1 mergeWith: type2.

	self assert: merged isSimpleType.

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeSimple01 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #String) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #String) anyOne.
	merged := type1 mergeWith: type2.

	self assert: merged isSimpleType.
	self assert: merged typeClass equals: String.
	self deny: merged nullable.

	type1 := (SchmidtTypeCollectorType fromLiteral: #String) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #Symbol) anyOne.
	merged := type1 mergeWith: type2.

	self assert: merged isSimpleType.
	self assert: merged typeClass equals: String.
	
	type1 := (SchmidtTypeCollectorType fromLiteral: #Dictionary) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #OrderedCollection) anyOne.
	merged := type1 mergeWith: type2.

	self assert: merged isSimpleType.
	self assert: merged typeClass equals: Collection.	

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeSimple02 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #String) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #(Array of Integer)) anyOne.
	merged := type1 mergeWith: type2.

	self assert: merged isSimpleType.
	self assert: merged typeClass equals: ArrayedCollection.

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeSimple03 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #String) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #(Dictionary of Integer keys Symbol)) anyOne.
	merged := type1 mergeWith: type2.

	self assert: merged isSimpleType.
	self assert: merged typeClass equals: Collection.

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeSimple04 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #String) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #(BlockClosure returning Integer)) anyOne.
	merged := type1 mergeWith: type2.

	self assert: merged isSimpleType.
	self assert: merged typeClass equals: Object.

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeSimple05 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #String) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #(Association key Integer value String)) anyOne.
	merged := type1 mergeWith: type2.

	self assert: merged isSimpleType.
	self assert: merged typeClass equals: Object.

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeSimple06 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #String) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #UndefinedObject) anyOne.
	merged := type1 mergeWith: type2.

	self assert: merged isSimpleType.
	self assert: merged typeClass equals: String.
	self assert: merged nullable

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeSimple07 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #UndefinedObject) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #String) anyOne.
	merged := type1 mergeWith: type2.

	self assert: merged isSimpleType.
	self assert: merged typeClass equals: String.
	self assert: merged nullable

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeSimple08 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #UndefinedObject) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #UndefinedObject) anyOne.
	merged := type1 mergeWith: type2.

	self assert: merged isSimpleType.
	self assert: merged typeClass equals: UndefinedObject.
	self assert: merged nullable

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeSimple09 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #String) anyOne nullable: true.
	type2 := (SchmidtTypeCollectorType fromLiteral: #(Array of Integer)) anyOne.
	merged := type1 mergeWith: type2.

	self assert: merged isSimpleType.
	self assert: merged nullable.
	self assert: merged typeClass equals: ArrayedCollection.

]

{ #category : 'tests' }
PharoCSharpCollectorTypeTest >> testMergeSimple10 [

	| type1 type2 merged | 
	type1 := (SchmidtTypeCollectorType fromLiteral: #String) anyOne.
	type2 := (SchmidtTypeCollectorType fromLiteral: #(Array of Integer)) anyOne nullable: true.
	merged := type1 mergeWith: type2.

	self assert: merged isSimpleType.
	self assert: merged nullable.
	self assert: merged typeClass equals: ArrayedCollection.

]
