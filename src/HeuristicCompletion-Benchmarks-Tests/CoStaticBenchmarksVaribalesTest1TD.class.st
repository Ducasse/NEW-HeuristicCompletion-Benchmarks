Class {
	#name : 'CoStaticBenchmarksVaribalesTest1TD',
	#superclass : 'TestCase',
	#instVars : [
		'bench'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests',
	#package : 'HeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'running' }
CoStaticBenchmarksVaribalesTest1TD >> setUp [
    super setUp.
    "Install or ensure the test method for VariableTestClass is compiled."
    VariableTestClass1TD installTestMethod.

    bench := CoStaticBenchmarksVariables new.
    bench scope: VariableTestClass1TD.

    "We can give it a fake builder with mock candidates for uppercase variables."
    bench builder: (FakeCompletionBuilder1TD new
                     mockCandidates: #('UpperCaseVar' 'UpperXyz' 'UnderCaseVar' 'foo')).
    bench completionBenchs: Dictionary new.
]

{ #category : 'running' }
CoStaticBenchmarksVaribalesTest1TD >> testRunBench [
    "Check that running the var-based benchmark logs results 
     when it sees an uppercase variable reference in testVariable method."

    bench run.

    self assert: bench completionBenchs isEmpty not.

    "Optionally, check that at least rank=1 or rank=2 has some counts.
     Because if the real variable is 'UpperCaseVar', 
     the code tries prefixes of length 2..8 for 'Up', 'Upp', 'Uppe', etc."

    (1 to: 10) do: [ :rank |
        (bench completionBenchs includesKey: rank) 
            ifTrue: [
                | prefixDict |
                prefixDict := bench completionBenchs at: rank.
                "prefixDict should map from prefixSize -> #(count setOfSelectors)"
                prefixDict keysDo: [ :pSize |
                    | entry |
                    entry := prefixDict at: pSize.
                    "Assert entry is { numberOfHits. setOfSelectors }"
                    self assert: entry size = 2.
                ]
            ] 
    ].
]
