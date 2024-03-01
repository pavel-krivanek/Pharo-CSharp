Class {
	#name : #PharoCSharpExample,
	#superclass : #Object,
	#instVars : [
		'ivar'
	],
	#category : 'Pharo CSharp'
}

{ #category : #initialization }
PharoCSharpExample >> _slotTypes [

	<slot: #ivar type: #ByteSymbol>
	
]

{ #category : #initialization }
PharoCSharpExample >> cascade [ 

	| temp |
	temp := self mix: (String new 
		asComment;
		alike: 'abc';
		yourself) min: (String new 
		alike: 'def';
		yourself)
]

{ #category : #initialization }
PharoCSharpExample >> comment [  

	"comment"
	^ 42
]

{ #category : #initialization }
PharoCSharpExample >> initialize [

	<var: #a type: #(Dictionary of Number keys String)>
	<returns: #(Dictionary of Number keys String)>
	| a |
	true
		ifTrue: [
			a := a + 1.
			^ self
		]
		
]

{ #category : #initialization }
PharoCSharpExample >> initialize: arg [

	<arg: #arg type: #(Dictionary of Number keys String)>
	<var: #a type: #(Dictionary of Number keys String)>
	<returns: #(Dictionary of Number keys String)>
	| a |
	true
		ifTrue: [
			a := a + 1.
			^ self
		].
	^ 0
		
]

{ #category : #initialization }
PharoCSharpExample >> lambda [ 

	'string' collect: [ :each | each + 1 ].
	
	'string' collect: [ :each | 
		each yourself. 
		each + 1 ].
]

{ #category : #initialization }
PharoCSharpExample >> methodWithArgument: arg [

	<arg: #arg type: #(Dictionary of Number keys String)>
	^ arg
		
]
