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
        Shape = (canvas, coords) ->
          cp = ComplexPlane(canvas)
          cp.draw_shape(coords)
          rescale = (coord, scaling) ->
            coord.times_real(scaling)
          reflect_origin = (coord) ->
            rescale coord, -1
          reflect_x = (coord) ->
            coord.conjugate()
          reflect_y = (coord) ->
            reflect_x reflect_origin(coord)
          self =
            transform: (f) ->
              coords = coords.map (coord) -> f(coord)
              cp.draw_shape(coords)
            reflect_origin: ->
              self.transform reflect_origin
            reflect_x: -> 
              self.transform reflect_x
            reflect_y: -> 
              self.transform reflect_y
            move: (x, y) ->
              self.transform (coord) -> coord.plus Complex(x,y)
            rescale: (scaling) ->
              self.transform (coord) -> rescale coord, scaling
            coords: -> coords
            rotate: (angle) ->
              radians = 2 * Math.PI * angle / 360
              other = Complex Math.cos(radians), Math.sin(radians)
              self.transform (coord) -> coord.times(other) 
      
        Complex = (a, b) ->
          a: a
          b: b
          conjugate: -> Complex(a, -b)
          times: (other) -> Complex(a * other.a - b * other.b, a * other.b + b * other.a)
          times_real: (real) -> Complex(a * real, b * real)
          plus: (other) -> Complex(a + other.a, b + other.b)
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
          x = (c) ->
            Math.floor(c.a) + 150
          y = (c) ->
            150 - Math.floor(c.b)
          move = (c) ->
            ctx.moveTo x(c), y(c)
          line = (c) ->
            ctx.lineTo x(c), y(c)
          self =
            draw_shape: (shape) ->
              self.reset()
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
        house = [Complex(10, 10), Complex(10, 40), Complex(25, 60), Complex(40, 40), Complex(40, 10)]
        this.shape = Shape(canvas, house)
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