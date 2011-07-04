pipedent = require("./pipedent")
fs = require("fs")
fn = process.argv[2]
fs.readFile fn, (err, data) ->
  throw err if err
  console.log pipedent.convert "#{data}"
  