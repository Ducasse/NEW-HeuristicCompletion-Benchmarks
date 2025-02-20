"
I'm class that handles the Varibales 
"
Class {
	#name : 'CoStaticBenchmarksVaribales',
	#superclass : 'CoStaticBenchmarks',
	#category : 'HeuristicCompletion-Benchmarks',
	#package : 'HeuristicCompletion-Benchmarks'
}

{ #category : 'benchmarking' }
CoStaticBenchmarksVaribales >> benchCallsite: aMessageNode atPosition: aPosition [

	| receiver |
	receiver := aMessageNode receiver.

	2 to: (aMessageNode receiver name size min: 8) do: [ :index |
		| prefix startTime endTime executionTime completion candidates completionIndex previousResultsPerIndexPerPrefixSize |
		"Start timing"
		startTime := Time millisecondClockValue.

		prefix := receiver name copyFrom: 1 to: index.
		aMessageNode receiver: (OCVariableNode named: prefix).

	
		completion := builder
			              node: aMessageNode receiver;
			              completionContext: (CoBenchmarkContext new
					               callsite: aMessageNode;
					               position: aPosition;
					               yourself);
			              buildCompletion.

		completion replaceFilterWith:
			(CoCaseSensitiveBeginsWithFilter filterString: prefix).
		candidates := completion first: 10.

		completionIndex := (candidates collect: [ :each | each contents ])
			                   indexOf: receiver name.

		"Existing logic: update completionBenchs dictionary"
		previousResultsPerIndexPerPrefixSize := completionBenchs
			                                        at: completionIndex
			                                        at: prefix size
			                                        ifAbsent: [
				                                        {
					                                        0.
					                                        Set new } ].
		previousResultsPerIndexPerPrefixSize second add: receiver.
		completionBenchs at: completionIndex at: prefix size put: {
				(previousResultsPerIndexPerPrefixSize first + 1).
				previousResultsPerIndexPerPrefixSize second }.

		"Stop timing and record it"
		endTime := Time millisecondClockValue.
		executionTime := endTime - startTime.
		self logTime: executionTime forPrefix: prefix size ].

	"Restore the original selector"
	aMessageNode receiver: receiver
]

{ #category : 'running' }
CoStaticBenchmarksVaribales >> run [

	scope methodsDo: [ :method |
		method parseTree nodesDo: [ :node |
			(node isMessage and: [ node receiver isVariable and: [ node receiver name first isUppercase ]])
				ifTrue: [ self benchCallsite: node atPosition: node keywordsIntervals first ] ] ]
]
