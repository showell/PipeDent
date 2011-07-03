input = \
  '''
  html
    head
    body
      table
        tr
          td id="one" | one
          td id="two" | two
      p
        | This is just free
        | form text.
      div class="body"
        <b>raw html just passes thru and takes precedence over | </b>
      span | Hello world
  '''
  
pipedent = require './pipedent'
console.log pipedent.convert(input)


