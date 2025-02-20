Class {
	#name : 'CoStaticBenchmarksMockMessage',
	#superclass : 'CoStaticBenchmarksMessage',
	#category : 'HeuristicCompletion-Benchmarks-Tests-Messages',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Messages'
}

{ #category : 'running' }
CoStaticBenchmarksMockMessage >> setUp [
    "Set up mock data so we can test method-name completions thoroughly."

    super initialize.

    "Fake 'completionBenchs' data structure:
     Dictionary of (index -> (Dictionary of (prefixSize -> {count. Set of items}))).
     For a real method's name, 'index' is which rank it was found in the top-10 results.
    "
    self completionBenchs: (Dictionary new
        at: 1 put: (Dictionary new
                      at: 2 put: { 5 . #('methodA' 'methodB')} ;
                      at: 3 put: { 3 . #('methodC')} ;
                      yourself);
        at: 2 put: (Dictionary new
                      at: 2 put: { 2 . #('methodX')} ;
                      at: 3 put: { 2 . #('methodY')} ;
                      yourself);
        at: 3 put: (Dictionary new
                      at: 2 put: { 1 . #('methodZ')} ;
                      yourself);
        "If the correct item wasn't found in top-10, we might store index=0..."
        at: 0 put: (Dictionary new
                      at: 2 put: { 2 . #('NOTFOUND1' 'NOTFOUND2')} ;
                      yourself);
        yourself).

    "Fake 'completionTimes' data structure:
     Dictionary: prefixSize -> #( totalTime count )
    "
    self completionTimes: (Dictionary new
        at: 2 put: #( 400 5 );   "400ms total for prefix size 2, over 5 calls"
        at: 3 put: #( 600 5 );   "600ms total for prefix size 3, over 5 calls"
        yourself).

    "Fake 'memoryUsages' data structure:
     Dictionary: prefixSize -> #( totalMemory count )
    "
    self memoryUsages: (Dictionary new
        at: 2 put: #( 8000 5 );  "8k total usage over 5 calls"
        at: 3 put: #(16000 5 ); "16k total usage over 5 calls"
        yourself).


]

{ #category : 'running' }
CoStaticBenchmarksMockMessage >> testAccuracy [
    "Test that accuracy calculations produce expected (or at least valid) results."
    | accuracy2 accuracy3 |
    accuracy2 := self accuracyForCompletionIndex: (1 to: 1) withPrefixSize: 2.
    accuracy3 := self accuracyForCompletionIndex: (1 to: 1) withPrefixSize: 3.

    self assert: accuracy2 >= 0.
    self assert: accuracy2 <= 1.
    self assert: accuracy3 >= 0.
    self assert: accuracy3 <= 1.
]

{ #category : 'running' }
CoStaticBenchmarksMockMessage >> testDiff [
    "Compare self to another mock instance and ensure we get a valid difference table."
    | other result |
    other := self class new.
    other setUp.
    "Adjust the other instance's data slightly to ensure differences."
    other completionTimes at: 2 put: #(450 5).  "just to differ a bit"

    result := self diff: other.

    "The #diff: method typically returns a dictionary with 
     keys #('BenchmarkA' 'BenchmarkB' 'Difference')."
    self assert: result includesKey: 'BenchmarkA'.
    self assert: result includesKey: 'BenchmarkB'.
    self assert: result includesKey: 'Difference'.

    "Optionally, check that 'Difference' is not all zeros."
    (result at: 'Difference') do: [ :row |
        "row is typically an Array of strings, e.g., { 'Prefix label'. 'Value1'. 'Value2'... }"
        "We can do shallow checks here."
        self deny: (row allSatisfy: [ :each | each = '0.00' ])
    ].
]

{ #category : 'running' }
CoStaticBenchmarksMockMessage >> testMMR [
    "Test mean reciprocal rank across prefix sizes."
    | mmr2 mmr3 overallMMR |
    mmr2 := self mmrForPrefixSize: 2.
    mmr3 := self mmrForPrefixSize: 3.
    overallMMR := self mmr.

    self assert: mmr2 >= 0.
    self assert: mmr2 <= 1.
    self assert: mmr3 >= 0.
    self assert: mmr3 <= 1.

    "Overall MMR is just a combined measure across prefix sizes 2..8 
     (only 2,3 are in our mock data, so it should be some average)."
    self assert: overallMMR >= 0.
    self assert: overallMMR <= 1.

]

{ #category : 'running' }
CoStaticBenchmarksMockMessage >> testMemory [
    "Test total and average memory usage with our mock data."
    | mem2 mem3 avgMem2 avgMem3 count2 count3 |
    mem2 := self totalMemoryForPrefix: 2.
    mem3 := self totalMemoryForPrefix: 3.

    "Check total memory usage"
    self assert: mem2 = 8000.
    self assert: mem3 = 16000.

    "Compute average memory usage ourselves"
    count2 := (self memoryUsages at: 2) second.
    count3 := (self memoryUsages at: 3) second.
    avgMem2 := self averageMemoryForPrefix: 2.
    avgMem3 := self averageMemoryForPrefix: 3.

    self assert: avgMem2 = (8000 / 5).
    self assert: avgMem3 = (16000 / 5).
]

{ #category : 'running' }
CoStaticBenchmarksMockMessage >> testNDCG [
    "Test NDCG computations for prefix sizes."
    | ndcg2 ndcg3 |
    ndcg2 := self ndcgForPrefixSize: 2.
    ndcg3 := self ndcgForPrefixSize: 3.

    self assert: ndcg2 >= 0.
    self assert: ndcg2 <= 1.
    self assert: ndcg3 >= 0.
    self assert: ndcg3 <= 1.
]

{ #category : 'running' }
CoStaticBenchmarksMockMessage >> testRankDistribution [
    "Test rank distribution for each prefix size."
    | dist2 dist3 |
    dist2 := self rankDistributionForPrefixSize: 2.  "Array(1..10) of how often correct item was found at each rank"
    dist3 := self rankDistributionForPrefixSize: 3.

    "We only have data for ranks 1,2,3,0 in setUp, so let's ensure we don't get nil in others"
    dist2 do: [ :count | self assert: count >= 0 ].
    dist3 do: [ :count | self assert: count >= 0 ].

]

{ #category : 'running' }
CoStaticBenchmarksMockMessage >> testRecall [
    "Test recall@K for prefix sizes."
    | recall2At1 recall3At3 |
    recall2At1 := self recallAtK: 1 withPrefixSize: 2.
    recall3At3 := self recallAtK: 3 withPrefixSize: 3.

    self assert: recall2At1 >= 0.
    self assert: recall2At1 <= 1.
    self assert: recall3At3 >= 0.
    self assert: recall3At3 <= 1.

]

{ #category : 'running' }
CoStaticBenchmarksMockMessage >> testTime [
    "Ensure total and average times match our mock data."
    | total2 avg2 total3 avg3 |
    total2 := self totalTimeForPrefix: 2.
    avg2   := self averageTimeForPrefix: 2.
    total3 := self totalTimeForPrefix: 3.
    avg3   := self averageTimeForPrefix: 3.

    self assert: total2 = 400.
    self assert: avg2 = (400 / 5).
    self assert: total3 = 600.
    self assert: avg3 = (600 / 5).
]
