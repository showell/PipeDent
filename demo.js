(function() {
  var CannedWidgets, convert, demo_layout, format_intro, num_user_changes, set_code, set_up_output_toggle, update_widgets;
  demo_layout = 'table\n  tr valign="top"\n    td id="leftPanel"\n      p id="intro"\n        | Welcome to the demo.  As you edit the code below, it\n        | will convert automatically.\n      ul id="canned_widgets" |        \n      h2 id="leftPanel" | Input\n      textarea id="input_code" rows=80 cols=80 |\n    td id="rightPanel"\n      h4 | Output HTML\n      a href="#" id="outputToggle" | Hide\n      pre id="output" |\n      <hr>\n      style type="text/css" id="rendered_style" | {}\n      h4 | Rendered HTML\n      div id="rendered" |';
  convert = this.pipedent_convert;
  num_user_changes = 0;
  set_up_output_toggle = function() {
    var elem, visible;
    elem = $("#outputToggle");
    visible = true;
    return elem.click(function() {
      if (visible) {
        $("#output").hide();
        visible = false;
        return elem.text("Show");
      } else {
        $("#output").show();
        visible = true;
        return elem.text("Hide");
      }
    });
  };
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
  set_code = function(code) {
    var len, line, max_line, _i, _len, _ref;
    max_line = 0;
    _ref = code.split("\n");
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      line = _ref[_i];
      len = line.length;
      if (len > max_line) {
        max_line = len;
      }
    }
    $("#input_code").attr("cols", max_line * 0.9);
    return $("#input_code").val(code);
  };
  update_widgets = function(input) {
    var js, output;
    output = convert_widget_package(input);
    $("#output").text(output.HTML);
    $("#rendered").html(output.HTML);
    $("#rendered_style").html(output.CSS);
    if (output.COFFEE) {
      try {
        js = CoffeeScript.compile(output.COFFEE);
      } catch (e) {
        console.log(e);
        console.log("(problem with compiling CS)");
      }
      try {
        return eval(js);
      } catch (e) {
        console.log(e);
        return console.log("problem in JS");
      }
    }
  };
  CannedWidgets = function(collection) {
    var a, elem, key, li, set_click, val, values, widget, _i, _len, _results;
    elem = $("#canned_widgets");
    values = (function() {
      var _results;
      _results = [];
      for (key in collection) {
        val = collection[key];
        _results.push(val);
      }
      return _results;
    })();
    set_click = function(a, widget) {
      return a.click(function() {
        return set_code(widget.code);
      });
    };
    _results = [];
    for (_i = 0, _len = values.length; _i < _len; _i++) {
      widget = values[_i];
      li = $("<li>");
      a = $(convert("a href='#' | " + widget.description));
      li.html(a);
      set_click(a, widget);
      _results.push(elem.append(li));
    }
    return _results;
  };
  $(document).ready(function() {
    var canned_widgets, demo_input, last_parsed_text, parse, user_engaged;
    $("#content").html(convert(demo_layout));
    $("#leftPanel").css("padding", "10px");
    $("#rightPanel").css("padding", "10px");
    canned_widgets = CannedWidgets(widget_collection);
    demo_input = widget_collection.pipedent.code;
    format_intro();
    set_up_output_toggle();
    $("#input_code").tabby({
      tabString: "  "
    });
    set_code(demo_input);
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
