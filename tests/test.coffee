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
  output: \
      '''
      <!DOCTYPE html>

      <html>
        <head>
          <title><%= title %></title>
          <meta http-equiv="content-type" content="text/html; charset=UTF-8">
          <link rel="stylesheet" media="all" href="docco.css" />
        </head>
        <body>
          <div id="container">
            <div id="background"></div>
            <% if sources.length > 1: %>
              <div id="jump_to">
                Jump To &hellip;
                <div id="jump_wrapper">
                  <div id="jump_page">
                    <% for source in sources: %>
                      <a class="source" href="<%= path.basename(destination(source)) %>">
                        <%= path.basename(source) %>
                      </a>
                    <% end %>
                  </div>
                </div>
              </div>
            <% end %>
            <table cellpadding="0" cellspacing="0">
              <thead>
                <tr>
                  <th class="docs">
                    <h1>
                      <%= title %>
                    </h1>
                  </th>
                  <th class="code">
                  </th>
                </tr>
              </thead>
              <tbody>
                <% for section in sections: %>
                  <tr id="section-<%= i + 1 %>">
                    <td class="docs">
                      <div class="pilwrap">
                        <a class="pilcrow" href="#section-<%= i + 1 %>">&#182;</a>
                      </div>
                      <%= section.docs_html %>
                    </td>
                    <td class="code">
                      <%= section.code_html %>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        </body>
      </html>
      '''


