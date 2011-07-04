(function() {
  var html_escape, jsdom, pipedent, stream, window;
  jsdom = require("jsdom");
  pipedent = require("../pipedent");
  html_escape = function(s) {
    return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  };
  stream = function($, append) {
    var example;
    example = 'h1 | Overview\ndiv id="overview"\n  p\n    | PipeDent is a tool for creating HTML with small snippets\n    | of text that provide the semantics of HTML without the\n    | syntax.  It is implemented in Coffeescript.\n  p\n    | You can run it from the browser or run it from node.js.\nh1 | Syntax\nul\n  li\n    | Use indentation for HTML blocks.  (Use PASS for empty blocks.)\n  li\n    | Use pipes to separate markup from content.  Content goes to\n    | the right of pipes.\nh1 | Installation\np\n  | The best way to get started with PipeDent is to run the\n  | demo with two simple commands\npre\n  | git clone git@github.com:showell/PipeDent.git\n  | cd PipeDent && open demo.htm \np | For usage in the browser, follow the model of example.htm.\np | For usage on the server, follow the model of example.coffee.\np | To convert files from the command line, see convert.js.\np\n  | Once you are ready to create your own programs, install\n  | pipedent.js on your web server or in a place where your\n  | node.js programs can find it.\nh1 | Example\ntable id="example" border=1\n  tr valign="top"\n    td id="input"\n      h2 | INPUT\n      pre\n        PASS\n    td id="output"\n      h2 | HTML OUTPUT\n      pre\n        PASS';
    append(pipedent.convert(example));
    $("#example #input pre").text(example);
    return $("#example #output pre").text(html_escape(pipedent.convert(example)));
  };
  window = jsdom.jsdom().createWindow();
  jsdom.jQueryify(window, 'http://code.jquery.com/jquery-1.4.2.min.js', function() {
    window.$('body').append('<div class="CONTENT"></div>');
    stream(window.$, function(html) {
      return window.$('.CONTENT').append(html);
    });
    return console.log(window.$('.CONTENT').html());
  });
}).call(this);
