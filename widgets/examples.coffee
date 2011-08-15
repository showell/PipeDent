this.widget_collection =
  pipedent:
    description: "PipeDent"
    code: \
      '''
      HTML
        <hr>
          h2 | About Pipedent
          ul
            li | small subset/dialect of HAML/Jade
            li | use it as a preprocessor
            li | just requires one file to run
            li | source code is annotated
          h2 | Syntax
          ul
            li | Use indentation for blocks
            li | Use "|" to separate markup from content
            li | Use "|" to auto-close single-line tags
            li | Inline HTML passes through fine.
        <hr>
          a href="https://github.com/showell/PipeDent/blob/master/pipedent.coffee" | Github
      CSS
        ul {
          list-style-type: none
        }
      '''
  
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
  
  complex_numbers:
    description: "Basic Graphics"
    code: \
      '''
      HTML
        table
          tr valign="top"
            td
              canvas id="ComplexNumbers" |
            td
              div id="ButtonPanel"
                button id="rotate_plus10" | Rotate 10 counterclockwise
                button id="rotate_minus10" | Rotate 10 clockwise
                button id="reflect_x" | Reflect across x-axis
                button id="reflect_y" | Reflect across y-axis
                button id="reflect_origin" | Reflect across origin
                button id="expand" | Expand
                button id="compress" | Compress
      CSS
        #ComplexNumbers {
          width: 300px;
          height: 300px;
          border: 3px blue solid
        }
        
      COFFEE
        ButtonPanel = (shape, div) ->
          div.find("#rotate_plus10").click -> shape.rotate(10)
          div.find("#rotate_minus10").click -> shape.rotate(-10)
          div.find("#reflect_x").click -> shape.reflect_x()
          div.find("#reflect_y").click -> shape.reflect_y()
          div.find("#reflect_origin").click -> shape.reflect_origin()
          div.find("#expand").click -> shape.rescale(1.2)
          div.find("#compress").click -> shape.rescale(0.8)
            
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
        this.button_panel = ButtonPanel(shape, $("#ButtonPanel"))
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