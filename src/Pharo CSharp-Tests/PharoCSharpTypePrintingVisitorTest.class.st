Class {
	#name : 'PharoCSharpTypePrintingVisitorTest',
	#superclass : 'TestCase',
	#instVars : [
		'visitor'
	],
	#category : 'Pharo CSharp-Tests',
	#package : 'Pharo CSharp-Tests'
}

{ #category : 'tests' }
PharoCSharpTypePrintingVisitorTest >> setUp [ 

	super setUp. 
	visitor := PharoCSharpTypePrintingVisitor new.
]

{ #category : 'tests' }
PharoCSharpTypePrintingVisitorTest >> testAssociation [

	| type | 
	type := SchmidtTypeCollectorType fromLiteral: #(Association key String value Integer).
	self assert: (visitor visitType: type anyOne) equals: 'Association<string, long>'.

	type := SchmidtTypeCollectorType fromLiteral: #(Association key () value ()).
	self assert: (visitor visitType: type anyOne) equals: 'Association<unknown, unknown>'.

	type := SchmidtTypeCollectorType fromLiteral: #(Association key String value Integer).
	self assert: (visitor visitType: type anyOne beNullable) equals: 'Association<string, long>?'.


]

{ #category : 'tests' }
PharoCSharpTypePrintingVisitorTest >> testBlock [

	| type | 
	type := SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments String returning Integer).
	self assert: (visitor visitType: type anyOne) equals: 'Func<string, long>'.

	type := SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments String returning Integer).
	self assert: (visitor visitType: type anyOne) equals: 'Func<string, long>'.

	type := SchmidtTypeCollectorType fromLiteral: #(FullBlockClosure arguments String returning Integer).
	self assert: (visitor visitType: type anyOne beNullable) equals: 'Func<string, long>?'.

]

{ #category : 'tests' }
PharoCSharpTypePrintingVisitorTest >> testCollection [

	| type | 
	type := SchmidtTypeCollectorType fromLiteral: #(Array of String).
	self assert: (visitor visitType: type anyOne) equals: 'List<string>'.

	type := SchmidtTypeCollectorType fromLiteral: #(Array of (Array of String) ).
	self assert: (visitor visitType: type anyOne) equals: 'List<List<string>>'.

	type := SchmidtTypeCollectorType fromLiteral: #(Array of ()).
	self assert: (visitor visitType: type anyOne) equals: 'List<unknown>'.

	"uknown type of collection"
	type := SchmidtTypeCollectorType fromLiteral: #(Collection of String).
	self assert: (visitor visitType: type anyOne) equals: 'string[]'.

	type := SchmidtTypeCollectorType fromLiteral: #(Array of String).
	self assert: (visitor visitType: type anyOne beNullable) equals: 'List<string>?'.

]

{ #category : 'tests' }
PharoCSharpTypePrintingVisitorTest >> testDictionary [

	| type | 
	type := SchmidtTypeCollectorType fromLiteral: #(Dictionary of String keys Integer).
	self assert: (visitor visitType: type anyOne) equals: 'Dictionary<long, string>'.

	type := SchmidtTypeCollectorType fromLiteral: #(Dictionary of () keys ()).
	self assert: (visitor visitType: type anyOne) equals: 'Dictionary<unknown, unknown>'.

	type := SchmidtTypeCollectorType fromLiteral: #(Dictionary of String keys Integer).
	self assert: (visitor visitType: type anyOne beNullable) equals: 'Dictionary<long, string>?'.

]

{ #category : 'tests' }
PharoCSharpTypePrintingVisitorTest >> testSimple [

	| type | 
	type := SchmidtTypeCollectorType fromLiteral: #String.
	self assert: (visitor visitType: type anyOne) equals: 'string'.

	type := SchmidtTypeCollectorType fromLiteral: #PharoCSharpTypePrintingVisitorTest.
	self assert: (visitor visitType: type anyOne) equals: 'PdmCSharpTypePrintingVisitorTest'.

	type := SchmidtTypeCollectorType fromLiteral: #String.
	self assert: (visitor visitType: type anyOne beNullable) equals: 'string?'.
	
]
