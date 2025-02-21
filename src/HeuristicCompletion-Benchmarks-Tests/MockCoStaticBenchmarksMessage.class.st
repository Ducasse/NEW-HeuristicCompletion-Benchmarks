Class {
	#name : 'MockCoStaticBenchmarksMessage',
	#superclass : 'CoStaticBenchmarksMessage',
	#category : 'HeuristicCompletion-Benchmarks-Tests-Mock',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Mock'
}

{ #category : 'running' }
MockCoStaticBenchmarksMessage >> benchCallsite: aMessageNode atPosition: aPosition [ 
   "No-op or fake logic." 
   ^ self

]

{ #category : 'running' }
MockCoStaticBenchmarksMessage >> buildCompletionFor: aMessageNode atPosition: aPosition [
   ^ nil  "Fake"
]

{ #category : 'running' }
MockCoStaticBenchmarksMessage >> fetchTopCandidatesFrom: completion usingPrefix: prefix [
   ^ #( 'msgCandidate1' 'msgCandidate2' )
]

{ #category : 'running' }
MockCoStaticBenchmarksMessage >> findCompletionIndexFor: originalSelector inCandidates: candidates [
   ^ 1
]

{ #category : 'running' }
MockCoStaticBenchmarksMessage >> initializeMockDataForMessage [
   "Set up some known data. Reuse the same pattern or a slightly different one."
   completionBenchs := Dictionary new.
   (0 to: 1) do: [:rank |
      | prefixDict |
      prefixDict := Dictionary new.
      (2 to: 3) do: [:pSize |
         prefixDict 
            at: pSize
            put: {
               (rank+1). 
               (Set with: ('message_', rank asString, '_', pSize asString)) 
            }].
      completionBenchs at: rank put: prefixDict.
   ].
   completionTimes := { 2 -> #(50 5). 3 -> #(90 9) } asDictionary.
   memoryUsages := { 2 -> #(512 5). 3 -> #(1024 9) } asDictionary.
]

{ #category : 'running' }
MockCoStaticBenchmarksMessage >> run [
   "Pretend to run message-based benchmarks. We'll just call an init method with known data."
   self initializeMockDataForMessage.
]

{ #category : 'running' }
MockCoStaticBenchmarksMessage >> startMemoryMeasurement [
   ^ 500
]

{ #category : 'running' }
MockCoStaticBenchmarksMessage >> startTimeMeasurement [
   ^ Time millisecondClockValue

]

{ #category : 'running' }
MockCoStaticBenchmarksMessage >> trackCompletionResultsFor: originalSelector atIndex: completionIndex withPrefix: prefix [
   "No-op or store something."
   ^ self
]
