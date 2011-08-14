(function() {
  this.widget_collection = {
    basic_tables: {
      description: "Basic Tables",
      code: 'HTML\n  div id="TableWidget"\n    <hr>\n    h6 | Simple tables\n    table border=1\n      tr\n        td class="NW"\n          Northwest\n        td class="NE"\n          Northeast\n      tr\n        td class="SW"\n          Southwest\n        td class="SE"\n          Southeast\nCSS\n  .NW {\n    background: red\n  }\n  .SE {\n    background: lightblue\n  }\nCOFFEE\n  Widget = (elem) ->\n    set_color = (elem, color) ->\n      elem.css("background", color)\n    NW: (color) -> set_color $(".NW"), color\n    NE: (color) -> set_color $(".NE"), color\n    SW: (color) -> set_color $(".SW"), color\n    SE: (color) -> set_color $(".SE"), color\n  this.widget = Widget $("#TableWidget")'
    },
    trig: {
      description: "Complex Numbers",
      code: 'HTML\n  canvas id="ComplexNumbers" |\nCSS\n  #ComplexNumbers {\n    width: 300px;\n    height: 300px;\n    border: 1px black solid\n  }\nCOFFEE\n  Complex = (a, b) ->\n    a: a\n    b: b\n    conjugate: -> Complex(a, -b)\n    times: (other) -> Complex(a * other.a - b * other.b, a * other.b + b * other.a)\n    toString: -> "#{a} + #{b}i"\n    magnitude: -> a*a + b*b\n\n  ComplexPlane = (canvas) ->\n    ctx = canvas.getContext("2d")\n    ctx.lineWidth = 2;\n    ctx.scale(1, 0.5)\n    draw_axes = ->\n      ctx.moveTo(0, 150)\n      ctx.lineTo(300, 150)\n      ctx.moveTo(150, 0)\n      ctx.lineTo(150, 300)\n      ctx.stroke()\n    move = (c) ->\n      ctx.moveTo(c.a+150, 150-c.b)\n    line = (c) ->\n      ctx.lineTo(c.a+150, 150-c.b)\n    self =\n      draw_shape: (shape) ->\n        ctx.strokeStyle = "red"\n        ctx.beginPath()\n        move(shape[shape.length-1])\n        for point in shape\n          line(point)\n        ctx.stroke()\n      reset: ->\n        canvas.width = canvas.width\n        ctx.scale(1, 0.5)\n        draw_axes()\n        \n  canvas = $("#ComplexNumbers").get()[0]\n  cp = ComplexPlane(canvas)\n  house = [Complex(10, 10), Complex(10, 40), Complex(40, 40), Complex(40, 10)]\n  cp.reset()\n  house = [Complex(10, 10), Complex(10, 40), Complex(25, 50), Complex(40, 40), Complex(40, 10)]\n  cp.draw_shape(house)\n  this.Complex = Complex'
    },
    keyboard_cat: {
      description: "Keyboard Cat!",
      code: 'HTML\n  iframe id="cat" src="http://bit.ly/rnRblF" allowfullscreen |\nCSS\n  #cat {\n    width: 425;\n    height: 349;\n  }'
    }
  };
}).call(this);
