eco = require "eco"
fs  = require "fs"
pipedent = require "../pipedent"

pipedent_template = fs.readFileSync("./docco_example.pipedent").toString()
eco_template = pipedent.convert(pipedent_template)
html = eco.render eco_template,
  title: 'foo.js'
  sources: ['bar.js', 'yo.js']
  destination: (s) -> "localhost:/#{s}"
  path: require 'path'
  sections: [
    docs_html: "yo"
    code_html: "bar"
  ]
console.log html