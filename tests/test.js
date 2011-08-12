(function() {
  var assert_equal, convert, convert_widget_package, fs, indent, pipedent, run_package_test, run_test;
  pipedent = require("../pipedent");
  fs = require('fs');
  convert = pipedent.convert;
  convert_widget_package = pipedent.convert_widget_package;
  assert_equal = function(expected, actual, msg) {
    var actual_line, i, line, _len, _ref;
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
        actual_line = actual.split("\n")[i];
        if (line !== actual_line) {
          console.log("****", line);
          console.log("----", actual_line);
          console.log("");
        }
      }
      throw "fail";
    }
  };
  indent = function(s, indent) {
    var lines;
    lines = s.split("\n");
    lines = lines.map(function(line) {
      if (line === '') {
        return line;
      } else {
        return indent + line;
      }
    });
    return lines.join("\n");
  };
  run_test = function(test) {
    var actual, expected, msg;
    expected = test.output + "\n";
    actual = convert(test.input);
    msg = "test: " + test.use_case;
    return assert_equal(expected, actual, msg);
  };
  run_package_test = function(test) {
    var actual, expected, msg;
    expected = indent(test.output, '  ');
    actual = convert_widget_package(test.input)[test.key];
    msg = "test: " + test.use_case;
    return assert_equal(expected, actual, msg);
  };
  run_package_test({
    use_case: "Basic HTML",
    input: 'HTML\n  p | hello\n  b | world',
    key: 'HTML',
    output: '<p>hello</p>\n<b>world</b>'
  });
  run_package_test({
    use_case: "Basic CSS",
    input: 'CSS\n  #square {\n    background: red\n  }',
    key: 'CSS',
    output: '#square {\n  background: red\n}'
  });
  run_test({
    use_case: "Let HTML pass through",
    input: '<div>\n  <h2>foo</h2>\n</div>',
    output: '<div>\n  <h2>foo</h2>\n</div>'
  });
  run_test({
    use_case: "Basic Indent",
    input: 'foo\n  bar\n  | bar\n  <b>html passes thru</b>\n\nyo |',
    output: '<foo>\n  bar\n  bar\n  <b>html passes thru</b>\n</foo>\n\n<yo></yo>'
  });
  run_test({
    use_case: "Deep Indent",
    input: 'foo\n  bar\n    baz\n      yo\n      \n  bar2\n    baz\n  \n  bar3\n    baz\n      yo',
    output: '<foo>\n  <bar>\n    <baz>\n      yo\n    </baz>\n  </bar>\n\n  <bar2>\n    baz\n  </bar2>\n\n  <bar3>\n    <baz>\n      yo\n    </baz>\n  </bar3>\n</foo>'
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
