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
        textarea id="output" rows=20 cols=80
          PASS
        h1 | Rendered HTML
        div id="rendered"
          PASS
  '''

my_html_input = \
  '''
  table border=1
    tr
      td | "NW"
      td | "NE"
    tr
      td | "SW"
      td | "SE"
  '''

demo_input = my_html_input
convert = this.pipedent_convert
  
$(document).ready ->
  $("#content").html(convert demo_layout)
  demo_output = convert(demo_input)  
  $("#input").tabby {tabString: "  "};
  $("#input").text(demo_input)
  $("#output").text(demo_output)
  $("#rendered").html(demo_output)
  last_parsed_text = demo_input
  # This is a crude mechanism to continually parse
  # the input.
  parse = ->
    input = $("#input").val()
    if input != last_parsed_text
      output = convert(input)
      $("#output").text(output)
      $("#rendered").html(output)
      last_parsed_text = input
    setTimeout parse, 200
  setTimeout parse, 200