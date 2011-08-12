(function() {
  var convert, demo_input, demo_layout, my_html_input, update_widgets;
  demo_layout = 'p\n  | Welcome to the demo.  As you edit the code on the left, it\n  | will convert automatically.\ntable\n  tr valign="top"\n    td\n      h1 | Input\n      textarea id="input" rows=80 cols=80\n        PASS\n    td\n      h1 | Output HTML\n      textarea id="output" rows=20 cols=80 |\n      style type="text/css" id="rendered_style" | {}\n      h1 | Rendered HTML\n      div id="rendered" |';
  my_html_input = 'HTML\n  <hr>\n  h6 | Simple tables\n  table border=1\n    tr\n      td class="red"\n        NW\n      td\n        NE\n    tr\n      td\n        SW\n      td style="background: lightblue"\n        SE\nCSS\n  .red {\n    background: red\n  }';
  demo_input = my_html_input;
  convert = this.pipedent_convert;
  update_widgets = function(input) {
    var output;
    output = convert_widget_package(input);
    $("#output").text(output.HTML);
    $("#rendered").html(output.HTML);
    return $("#rendered_style").html(output.CSS);
  };
  $(document).ready(function() {
    var last_parsed_text, parse;
    $("#content").html(convert(demo_layout));
    $("#input").tabby({
      tabString: "  "
    });
    $("#input").text(demo_input);
    last_parsed_text = demo_input;
    update_widgets(demo_input);
    parse = function() {
      var input;
      input = $("#input").val();
      if (input !== last_parsed_text) {
        update_widgets(input);
        last_parsed_text = input;
      }
      return setTimeout(parse, 200);
    };
    return setTimeout(parse, 200);
  });
}).call(this);
