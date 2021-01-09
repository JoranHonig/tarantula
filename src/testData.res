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

type testResult = {
    test: testIdentifier,
    result: option<string>,
}

type testData = {
    testResults: Js_dict.t<testResult>,
    coverage: array<sourceFile>,
}

exception NotFound(string)
let unwrap = (anOption, message) => switch anOption {
    | Some(e) => e;
    | None => raise(NotFound(message))
}

let fromMocha = (mochaTestResult) => {
    let toTestResult = (testCase, result) => {
            {
                test : {
                    title:  Js_dict.get(testCase, "title") -> unwrap("Can't find title in test object"),
                    fullTitle: Js_dict.get(testCase, "fullTitle") -> unwrap("Can't find fullTitle in test object"),
                    file: Js_dict.get(testCase, "file") -> unwrap("Can't find file in test object"),
                },
                result: result
            }
    } 
    try {
        let passed = Js_dict.get(mochaTestResult, "passed")
        -> unwrap("Can't find passed test cases in mocha result")
        -> Belt.Array.map(testCase => toTestResult(testCase, Some("Success")))
        let failed = Js_dict.get(mochaTestResult, "failed") 
        -> unwrap("Can't find failed test cases in mocha result")
        -> Belt.Array.map(testCase => toTestResult(testCase, Some("Failure")))        
        let parsedTestResult = Array.concat(list{passed, failed})
        -> Belt.Array.map(testResult => (testResult.test.fullTitle, testResult))
        -> Js_dict.fromArray
        Some(parsedTestResult)
    } catch {
        | NotFound(_) => None
    }
}

let fromSolCover = (coverageResult) => {
    try {
        let cov = Js_dict.keys(coverageResult)
        -> Belt.Array.map(fileName => {
            let solCoverLines = Js_dict.get(coverageResult, fileName) 
                -> unwrap("Can't Happen")
            let sourceLines = Js_dict.keys(solCoverLines)
                -> Belt.Array.map(sourceLine => {
                    let identifiers = Js_dict.get(solCoverLines, sourceLine) 
                    -> unwrap("Can't Happen")
                    -> Belt.Array.map(solCoverIdentifier => {
                        title:  Js_dict.get(solCoverIdentifier, "title") -> unwrap("Can't find title in test object"),
                        fullTitle: Js_dict.get(solCoverIdentifier, "fullTitle") -> unwrap("Can't find fullTitle in test object"),
                        file: Js_dict.get(solCoverIdentifier, "file") -> unwrap("Can't find file in test object"),
                    })
                    {
                        lineNumber: Belt.Int.fromString(sourceLine) -> unwrap("Error parsing line number"),
                        tests: identifiers
                    }
                })          
            {
                fileName: fileName,
                lines: sourceLines
            }
        })
        Some(cov)
    } catch {
        | NotFound(_) => None
    }
}