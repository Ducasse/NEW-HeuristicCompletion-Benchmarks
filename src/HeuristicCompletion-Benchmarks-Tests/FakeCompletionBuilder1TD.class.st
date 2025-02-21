Class {
	#name : 'FakeCompletionBuilder1TD',
	#superclass : 'Object',
	#instVars : [
		'mockCandidates'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests',
	#package : 'HeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'accessing' }
FakeCompletionBuilder1TD >> buildCompletion [
    "Return a new FakeCompletion loaded with mockCandidates."
    | c |
    c := FakeCompletion1TD new.
    c candidates: (mockCandidates collect: [ :each |
        | candidate |
        candidate := FakeCompletionCandidate1TD new.
        candidate contents: each.
        candidate
    ]).
    ^ c
]

{ #category : 'accessing' }
FakeCompletionBuilder1TD >> completionContext: aContext [
    "No-op. We ignore the context in our fake builder."
    ^ self
]

{ #category : 'accessing' }
FakeCompletionBuilder1TD >> mockCandidates: aCollection [
    mockCandidates := aCollection
]

{ #category : 'accessing' }
FakeCompletionBuilder1TD >> node: aNode [
    "No-op or store node if needed. We do nothing here for simplicity."
    ^ self
]
