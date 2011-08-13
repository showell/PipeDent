(function() {
  var convert, demo_input, demo_layout, format_intro, my_html_input, num_user_changes, update_widgets;
  demo_layout = '\ntable\n  tr valign="top"\n    td\n      p id="intro"\n        | Welcome to the demo.  As you edit the code below, it\n        | will convert automatically.        \n      h2 | Input\n      textarea id="input_code" rows=80 cols=80 |\n    td\n      h2 | Output HTML\n      pre id="output" |\n      style type="text/css" id="rendered_style" | {}\n      h4 | Rendered HTML\n      div id="rendered" |';
  my_html_input = widget_collection.keyboard_cat.code;
  demo_input = my_html_input;
  convert = this.pipedent_convert;
  num_user_changes = 0;
  format_intro = function() {
    var e, hide_if_user_changes;
    e = $("#intro");
    e.css("font-weight", "bold");
    e.css("font-size", "20px");
    e.css("background-color", "lightgreen");
    e.css("width", "450px");
    hide_if_user_changes = function() {
      if (num_user_changes > 5) {
        return e.fadeOut(1000);
      } else {
        return setTimeout(hide_if_user_changes, 2000);
      }
    };
    return setTimeout(hide_if_user_changes, 2000);
  };
  update_widgets = function(input) {
    var output;
    output = convert_widget_package(input);
    $("#output").text(output.HTML);
    $("#rendered").html(output.HTML);
    return $("#rendered_style").html(output.CSS);
  };
  $(document).ready(function() {
    var last_parsed_text, parse, user_engaged;
    $("#intro").css("font-weight", "bold");
    $("#content").html(convert(demo_layout));
    format_intro();
    $("#input_code").tabby({
      tabString: "  "
    });
    $("#input_code").text(demo_input);
    last_parsed_text = demo_input;
    update_widgets(demo_input);
    user_engaged = false;
    parse = function() {
      var input;
      input = $("#input_code").val();
      if (input !== last_parsed_text) {
        num_user_changes += 1;
        update_widgets(input);
        last_parsed_text = input;
      }
      return setTimeout(parse, 200);
    };
    return setTimeout(parse, 200);
  });
}).call(this);
