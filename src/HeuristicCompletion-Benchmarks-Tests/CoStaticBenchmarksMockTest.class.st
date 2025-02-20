Class {
	#name : 'CoStaticBenchmarksMockTest',
	#superclass : 'TestCase',
	#instVars : [
		'benchmarks'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests-Mock',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Mock'
}

{ #category : 'running' }
CoStaticBenchmarksMockTest >> setUp [ 

	super setUp.
	benchmarks := CoStaticBenchmarks new.
	benchmarks builder: CoGlobalSorterResultSetBuilder new.
	benchmarks initialize.
]

{ #category : 'running' }
CoStaticBenchmarksMockTest >> tearDown [ 
	
	benchmarks := nil.
	super tearDown.
]

{ #category : 'running' }
CoStaticBenchmarksMockTest >> testAverageMemoryForPrefix [


	benchmarks logMemory: 1000 forPrefix: 2.
	benchmarks logMemory: 3000 forPrefix: 2.
	
	self assert: (benchmarks averageMemoryForPrefix: 2) equals: 2000.
]

{ #category : 'running' }
CoStaticBenchmarksMockTest >> testAverageTimeForPrefix [

	benchmarks logTime: 10 forPrefix: 3.
	benchmarks logTime: 20 forPrefix: 3.
	
	self assert: (benchmarks averageTimeForPrefix: 3) equals: 15.
]

{ #category : 'running' }
CoStaticBenchmarksMockTest >> testBuilder [

	| newBuilder |
	newBuilder := CoASTHeuristicsResultSetBuilder.
	benchmarks builder: newBuilder.
	self assert: benchmarks builder equals: newBuilder.
	
]

{ #category : 'running' }
CoStaticBenchmarksMockTest >> testDiff [

	| benchA benchB diffResult |
	benchA := CoStaticBenchmarks new.
	benchB := CoStaticBenchmarks new.

	diffResult := benchA diff: benchB.

	"Check that diffResult is an array."
	self assert: diffResult isArray.

	"Ensure it contains exactly 3 associations."
	self assert: diffResult size equals: 3.

	"Check that each entry is an association (key -> value)."
	diffResult do: [ :entry |
		self assert: entry isAssociation. "Each entry should be a key -> value pair"
		self assert: entry value isArray. "The value of the association should be an array"
		self assert: entry value size equals: 3. "Ensure the outer array contains 3 elements"

		"Ensure that each sub-array has 5 elements"
		entry value do: [ :subArray |
			self assert: subArray isArray. "Each sub-array should be an array"
			self assert: subArray size equals: 5 "Each sub-array should have 5 elements" ] ]
]

{ #category : 'running' }
CoStaticBenchmarksMockTest >> testInitialize [

	| bench time memory |
	bench := benchmarks completionBenchs.
	time := benchmarks completionTimes.
	memory := benchmarks memoryUsages.
	
	self assert: bench isEmpty.
	self assert: time isEmpty.
	self assert: memory isEmpty.
]

{ #category : 'tests' }
CoStaticBenchmarksMockTest >> testInspectionResults [
	"Just verify it returns something without error; 
     you might parse the returned table or string to ensure correct formatting."

	benchmarks accuracyInspectionResults.
	self assert:
		(benchmarks accuracyInspectionResults isKindOf: SpTablePresenter)
]

{ #category : 'running' }
CoStaticBenchmarksMockTest >> testLogMemory [

   "memoryUsages at: 2 => #( totalBytes count ) => #( 3072 2 )."
	| stored |
	benchmarks logMemory: 1024 forPrefix: 2.
	benchmarks logMemory: 2048 forPrefix: 2.
	stored := benchmarks memoryUsages at:2 ifAbsent: [ #(0 0) ].

	self assert: stored first equals: 3072.
	self assert: stored second equals: 2.
]

{ #category : 'running' }
CoStaticBenchmarksMockTest >> testLogTime [

    "completionTimes at: 2 => #( totalTime count ) => #( 50 2 )."
	| stored |
	benchmarks logTime: 20 forPrefix: 2.
	benchmarks logTime: 30 forPrefix: 2.
	stored := benchmarks completionTimes at: 2 ifAbsent: [ #(0 0) ].
	self assert: stored first equals: 50.
	self assert: stored second equals: 2.	    
]

{ #category : 'tests' }
CoStaticBenchmarksMockTest >> testMMR [

    "Add data to completionBenchs to simulate correct finds at rank=1 for prefix=2.
	Now total for prefix=2 is 2, prefix=3 is 1 => total=3.
   MRR for prefix=2 => average(1/1 + 1/1), that is 1.0 (since all are rank=1).
	MRR for prefix=3 => average(1/1) => 1.0.
   So #mmr => (3 * 1.0) / 3 => 1.0."
   benchmarks completionBenchs
		at: 1
      put: (Dictionary new 
			at: 2 put: #(2 (selA selB));
         at: 3 put: #(1 (selC));
				yourself).
    
    self assert: (benchmarks mmrForPrefixSize: 2) equals: 1.0.
    self assert: (benchmarks mmrForPrefixSize: 3) equals: 1.0.
    self assert: benchmarks mmr equals: 1.0.
]

{ #category : 'tests' }
CoStaticBenchmarksMockTest >> testNDCG [

    | ndcgValue |
    "Simulate 2 correct finds at rank=1, prefix=2 => we should get near 1.0 for NDCG.
     This test just ensures the method runs and returns a value in [0..1]."
    benchmarks completionBenchs
        at: 1
        put: (Dictionary new
                at: 2 put: #(2 (selA selB));
                yourself).


    ndcgValue := benchmarks ndcgForPrefixSize: 2.
    self assert: ndcgValue >= 0.
]

{ #category : 'tests' }
CoStaticBenchmarksMockTest >> testRankDistributionForPrefixSize [

    "We add 1 correct find at ranks 1, 2, and 3 for prefix=2. 
     Then #rankDistributionForPrefixSize: 2 => #(1 1 1 0 0 0 0 0 0 0)."

    | dist |
    benchmarks completionBenchs
        at: 1
        put: (Dictionary new at: 2 put: #(1 (selA)); yourself).
    benchmarks completionBenchs
        at: 2
        put: (Dictionary new at: 2 put: #(1 (selB)); yourself).
    benchmarks completionBenchs
        at: 3
        put: (Dictionary new at: 2 put: #(1 (selC)); yourself).

    dist := benchmarks rankDistributionForPrefixSize: 2.
    self assert: dist size equals: 10.
    self assert: dist equals: #(1 1 1 0 0 0 0 0 0 0).
]

{ #category : 'tests' }
CoStaticBenchmarksMockTest >> testRecallAtK [

    "Total attempts for prefix=2 => 3, so recall@K=1 => 3/3 => 1.0"
    benchmarks completionBenchs
        at: 1
        put: (Dictionary new
                 at: 2 put: #(3 (someSel someSel2 someSel3));
                 yourself).

    self assert: (benchmarks recallAtK: 1 withPrefixSize: 2) equals: 1.0.
    
    "If we ask for rank=3 => same result, because rank=1 is included."
    self assert: (benchmarks recallAtK: 3 withPrefixSize: 2) equals: 1.0.
]

{ #category : 'running' }
CoStaticBenchmarksMockTest >> testScope [ 

	| fakeClass |
	fakeClass := Object.
	benchmarks scope: fakeClass.
	self assert: benchmarks scope equals: fakeClass.
]

{ #category : 'tests' }
CoStaticBenchmarksMockTest >> testScore [
	"The #score method is a bit arbitrary; it uses #gradeForPrefixSize, 
     which uses #accuracyForCompletionIndex: (2..8). 
     Here we just ensure it doesn't crash 
     and returns a numeric value in the expected range [0..100]."

	benchmarks score.
	self assert: (benchmarks score between: 0 and: 100)
]

{ #category : 'running' }
CoStaticBenchmarksMockTest >> testTotalMemoryForPrefix [

	benchmarks logMemory: 1000 forPrefix: 2.
	benchmarks logMemory: 2000 forPrefix: 2.
	
	self assert: (benchmarks totalMemoryForPrefix: 2) equals: 3000.
]

{ #category : 'running' }
CoStaticBenchmarksMockTest >> testTotalTime [

	benchmarks logTime: 10 forPrefix: 2.
	benchmarks logTime: 30 forPrefix: 3.
	
	self assert: benchmarks totalTime equals: 40.
]

{ #category : 'running' }
CoStaticBenchmarksMockTest >> testTotalTimeForPrefix [

	benchmarks logTime: 10 forPrefix: 3.
	benchmarks logTime: 20 forPrefix: 3.
	
	self assert: (benchmarks totalTimeForPrefix: 3) equals: 30.
]
