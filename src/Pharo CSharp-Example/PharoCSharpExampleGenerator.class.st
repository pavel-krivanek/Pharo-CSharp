Class {
	#name : 'PharoCSharpExampleGenerator',
	#superclass : 'PharoCSharpGenerator',
	#category : 'Pharo CSharp-Example',
	#package : 'Pharo CSharp-Example'
}

{ #category : 'as yet unclassified' }
PharoCSharpExampleGenerator class >> generate [ 

	<script>
	
	| basePath |
	basePath := './' asFileReference.
	
	self 
		generatePackage: 'Pharo CSharp-Example' 
		head: self head 
		file: basePath / 'PharoCSharpExample.cs'.
		
		
								
]

{ #category : 'as yet unclassified' }
PharoCSharpExampleGenerator class >> head [

	^'
using System;

using PharoUtils;

namespace PharoCSharpExample;
'
]

{ #category : 'as yet unclassified' }
PharoCSharpExampleGenerator class >> openTranlator [ 

	<script>
	super openTranlator
]
