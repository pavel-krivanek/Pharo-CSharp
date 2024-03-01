Extension { #name : #Character }

{ #category : #'*Pharo CSharp' }
Character >> asCSharpLiteral [

	^ '''', (self asString copyReplaceAll: '''' with: '\'''),  ''''
	

]
