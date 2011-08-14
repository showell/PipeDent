this.widget_collection =
  basic_tables:
    description: "Basic Tables"
    code: \
      '''
      HTML
        div id="TableWidget"
          <hr>
          h6 | Simple tables
          table border=1
            tr
              td class="NW"
                Northwest
              td class="NE"
                Northeast
            tr
              td class="SW"
                Southwest
              td class="SE"
                Southeast
      CSS
        .NW {
          background: red
        }
        .SE {
          background: lightblue
        }
      COFFEE
        Widget = (elem) ->
          set_color = (elem, color) ->
            elem.css("background", color)
          NW: (color) -> set_color $(".NW"), color
          NE: (color) -> set_color $(".NE"), color
          SW: (color) -> set_color $(".SW"), color
          SE: (color) -> set_color $(".SE"), color
        this.widget = Widget $("#TableWidget")
      '''
  
  trig:
    description: "Complex Numbers"
    code: \
      '''
      HTML
        canvas id="ComplexNumbers" |
      CSS
        #ComplexNumbers {
          width: 300px;
          height: 300px;
          border: 1px black solid
        }
      COFFEE
        Complex = (a, b) ->
          a: a
          b: b
          conjugate: -> Complex(a, -b)
          times: (other) -> Complex(a * other.a - b * other.b, a * other.b + b * other.a)
          toString: -> "#{a} + #{b}i"
          magnitude: -> a*a + b*b

        ComplexPlane = (canvas) ->
          ctx = canvas.getContext("2d")
          ctx.lineWidth = 2;
          ctx.scale(1, 0.5)
          draw_axes = ->
            ctx.moveTo(0, 150)
            ctx.lineTo(300, 150)
            ctx.moveTo(150, 0)
            ctx.lineTo(150, 300)
            ctx.stroke()
          move = (c) ->
            ctx.moveTo(c.a+150, 150-c.b)
          line = (c) ->
            ctx.lineTo(c.a+150, 150-c.b)
          self =
            draw_shape: (shape) ->
              ctx.strokeStyle = "red"
              ctx.beginPath()
              move(shape[shape.length-1])
              for point in shape
                line(point)
              ctx.stroke()
            reset: ->
              canvas.width = canvas.width
              ctx.scale(1, 0.5)
              draw_axes()
              
        canvas = $("#ComplexNumbers").get()[0]
        cp = ComplexPlane(canvas)
        house = [Complex(10, 10), Complex(10, 40), Complex(40, 40), Complex(40, 10)]
        cp.reset()
        house = [Complex(10, 10), Complex(10, 40), Complex(25, 50), Complex(40, 40), Complex(40, 10)]
        cp.draw_shape(house)
        this.Complex = Complex
      '''
      
      
  keyboard_cat:
    description: "Keyboard Cat!"
    code: \
      '''
      HTML
        iframe id="cat" src="http://bit.ly/rnRblF" allowfullscreen |
      CSS
        #cat {
          width: 425;
          height: 349;
        }
      '''