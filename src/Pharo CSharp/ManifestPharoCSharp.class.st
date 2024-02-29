"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestPharoCSharp',
	#superclass : 'PackageManifest',
	#category : 'Pharo CSharp-Manifest',
	#package : 'Pharo CSharp',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestPharoCSharp class >> ruleStringConcatenationRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#'Documaps CSharp')) #'2024-01-24T17:20:55.563+01:00') )
]
