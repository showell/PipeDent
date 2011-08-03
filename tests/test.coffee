pipedent = require "../pipedent"
fs = require 'fs'
convert = pipedent.convert

assert_equal = (expected, actual, msg) ->
  if expected != actual
    console.warn msg
    console.warn '====='
    console.warn "EXPECTED"
    console.warn expected
    console.warn 'ACTUAL'
    console.warn actual
    throw "fail"

run_test = (test) ->
  expected = test.output + "\n"
  actual = convert(test.input)
  msg = "test: #{test.use_case}"
  assert_equal expected, actual, msg

run_test 
  use_case: "Let HTML pass through"
  input: \
    '''
    <div>
      <h2>foo</h2>
    </div>
    '''
  output: \
    '''
    <div>
      <h2>foo</h2>
    </div>
    '''
  

run_test
  use_case: "Basic Indent"
  input: \
    '''
    foo
      bar
      | bar
      <b>html passes thru</b>

    yo
      PASS
    '''
  output: \
    '''
    <foo>
      bar
      bar
      <b>html passes thru</b>
    </foo>

    <yo>
    </yo>
    '''

run_test
  use_case: "Pipes"
  input: \
    '''
    h1 | apple
    h2 | banana
    | carrot
    '''
  output: \
    '''
    <h1>apple</h1>
    <h2>banana</h2>
    carrot
    '''

run_test
  use_case: "Sit nicely on top of microtemplates"
  input: fs.readFileSync('./docco_example.pipedent').toString()
  output: fs.readFileSync('./docco_example.eco').toString()