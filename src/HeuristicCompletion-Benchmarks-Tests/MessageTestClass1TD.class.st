Class {
	#name : 'MessageTestClass1TD',
	#superclass : 'Object',
	#category : 'HeuristicCompletion-Benchmarks-Tests',
	#package : 'HeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'as yet unclassified' }
MessageTestClass1TD class >> installTestMethod [
    self compile: 'someMethod
        "A trivial method that has a message send ''asString'' & ''trim''."
        ^ ''Hello'' asString trim'
]

{ #category : 'as yet unclassified' }
MessageTestClass1TD >> someMethod [
        "A trivial method that has a message send 'asString' & 'trim'."
        ^ 'Hello' asString trim
]
