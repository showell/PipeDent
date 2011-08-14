(function() {
  this.widget_collection = {
    basic_tables: {
      description: "Basic Tables",
      code: 'HTML\n  div id="TableWidget"\n    <hr>\n    h6 | Simple tables\n    table border=1\n      tr\n        td class="NW"\n          Northwest\n        td class="NE"\n          Northeast\n      tr\n        td class="SW"\n          Southwest\n        td class="SE"\n          Southeast\nCSS\n  .NW {\n    background: red\n  }\n  .SE {\n    background: lightblue\n  }\nCOFFEE\n  Widget = (elem) ->\n    set_color = (elem, color) ->\n      elem.css("background", color)\n    NW: (color) -> set_color $(".NW"), color\n    NE: (color) -> set_color $(".NE"), color\n    SW: (color) -> set_color $(".SW"), color\n    SE: (color) -> set_color $(".SE"), color\n  this.widget = Widget $("#TableWidget")'
    },
    keyboard_cat: {
      description: "Keyboard Cat!",
      code: 'HTML\n  iframe id="cat" src="http://bit.ly/rnRblF" allowfullscreen |\nCSS\n  #cat {\n    width: 425;\n    height: 349;\n  }'
    }
  };
}).call(this);
