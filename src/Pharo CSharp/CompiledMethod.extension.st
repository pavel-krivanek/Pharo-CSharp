Extension { #name : 'CompiledMethod' }

{ #category : '*Pharo CSharp' }
CompiledMethod >> allTempAndArgNames [ 

	^ ((self temporaryVariables collect: [:each | each name ])
		, (self ast blockNodes flatCollect: [:block |
			(block temporaryNames), (block arguments collect: [ :e | e name ]) ])) asSet
]
