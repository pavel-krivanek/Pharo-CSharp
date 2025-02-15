Extension { #name : 'OCNode' }

{ #category : '*Pharo CSharp' }
OCNode >> asCSharpLiteralIn: aVisitor [ 

	^ self acceptVisitor: aVisitor

	
]

{ #category : '*Pharo CSharp' }
OCNode >> parentheses [ 

	^ #()
]
