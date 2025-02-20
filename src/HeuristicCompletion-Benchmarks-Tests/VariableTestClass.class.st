Class {
	#name : 'VariableTestClass',
	#superclass : 'Object',
	#instVars : [
		'UpperCaseVar'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests-Mock',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Mock'
}

{ #category : 'as yet unclassified' }
VariableTestClass class >> installTestMethod [
    self compile: 'testVariable
        UpperCaseVar := ''foo''.
        ^ UpperCaseVar size'
]

{ #category : 'as yet unclassified' }
VariableTestClass >> testVariable [
        UpperCaseVar := 'foo'.
        ^ UpperCaseVar size
]
