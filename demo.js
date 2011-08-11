(function() {
  var convert, demo_input, demo_layout, my_html_input;
  demo_layout = 'p\n  | Welcome to the demo.  As you edit the code on the left, it\n  | will convert automatically.\ntable\n  tr valign="top"\n    td\n      h1 | Input\n      textarea id="input" rows=80 cols=80\n        PASS\n    td\n      h1 | Output HTML\n      textarea id="output" rows=20 cols=80\n        PASS\n      h1 | Rendered HTML\n      div id="rendered"\n        PASS';
  my_html_input = 'table border=1\n  tr\n    td | "NW"\n    td | "NE"\n  tr\n    td | "SW"\n    td | "SE"';
  demo_input = my_html_input;
  convert = this.pipedent_convert;
  $(document).ready(function() {
    var demo_output, last_parsed_text, parse;
    $("#content").html(convert(demo_layout));
    demo_output = convert(demo_input);
    $("#input").tabby({
      tabString: "  "
    });
    $("#input").text(demo_input);
    $("#output").text(demo_output);
    $("#rendered").html(demo_output);
    last_parsed_text = demo_input;
    parse = function() {
      var input, output;
      input = $("#input").val();
      if (input !== last_parsed_text) {
        output = convert(input);
        $("#output").text(output);
        $("#rendered").html(output);
        last_parsed_text = input;
      }
      return setTimeout(parse, 200);
    };
    return setTimeout(parse, 200);
  });
}).call(this);
