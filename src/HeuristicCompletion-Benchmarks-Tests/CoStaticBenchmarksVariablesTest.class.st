Class {
	#name : 'CoStaticBenchmarksVariablesTest',
	#superclass : 'TestCase',
	#instVars : [
		'benchmark'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests-Mock',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Mock'
}

{ #category : 'running' }
CoStaticBenchmarksVariablesTest >> setUp [

   benchmark := MockCoStaticBenchmarksVariables new.
   benchmark run
]

{ #category : 'running' }
CoStaticBenchmarksVariablesTest >> testAccuracy [
   | acc |
   acc := benchmark accuracyForCompletionIndex: (0 to: 0) withPrefixSize: 2.
   self assert: acc >= 0.
   self assert: acc <= 1
]

{ #category : 'running' }
CoStaticBenchmarksVariablesTest >> testMMR [
   self assert: benchmark mmr >= 0
]

{ #category : 'running' }
CoStaticBenchmarksVariablesTest >> testMemoryUsage [
   | total memAvg |
   total := benchmark totalMemoryForPrefix: 2.
   memAvg := benchmark averageMemoryForPrefix: 2.
   self assert: total = 2048.
   self assert: memAvg = (2048 / 4)
]

{ #category : 'running' }
CoStaticBenchmarksVariablesTest >> testRecall [
   self assert: (benchmark recallAtK: 3 withPrefixSize: 2) between: 0 and: 1
]

{ #category : 'running' }
CoStaticBenchmarksVariablesTest >> testTiming [
   | totalTime avgTime |
   totalTime := benchmark totalTimeForPrefix: 2.
   avgTime := benchmark averageTimeForPrefix: 2.
   self assert: totalTime = 120.
   self assert: avgTime = (120 / 4)
]
