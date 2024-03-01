Extension { #name : #RBNode }

{ #category : #'*Pharo CSharp' }
RBNode >> asCSharpLiteralIn: aVisitor [ 

	^ self acceptVisitor: aVisitor

	
]

{ #category : #'*Pharo CSharp' }
RBNode >> parentheses [ 

	^ #()
]
