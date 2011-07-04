(function() {
  var assert_equal, convert, pipedent, run_test;
  pipedent = require("../pipedent");
  convert = pipedent.convert;
  assert_equal = function(expected, actual, msg) {
    if (expected !== actual) {
      console.log(msg);
      console.log('=====');
      console.log("EXPECTED");
      console.log(expected);
      console.log('ACTUAL');
      console.log(actual);
      throw "fail";
    }
  };
  run_test = function(test) {
    var actual, expected, msg;
    expected = test.output + "\n";
    actual = convert(test.input);
    msg = "test: " + test.use_case;
    return assert_equal(expected, actual, msg);
  };
  run_test({
    use_case: "Let HTML pass through",
    input: '<div>\n  <h2>foo</h2>\n</div>',
    output: '<div>\n  <h2>foo</h2>\n</div>'
  });
  run_test({
    use_case: "Basic Indent",
    input: 'foo\n  bar\n  | bar\n  <b>html passes thru</b>\n\nyo\n  PASS',
    output: '<foo>\n  bar\n  bar\n  <b>html passes thru</b>\n</foo>\n\n<yo>\n</yo>'
  });
  run_test({
    use_case: "Pipes",
    input: 'h1 | apple\nh2 | banana\n| carrot',
    output: '<h1>apple</h1>\n<h2>banana</h2>\ncarrot'
  });
}).call(this);
