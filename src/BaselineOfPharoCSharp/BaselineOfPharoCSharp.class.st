Class {
	#name : #BaselineOfPharoCSharp,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoCSharp
}

{ #category : #baselines }
BaselineOfPharoCSharp >> baseline: spec [ 
	<baseline>
	spec for: #common
		do: [			
		  spec
			  baseline: 'RuntimeTypeCollector'
			  with: [ spec repository: 'github://pavel-krivanek/Runtime-Type-Collector' ].
						
			spec package: 'Pharo CSharp'.
			spec package: 'Pharo CSharp-Tests'.
			spec package: 'Pharo CSharp-Example'.
	]
]
