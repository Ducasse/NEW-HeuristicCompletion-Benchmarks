Class {
	#name : 'VariableTestClass1TD',
	#superclass : 'Object',
	#instVars : [
		'UpperCaseVar'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests',
	#package : 'HeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'as yet unclassified' }
VariableTestClass1TD class >> installTestMethod [
    self compile: 'testVariable
        UpperCaseVar := ''foo''.
        ^ UpperCaseVar size'
]

{ #category : 'as yet unclassified' }
VariableTestClass1TD >> testVariable [
        UpperCaseVar := 'foo'.
        ^ UpperCaseVar size
]
