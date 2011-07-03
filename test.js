(function() {
  var input, pipedent;
  input = 'html\n  head\n  body\n    table\n      tr\n        td id="one" | one\n        td id="two" | two\n    p\n      | This is just free\n      | form text.\n    div class="body"\n      <b>raw html just passes thru and takes precedence over | </b>\n    span | Hello world';
  pipedent = require('./pipedent');
  console.log(pipedent.convert(input));
}).call(this);
