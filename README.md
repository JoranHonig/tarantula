# 👾 Tarantula 
![Run Test 🔬](https://github.com/JoranHonig/tarantula/workflows/Run%20Test%20%F0%9F%94%AC/badge.svg)
Implementation of the tarantula fault localisation algorithm in rescript.


## ⬇ Installation

```sh
npm install
```

## Example usage
```javascript
var tarantula = require('tarantula')

var testData = {
    testResults: tarantula.TestData.fromMocha(exampleTestResult),
    coverage: tarantula.TestData.fromSolCover(exampleCoverage)
}

score = tarantula.Tarantula.tarantulaScore(testData)
```

## 🤖 Developers

- Build: `npm run build`
- Clean: `npm run clean`
- Build & watch: `npm run start`
- Test: `npm test`

## 📚 Learn More:
- [Empirical Evaluation of the Tarantula Automatic Fault-Localization Technique - James A. Jones and Mary Jean Harrold](http://spideruci.org/papers/jones05.pdf)
