Class {
	#name : #PharoCSharpObject,
	#superclass : #Object,
	#category : 'Pharo CSharp'
}

{ #category : #testing }
PharoCSharpObject class >> isCSharpClass [ 

	^ true
]

{ #category : #initialization }
PharoCSharpObject >> initialize [ 
	
	"this method is here to mark #intialize methods in subclasses as override"

	super initialize.
]
