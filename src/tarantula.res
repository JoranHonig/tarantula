@bs.send external filter: (array<'a>, 'a => bool) => array<'a> = "filter"
@bs.send external map: (array<'a>, 'a => 'b) => array<'b> = "map"

// Input Type definitions
module Test = {
    include TestData

    let passed = (statement: sourceLine, results: testData): int =>  {
        let sucesses = statement.tests 
            -> map(t => 
                switch Js.Dict.get(results.testResults, t.fullTitle) {
                    | Some({result: Some("Success")}) => 1
                    | _ => 0
                }
            )
        Belt.Array.reduce(sucesses, 0, (a,b) => a + b)
    }

    let failed = (statement: sourceLine, results: testData): int =>  {
        let failures = statement.tests
            -> map(t => 
                switch Js.Dict.get(results.testResults, t.fullTitle) {
                    | Some({result: Some("Failure")}) => 1
                    | _ => 0
                }
            )
        Belt.Array.reduce(failures, 0, (a,b) => a + b)
    }

    let totalPassed = (results: testData) => 
        Js.Dict.values(results.testResults) 
        -> filter(test => test.result == Some("Success"))
        -> Array.length


    let totalFailed = (results: testData) =>
        Js.Dict.values(results.testResults)
        -> filter(test => test.result == Some("Failure"))
        -> Array.length

}

include TestData

// == tarantula computation ==
type tarantulaLine = {
    lineNumber: int,
    hue: float,
    suspiciousness: float,
}

type tarantulaFile =  {
    fileName: string,
    lines: array<tarantulaLine>
}

let hue = (line: sourceLine, results: testData, tPassed, tFailed) => {
    let lPassed = float(Test.passed(line, results))
    let lFailed = float(Test.failed(line, results))
    let tPassed = float(tPassed)
    let tFailed = float(tFailed)
    let passedRatio = tPassed != 0.0 ? (lPassed /. tPassed) : 0.0
    let failedRatio = tFailed != 0.0 ? (lFailed /. tFailed) : 0.0
    let sumRatio =  passedRatio +. failedRatio
    sumRatio != 0.0 ?  passedRatio /. sumRatio : 0.0
}

let tarantulaForFile = (file: sourceFile, results: testData, tPassed, tFailed) => {
    let tarantula_lines: array<tarantulaLine> = 
        file.lines 
        -> map(line => {
                let lineHue = hue(line, results, tPassed, tFailed)
                {
                lineNumber: line.lineNumber,
                hue: lineHue,
                suspiciousness: 1.0 -. lineHue,
                }
            }
        )
    {fileName: file.fileName, lines: tarantula_lines}
}

// Returns an array of tarantula results for the coverage
let tarantulaScore = (results) => {
    let tPassed = Test.totalPassed(results)
    let tFailed = Test.totalFailed(results)
    results.coverage
    -> map(file => tarantulaForFile(file, results, tPassed, tFailed))
}

let rec flattenLines = (tFiles: option<list<tarantulaFile>>) =>
    switch tFiles {
        | None => list{}
        | Some(list{}) => list{}
        | Some(files) => {
            // Edge case is covered above
            let Some(file) = Belt.List.head(files)
            let tail = Belt.List.tail(files)
            Belt.List.concat(
                file.lines
                -> map(line => (file.fileName, line))
                -> Belt.List.fromArray,
                flattenLines(tail)
            )
        }
    }


let rankSuspects = (tFiles: array<tarantulaFile>) => {
    let cmp = (a, b) => if a == b { 0 } else if a > b { 1 } else { -1 }
    let allLines = flattenLines(Some(Belt.List.fromArray(tFiles))) 
    Belt.List.sort(
        allLines, 
        ((_, line_a), (_, line_b)) => cmp(line_b.suspiciousness, line_a.suspiciousness))
}
