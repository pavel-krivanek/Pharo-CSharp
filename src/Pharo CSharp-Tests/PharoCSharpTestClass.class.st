Class {
	#name : 'PharoCSharpTestClass',
	#superclass : 'Object',
	#category : 'Pharo CSharp-Tests',
	#package : 'Pharo CSharp-Tests'
}

{ #category : 'instance creation' }
PharoCSharpTestClass >> and [  

	<returns: #Integer>
	<blockArg: #each type: #Integer>
	
	(true and: [ false ]) 
		ifTrue: [ ^ 1 ].

	(self someMessage and: [ self otherMessage ]) 
		ifTrue: [ ^ 1 ].
	 
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> array [

	<returns: #Integer>
	<blockArg: #each type: #Integer>
	
	#(1 2 3) yourself.
	 
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> association [ 

	<returns: #Integer>
	<var: #assoc type: #(Association key Symbol value String)>
	
	| assoc |
	assoc := #someKey -> 'some value'.
	
	^ 0
	
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> atIfAbsent [ 

	<returns: #Integer>
	<var: #tmp type: #String>
	<var: #dict type: #(Dictionary of String keys String)>
	<blockArg: #each type: #Integer>

	| tmp dict |	
	dict := Dictionary new.
	tmp := dict at: 'test' ifAbsent: [ 
		dict at: 'another' ifAbsent: [ 'missing' ] ].
	
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> atIfAbsent2 [

	<returns: #Integer>
	<var: #tmp type: #String>
	<var: #dict type: #(Dictionary of String keys String)>
	<var: #help type: #(Dictionary of Integer keys Integer)>
	<blockArg: #each type: #Integer>

	| tmp dict help |	
	dict := Dictionary new.
	tmp := dict at: 'test' ifAbsent: [ 
		dict at: 'another' ifAbsent: [ help := Dictionary new ] ].
	tmp := dict at: 'test' ifAbsent: [ 
		dict at: 'another' ifAbsent: [ (help := Dictionary new) toString ] ].
	
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> atIfPresent [ 

	<returns: #Integer>
	<var: #dict type: #(Dictionary of Integer keys String)>
	<blockArg: #found type: #Integer>

	| dict |	

	dict at: #aKey ifPresent: [ :found |
		^ found ].

	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> atIfPresent2 [

	<returns: #Integer>
	<var: #dict type: #(Dictionary of Integer keys String)>
	<blockArg: #found type: #Integer>

	| dict |	

	dict at: #aKey ifPresent: [ :found | 
		#(returns: String).
		self yourself.
		^ 'aString'  ].

	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> binaryConversion [ 

	<returns: #Integer> 
	
	| s | 
	s << 'test'.
	s << 'test 2' << 'test 3'.
	(s << 'test 4') ifTrue: [ ^ 1 ].
	
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> binaryConversion2 [

	<returns: #Integer> 
	
	| s temp | 
	s << (temp ifNil: [ 0 ]) asString.
	
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> blocksReturningValues [
	
	<block: 1 returnsValue: true>
	<returns: #Integer>
	
	'string' blockMessage: [ :each | 
		each yourself. 
		each + 1 ].

	'string' blockMessage: [ :each | 
		each yourself. 
		each + 2 ].
	
	'string' do: [ :each | 
		each yourself. 
		each + 3 ].

	'string' select: [ :each | 
		each yourself. 
		each + 4 ].	
	
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> cascade [ 

	| temp |
	temp := self max: (String new 
		asComment;
		alike: 'abc';
		yourself) min: (String new 
		alike: 'def';
		yourself)	.
			
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> cascadeInsideBlock [

	<returns: #String>
	
	^ String streamContents: [ :s | 
		s  << 'Hello';
			<< (' World', '!')
	]

]

{ #category : 'instance creation' }
PharoCSharpTestClass >> cast [

	<returns: #Integer>
	<var: #num type: #Integer>
		
	| num |
	num := self yourself castAs: #Integer.
	num := self yourself castOrNilAs: #(Array of Integer).
	 
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> collect [ 

	<var: #tmp type: #(Array of Integer)>
	<returns: #(Array of Integer)>
	<blockArg: #each type: #Integer>
	
	^ self collect: [ :each | each + 1 ].
	 
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> complexType [

	<returns: #(Dictionary of (Dictionary of Integer keys Symbol) keys String)>
	
	^ nil

]

{ #category : 'instance creation' }
PharoCSharpTestClass >> copyFromTo [ 

	<var: #aCollection type: #(Array of Integer)>
	<returns: #Integer>
	
	| aCollection |
	aCollection copyFrom: 2 to: 3.
	
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> do [  

	<var: #tmp type: #(Array of Integer)>
	<returns: #Integer>
	<blockArg: #each type: #Integer>
	
	self do: [ :each | each + 1 ].
	 
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> doWithIndex [

	<var: #aCollection type: #(Array of String)>
	<blockArg: #each type: #String>
	<blockArg: #index type: #Integer>
	<returns: #Integer>
	
	| aCollection |
	aCollection doWithIndex: [ :each :index | 
		each + index ].

	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> dynamicArray [

	<returns: #Integer>
	<blockArg: #each type: #Integer>
	
	{1. 2. 3} yourself.
	 
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> if [
	<var: #a type: #Integer>
	<returns: #Integer>
	| a |
	a := 0.
	true
		ifTrue: [
			a := a + 1.
			^ 1
		].
	^ 0
		
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> implicitReturn [

	<returns: #PharoCSharpTestClass>
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> isKindOf [ 

	<returns: #Integer>
	<var: #tmp type: #Collection>
	| tmp |
	(tmp isKindOf: Collection)
		ifTrue: [ ^ 1 ].
	
	^ 0
	
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> keysAndValuesDo [

	<var: #aCollection type: #(Dictionary of Integer keys String)>
	<returns: #Integer>
	<blockArg: #k type: #String>
	<blockArg: #v type: #Integer>
	
	| aCollection |
	aCollection keysAndValuesDo: [ :k :v | ^ v ].
	 
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> lambda1 [

	<returns: #Integer>
	self message select: [ :each | each + 1 ].
	
	self message select: [ :each | each toString. each + 1 ].
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> methodWithArgument: arg [

	<arg: #arg type: #(Dictionary of Number keys String)>
	^ arg
		
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> modulo [ 

	<returns: #Integer>
	
	^ 20 \\ 3
	
	
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> newMessage [ 

	<returns: #(Dictionary of Integer keys String)>
	<var: #array type: #(OrderedCollection of Integer)>

	| array |
	
	Object new.
	Object new toString.
	self new.
	self class new.
	array := OrderedCollection new.
	
	^ Dictionary new
	
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> nonLocalReturn [ 

	<returns: #Boolean>
	true ifTrue: [ 
		^ true
	].
	^ false
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> nonOnDo [

	<returns: #Integer>
	[
	 42
	] on: Error do: [ :err |
	'something' ].

	[
	 42
	] on: Error do: [ 
	'something' ].
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> nullable [
	<var: #a type: #(Integer UndefinedObject)>
	<var: #b type: #(UndefinedObject Integer)>
	<returns: #Integer>
	| a b |
	a := nil.
	a := 0.
	b := nil.
	b := 0.
	^ 0
		
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> or [  

	<returns: #Integer>
	<blockArg: #each type: #Integer>
	
	(true or: [ false ]) 
		ifTrue: [ ^ 1 ].

	(self someMessage or: [ self otherMessage ]) 
		ifTrue: [ ^ 1 ].
	 
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> orderedCollection01 [

	<returns: #Integer>
	<var: #temp type: #(OrderedCollection of Integer)>
	
	| temp |
	temp := OrderedCollection new.
	temp add: 1.
	
	^ 0
	
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> pharoCSharp [  

	<var: #tmp type: #Integer>
	<returns: #Integer>
	<blockArg: #each type: #Integer>
	| tmp |
	self
		pharo: [ 
			self yourself
		] 
		cSharp: [
			'Console.WriteLine({1});' format: {'Hello World!'}
		].
	tmp := (self pharo: [ 'in Pharo' ] cSharp: [ '"in C#"' ] ).
	
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> precedence [
	<returns: #Integer>
	^ 2 + 5 * 6
		
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> select [

	<var: #tmp type: #(Array of Integer)>
	<returns: #(Array of Integer)>
	<blockArg: #each type: #Integer>
	
	^ self message select: [ :each | each + 1 ].
	 
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> selfInBinary [ 

	<returns: #Boolean>
	^ self == true.

]

{ #category : 'instance creation' }
PharoCSharpTestClass >> streamContents [ 

	<returns: #String>
	<blockArg: #s type: #WriteStream>
	^ String streamContents: [ :s | 
		s << 'hello' ].
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> ternary [ 	 
	
	<returns: #Integer>
	| tmp |
	
	tmp := true ifTrue: [ 'true' ] ifFalse: [ 'false' ].	
	tmp := true ifFalse: [ 'false' ] ifTrue: [ 'true' ].
	tmp := true ifTrue: [ 'true' ].
	tmp := true ifFalse: [ 'false' ].
	tmp := true ifNil: [ 'isNil' ].
	tmp := true ifNotNil: [ 'notNil' ].
	tmp := true ifNotNil: [ :arg | arg ].
	tmp := true ifNotNil: [ 'notNil' ] ifNil: [ 'isNil' ].
	tmp := true ifNotNil: [ :arg | arg ] ifNil: [ 'isNil' ].
	tmp := true ifNil: [ 'isNil' ] ifNotNil: [ 'notNil' ].
	tmp := true ifNil: [ 'isNil' ] ifNotNil: [ :arg | arg ].
	tmp := true ifEmpty: [ 'empty' ] ifNotEmpty: [ 'notEmpty' ].
	tmp := true ifEmpty: [ 'empty' ] ifNotEmpty: [ :arg | arg ].
	tmp := true ifNotEmpty: [ 'notEmpty' ] ifEmpty: [ 'empty' ] .
	tmp := true ifNotEmpty: [ :arg | arg ] ifEmpty: [ 'empty' ] .
	tmp := true ifEmpty: [ 'empty' ].
	tmp := true ifNotEmpty: [ 'notEmpty' ].
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> ternaryInBlockNotReturningValue [

	<var: #nonDict type: #(Object)>
	<var: #temp type: #Integer>
	<var: #k type: #String>
	<var: #v type: #Integer>
	<block: 1 returnsValue: false>

	| nonDict temp |
	
	nonDict keysAndValuesDo: [ :k :v |
		temp = 1 ifTrue: [ 2 ]
	].

			
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> whileTrue [
	<var: #a type: #Integer>
	<returns: #Integer>
	| a |
	a := 0.
	[ true ] whileTrue: [
		a := a + 1.
		a := a - 1.
	].
	^ 0
		
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> with [

	<returns: #Integer>
	<var: #tmp type: #(Array of Integer)>
	| tmp |
	tmp := OrderedCollection with: 1.
	 
	^ 0
]

{ #category : 'instance creation' }
PharoCSharpTestClass >> withIndexDo [  

	<var: #aCollection type: #(Array of String)>
	<blockArg: #each type: #String>
	<blockArg: #index type: #Integer>
	<returns: #Integer>
	
	| aCollection |
	aCollection withIndexDo: [ :each :index | 
		each + index ].

	^ 0
]
