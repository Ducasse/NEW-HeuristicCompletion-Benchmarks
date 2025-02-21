Class {
	#name : 'MockCoStaticBenchmarksVariables',
	#superclass : 'CoStaticBenchmarksVariables',
	#category : 'HeuristicCompletion-Benchmarks-Tests-Mock',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Mock'
}

{ #category : 'running' }
MockCoStaticBenchmarksVariables >> benchCallsite: aMessageNode atPosition: aPosition [
   ^ self

]

{ #category : 'running' }
MockCoStaticBenchmarksVariables >> buildCompletionFor: aMessageNode atPosition: aPosition [
   ^ nil
]

{ #category : 'running' }
MockCoStaticBenchmarksVariables >> fetchTopCandidatesFrom: completion usingPrefix: prefix [
   ^ #( 'varCandidateA' 'varCandidateB' )
]

{ #category : 'running' }
MockCoStaticBenchmarksVariables >> findCompletionIndexFor: receiver inCandidates: candidates [
   ^ 1
]

{ #category : 'running' }
MockCoStaticBenchmarksVariables >> initializeMockDataForVariables [
   completionBenchs := Dictionary new.
   (0 to: 2) do: [:rank |
      | prefixDict |
      prefixDict := Dictionary new.
      (2 to: 3) do: [:pSize |
         prefixDict 
            at: pSize
            put: {
               (rank+2). 
               (Set with: ('var_', rank asString, '_', pSize asString)) 
            }].
      completionBenchs at: rank put: prefixDict.
   ].
   completionTimes := { 2 -> #(120 4). 3 -> #(240 6) } asDictionary.
   memoryUsages := { 2 -> #(2048 4). 3 -> #(4096 6) } asDictionary.
]

{ #category : 'running' }
MockCoStaticBenchmarksVariables >> run [
   self initializeMockDataForVariables.
]

{ #category : 'running' }
MockCoStaticBenchmarksVariables >> startMemoryMeasurement [
   ^ 2000
]

{ #category : 'running' }
MockCoStaticBenchmarksVariables >> startTimeMeasurement [
   ^ Time millisecondClockValue

]

{ #category : 'running' }
MockCoStaticBenchmarksVariables >> trackCompletionResultsFor: receiver atIndex: completionIndex withPrefix: prefix [
   ^ self
]
