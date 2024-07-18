Extension { #name : 'UndefinedObject' }

{ #category : '*Pharo CSharp' }
UndefinedObject >> asCSharpLiteral [

	^ 'null'
]

{ #category : '*Pharo CSharp' }
UndefinedObject >> asCSharpLiteralIn: aVisitor [ 

	^ PharoCSharpSimpleExpressionNode new content: self asCSharpLiteral
]
