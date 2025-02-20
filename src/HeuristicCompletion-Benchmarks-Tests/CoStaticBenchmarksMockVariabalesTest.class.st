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
