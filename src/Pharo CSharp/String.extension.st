Extension { #name : 'String' }

{ #category : '*Pharo CSharp' }
String >> asCSharpLiteral [

	^ '"', (self copyReplaceAll: '"' with: '\"'),  '"'
]

{ #category : '*Pharo CSharp' }
String >> asCSharpLiteralIn: aVisitor [ 

	^ PharoCSharpSimpleExpressionNode new content: self asCSharpLiteral
]
