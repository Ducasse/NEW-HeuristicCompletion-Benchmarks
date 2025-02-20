Class {
	#name : 'CoStaticBenchmarksMockVariabalesTest',
	#superclass : 'TestCase',
	#instVars : [
		'benchmarks'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests-Variables',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Variables'
}

{ #category : 'running' }
CoStaticBenchmarksMockVariabalesTest >> setUp [ 

    super setUp.
    benchmarks := CoStaticBenchmarksVariablesMock new.
    benchmarks initialize.
]

{ #category : 'running' }
CoStaticBenchmarksMockVariabalesTest >> tearDown [ 

    benchmarks := nil.
    super tearDown
]

{ #category : 'running' }
CoStaticBenchmarksMockVariabalesTest >> testAccuracyForCompletionIndex [ 

    "Simulate: the correct variable/class is found at rank=1, prefix=2, exactly once."
    benchmarks completionBenchs 
        at: 1
        put: (Dictionary new
                at: 2 put: #(1 (someVariable));
                yourself).

    self assert: (benchmarks accuracyForCompletionIndex: (1 to: 1) withPrefixSize: 2) equals: 1.0.
    self assert: (benchmarks accuracyForCompletionIndex: (2 to: 2) withPrefixSize: 2) equals: 0.0.
]

{ #category : 'running' }
CoStaticBenchmarksMockVariabalesTest >> testAccuracyForCompletionIndexCalculation [

    "Simulate:
        - Rank=1, Prefix=2, Count=2
        - Rank=2, Prefix=2, Count=1
     So total = 3 for prefix=2."

    | prefixDict1 prefixDict2 result |
    
    prefixDict1 := Dictionary new.
    prefixDict1 at: 2 put: { 2 . #(varA varB) }. "Rank 1, Prefix 2"

    prefixDict2 := Dictionary new.
    prefixDict2 at: 2 put: { 1 . #(varC) }. "Rank 2, Prefix 2"

    benchmarks completionBenchs at: 1 put: prefixDict1.
    benchmarks completionBenchs at: 2 put: prefixDict2.

    "Check rank=1 only => 2/3"
    result := benchmarks accuracyForCompletionIndex: (1 to: 1) withPrefixSize: 2.
    self assert: result equals: 2/3.

    "Check rank=1..2 => (2+1)/3 => 1.0"
    result := benchmarks accuracyForCompletionIndex: (1 to: 2) withPrefixSize: 2.
    self assert: result equals: 1.0.

    "Check rank=3 => 0/3 => 0.0"
    result := benchmarks accuracyForCompletionIndex: (3 to: 3) withPrefixSize: 2.
    self assert: result equals: 0.0.
]

{ #category : 'running' }
CoStaticBenchmarksMockVariabalesTest >> testAccuracyPerSelectorLength [ 

    "Same idea, but your 'variables' can have different name lengths."
    | prefixDict |
    prefixDict := Dictionary new.
    prefixDict at: 2 put: { 1 . (Set with: 'abcdVar') }.
    benchmarks completionBenchs at: 1 put: prefixDict.

    self assert: (benchmarks accuracyPerSelectorLength: 7) equals: 1.0.
    self assert: (benchmarks accuracyPerSelectorLength: 8) equals: 0.0.
]
