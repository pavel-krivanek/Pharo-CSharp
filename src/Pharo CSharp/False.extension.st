Extension { #name : #False }

{ #category : #'*Pharo CSharp' }
False >> asCSharpLiteral [

	^ 'false'
]

{ #category : #'*Pharo CSharp' }
False >> asCSharpLiteralIn: aVisitor [ 

	^ PharoCSharpSimpleExpressionNode new content: self asCSharpLiteral
]
