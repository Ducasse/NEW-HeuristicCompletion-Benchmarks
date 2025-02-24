Class {
	#name : 'CocotAnalyser',
	#superclass : 'Object',
	#instVars : [
		'usedClassNames',
		'scope',
		'definedClassNames',
		'package',
		'internalUsers'
	],
	#category : 'HeuristicCompletion-CocotAnalyser',
	#package : 'HeuristicCompletion-CocotAnalyser'
}

{ #category : 'examples' }
CocotAnalyser class >> example1 [
	"self example1"
	<script>
	^ CocotAnalyser new runForPackage:
		  (PackageOrganizer default packageNamed: 'NECompletion'); inspect
]

{ #category : 'examples' }
CocotAnalyser class >> exampleHeurisitic [
	"self exampleNec"

	<script>
	^ CocotAnalyser new
		  runForPackage:
			  (PackageOrganizer default packageNamed: 'HeuristicCompletion-Model');
		  inspect
]

{ #category : 'examples' }
CocotAnalyser class >> exampleNec [
	"self exampleNec"

	<script>
	^ CocotAnalyser new
		  runForPackage:
			  (PackageOrganizer default packageNamed: 'NECompletion');
		  inspect
]

{ #category : 'initialization' }
CocotAnalyser >> collectData [

	self collectDataFromClassReference.
	self collectDataFromClassDefinition.
	self computeInternalUse
]

{ #category : 'initialization' }
CocotAnalyser >> collectDataFromClassDefinition [

	definedClassNames := package definedClasses collect: [ :each | each name ]
]

{ #category : 'initialization' }
CocotAnalyser >> collectDataFromClassReference [

	scope methodsDo: [ :method |
		method parseTree nodesDo: [ :node |
			(node isMessage and: [
				 node receiver isVariable and: [
					 node receiver name first isUppercase ] ]) ifTrue: [
				usedClassNames add: node receiver name ] ] ]
]

{ #category : 'initialization' }
CocotAnalyser >> computeInternalUse [

	usedClassNames do: [ :each | 
		(definedClassNames includes: each)
			ifTrue: [ 
				internalUsers add: each ]].

]

{ #category : 'initialization' }
CocotAnalyser >> definedClassNames [

	^ definedClassNames
]

{ #category : 'initialization' }
CocotAnalyser >> initialize [

	super initialize.
	usedClassNames := OrderedCollection new.
	internalUsers := OrderedCollection new
]

{ #category : 'as yet unclassified' }
CocotAnalyser >> internalUserNumber [

	^ internalUsers size
]

{ #category : 'initialization' }
CocotAnalyser >> internalUserRatio [

	^ (self internalUserNumber / self definedClassNames size) asFloat
]

{ #category : 'initialization' }
CocotAnalyser >> runForPackage: aPackage [
	
	package := aPackage.
	scope := CoBenchmarkPackage on: aPackage.
	self collectData
]

{ #category : 'as yet unclassified' }
CocotAnalyser >> uniqueInternalUserNumber [

	^ self uniqueInternalUsers size
]

{ #category : 'as yet unclassified' }
CocotAnalyser >> uniqueInternalUsers [

	^ internalUsers asSet
]

{ #category : 'initialization' }
CocotAnalyser >> usedClassNames [

	^ usedClassNames
]
