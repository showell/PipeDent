(function() {
  this.widget_collection = {
    basic_tables: {
      description: "Basic Tables",
      code: 'HTML\n  <hr>\n  h6 | Simple tables\n  table border=1\n    tr\n      td class="red"\n        Northwest\n      td\n        Northeast\n    tr\n      td\n        Southwest\n      td style="background: lightblue"\n        Southeast\nCSS\n  .red {\n    background: red\n  }'
    },
    keyboard_cat: {
      description: "Keyboard Cat!",
      code: 'HTML\n  iframe id="cat" src="http://bit.ly/rnRblF" allowfullscreen |\nCSS\n  #cat {\n    width: 425;\n    height: 349;\n  }'
    }
  };
}).call(this);
