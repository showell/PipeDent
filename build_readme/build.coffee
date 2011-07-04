jsdom  = require("jsdom")
pipedent = require("../pipedent")

html_escape = (s) ->
  s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')

stream = ($, append) ->
  full_example = "https://github.com/showell/PipeDent/blob/master/build_readme/build.coffee"
  example = \
    """
    h1 | Overview
    div id="overview"
      p
        | PipeDent is a tool for creating HTML with small snippets
        | of text that provide the semantics of HTML without the
        | syntax.  It is implemented in Coffeescript.
      p
        | You can run it from the browser or run it from node.js.
    h1 | Syntax
    ul
      li
        | Use indentation for HTML blocks.  (Use PASS for empty blocks.)
      li
        | Use pipes to separate markup from content.  Content goes to
        | the right of pipes.
    h1 | Installation
    p
      | The best way to get started with PipeDent is to run the
      | demo with two simple commands
    pre
      | git clone git@github.com:showell/PipeDent.git
      | cd PipeDent && open demo.htm 
    p | For usage in the browser, follow the model of example.htm.
    p | For usage on the server, follow the model of example.coffee.
    p | To convert files from the command line, see convert.js.
    p
      | Once you are ready to create your own programs, install
      | pipedent.js on your web server or in a place where your
      | node.js programs can find it.
    h1 | Examples    
    p
      See the Installation instructions for how to run the demo program.
    p
      | You can see a full example here:
    p
      a href="#{full_example}" | Full Example
    p
      | Here is an example PipeDent translation:
    div
      h2 | INPUT
      pre id="input"
        PASS
    div
      h2 | HTML OUTPUT
      pre id="output"
        PASS
    """
  append pipedent.convert example
  $("pre#input").text(example)
  $("pre#output").text html_escape pipedent.convert(example)

window = jsdom.jsdom().createWindow()
  
jsdom.jQueryify window, 'http://code.jquery.com/jquery-1.4.2.min.js', ->
  window.$('body').append('<div class="CONTENT"></div>')
  stream window.$, (html) ->
    window.$('.CONTENT').append html
  console.log(window.$('.CONTENT').html())