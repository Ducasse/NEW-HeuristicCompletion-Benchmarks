"
I'm class that handles the Varibales 



``` smalltalk
g1 := CoStaticBenchmarksVariables runAllOnPackage: 'NECompletion' heuristics: [ :b | CoStaticBenchmarksVariables defaultHeuristics: b ]. 
```

"
Class {
	#name : 'CoStaticBenchmarksVariables',
	#superclass : 'CoStaticBenchmarks',
	#category : 'HeuristicCompletion-Benchmarks',
	#package : 'HeuristicCompletion-Benchmarks'
}

{ #category : 'running' }
CoStaticBenchmarksVariables class >> customHeuristics: aBuilder [

	aBuilder variablesHeuristic: (aBuilder newHeuristicBuilder
			 add: CoLocalScopeVariablesHeuristic new;
			 add: CoWorkspaceVariablesHeuristic new;
			 add: CoInstanceAccessibleVariablesHeuristic new;
			 add: (CoGlobalVariablesHeuristic new globalVariableFetcherClass:
						  CoPackageScopedGlobalVariableFetcher);
			 build)
]

{ #category : 'running' }
CoStaticBenchmarksVariables class >> defaultHeuristics: aBuilder [

	aBuilder variablesHeuristic: (aBuilder newHeuristicBuilder
			 add: CoLocalScopeVariablesHeuristic new;
			 add: CoWorkspaceVariablesHeuristic new;
			 add: CoInstanceAccessibleVariablesHeuristic new;
			 add: CoGlobalVariablesHeuristic new;
			 build)
]

{ #category : 'benchmarks' }
CoStaticBenchmarksVariables >> benchCallsite: aMessageNode atPosition: aPosition [

	| receiver |
	receiver := aMessageNode receiver.

	2 to: (self maxPrefixSizeFor: receiver) do: [ :index |
		| prefix startTime startMemory completion candidates completionIndex |

		startTime := self startTimeMeasurement.
		startMemory := self startMemoryMeasurement.

		prefix := self extractPrefixFrom: receiver at: index.
		aMessageNode receiver: (OCVariableNode named: prefix).

		completion := self buildCompletionFor: aMessageNode atPosition: aPosition.

		candidates := self fetchTopCandidatesFrom: completion usingPrefix: prefix.
		completionIndex := self findCompletionIndexFor: receiver inCandidates: candidates.

		self trackCompletionResultsFor: receiver atIndex: completionIndex withPrefix: prefix.

		self logMemoryUsageSince: startMemory forPrefixSize: prefix size.
		self logExecutionTimeSince: startTime forPrefixSize: prefix size ].

	aMessageNode receiver: receiver.

]

{ #category : 'benchmarks' }
CoStaticBenchmarksVariables >> buildCompletionFor: aMessageNode atPosition: aPosition [
	^ builder
		node: aMessageNode receiver;
		completionContext: (CoBenchmarkContext new
			callsite: aMessageNode;
			position: aPosition;
			yourself);
		buildCompletion.
]

{ #category : 'benchmarks' }
CoStaticBenchmarksVariables >> extractPrefixFrom: receiver at: index [
	^ receiver name copyFrom: 1 to: index.
]

{ #category : 'benchmarks' }
CoStaticBenchmarksVariables >> fetchTopCandidatesFrom: completion usingPrefix: prefix [
	completion replaceFilterWith: (CoCaseSensitiveBeginsWithFilter filterString: prefix).
	^ completion first: 10.
]

{ #category : 'benchmarks' }
CoStaticBenchmarksVariables >> findCompletionIndexFor: receiver inCandidates: candidates [
	^ (candidates collect: [ :each | each contents ]) indexOf: receiver name.
]

{ #category : 'benchmarks' }
CoStaticBenchmarksVariables >> logExecutionTimeSince: startTime forPrefixSize: prefixSize [
	| executionTime |
	executionTime := Time millisecondClockValue - startTime.
	self logTime: executionTime forPrefix: prefixSize.
]

{ #category : 'benchmarks' }
CoStaticBenchmarksVariables >> logMemoryUsageSince: startMemory forPrefixSize: prefixSize [
	| memoryUsed |
	memoryUsed := self currentMemoryUsage - startMemory.
	self logMemory: memoryUsed forPrefix: prefixSize.
]

{ #category : 'benchmarks' }
CoStaticBenchmarksVariables >> maxPrefixSizeFor: receiver [
	^ receiver name size min: 8.

]

{ #category : 'running' }
CoStaticBenchmarksVariables >> run [

	scope methodsDo: [ :method |
		method parseTree nodesDo: [ :node |
			(node isMessage and: [ node receiver isVariable and: [ node receiver name first isUppercase ]])
				ifTrue: [ self benchCallsite: node atPosition: node keywordsIntervals first ] ] ]
]

{ #category : 'benchmarks' }
CoStaticBenchmarksVariables >> startMemoryMeasurement [
	^ self currentMemoryUsage.
]

{ #category : 'benchmarks' }
CoStaticBenchmarksVariables >> startTimeMeasurement [
	^ Time millisecondClockValue.
]

{ #category : 'benchmarks' }
CoStaticBenchmarksVariables >> trackCompletionResultsFor: receiver atIndex: completionIndex withPrefix: prefix [
	| previousResultsPerIndexPerPrefixSize |
	previousResultsPerIndexPerPrefixSize := completionBenchs
		at: completionIndex
		at: prefix size
		ifAbsent: [ { 0. Set new } ].
	previousResultsPerIndexPerPrefixSize second add: receiver.
	completionBenchs at: completionIndex at: prefix size put: {
		(previousResultsPerIndexPerPrefixSize first + 1).
		previousResultsPerIndexPerPrefixSize second }.
]
