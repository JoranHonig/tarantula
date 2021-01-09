var assert = require('assert')
const { stringify } = require('querystring')
var tarantula = require('../src/tarantula.bs.js')
var td = require('../src/TestData.bs.js')

var exampleCoverage = {
    "contracts/MetaCoin.sol": {
     "17": [
      {
       "title": "should put 10000 MetaCoin in the first account",
       "fullTitle": "Contract: MetaCoin should put 10000 MetaCoin in the first account",
       "file": "test/metacoin.js"
      }
     ],
     "21": [
      {
       "title": "should send coin correctly",
       "fullTitle": "Contract: MetaCoin should send coin correctly",
       "file": "test/metacoin.js"
      }
     ],
     "22": [
      {
       "title": "should send coin correctly",
       "fullTitle": "Contract: MetaCoin should send coin correctly",
       "file": "test/metacoin.js"
      }
     ],
     "23": [
      {
       "title": "should send coin correctly",
       "fullTitle": "Contract: MetaCoin should send coin correctly",
       "file": "test/metacoin.js"
      }
     ],
     "24": [
      {
       "title": "should send coin correctly",
       "fullTitle": "Contract: MetaCoin should send coin correctly",
       "file": "test/metacoin.js"
      }
     ],
     "25": [
      {
       "title": "should send coin correctly",
       "fullTitle": "Contract: MetaCoin should send coin correctly",
       "file": "test/metacoin.js"
      }
     ],
     "29": [
      {
       "title": "should call a function that depends on a linked library",
       "fullTitle": "Contract: MetaCoin should call a function that depends on a linked library",
       "file": "test/metacoin.js"
      }
     ],
     "33": [
      {
       "title": "should put 10000 MetaCoin in the first account",
       "fullTitle": "Contract: MetaCoin should put 10000 MetaCoin in the first account",
       "file": "test/metacoin.js"
      },
      {
       "title": "should call a function that depends on a linked library",
       "fullTitle": "Contract: MetaCoin should call a function that depends on a linked library",
       "file": "test/metacoin.js"
      },
      {
       "title": "should send coin correctly",
       "fullTitle": "Contract: MetaCoin should send coin correctly",
       "file": "test/metacoin.js"
      }
     ]
    },
    "contracts/ConvertLib.sol": {
     "7": [
      {
       "title": "should call a function that depends on a linked library",
       "fullTitle": "Contract: MetaCoin should call a function that depends on a linked library",
       "file": "test/metacoin.js"
      }
     ]
    }
   }

var exampleTestResult = {
    "stats": {
      "suites": 2,
      "tests": 5,
      "passes": 5,
      "pending": 0,
      "failures": 0,
      "start": "2021-01-09T13:09:27.023Z",
      "end": "2021-01-09T13:09:32.066Z",
      "duration": 5043
    },
    "tests": [
      {
        "title": "testInitialBalanceUsingDeployedContract",
        "fullTitle": "TestMetaCoin testInitialBalanceUsingDeployedContract",
        "duration": 72,
        "currentRetry": 0,
        "err": {}
      },
      {
        "title": "testInitialBalanceWithNewMetaCoin",
        "fullTitle": "TestMetaCoin testInitialBalanceWithNewMetaCoin",
        "duration": 62,
        "currentRetry": 0,
        "err": {}
      },
      {
        "title": "should put 10000 MetaCoin in the first account",
        "fullTitle": "Contract: MetaCoin should put 10000 MetaCoin in the first account",
        "file": "/Users/walker/Development/metacoin/test/metacoin.js",
        "duration": 59,
        "currentRetry": 0,
        "err": {}
      },
      {
        "title": "should call a function that depends on a linked library",
        "fullTitle": "Contract: MetaCoin should call a function that depends on a linked library",
        "file": "/Users/walker/Development/metacoin/test/metacoin.js",
        "duration": 81,
        "currentRetry": 0,
        "err": {}
      },
      {
        "title": "should send coin correctly",
        "fullTitle": "Contract: MetaCoin should send coin correctly",
        "file": "/Users/walker/Development/metacoin/test/metacoin.js",
        "duration": 148,
        "currentRetry": 0,
        "err": {}
      }
    ],
    "pending": [],
    "failures": [
        {
            "title": "should send coin correctly",
            "fullTitle": "Contract: MetaCoin should send coin correctly",
            "file": "/Users/walker/Development/metacoin/test/metacoin.js",
            "duration": 148,
            "currentRetry": 0,
            "err": {}
          }
    ],
    "passes": [
      {
        "title": "testInitialBalanceUsingDeployedContract",
        "fullTitle": "TestMetaCoin testInitialBalanceUsingDeployedContract",
        "duration": 72,
        "currentRetry": 0,
        "err": {}
      },
      {
        "title": "testInitialBalanceWithNewMetaCoin",
        "fullTitle": "TestMetaCoin testInitialBalanceWithNewMetaCoin",
        "duration": 62,
        "currentRetry": 0,
        "err": {}
      },
      {
        "title": "should put 10000 MetaCoin in the first account",
        "fullTitle": "Contract: MetaCoin should put 10000 MetaCoin in the first account",
        "file": "/Users/walker/Development/metacoin/test/metacoin.js",
        "duration": 59,
        "currentRetry": 0,
        "err": {}
      },
      {
        "title": "should call a function that depends on a linked library",
        "fullTitle": "Contract: MetaCoin should call a function that depends on a linked library",
        "file": "/Users/walker/Development/metacoin/test/metacoin.js",
        "duration": 81,
        "currentRetry": 0,
        "err": {}
      },

    ]
  }
   
describe('Tarantula', function() {
    describe('tarantulaScore()', function() {
        it('should score this input correctly', function() {
            var testData = {
                testResults: td.fromMocha(exampleTestResult),
                coverage: td.fromSolCover(exampleCoverage)
            }
            // console.log(testData)

            // Act
            score = tarantula.Tarantula.tarantulaScore(testData)

            // Assert
            for (var filename in score) {
                console.log(score[filename])
            }
        })
    })
})