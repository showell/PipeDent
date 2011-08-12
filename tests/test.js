(function() {
  var assert_equal, convert, fs, pipedent, run_test;
  pipedent = require("../pipedent");
  fs = require('fs');
  convert = pipedent.convert;
  assert_equal = function(expected, actual, msg) {
    var i, line, _len, _ref;
    if (expected.trim() !== actual.trim()) {
      console.warn(msg);
      console.warn('=====');
      console.warn("EXPECTED");
      console.warn(expected);
      console.warn('ACTUAL');
      console.warn(actual);
      _ref = expected.split("\n");
      for (i = 0, _len = _ref.length; i < _len; i++) {
        line = _ref[i];
        if (line !== actual.split("\n")[i]) {
          console.log("****", line);
        }
      }
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
    use_case: "Trailing Pipe",
    input: 'div id="yo" |',
    output: '<div id="yo"></div>'
  });
  run_test({
    use_case: "Pipes",
    input: 'h1 | apple\nh2 | banana\n| carrot',
    output: '<h1>apple</h1>\n<h2>banana</h2>\ncarrot'
  });
  run_test({
    use_case: "Sit nicely on top of microtemplates",
    input: fs.readFileSync('./docco_example.pipedent').toString(),
    output: fs.readFileSync('./docco_example.eco').toString()
  });
}).call(this);
