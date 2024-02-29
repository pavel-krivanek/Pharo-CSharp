Extension { #name : 'True' }

{ #category : '*Pharo CSharp' }
True >> asCSharpLiteral [

	^ 'true'
]

{ #category : '*Pharo CSharp' }
True >> asCSharpLiteralIn: aVisitor [ 

	^ PharoCSharpSimpleExpressionNode new content: self asCSharpLiteral
]
