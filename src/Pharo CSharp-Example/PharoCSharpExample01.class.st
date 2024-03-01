Class {
	#name : 'PharoCSharpExample01',
	#superclass : 'PharoCSharpObject',
	#instVars : [
		'count'
	],
	#category : 'Pharo CSharp-Example',
	#package : 'Pharo CSharp-Example'
}

{ #category : 'initialization' }
PharoCSharpExample01 >> _slotTypes [ 

	<slot: #count type: #Integer>
]

{ #category : 'initialization' }
PharoCSharpExample01 >> increate [ 

	<returns: #Integer>
	
	^ count := count + 1
]
