Class {
	#name : 'CoStaticBenchmarksTest1TD',
	#superclass : 'TestCase',
	#instVars : [
		'bench'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests',
	#package : 'HeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'running' }
CoStaticBenchmarksTest1TD >> setUp [
    "Set up a fresh instance before each test."
    super setUp.
    bench := CoStaticBenchmarks new.
    "Override or set any default states if needed, e.g. a fake builder, etc."
    bench completionBenchs: Dictionary new.
    bench completionTimes: Dictionary new.
    bench memoryUsages: Dictionary new.
]

{ #category : 'running' }
CoStaticBenchmarksTest1TD >> testAccuracyCalculation [
    "Arrange a known distribution of completions:
     Suppose rank=1 had 2 hits, rank=2 had 1 hit, rank=3 had 0 hits, rank=4..10 had 0 hits
     for prefix size 2."

    | prefixSize rank1Entry rank2Entry accuracy tolerance totalCalls |
    prefixSize := 2.
    tolerance := 0.0001.

    "Create a nested Dictionary structure:
        bench.completionBenchs at: rank -> (Dictionary new at: prefixSize put: #(count setOfSelectors) )"
    rank1Entry := { 2. #(#selA #selB) }.  "2 callsites found correct at rank=1"
    rank2Entry := { 1. #(#selC) }.       "1 callsite found correct at rank=2"

    bench completionBenchs
        at: 1
        put: (Dictionary new at: prefixSize put: rank1Entry; yourself).
    bench completionBenchs
        at: 2
        put: (Dictionary new at: prefixSize put: rank2Entry; yourself).

    "Act: Let's compute accuracy for rank 1 to 1 (meaning exactly rank=1)."
    accuracy := bench
        accuracyForCompletionIndex: (1 to: 1)
        withPrefixSize: prefixSize.

    "Assert: There are totalEntries=2+1=3 calls. But rank=1 had 2 correct out of 3 => accuracy=2/3=0.666.."
    totalCalls := 3.  "2 + 1"
    self assert: ((accuracy - (2 / totalCalls)) abs < tolerance).

    "Similarly, test accuracy from rank 1 to rank 2 => 3/3 => 1.0"
    accuracy := bench
        accuracyForCompletionIndex: (1 to: 2)
        withPrefixSize: prefixSize.
    self assert: accuracy = 1.0.
]

{ #category : 'running' }
CoStaticBenchmarksTest1TD >> testLoggingMemory [
	"Make sure logging accumulates correctly in the dictionaries."

	| prefixSize memoryBefore tolerance |
	prefixSize := 2.
	tolerance := 0.001.

	"Memory usage"
	memoryBefore := bench memoryUsages
		                at: prefixSize
		                ifAbsent: [ #( 0 0 ) ].
	self assert: memoryBefore equals: #( 0 0 ).

	bench logMemory: 4096 forPrefix: prefixSize.
	bench logMemory: 2048 forPrefix: prefixSize.

	self assert: (bench memoryUsages at: prefixSize) equals: #( 6144 2 ).
	self assert:
		((bench averageMemoryForPrefix: prefixSize) - 3072) abs < tolerance
]

{ #category : 'running' }
CoStaticBenchmarksTest1TD >> testLoggingTime [
	"Make sure logging accumulates correctly in the dictionaries."

	| prefixSize timesBefore tolerance |
	prefixSize := 2.
	tolerance := 0.001.

	"Initially empty -> #(#(0 0))"
	timesBefore := bench completionTimes
		               at: prefixSize
		               ifAbsent: [ #( 0 0 ) ].
	self assert: timesBefore equals: #( 0 0 ).

	bench logTime: 100 forPrefix: prefixSize.
	bench logTime: 200 forPrefix: prefixSize.

	"Now check the times dictionary => total=300, count=2"
	self
		assert: (bench completionTimes at: prefixSize)
		equals: #( 300 2 ).

	"Check averageTimeForPrefix:"
	self assert:
		((bench averageTimeForPrefix: prefixSize) - 150) abs < tolerance.

]

{ #category : 'running' }
CoStaticBenchmarksTest1TD >> testMRRCalculation [
    "Test the MRR for a single prefix size distribution."

    | prefixSize rank1Entry rank2Entry rank3Entry mrr tolerance expectedMrr |
    prefixSize := 2.
    tolerance := 0.0001.

    "Construct a scenario with 3 total callsites:
       - 1 callsite is correct at rank=1
       - 1 callsite is correct at rank=2
       - 1 callsite is correct at rank=3"
    rank1Entry := { 1. #(#selA) }.
    rank2Entry := { 1. #(#selB) }.
    rank3Entry := { 1. #(#selC) }.

    bench completionBenchs
        at: 1
        put: (Dictionary new at: prefixSize put: rank1Entry; yourself).
    bench completionBenchs
        at: 2
        put: (Dictionary new at: prefixSize put: rank2Entry; yourself).
    bench completionBenchs
        at: 3
        put: (Dictionary new at: prefixSize put: rank3Entry; yourself).

    "MRR = average(1/1, 1/2, 1/3) = (1 + 0.5 + 0.3333)/3 = ~0.61"
    mrr := bench mmrForPrefixSize: prefixSize.
    expectedMrr := (1 + 0.5 + 0.3333) / 3.
    self assert: ((mrr - expectedMrr) abs < tolerance).
]
