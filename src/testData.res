type testIdentifier = {
    title: string,
    fullTitle: string,
    file: option<string>
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


module TestCmp = Belt.Id.MakeComparable({
    let matchFromEnd = (a, b) => switch (a, b) {
            | (Some(one), Some(other)) => Js.String.endsWith(one, other) || Js.String.endsWith(other, one)
            | (None, None) => true
            | _ => false
        }


  type t = testIdentifier
  let cmp = (a, b) => switch (Pervasives.compare(a.title, b.title), matchFromEnd(a.file, b.file)) {
          | (0, true) => 0
          | _ => 1
      }
})

type testData = {
    testResults: Belt.Map.t<testIdentifier, testResult, TestCmp.identity>,
    coverage: array<sourceFile>,
}

exception ParsingError(string)

let unwrap = (anOption, message) => switch anOption {
    | Some(e) => e;
    | None => raise(ParsingError(message))
}

let fromMocha = (mochaTestResult) => {
    let toTestResult = (testCase, result) => {
            {
                test : {
                    title:  Js_dict.get(testCase, "title") -> unwrap("Can't find title in test object"),
                    fullTitle: Js_dict.get(testCase, "fullTitle") -> unwrap("Can't find fullTitle in test object"),
                    file: Js_dict.get(testCase, "file"),
                },
                result: result
            }
    } 
    try {
        let passed = Js_dict.get(mochaTestResult, "passes")
        -> unwrap("Can't find passed test cases in mocha result")
        -> Belt.Array.map(testCase => toTestResult(testCase, Some("Success")))

        let failed = Js_dict.get(mochaTestResult, "failures") 
        -> unwrap("Can't find failed test cases in mocha result")
        -> Belt.Array.map(testCase => toTestResult(testCase, Some("Failure"))) 

        let parsedTestResult = Array.concat(list{passed, failed})
        -> Belt.Array.map(testResult => (testResult.test, testResult))
        -> Belt.Map.fromArray(~id=module(TestCmp))

        Some(parsedTestResult)
    } catch {
        | ParsingError(message) => Js.Exn.raiseError(message)
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
                        file: Js_dict.get(solCoverIdentifier, "file"),
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
        | ParsingError(message) => Js.Exn.raiseError(message)
    }
}