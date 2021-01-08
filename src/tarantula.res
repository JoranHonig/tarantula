@bs.send external filter: (array<'a>, 'a => bool) => array<'a> = "filter"
@bs.send external map: (array<'a>, 'a => 'b) => array<'b> = "map"

// Input Type definitions

type testIdentifier = {
    title: string,
    fullTitle: string,
    file: string
}

type sourceLine = {
    lineNumber: int,
    tests: array<testIdentifier>,
}

type sourceFile = {
    fileName: string,
    lines: array<sourceLine>,
}

type individualTestResult = {
    test: testIdentifier,
    result: option<string>,
}

type testData = {
    tests: Js_dict.t<individualTestResult>,
    coverage: array<sourceFile>,
}


// == Helpers == 
let passed = (statement: sourceLine, results: testData) =>  {
    let sucesses = statement.tests 
        -> map(t => 
            switch Js.Dict.get(results.tests, t.fullTitle) {
                | Some({result: Some("Success")}) => 1
                | _ => 0
            }
        )
    Belt.Array.reduce(sucesses, 0, (a,b) => a + b)
}

let failed = (statement: sourceLine, results: testData) =>  {
    let failures = statement.tests
        -> map(t => 
            switch Js.Dict.get(results.tests, t.fullTitle) {
                | Some({result: Some("Failure")}) => 1
                | _ => 0
            }
        )
    Belt.Array.reduce(failures, 0, (a,b) => a + b)
}

let totalPassed = (results: testData) => 
    Js.Dict.values(results.tests) 
    -> filter(test => test.result == Some("Success"))
    -> Array.length


let totalFailed = (results: testData) =>
    Js.Dict.values(results.tests)
    -> filter(test => test.result == Some("Failure"))
    -> Array.length


// == tarantula computation ==
type tarantulaLine = {
    lineNumber: int,
    hue: float
}

type tarantulaFile =  {
    fileName: string,
    lines: array<tarantulaLine>
}

type tarantulaResult = array<tarantulaFile>;

let hue = (line: sourceLine, results: testData, tPassed, tFailed) => {
    let lPassed = float(passed(line, results))
    let lFailed = float(failed(line, results))
    let tPassed = float(tPassed)
    let tFailed = float(tFailed)
    (lPassed /. tPassed) /. ((lPassed/.tPassed)+.(lFailed/.tFailed))
}

let tarantulaForFile = (file: sourceFile, results: testData, tPassed, tFailed) => {
    let tarantula_lines: array<tarantulaLine> = 
        file.lines 
        -> map(line => {
            lineNumber: line.lineNumber,
            hue: hue(line, results, tPassed, tFailed)
            }
        )
    {fileName: file.fileName, lines: tarantula_lines}
}

// Returns an array of tarantula results for the coverage
let tarantulaScore = (results) => {
    let tPassed = totalPassed(results)
    let tFailed = totalFailed(results)
    results.coverage
    -> map(file => tarantulaForFile(file, results, tPassed, tFailed))
}