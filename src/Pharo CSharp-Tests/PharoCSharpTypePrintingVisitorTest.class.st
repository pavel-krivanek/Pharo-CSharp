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
	type := RuntimeTypeCollectorType fromLiteral: #(Association key String value Integer).
	self assert: (visitor visitType: type anyOne) equals: 'Association<string, long>'.

	type := RuntimeTypeCollectorType fromLiteral: #(Association key () value ()).
	self assert: (visitor visitType: type anyOne) equals: 'Association<unknown, unknown>'.

	type := RuntimeTypeCollectorType fromLiteral: #(Association key String value Integer).
	self assert: (visitor visitType: type anyOne beNullable) equals: 'Association<string, long>?'.


]

{ #category : 'tests' }
PharoCSharpTypePrintingVisitorTest >> testBlock [

	| type | 
	type := RuntimeTypeCollectorType fromLiteral: #(FullBlockClosure arguments String returning Integer).
	self assert: (visitor visitType: type anyOne) equals: 'Func<string, long>'.

	type := RuntimeTypeCollectorType fromLiteral: #(FullBlockClosure arguments String returning Integer).
	self assert: (visitor visitType: type anyOne) equals: 'Func<string, long>'.

	type := RuntimeTypeCollectorType fromLiteral: #(FullBlockClosure arguments String returning Integer).
	self assert: (visitor visitType: type anyOne beNullable) equals: 'Func<string, long>?'.

]

{ #category : 'tests' }
PharoCSharpTypePrintingVisitorTest >> testCollection [

	| type | 
	type := RuntimeTypeCollectorType fromLiteral: #(Array of String).
	self assert: (visitor visitType: type anyOne) equals: 'List<string>'.

	type := RuntimeTypeCollectorType fromLiteral: #(Array of (Array of String) ).
	self assert: (visitor visitType: type anyOne) equals: 'List<List<string>>'.

	type := RuntimeTypeCollectorType fromLiteral: #(Array of ()).
	self assert: (visitor visitType: type anyOne) equals: 'List<unknown>'.

	"uknown type of collection"
	type := RuntimeTypeCollectorType fromLiteral: #(Collection of String).
	self assert: (visitor visitType: type anyOne) equals: 'string[]'.

	type := RuntimeTypeCollectorType fromLiteral: #(Array of String).
	self assert: (visitor visitType: type anyOne beNullable) equals: 'List<string>?'.

]

{ #category : 'tests' }
PharoCSharpTypePrintingVisitorTest >> testDictionary [

	| type | 
	type := RuntimeTypeCollectorType fromLiteral: #(Dictionary of String keys Integer).
	self assert: (visitor visitType: type anyOne) equals: 'Dictionary<long, string>'.

	type := RuntimeTypeCollectorType fromLiteral: #(Dictionary of () keys ()).
	self assert: (visitor visitType: type anyOne) equals: 'Dictionary<unknown, unknown>'.

	type := RuntimeTypeCollectorType fromLiteral: #(Dictionary of String keys Integer).
	self assert: (visitor visitType: type anyOne beNullable) equals: 'Dictionary<long, string>?'.

]

{ #category : 'tests' }
PharoCSharpTypePrintingVisitorTest >> testSimple [

	| type | 
	type := RuntimeTypeCollectorType fromLiteral: #String.
	self assert: (visitor visitType: type anyOne) equals: 'string'.

	type := RuntimeTypeCollectorType fromLiteral: #PharoCSharpTypePrintingVisitorTest.
	self assert: (visitor visitType: type anyOne) equals: 'PharoCSharpTypePrintingVisitorTest'.

	type := RuntimeTypeCollectorType fromLiteral: #String.
	self assert: (visitor visitType: type anyOne beNullable) equals: 'string?'.
	
]
