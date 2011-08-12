pipedent = require "../pipedent"
fs = require 'fs'
convert = pipedent.convert
convert_widget_package = pipedent.convert_widget_package
 
assert_equal = (expected, actual, msg) ->
  if expected.trim() != actual.trim()
    console.warn msg
    console.warn '====='
    console.warn "EXPECTED"
    console.warn expected
    console.warn 'ACTUAL'
    console.warn actual
    for line, i in expected.split("\n")
      actual_line = actual.split("\n")[i]
      if line != actual_line
        console.log "****", line
        console.log "----", actual_line
        console.log ""
    throw "fail"

indent = (s, indent) ->
  lines = s.split("\n")
  lines = lines.map (line) ->
    if line == '' then line else indent + line
  lines.join("\n")

run_test = (test) ->
  expected = test.output + "\n"
  actual = convert(test.input)
  msg = "test: #{test.use_case}"
  assert_equal expected, actual, msg

run_package_test = (test) ->
  expected = indent(test.output, '  ')
  actual = convert_widget_package(test.input)[test.key]
  if !actual?
    console.log test.input
    console.log convert_widget_package(test.input)
    throw "fail"    
  msg = "test: #{test.use_case}"
  assert_equal expected, actual, msg
  
run_package_test
  use_case: "Basic HTML"
  input: \
    '''
    HTML
      p | hello
      b | world
    '''
  key: \
    'HTML'
  output: \
    '''
    <p>hello</p>
    <b>world</b>
    '''

run_package_test
  use_case: "Basic CSS"
  input: \
    '''
    HTML
      whatever
    CSS
      #square {
        background: red
      }
    '''
  key: \
    'CSS'
  output: \
    '''
    #square {
      background: red
    }
    '''

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

    yo |
    '''
  output: \
    '''
    <foo>
      bar
      bar
      <b>html passes thru</b>
    </foo>

    <yo></yo>
    '''

run_test
  use_case: "Deep Indent"
  input: \
    '''
    foo
      bar
        baz
          yo
          
      bar2
        baz
      
      bar3
        baz
          yo
    '''
  output: \
    '''
    <foo>
      <bar>
        <baz>
          yo
        </baz>
      </bar>

      <bar2>
        baz
      </bar2>

      <bar3>
        <baz>
          yo
        </baz>
      </bar3>
    </foo>
    '''

run_test
  use_case: "Trailing Pipe"
  input: '''
    div id="yo" |
    '''
  output: '''
    <div id="yo"></div>
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