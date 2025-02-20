Class {
	#name : 'CoStaticBenchmarksMockMessageTest',
	#superclass : 'TestCase',
	#instVars : [
		'benchmarks'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests-Messages',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Messages'
}

{ #category : 'running' }
CoStaticBenchmarksMockMessageTest >> setUp [ 
    super setUp.
    "Instead of CoStaticBenchmarks, we use the specialized message mock."
    benchmarks := CoStaticBenchmarksMockMessage new.
    benchmarks setUp.  "This populates the mock data"
]

{ #category : 'running' }
CoStaticBenchmarksMockMessageTest >> tearDown [ 

    benchmarks := nil.
    super tearDown
]

{ #category : 'running' }
CoStaticBenchmarksMockMessageTest >> testAccuracyForCompletionIndex [ 

    "Same logic as in CoStaticBenchmarksTest, but using the message mock's data."

    "We'll just do a quick check that the 'accuracyForCompletionIndex:' returns
     a valid value in [0..1]. Because the mock sets up some data, we can rely
     on that to produce real (fake) numbers."
    | result |
    result := benchmarks accuracyForCompletionIndex: (1 to: 1) withPrefixSize: 2.
    self assert: result >= 0.
    self assert: result <= 1.
]
