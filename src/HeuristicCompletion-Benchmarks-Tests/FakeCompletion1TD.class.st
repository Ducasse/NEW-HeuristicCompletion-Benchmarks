Class {
	#name : 'FakeCompletion1TD',
	#superclass : 'Object',
	#instVars : [
		'candidates'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests',
	#package : 'HeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'initialization' }
FakeCompletion1TD >> candidates: aCollection [
    candidates := aCollection asOrderedCollection
]

{ #category : 'initialization' }
FakeCompletion1TD >> first: n [
    ^ candidates first: (n min: candidates size)
]

{ #category : 'initialization' }
FakeCompletion1TD >> initialize [
    candidates := OrderedCollection new.
]

{ #category : 'initialization' }
FakeCompletion1TD >> replaceFilterWith: aFilter [
    "We won't do actual prefix filtering; we could simulate if we want to. 
     For now, do nothing or remove items that don't start with filter if you want."
    ^ self
]
