"
I'm a subclass that handles the Message during the bench
"
Class {
	#name : 'CoStaticBenchmarksMessage',
	#superclass : 'CoStaticBenchmarks',
	#category : 'HeuristicCompletion-Benchmarks',
	#package : 'HeuristicCompletion-Benchmarks'
}

{ #category : 'benchmarks' }
CoStaticBenchmarksMessage >> benchCallsite: aMessageNode atPosition: aPosition [ 

    | originalSelector |
    originalSelector := aMessageNode selector.
    2 to: (aMessageNode selector size min: 8) do: [ :index | 
        | prefix
          startTime endTime executionTime
          startMemory endMemory memoryUsed
          completion candidates completionIndex 
          previousResultsPerIndexPerPrefixSize |

        "1) Start timing"
        startTime := Time millisecondClockValue.

        "2) Start memory usage (adjust to your dialect's API)"
        startMemory := self currentMemoryUsage.

        prefix := originalSelector copyFrom: 1 to: index.
        aMessageNode selector: prefix.

        completion := builder
            node: aMessageNode;
            completionContext: (CoBenchmarkContext new
                callsite: aMessageNode;
                position: aPosition;
                yourself);
            buildCompletion.

        completion replaceFilterWith: (CoCaseSensitiveBeginsWithFilter filterString: prefix).
        candidates := completion first: 10.

        completionIndex := (candidates collect: [ :each | each contents ]) indexOf: originalSelector.

        "Existing logic to track accuracy..."
        previousResultsPerIndexPerPrefixSize :=
            completionBenchs
                at: completionIndex
                at: prefix size
                ifAbsent: [ { 0 . Set new } ].
        previousResultsPerIndexPerPrefixSize second add: originalSelector.
        completionBenchs
            at: completionIndex
            at: prefix size
            put: { previousResultsPerIndexPerPrefixSize first + 1 .
                   previousResultsPerIndexPerPrefixSize second }.

        "3) Stop memory usage"
        endMemory := self currentMemoryUsage.  "Adjust to your dialect's API"
        memoryUsed := endMemory - startMemory.
        self logMemory: memoryUsed forPrefix: prefix size.

        "4) Stop timing and record it"
        endTime := Time millisecondClockValue.
        executionTime := endTime - startTime.
        self logTime: executionTime forPrefix: prefix size.
    ].
    aMessageNode selector: originalSelector
]

{ #category : 'running' }
CoStaticBenchmarksMessage >> run [

	scope methodsDo: [ :method |
		method parseTree nodesDo: [ :node |
			node isMessage ifTrue: [
				self benchCallsite: node atPosition: node keywordsIntervals first ]
		]
	]
]
