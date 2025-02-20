Class {
	#name : 'CoStaticBenchmarksVariablesMock',
	#superclass : 'CoStaticBenchmarksVaribales',
	#category : 'HeuristicCompletion-Benchmarks-Tests-Variables',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Variables'
}

{ #category : 'metrics' }
CoStaticBenchmarksVariablesMock >> accuracyForCompletionIndex: completionIndexRange withPrefixSize: prefixSize [ 

      ^ (completionIndexRange first + prefixSize) / 10.0
]

{ #category : 'metrics' }
CoStaticBenchmarksVariablesMock >> completionIndexes [ 

      ^ #((0) (1) (2 to: 3))
]

{ #category : 'metrics' }
CoStaticBenchmarksVariablesMock >> prefixSizes [

    ^ #(1 2 3 4)
]
