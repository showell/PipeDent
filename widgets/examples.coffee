this.widget_collection =
  basic_tables:
    description: "Basic Tables"
    code: \
      '''
      HTML
        <hr>
        h6 | Simple tables
        table border=1
          tr
            td class="red"
              Northwest
            td
              Northeast
          tr
            td
              Southwest
            td style="background: lightblue"
              Southeast
      CSS
        .red {
          background: red
        }
      '''