input = '''
  html
    head
    body
      table
        tr
          td
        tr
          td
  '''
  
pipedent = require './pipedent'
console.log pipedent.convert(input)