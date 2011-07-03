(function() {
  var input, pipedent;
  input = 'html\n  head\n  body\n    table\n      tr\n        td\n        td';
  pipedent = require('./pipedent');
  console.log(pipedent.convert(input));
}).call(this);
