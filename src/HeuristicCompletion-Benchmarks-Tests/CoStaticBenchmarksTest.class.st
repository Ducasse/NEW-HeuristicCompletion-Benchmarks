Class {
	#name : 'CoStaticBenchmarksTest',
	#superclass : 'TestCase',
	#instVars : [
		'benchmark'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests-Mock',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Mock'
}

{ #category : 'running' }
CoStaticBenchmarksTest >> setUp [
	"Create a new MockCoStaticBenchmarks and run it so we have known data."
	super setUp.
	benchmark := MockCoStaticBenchmarks new.
	benchmark run
]

{ #category : 'running' }
CoStaticBenchmarksTest >> testAccuracyForCompletionIndex [
   "Test the accuracyForCompletionIndex:withPrefixSize: method on known data."
   | accuracy0to0 accuracy1to1 accuracy2to3 |
   accuracy0to0 := benchmark accuracyForCompletionIndex: (0 to: 0) withPrefixSize: 2.
   self assert: accuracy0to0 equals: 1/benchmark totalEntriesPerPrefixSize: 2.

   accuracy1to1 := benchmark accuracyForCompletionIndex: (1 to: 1) withPrefixSize: 2.
   "Similarly test other ranges or prefix sizes..."
   self assert: accuracy1to1 > 0.
	
   accuracy2to3 := benchmark accuracyForCompletionIndex: (2 to: 3) withPrefixSize: 3.
   self assert: accuracy2to3 > 0
]

{ #category : 'running' }
CoStaticBenchmarksTest >> testMMR [
   "Test the MRR calculation on the known data."
   | mmrValue mmrPrefix2 |
   mmrValue := benchmark mmr.
   mmrPrefix2 := benchmark mmrForPrefixSize: 2.

   self assert: mmrValue >= 0.
   self assert: mmrPrefix2 >= 0.
   "You can compare to exact fractions if you set up your data precisely."
]

{ #category : 'running' }
CoStaticBenchmarksTest >> testMemoryUsage [
   | totalMemory2 avgMemory2 |
   totalMemory2 := benchmark totalMemoryForPrefix: 2.
   avgMemory2 := benchmark averageMemoryForPrefix: 2.

   self assert: totalMemory2 = 1024.
   self assert: avgMemory2 = (1024 / 2).
]

{ #category : 'running' }
CoStaticBenchmarksTest >> testNDCG [
   | ndcgVal ndcgPrefix2 |
   ndcgVal := benchmark ndcgForPrefixSize: 3.
   ndcgPrefix2 := benchmark ndcgForPrefixSize: 2.
   self assert: ndcgVal >= 0.
   self assert: ndcgVal <= 1.
   self assert: ndcgPrefix2 >= 0.
   self assert: ndcgPrefix2 <= 1
]

{ #category : 'running' }
CoStaticBenchmarksTest >> testRecall [
   | recallVal |
   recallVal := benchmark recallAtK: 3 withPrefixSize: 2.
   self assert: recallVal >= 0.
   self assert: recallVal <= 1
]

{ #category : 'running' }
CoStaticBenchmarksTest >> testTimeUsage [
   | total2 count2 avg2 |
   total2 := benchmark totalTimeForPrefix: 2.
   count2 := (benchmark completionTimes at: 2) second.
   avg2 := benchmark averageTimeForPrefix: 2.

   self assert: total2 = 200.
   self assert: count2 = 2.
   self assert: avg2 = (200 / 2)
]
