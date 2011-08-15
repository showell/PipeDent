# <hr>
# Set up the overall structure using PipeDent itself.
demo_layout = \
  '''
  table
    tr valign="top"
      td id="leftPanel"
        p id="intro"
          | Welcome to the demo.  As you edit the code below, it
          | will convert automatically.
        ul id="canned_widgets" |        
        h2 id="leftPanel" | Input
        textarea id="input_code" rows=80 cols=80 |
      td id="rightPanel"
        h4 | Output HTML
        a href="#" id="outputToggle" | Hide
        pre id="output" |
        <hr>
        style type="text/css" id="rendered_style" | {}
        h4 | Rendered HTML
        div id="rendered" |
  '''

convert = this.pipedent_convert
num_user_changes = 0  

# <hr>
# Allow toggling of HTML output.
set_up_output_toggle = ->
  elem = $("#outputToggle")  
  visible = true
  elem.click ->
    if visible
      $("#output").hide()
      visible = false
      elem.text("Show")
    else
      $("#output").show()
      visible = true
      elem.text("Hide")

# <hr>
# Format the introductory text that says to start editing,
# and remove it when they have done a few edits.
format_intro = ->
  e = $("#intro")
  e.css("font-weight", "bold")
  e.css("font-size", "20px")
  e.css("background-color", "lightgreen")
  e.css("width", "450px")
  hide_if_user_changes = ->
    if num_user_changes > 5
      e.fadeOut(1000)
    else
      setTimeout(hide_if_user_changes, 2000)
  setTimeout(hide_if_user_changes, 2000)
  
# <hr>
# When new code is loaded, adjust the columns to fit the new text.
set_code = (code) ->
  max_line = 0
  for line in code.split("\n")
    len = line.length
    max_line = len if len > max_line
  # The cols attribute needs rescaling for some reason.
  $("#input_code").attr("cols", max_line * 0.9)
  $("#input_code").val code
  
# <hr>
# Any time code changes, update the world.
update_widgets = (input) ->
  output = convert_widget_package(input)
  $("#output").text(output.HTML)
  $("#rendered").html(output.HTML)
  $("#rendered_style").html(output.CSS)
  if output.COFFEE
    try
      js = CoffeeScript.compile output.COFFEE
    catch e
      console.log e
      console.log "(problem with compiling CS)"
    try
      eval js
    catch e
      console.log e
      console.log "problem in JS"

# <hr>      
# CannedWidgets are pre-built widgets that users can select to
# load up.
CannedWidgets = (collection) ->
  elem = $("#canned_widgets")
  values = (val for key, val of collection)
  set_click = (a, widget) ->
    a.click ->
      set_code widget.code
      # update_widgets widget.code
  for widget in values
    li = $("<li>")
    a = $ convert "a href='#' | #{widget.description}"
    li.html a
    set_click a, widget
    elem.append(li)
    
# <hr>
# Get everything up and running.       
$(document).ready ->
  $("#content").html(convert demo_layout)
  $("#leftPanel").css("padding", "10px")
  $("#rightPanel").css("padding", "10px")
  
  canned_widgets = CannedWidgets(widget_collection)
  demo_input = widget_collection.pipedent.code
  format_intro()
  set_up_output_toggle()
  
  $("#input_code").tabby {tabString: "  "};
  set_code demo_input
  last_parsed_text = demo_input
  update_widgets(demo_input)
  user_engaged = false
  
  # This is a crude mechanism to continually parse
  # the input.
  parse = ->
    input = $("#input_code").val()
    if input != last_parsed_text
      num_user_changes += 1
      update_widgets(input)
      last_parsed_text = input
    setTimeout parse, 200
  setTimeout parse, 200