Extension { #name : 'Integer' }

{ #category : '*Pharo CSharp' }
Integer >> asCSharpLiteral [

	^ self asString, 'L'
]
