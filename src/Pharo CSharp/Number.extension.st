Extension { #name : 'Number' }

{ #category : '*Pharo CSharp' }
Number >> asCSharpLiteral [

	^ self asString
]

{ #category : '*Pharo CSharp' }
Number >> asCSharpLiteralIn: aVisitor [ 

	^ PharoCSharpSimpleExpressionNode new content: self asCSharpLiteral
]
