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
    to_array: ->
      # shim
      list[first...last]
    shift_slice: (how_many) ->
      view = ArrayView(list, index, index + how_many)
      index += how_many
      view
    shift_while: (f) ->
      while self.len() > 0
        return if !f(self.peek())
        self.shift()
  

IndentationHelper =
  eat_empty_lines: (indented_lines) ->
    indented_lines.shift_while (elem) ->
      [prefix, line] = elem
      line == ''

  get_indented_block: (len_prefix, indented_lines) ->
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

  find_indentation: (line) ->
    re = RegExp('( *)(.*)')
    match = re.exec(line)
    prefix = match[1]
    line = match[2]
    prefix = '' if line == ''
    return [prefix, line]

parse = (s, parser) ->
  prefix_line_array = (IndentationHelper.find_indentation(line) for line in s.split('\n'))
  parser(ArrayView prefix_line_array)

HTML = (append) ->
  get_tags = (full_tag) ->
    tag = full_tag.split(' ')[0]
    ["<#{full_tag}>", "</#{tag}>"]

  enclose_tag = (tag, text) ->
    [start_tag, end_tag] = get_tags(tag)
    start_tag + text + end_tag

  html_syntax = RegExp /(^\<.*)/

  line_method = (prefix, line) ->
    append(prefix + leaf_method(line))
    
  branch_method = (indented_lines) ->
    if indented_lines.len() == 0
      return
    [prefix, line] = indented_lines.shift()
    if line == ''
      line_method(prefix, line)
    else
      block_size = IndentationHelper.get_indented_block prefix.length, indented_lines
      if block_size == 0
        line_method(prefix, line)
      else
        block = indented_lines.shift_slice(block_size) 
       
        if html_syntax.exec(line)
          append(prefix + line)
          branch_method(block)
        else
          [start_tag, end_tag] = get_tags(line)
          append(prefix + start_tag)
          branch_method(block)
          append(prefix + end_tag)
    branch_method(indented_lines)

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
    translations = [
      raw_html,
      text_enclosing_tag,
      empty_closed_tag
    ]

    for translation in translations
      m = translation.syntax.exec(s)
      return translation.convert(m) if m
    s
    
  branch_method: branch_method
  line_method: line_method

output = () ->
  tokens = []
  self =
    append: (data) ->
      tokens.push data
    text: ->
      tokens.join('\n')

convert = (s) ->  
  buffer = output()
  html = HTML(buffer.append)
  parse(s, html.branch_method)
  buffer.text()

convert_widget_package = (s) ->
  obj = {}
  parser = (indented_lines) ->
    IndentationHelper.eat_empty_lines(indented_lines)
    while indented_lines.len() > 0
      [prefix, line] = indented_lines.shift()
      key = line
      block_size = IndentationHelper.get_indented_block prefix.length, indented_lines
      block = indented_lines.shift_slice(block_size)
      buffer = output()

      if key == 'HTML'
        html = HTML(buffer.append)
        html.branch_method(block)
      else
        while block.len() > 0
          [prefix, line] = block.shift()
          buffer.append prefix+line

      obj[key] = buffer.text()

      IndentationHelper.eat_empty_lines(indented_lines)
    return

  parse(s, parser)
  obj
    

if exports?
  # node.js has require mechanism
  exports.convert = convert
  exports.convert_widget_package = convert_widget_package
else
  # in browser use a more unique name
  this.pipedent_convert = convert
  this.convert_widget_package = convert_widget_package

