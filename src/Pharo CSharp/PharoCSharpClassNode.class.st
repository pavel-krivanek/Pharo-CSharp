"
C# class definition node
"
Class {
	#name : #PharoCSharpClassNode,
	#superclass : #PharoCSharpNode,
	#instVars : [
		'name',
		'visibility',
		'variables',
		'regions',
		'staticRegions',
		'supertypes',
		'genericTypes',
		'isInterface'
	],
	#category : #'Pharo CSharp-AST'
}

{ #category : #accessing }
PharoCSharpClassNode >> acceptVisitor: aVisitor [
	^ aVisitor visitClassNode: self
]

{ #category : #accessing }
PharoCSharpClassNode >> addGenericType: typeName [ 
	
	^ genericTypes add: typeName
]

{ #category : #accessing }
PharoCSharpClassNode >> addRegion: aRegion [ 

	aRegion parent: self.
	^ regions add: aRegion
]

{ #category : #accessing }
PharoCSharpClassNode >> addStaticRegion: aRegion [ 

	aRegion parent: self.
	^ staticRegions add: aRegion
]

{ #category : #accessing }
PharoCSharpClassNode >> addSupertype: typeName [ 
	
	^ supertypes add: typeName
]

{ #category : #accessing }
PharoCSharpClassNode >> addVariable: aMethod [ 

	aMethod parent: self.
	^ variables add: aMethod
]

{ #category : #accessing }
PharoCSharpClassNode >> from: aClass [ 

	comments := { aClass comment }.
	hasParentheses := false

	
]

{ #category : #accessing }
PharoCSharpClassNode >> genericTypes [

	^ genericTypes
]

{ #category : #accessing }
PharoCSharpClassNode >> genericTypes: anObject [

	genericTypes := anObject
]

{ #category : #accessing }
PharoCSharpClassNode >> hasGenericTypes [

	^ genericTypes notEmpty
]

{ #category : #accessing }
PharoCSharpClassNode >> hasSupertypes [ 

	^ supertypes notEmpty
]

{ #category : #accessing }
PharoCSharpClassNode >> initialize [ 

	super initialize.
	
	visibility := #public.
	supertypes := OrderedCollection new.	
	genericTypes := OrderedCollection new.
	variables := OrderedCollection new.
	regions := OrderedCollection new.		
	staticRegions := OrderedCollection new.		
	isInterface := false.
]

{ #category : #accessing }
PharoCSharpClassNode >> isInterface [

	^ isInterface
]

{ #category : #accessing }
PharoCSharpClassNode >> isInterface: anObject [

	isInterface := anObject
]

{ #category : #accessing }
PharoCSharpClassNode >> name [

	^ name
]

{ #category : #accessing }
PharoCSharpClassNode >> name: anObject [

	name := anObject
]

{ #category : #accessing }
PharoCSharpClassNode >> regions [

	^ regions
]

{ #category : #accessing }
PharoCSharpClassNode >> regions: anObject [

	regions := anObject.
	regions do: [ :each | each parent: self ]
]

{ #category : #accessing }
PharoCSharpClassNode >> staticRegions [

	^ staticRegions
]

{ #category : #accessing }
PharoCSharpClassNode >> staticRegions: anObject [

	staticRegions := anObject.
	staticRegions do: [ :each | each parent: self ]
]

{ #category : #accessing }
PharoCSharpClassNode >> supertypes [ 

	^ supertypes
]

{ #category : #accessing }
PharoCSharpClassNode >> supertypes: anObject [

	supertypes := anObject
]

{ #category : #accessing }
PharoCSharpClassNode >> variables [

	^ variables
]

{ #category : #accessing }
PharoCSharpClassNode >> variables: anObject [

	variables := anObject.
	variables do: [ :each | each parent: self ]
]

{ #category : #accessing }
PharoCSharpClassNode >> visibility [

	^ visibility
]

{ #category : #accessing }
PharoCSharpClassNode >> visibility: anObject [

	visibility := anObject
]
