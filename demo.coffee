my_html_input = \
  '''
  p
    | Welcome the demo.  As you edit the code on the left, it
    | will convert automatically.
  table
    tr
      td
        h1 | Input
        textarea id="input" rows=80 cols=80
          PASS
      td
        h1 | Output HTML
        textarea id="output" rows=80 cols=80
          PASS
  '''

demo_input = my_html_input
convert = this.pipedent_convert
  
$(document).ready ->
  demo_output = convert(demo_input)  
  $("#content").html(convert my_html_input)
  console.log(demo_output)
  $("#input").text(demo_input)
  $("#output").text(demo_output)
  # This is a crude mechanism to continually parse
  # the input.
  parse = ->
    input = $("#input").val()
    output = convert(input)
    $("#output").text(output)
    setTimeout parse, 200
  setTimeout parse, 200