Class {
	#name : 'CoStaticBenchmarksVariablesMock',
	#superclass : 'CoStaticBenchmarksVaribales',
	#category : 'HeuristicCompletion-Benchmarks-Tests-Variables',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Variables'
}

{ #category : 'running' }
CoStaticBenchmarksVariablesMock >> setUp [
    super initialize.

    "Fake completions data"
    self completionBenchs: (Dictionary new
        at: 1 put: (Dictionary new
                      at: 2 put: { 3 . #('MyClass' 'OtherClass')} ;
                      at: 3 put: { 2 . #('MyClass')} ;
                      yourself);
        at: 2 put: (Dictionary new
                      at: 2 put: { 1 . #('AnotherClass')} ;
                      yourself);
        at: 0 put: (Dictionary new
                      at: 2 put: { 2 . #('NOTFOUND')} ;
                      yourself);
        yourself).

    "Fake times"
    self completionTimes: (Dictionary new
        at: 2 put: #( 250 3 ); 
        at: 3 put: #( 500 3 ); 
        yourself).

    "Fake memory usage"
    self memoryUsages: (Dictionary new
        at: 2 put: #( 9000 3 ); 
        at: 3 put: #(18000 3 );
        yourself).

]

{ #category : 'running' }
CoStaticBenchmarksVariablesMock >> testAccuracy [
    | accuracy2 accuracy3 |
    accuracy2 := self accuracyForCompletionIndex: (1 to: 1) withPrefixSize: 2.
    accuracy3 := self accuracyForCompletionIndex: (1 to: 2) withPrefixSize: 3.

    self assert: accuracy2 >= 0.
    self assert: accuracy2 <= 1.
    self assert: accuracy3 >= 0.
    self assert: accuracy3 <= 1.
]

{ #category : 'running' }
CoStaticBenchmarksVariablesMock >> testDiff [
    | other result |
    other := self class new.
    other setUp.

    "Slightly adjust the other instance's data."
    other completionTimes at: 2 put: #( 300 3 ). 

    result := self diff: other.

    self assert: result includesKey: 'BenchmarkA'.
    self assert: result includesKey: 'BenchmarkB'.
    self assert: result includesKey: 'Difference'.

    (result at: 'Difference') do: [ :row |
        self deny: (row allSatisfy: [ :each | each = '0.00' ])
    ].
]

{ #category : 'running' }
CoStaticBenchmarksVariablesMock >> testMMR [
    | mmr2 mmr3 overallMMR |
    mmr2 := self mmrForPrefixSize: 2.
    mmr3 := self mmrForPrefixSize: 3.
    overallMMR := self mmr.

    self assert: mmr2 >= 0.
    self assert: mmr2 <= 1.
    self assert: mmr3 >= 0.
    self assert: mmr3 <= 1.
    self assert: overallMMR >= 0.
    self assert: overallMMR <= 1.

]

{ #category : 'running' }
CoStaticBenchmarksVariablesMock >> testMemory [
    | mem2 mem3 avg2 avg3 count2 count3 |
    mem2 := self totalMemoryForPrefix: 2.
    mem3 := self totalMemoryForPrefix: 3.
    self assert: mem2 = 9000.
    self assert: mem3 = 18000.

    count2 := (self memoryUsages at: 2) second.
    count3 := (self memoryUsages at: 3) second.
    avg2   := self averageMemoryForPrefix: 2.
    avg3   := self averageMemoryForPrefix: 3.

    self assert: avg2 = (9000 / 3).
    self assert: avg3 = (18000 / 3).

]

{ #category : 'running' }
CoStaticBenchmarksVariablesMock >> testNDCG [
    | ndcg2 ndcg3 |
    ndcg2 := self ndcgForPrefixSize: 2.
    ndcg3 := self ndcgForPrefixSize: 3.

    self assert: ndcg2 >= 0.
    self assert: ndcg2 <= 1.
    self assert: ndcg3 >= 0.
    self assert: ndcg3 <= 1.

]

{ #category : 'running' }
CoStaticBenchmarksVariablesMock >> testRankDistribution [
    | dist2 dist3 |
    dist2 := self rankDistributionForPrefixSize: 2.
    dist3 := self rankDistributionForPrefixSize: 3.

    dist2 do: [ :val | self assert: val >= 0 ].
    dist3 do: [ :val | self assert: val >= 0 ].

]

{ #category : 'running' }
CoStaticBenchmarksVariablesMock >> testRecall [
    | recall2At1 recall3At2 |
    recall2At1 := self recallAtK: 1 withPrefixSize: 2.
    recall3At2 := self recallAtK: 2 withPrefixSize: 3.

    self assert: recall2At1 >= 0.
    self assert: recall2At1 <= 1.
    self assert: recall3At2 >= 0.
    self assert: recall3At2 <= 1.

]

{ #category : 'running' }
CoStaticBenchmarksVariablesMock >> testTime [
    | total2 avg2 total3 avg3 |
    total2 := self totalTimeForPrefix: 2.
    avg2   := self averageTimeForPrefix: 2.
    total3 := self totalTimeForPrefix: 3.
    avg3   := self averageTimeForPrefix: 3.

    self assert: total2 = 250.
    self assert: avg2 = (250 / 3).
    self assert: total3 = 500.
    self assert: avg3 = (500 / 3).
]
