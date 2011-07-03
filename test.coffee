input = '''
  html
    head
    body
      table
        tr
          td
          td
  '''
  
pipedent = require './pipedent'
console.log pipedent.convert(input)