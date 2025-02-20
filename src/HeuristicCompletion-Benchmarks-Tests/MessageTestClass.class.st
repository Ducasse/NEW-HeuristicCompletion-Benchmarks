Class {
	#name : 'MessageTestClass',
	#superclass : 'Object',
	#category : 'HeuristicCompletion-Benchmarks-Tests-Mock',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Mock'
}

{ #category : 'as yet unclassified' }
MessageTestClass class >> installTestMethod [
    self compile: 'someMethod
        "A trivial method that has a message send ''asString'' & ''trim''."
        ^ ''Hello'' asString trim'
]

{ #category : 'as yet unclassified' }
MessageTestClass >> someMethod [
        "A trivial method that has a message send 'asString' & 'trim'."
        ^ 'Hello' asString trim
]
