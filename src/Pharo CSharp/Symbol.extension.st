Extension { #name : 'Symbol' }

{ #category : '*Pharo CSharp' }
Symbol >> asCSharpLiteral [
	
	^ super asCSharpLiteral 
	"^ 'Symbol.', (self copyReplaceAll: ':' with: '_')"
]
