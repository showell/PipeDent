# <hr>
# ArrayView is basically an iterator on an array.  We use it
# to avoid creating lots of little lists as we descend the
# document.
ArrayView = (list, first, last) ->
  first = 0 unless first?
  last = list.length unless last?
  index = first
  self =
    shift: ->
      obj = list[index]
      index += 1
      obj
    peek: ->
      list[index]
    len: ->
      last - index
    at: (offset) ->
      list[index + offset]
    shift_slice: (how_many) ->
      view = ArrayView(list, index, index + how_many)
      index += how_many
      view
    shift_while: (f) ->
      while self.len() > 0
        return if !f(self.peek())
        self.shift()
  
# <hr>
# Indentation helper methods:
IndentationHelper =
  # Shift empty lines off of our ArrayView.  Useful in modes
  # where empty lines aren't needed for the final output.
  eat_empty_lines: (indented_lines) ->
    indented_lines.shift_while (elem) ->
      [prefix, line] = elem
      line == ''

  # Count how many lines are in next indented block, but exclude
  # any trailing final whitespace, while still allowing for empty
  # lines within the block.
  number_of_lines_in_indented_block: (len_prefix, indented_lines) ->
      # Find how many lines are indented
      i = 0
      while i < indented_lines.len()
          [new_prefix, line] = indented_lines.at(i)
          if line and new_prefix.length <= len_prefix
              break
          i += 1
      # Rewind to exclude empty lines
      while i-1 >= 0 and indented_lines.at(i-1)[1] == ''
          i -= 1
      return i

  # transform "  hello" to ["  ", "hello"]
  find_indentation: (line) ->
    re = RegExp('( *)(.*)')
    match = re.exec(line)
    prefix = match[1]
    line = match[2]
    prefix = '' if line == ''
    return [prefix, line]

# <hr>
# Small helper to bootstrap a parsing algorithm.
parse = (s, parser) ->
  prefix_line_array = (IndentationHelper.find_indentation(line) for line in s.split('\n'))
  parser(ArrayView prefix_line_array)

# <hr>
# Object used to parse PipeDent to something like HTML. Basic rules:
#   indentation -> format like HTML blocks
#   pipes -> create HTML one-liners
#   HTML -> pass through
HTML = (append) ->
  # create start and end tag
  get_tags = (full_tag) ->
    tag = full_tag.split(' ')[0]
    ["<#{full_tag}>", "</#{tag}>"]

  # given tag and text, enclose text in angle-bracketed tags
  enclose_tag = (tag, text) ->
    [start_tag, end_tag] = get_tags(tag)
    start_tag + text + end_tag

  # HTML syntax passes through.  Look for angle brackets at the beginning
  # of the line.
  html_syntax = RegExp /(^\<.*)/

  # tranform a line of text
  line_method = (prefix, line) ->
    append(prefix + leaf_method(line))
    
  # entry point to out parser, loop through and find all "compound"
  # statements
  parse_to_html = (indented_lines) ->
    while indented_lines.len() > 0
      parse_compound_statement(indented_lines)
    
  # a "compound" statement is either an empty line, a single line, or a block
  parse_compound_statement = (indented_lines) ->  
    [prefix, line] = indented_lines.shift()
    if line == ''
      line_method(prefix, line)
    else
      block_size = IndentationHelper.number_of_lines_in_indented_block prefix.length, indented_lines
      if block_size == 0
        line_method(prefix, line)
      else
        block = indented_lines.shift_slice(block_size) 
        block_method(prefix, line, block)
  
  # If the header of a block already is in HTML, just recursively parse its contents.
  # Otherwise, we build the start and end tags.     
  block_method = (prefix, line, block) ->
    if html_syntax.exec(line)
      append(prefix + line)
      parse_to_html(block)
    else
      [start_tag, end_tag] = get_tags(line)
      append(prefix + start_tag)
      parse_to_html(block)
      append(prefix + end_tag)

  # Single-line transforms are all regex-driven.
  leaf_method = (s) ->
    raw_html =
      syntax: html_syntax
      convert: (m) -> m[1]
    text_enclosing_tag =
      syntax: RegExp /(.*?)\s*\| (.*)/
      convert: (m) -> 
        return m[2] if m[1] == ''
        enclose_tag(m[1], m[2])
    empty_closed_tag =
      syntax: RegExp /(.+?)\s*\|$/
      convert: (m) ->
        enclose_tag(m[1], '')
        
    # Run through the translations in precedence over.
    translations = [
      raw_html,
      text_enclosing_tag,
      empty_closed_tag
    ]

    for translation in translations
      m = translation.syntax.exec(s)
      return translation.convert(m) if m
    s
  
  # Expose our key entry points  
  parse_to_html: parse_to_html
  line_method: line_method

# <hr>
# A simple buffer object that supports append() and text().  We hide
# the implementation detail that we defer string concatenation until
# the user wants the final results.
output = () ->
  tokens = []
  self =
    append: (data) ->
      tokens.push data
    text: ->
      tokens.join('\n')

# <hr>
# Entry point for converting PipeDent documents.  This just glues the
# HTML object to the parse() method and a buffer.  The HTML object does
# the bullk of the work.
convert = (s) ->  
  buffer = output()
  html = HTML(buffer.append)
  parse(s, html.parse_to_html)
  buffer.text()

# <hr>
# Convert a widget package to JSON.  Block headers can be "HTML" or 
# arbitrary strings like "CSS" and "COFFEE".  Right now only HTML leads
# to translation.  Others pass through untouched.  TODO: possibly
# dedent blocks.
convert_widget_package = (s) ->
  obj = {}
  parser = (indented_lines) ->
    IndentationHelper.eat_empty_lines(indented_lines)
    while indented_lines.len() > 0
      [prefix, line] = indented_lines.shift()
      key = line
      block_size = IndentationHelper.number_of_lines_in_indented_block prefix.length, indented_lines
      block = indented_lines.shift_slice(block_size)
      buffer = output()

      if key == 'HTML'
        html = HTML(buffer.append)
        html.parse_to_html(block)
      else
        while block.len() > 0
          [prefix, line] = block.shift()
          buffer.append prefix+line

      obj[key] = buffer.text()

      IndentationHelper.eat_empty_lines(indented_lines)
    return

  parse(s, parser)
  obj
    
# <hr>
# Exports.  (All this code runs in a big closure.)
if exports?
  # node.js has require mechanism
  exports.convert = convert
  exports.convert_widget_package = convert_widget_package
else
  # in browser use a more unique name
  this.pipedent_convert = convert
  this.convert_widget_package = convert_widget_package

