demo_layout = \
  '''
  p id="intro"
    | Welcome to the demo.  As you edit the code on the left, it
    | will convert automatically.
  table
    tr valign="top"
      td
        h2 | Input
        textarea id="input" rows=80 cols=80
          PASS
      td
        h2 | Output HTML
        textarea id="output" rows=20 cols=80 |
        style type="text/css" id="rendered_style" | {}
        h4 | Rendered HTML
        div id="rendered" |
  '''

my_html_input = widget_collection.basic_tables.code

demo_input = my_html_input
convert = this.pipedent_convert
  
format_intro = ->
  e = $("#intro")
  e.css("font-weight", "bold")
  e.css("font-size", "30px")
  e.css("background-color", "lightgreen")
  
update_widgets = (input) ->
  output = convert_widget_package(input)
  $("#output").text(output.HTML)
  $("#rendered").html(output.HTML)
  $("#rendered_style").html(output.CSS)
        
$(document).ready ->
  $("#intro").css("font-weight", "bold")
  
  $("#content").html(convert demo_layout)
  
  format_intro()
  
  $("#input").tabby {tabString: "  "};
  $("#input").text(demo_input)
  last_parsed_text = demo_input
  update_widgets(demo_input)
  # This is a crude mechanism to continually parse
  # the input.
  parse = ->
    input = $("#input").val()
    if input != last_parsed_text
      update_widgets(input)
      last_parsed_text = input
    setTimeout parse, 200
  setTimeout parse, 200