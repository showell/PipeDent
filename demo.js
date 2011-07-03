(function() {
  var convert, demo_input, my_html_input;
  my_html_input = 'p\n  | Welcome the demo.  As you edit the code on the left, it\n  | will convert automatically.\ntable\n  tr\n    td\n      h1 | Input\n      textarea id="input" rows=80 cols=80\n        PASS\n    td\n      h1 | Output HTML\n      textarea id="output" rows=80 cols=80\n        PASS';
  demo_input = my_html_input;
  convert = this.pipedent_convert;
  $(document).ready(function() {
    var demo_output, parse;
    demo_output = convert(demo_input);
    $("#content").html(convert(my_html_input));
    console.log(demo_output);
    $("#input").text(demo_input);
    $("#output").text(demo_output);
    parse = function() {
      var input, output;
      input = $("#input").val();
      output = convert(input);
      $("#output").text(output);
      return setTimeout(parse, 200);
    };
    return setTimeout(parse, 200);
  });
}).call(this);
