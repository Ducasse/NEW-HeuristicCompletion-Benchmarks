Class {
	#name : 'CoStaticBenchmarksMockMessageTest',
	#superclass : 'TestCase',
	#instVars : [
		'benchmarks'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests-Message',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Message'
}

{ #category : 'running' }
CoStaticBenchmarksMockMessageTest >> setUp [ 

	super setUp.
	benchmarks := CoStaticBenchmarksMessageMock new.
	benchmarks initialize.
]

{ #category : 'running' }
CoStaticBenchmarksMockMessageTest >> tearDown [ 

	benchmarks := nil.
	super tearDown
]

{ #category : 'running' }
CoStaticBenchmarksMockMessageTest >> testAccuracyForCompletionIndex [

	"Simulate: the correct method is found at rank=1, prefix=2, exactly once."
    "completionBenchs is a nested dictionary: completionBenchs at: rank => at: prefix => #( count . setOfSelectors )"
    
    "For rank=1, prefix=2, we add {1 . #(someSelector)}"
    benchmarks completionBenchs 
        at: 1
        put: (Dictionary new
                at: 2 put: #(1 (someSelector));
                yourself).
    
    "So totalEntriesPerPrefixSize: 2 => 1. 
     #accuracyForCompletionIndex: (1 to: 1) => #('1st' rank).
     This means we count how many times it was found at rank=1 / total attempts => 1/1 = 1.0."
    
    self assert: (benchmarks accuracyForCompletionIndex: (1 to: 1) withPrefixSize: 2) equals: 1.0.
    
    "Check zero if we ask for rank=2..2"
    self assert: (benchmarks accuracyForCompletionIndex: (2 to: 2) withPrefixSize: 2) equals: 0.0.
]

{ #category : 'running' }
CoStaticBenchmarksMockMessageTest >> testAccuracyForCompletionIndexCalculation [

    "Simulate the following data:
    - Rank=1, Prefix=2, Count=2 (two successful completions at rank 1 with prefix 2)
    - Rank=2, Prefix=2, Count=1 (one successful completion at rank 2 with prefix 2)
    
    Total entries for prefix=2 => 3 (2 + 1)."

    | prefixDict1 prefixDict2 result |
    
    prefixDict1 := Dictionary new.
    prefixDict1 at: 2 put: { 2 . #(selA selB) }. "Rank 1, Prefix 2, Count=2"
    
    prefixDict2 := Dictionary new.
    prefixDict2 at: 2 put: { 1 . #(selC) }. "Rank 2, Prefix 2, Count=1"
    
    benchmarks completionBenchs at: 1 put: prefixDict1. "Simulate rank 1 completions"
    benchmarks completionBenchs at: 2 put: prefixDict2. "Simulate rank 2 completions"
    
    "Calculate accuracy for rank range 1 to 1 (rank 1 only) with prefix size 2.
    Expected: 2/3 = 0.6667."
    result := benchmarks accuracyForCompletionIndex: (1 to: 1) withPrefixSize: 2.
    self assert: result equals: 2/3.
    
    "Calculate accuracy for rank range 1 to 2 (ranks 1 and 2 combined) with prefix size 2.
    Expected: (2 + 1)/3 = 1.0."
    result := benchmarks accuracyForCompletionIndex: (1 to: 2) withPrefixSize: 2.
    self assert: result equals: 1.0.
    
    "Calculate accuracy for rank range 3 to 3 (rank 3 only) with prefix size 2.
    Expected: 0/3 = 0.0."
    result := benchmarks accuracyForCompletionIndex: (3 to: 3) withPrefixSize: 2.
    self assert: result equals: 0.0.


]

{ #category : 'running' }
CoStaticBenchmarksMockMessageTest >> testAccuracyPerSelectorLength [

    "We log a correct find at rank=1, prefix=2, for the selector 'abcd' (size=4). 
     Then we verify #accuracyPerSelectorLength: 4 => 1.0."
    | prefixDict |
    prefixDict := Dictionary new.
    prefixDict at: 2 put: { 1 . (Set with: 'abcd') }.
    benchmarks completionBenchs at: 1 put: prefixDict.

    self assert: (benchmarks accuracyPerSelectorLength: 4) equals: 1.0.
    self assert: (benchmarks accuracyPerSelectorLength: 5) equals: 0.0.
]
