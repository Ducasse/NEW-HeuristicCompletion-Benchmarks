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
    "Use the specialized variable/class name mock."
    benchmarks := CoStaticBenchmarksMockVariables new.
    benchmarks setUp.  "Populates the mock data"
]

{ #category : 'running' }
CoStaticBenchmarksMockVariabalesTest >> tearDown [ 

    benchmarks := nil.
    super tearDown
]

{ #category : 'running' }
CoStaticBenchmarksMockVariabalesTest >> testAccuracyForCompletionIndex [ 

    "Check the computed accuracy is valid based on the variable mock's data."
    | result |
    result := benchmarks accuracyForCompletionIndex: (1 to: 1) withPrefixSize: 2.
    self assert: result >= 0.
    self assert: result <= 1.
]

{ #category : 'running' }
CoStaticBenchmarksMockVariabalesTest >> testTime [

    | total2 avg2 |
    total2 := benchmarks totalTimeForPrefix: 2.
    avg2   := benchmarks averageTimeForPrefix: 2.
    "From CoStaticBenchmarksVaribaleMock>>setUp we have #(250 3) for prefix=2."
    self assert: total2 = 250.
    self assert: avg2 = (250 / 3).
]
