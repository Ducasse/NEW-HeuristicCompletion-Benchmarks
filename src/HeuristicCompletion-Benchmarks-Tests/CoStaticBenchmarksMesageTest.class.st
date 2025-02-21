Class {
	#name : 'CoStaticBenchmarksMesageTest',
	#superclass : 'TestCase',
	#instVars : [
		'benchmark'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests-Mock',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Mock'
}

{ #category : 'running' }
CoStaticBenchmarksMesageTest >> setUp [
	super setUp.
   benchmark := MockCoStaticBenchmarksMessage new.
   benchmark run
]

{ #category : 'running' }
CoStaticBenchmarksMesageTest >> testAccuracy [
   | val |
   val := benchmark accuracyForCompletionIndex: (0 to: 0) withPrefixSize: 2.
   self assert: val >= 0.
   self assert: val <= 1
]

{ #category : 'running' }
CoStaticBenchmarksMesageTest >> testMMR [
   self assert: benchmark mmr >= 0
]

{ #category : 'running' }
CoStaticBenchmarksMesageTest >> testMemory [
   | total memAvg |
   total := benchmark totalMemoryForPrefix: 2.
   memAvg := benchmark averageMemoryForPrefix: 2.
   self assert: total = 512.
   self assert: memAvg = (512 / 5)
]

{ #category : 'running' }
CoStaticBenchmarksMesageTest >> testNDCG [
   self assert: (benchmark ndcgForPrefixSize: 2) between: 0 and: 1
]

{ #category : 'running' }
CoStaticBenchmarksMesageTest >> testRecall [
   self assert: (benchmark recallAtK: 1 withPrefixSize: 3) between: 0 and: 1
]

{ #category : 'running' }
CoStaticBenchmarksMesageTest >> testTime [
   | totalTime avgTime |
   totalTime := benchmark totalTimeForPrefix: 2.
   avgTime := benchmark averageTimeForPrefix: 2.
   self assert: totalTime = 50.
   self assert: avgTime = (50 / 5)
]
