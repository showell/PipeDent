demo_layout = \
  '''
  p
    | Welcome to the demo.  As you edit the code on the left, it
    | will convert automatically.
  table
    tr valign="top"
      td
        h1 | Input
        textarea id="input" rows=80 cols=80
          PASS
      td
        h1 | Output HTML
        textarea id="output" rows=20 cols=80 |
        style type="text/css" id="rendered_style" | {}
        h4 | Rendered HTML
        div id="rendered" |
  '''

my_html_input = \
  '''
  HTML
    <hr>
    h6 | Simple tables
    table border=1
      tr
        td class="red"
          NW
        td
          NE
      tr
        td
          SW
        td style="background: lightblue"
          SE
  CSS
    .red {
      background: red
    }
  '''

demo_input = my_html_input
convert = this.pipedent_convert
  
update_widgets = (input) ->
  output = convert_widget_package(input)
  $("#output").text(output.HTML)
  $("#rendered").html(output.HTML)
  $("#rendered_style").html(output.CSS)
        
$(document).ready ->
  $("#content").html(convert demo_layout)
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