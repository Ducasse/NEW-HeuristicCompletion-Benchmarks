Class {
	#name : 'FakeCompletionBuilder',
	#superclass : 'Object',
	#instVars : [
		'mockCandidates'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests-Mock',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Mock'
}

{ #category : 'accessing' }
FakeCompletionBuilder >> buildCompletion [
    "Return a new FakeCompletion loaded with mockCandidates."
    | c |
    c := FakeCompletion new.
    c candidates: (mockCandidates collect: [ :each |
        | candidate |
        candidate := FakeCompletionCandidate new.
        candidate contents: each.
        candidate
    ]).
    ^ c
]

{ #category : 'accessing' }
FakeCompletionBuilder >> completionContext: aContext [
    "No-op. We ignore the context in our fake builder."
    ^ self
]

{ #category : 'accessing' }
FakeCompletionBuilder >> mockCandidates: aCollection [
    mockCandidates := aCollection
]

{ #category : 'accessing' }
FakeCompletionBuilder >> node: aNode [
    "No-op or store node if needed. We do nothing here for simplicity."
    ^ self
]
