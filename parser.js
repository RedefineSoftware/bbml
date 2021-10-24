const bbml = require('./breadboarder');
const fs = require('fs');

const file = fs.readFileSync('./test.bbml', 'utf-8');

function parseBbml(input) {
  try {
    return bbml.parse(input);
  } catch (e) {
    throw e.name === "SyntaxError" ? new SyntaxError(e) : e;
  }
}

console.log(JSON.stringify(parseBbml(file), null, 2));

