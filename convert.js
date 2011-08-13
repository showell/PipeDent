(function() {
  var fn, fs, pipedent;
  pipedent = require("./pipedent");
  fs = require("fs");
  fn = process.argv[2];
  fs.readFile(fn, function(err, data) {
    if (err) {
      throw err;
    }
    return console.log(pipedent.convert("" + data));
  });
}).call(this);
