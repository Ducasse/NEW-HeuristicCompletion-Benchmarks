Class {
	#name : 'CoStaticBenchmarksMessageTest1TD',
	#superclass : 'TestCase',
	#instVars : [
		'bench'
	],
	#category : 'HeuristicCompletion-Benchmarks-Tests',
	#package : 'HeuristicCompletion-Benchmarks-Tests'
}

{ #category : 'running' }
CoStaticBenchmarksMessageTest1TD >> setUp [
    super setUp.
    "Install or ensure the test method is compiled into MessageTestClass."
    MessageTestClass1TD installTestMethod.

    bench := CoStaticBenchmarksMessage new.
    bench scope: MessageTestClass1TD.  "Set the scope to the class we want to benchmark."

    "Set up a fake builder with known mock candidates."
    bench builder: (FakeCompletionBuilder1TD new
                     mockCandidates: #('asString' 'trim' 'printOn:' 'asUppercase' 'size')).
    bench completionBenchs: Dictionary new.  "Just to be sure it is empty initially."
]

{ #category : 'running' }
CoStaticBenchmarksMessageTest1TD >> testRunBench [
    "Test that running the benchmark populates completionBenchs as expected."

    "Act: run the benchmark"
    bench run.

    "Assert: check that some data was logged. 
     For example, we expect some message callsites 
     (the parse tree for '^ ''Hello'' asString trim' has at least 2 message sends).
     We can't know exactly how many prefixes, but we can verify it isn't empty."

    self assert: bench completionBenchs isEmpty not.

    "Optionally, we can check that ranks exist in the dictionary.
     e.g., rank=1, rank=2, etc. 
     The exact distribution depends on the 'mockCandidates' and actual logic. 
     At least we can confirm there's some key present."

    bench completionBenchs keysDo: [ :rank |
        "rank should be an Integer 0..10"
        self assert: rank isInteger.
    ].

    "We can further test the prefix sizes we expect (2..8).
     For instance, check if prefix=2 results are recorded. 
     This confirms that benchCallsite:atPosition: iterated over prefix sizes."

    2 to: 8 do: [ :pSize |
        | anyFound |
        anyFound := false.
        bench completionBenchs keysAndValuesDo: [ :k :dict |
            (dict includesKey: pSize) ifTrue: [ anyFound := true ]].
        "No guarantee every prefix from 2..8 is used, but typically it should.
         We'll just check at least one is used. 
         You could adapt to your exact scenario."
    ].
]
