(function() {
  var assert_equal, convert, fs, pipedent, run_test;
  pipedent = require("../pipedent");
  fs = require('fs');
  convert = pipedent.convert;
  assert_equal = function(expected, actual, msg) {
    if (expected !== actual) {
      console.warn(msg);
      console.warn('=====');
      console.warn("EXPECTED");
      console.warn(expected);
      console.warn('ACTUAL');
      console.warn(actual);
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
  run_test({
    use_case: "Sit nicely on top of microtemplates",
    input: fs.readFileSync('./docco_example.pipedent').toString(),
    output: '<!DOCTYPE html>\n\n<html>\n  <head>\n    <title><%= title %></title>\n    <meta http-equiv="content-type" content="text/html; charset=UTF-8">\n    <link rel="stylesheet" media="all" href="docco.css" />\n  </head>\n  <body>\n    <div id="container">\n      <div id="background"></div>\n      <% if (sources.length > 1) { %>\n        <div id="jump_to">\n          Jump To &hellip;\n          <div id="jump_wrapper">\n            <div id="jump_page">\n              <% for (var i=0, l=sources.length; i<l; i++) { %>\n                <% var source = sources[i]; %>\n                <a class="source" href="<%= path.basename(destination(source)) %>">\n                  <%= path.basename(source) %>\n                </a>\n              <% } %>\n            </div>\n          </div>\n        </div>\n      <% } %>\n      <table cellpadding="0" cellspacing="0">\n        <thead>\n          <tr>\n            <th class="docs">\n              <h1>\n                <%= title %>\n              </h1>\n            </th>\n            <th class="code">\n            </th>\n          </tr>\n        </thead>\n        <tbody>\n          <% for (var i=0, l=sections.length; i<l; i++) { %>\n            <% var section = sections[i]; %>\n            <tr id="section-<%= i + 1 %>">\n              <td class="docs">\n                <div class="pilwrap">\n                  <a class="pilcrow" href="#section-<%= i + 1 %>">&#182;</a>\n                </div>\n                <%= section.docs_html %>\n              </td>\n              <td class="code">\n                <%= section.code_html %>\n              </td>\n            </tr>\n          <% } %>\n        </tbody>\n      </table>\n    </div>\n  </body>\n</html>'
  });
}).call(this);
