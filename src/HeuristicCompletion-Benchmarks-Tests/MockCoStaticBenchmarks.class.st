Class {
	#name : 'MockCoStaticBenchmarks',
	#superclass : 'CoStaticBenchmarks',
	#category : 'HeuristicCompletion-Benchmarks-Tests-Mock',
	#package : 'HeuristicCompletion-Benchmarks-Tests',
	#tag : 'Mock'
}

{ #category : 'running' }
MockCoStaticBenchmarks >> benchCallsite: aMessageNode atPosition: aPosition [
   "No-op for the mock."
   ^ self.
]

{ #category : 'running' }
MockCoStaticBenchmarks >> buildCompletionFor: aMessageNode atPosition: aPosition [
   "No-op or return a dummy completion object for the mock."
   ^ nil

]

{ #category : 'running' }
MockCoStaticBenchmarks >> fetchTopCandidatesFrom: completion usingPrefix: prefix [
   "Return a fixed set of pretend completions."
   ^ #( 'selector_0_2' 'selector_1_2' 'selector_2_2' )
]

{ #category : 'running' }
MockCoStaticBenchmarks >> findCompletionIndexFor: receiver inCandidates: candidates [
   "Pretend we found it at rank 1 always."
   ^ 1
]

{ #category : 'running' }
MockCoStaticBenchmarks >> initializeMockData [
   completionBenchs := Dictionary new.
   "Populate fake data for ranks 0..3 and prefix sizes 2..3 (just as an example). 
    The Array format is #(count SetOfSelectors)."
   (0 to: 3) do: [:rank |
      | prefixDict |
      prefixDict := Dictionary new.
      (2 to: 3) do: [:pSize |
         prefixDict 
            at: pSize
            put: {
               rank + 1.  "Some made-up count"
               (Set with: 'selector_', rank asString, '_', pSize asString) 
            } ].
      completionBenchs at: rank put: prefixDict
   ].

   "Fake times: prefix=2 => 200 ms total over 2 completions, prefix=3 => 300 ms total over 3 completions."
   completionTimes := {
      2 -> #(200 2).
      3 -> #(300 3).
   } asDictionary.

   "Fake memory usage: prefix=2 => 1024 bytes over 2 completions, prefix=3 => 1536 bytes over 3 completions."
   memoryUsages := {
      2 -> #(1024 2).
      3 -> #(1536 3).
   } asDictionary.

   builder := nil.  "We won't actually build anything in the mock."
   scope := nil.
]

{ #category : 'running' }
MockCoStaticBenchmarks >> run [
   "Override run to just load our known data instead of scanning real code."
   self initializeMockData.
]

{ #category : 'running' }
MockCoStaticBenchmarks >> startMemoryMeasurement [
   "Pretend current memory usage is a fixed number."
   ^ 1000
]

{ #category : 'running' }
MockCoStaticBenchmarks >> startTimeMeasurement [
   "Return the real clock or a stub; for a test, real clock is OK. We'll just do real time here."
   ^ Time millisecondClockValue
]

{ #category : 'running' }
MockCoStaticBenchmarks >> trackCompletionResultsFor: receiver atIndex: completionIndex withPrefix: prefix [
   "No-op for the mock, or you can store something if you want to test changes in flight."
   ^ self
]
