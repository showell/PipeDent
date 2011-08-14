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