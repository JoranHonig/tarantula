var assert = require('assert')
const { stringify } = require('querystring')
var t = require('../src/index.bs.js')

const exampleTestResult = require('./mocha.json');                                                                                                                                                                                                                                    
const exampleCoverage = require('./cover.json');    
   
describe('Tarantula', function() {
    describe('tarantulaScore()', function() {
        it('should score this input correctly', function() {
            var testData = {
                testResults: t.fromMocha(exampleTestResult),
                coverage: t.fromSolCover(exampleCoverage)
            }
            // console.log(testData.toArray())

            // Act
            score = t.tarantulaScore(testData)

            // Assert
            for (var filename in score) {
                console.log(score[filename])
            }
        })
    })
})