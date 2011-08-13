demo_layout = \
  '''

  table
    tr valign="top"
      td
        p id="intro"
          | Welcome to the demo.  As you edit the code below, it
          | will convert automatically.        
        h2 | Input
        textarea id="input_code" rows=80 cols=80 |
      td
        h2 | Output HTML
        pre id="output" |
        style type="text/css" id="rendered_style" | {}
        h4 | Rendered HTML
        div id="rendered" |
  '''

my_html_input = widget_collection.keyboard_cat.code

demo_input = my_html_input
convert = this.pipedent_convert
  
num_user_changes = 0  
  
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
  
update_widgets = (input) ->
  output = convert_widget_package(input)
  $("#output").text(output.HTML)
  $("#rendered").html(output.HTML)
  $("#rendered_style").html(output.CSS)
        
$(document).ready ->
  $("#intro").css("font-weight", "bold")
  
  $("#content").html(convert demo_layout)
  
  format_intro()
  
  $("#input_code").tabby {tabString: "  "};
  $("#input_code").text(demo_input)
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