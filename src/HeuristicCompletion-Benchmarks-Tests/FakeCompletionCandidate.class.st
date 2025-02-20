Class {
	#name : 'FakeCompletionCandidate',
	#superclass : 'Object',
	#instVars : [
		'contents'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests-Mock',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Mock'
}

{ #category : 'accessing' }
FakeCompletionCandidate >> contents [
    ^ contents
]

{ #category : 'accessing' }
FakeCompletionCandidate >> contents: aString [
    contents := aString
]
