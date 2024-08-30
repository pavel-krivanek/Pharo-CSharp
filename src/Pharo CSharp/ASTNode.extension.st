Extension { #name : 'ASTNode' }

{ #category : '*Pharo CSharp' }
ASTNode >> asCSharpLiteralIn: aVisitor [ 

	^ self acceptVisitor: aVisitor

	
]

{ #category : '*Pharo CSharp' }
ASTNode >> parentheses [ 

	^ #()
]
