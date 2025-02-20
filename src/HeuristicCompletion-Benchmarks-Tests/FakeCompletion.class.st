Class {
	#name : 'FakeCompletion',
	#superclass : 'Object',
	#instVars : [
		'candidates'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests-Mock',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Mock'
}

{ #category : 'initialization' }
FakeCompletion >> candidates: aCollection [
    candidates := aCollection asOrderedCollection
]

{ #category : 'initialization' }
FakeCompletion >> first: n [
    ^ candidates first: (n min: candidates size)
]

{ #category : 'initialization' }
FakeCompletion >> initialize [
    candidates := OrderedCollection new.
]

{ #category : 'initialization' }
FakeCompletion >> replaceFilterWith: aFilter [
    "We won't do actual prefix filtering; we could simulate if we want to. 
     For now, do nothing or remove items that don't start with filter if you want."
    ^ self
]
