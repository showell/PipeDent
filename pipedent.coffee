ArrayView = (list, first, last) ->
  index = first
  shift: ->
    obj = list[index]
    index += 1
    obj
  empty: ->
    index >= last
  peek: ->
    list[index]
  len: ->
    last - index
  at: (offset) ->
    list[index + offset]
  to_array: ->
    # shim
    list[first...last]
    

IndentationHelper =
  get_indented_block: (prefix_lines) ->
      [prefix, line] = prefix_lines.at(0)
      len_prefix = prefix.length
      # Find the first nonempty line with len(prefix) <= len(prefix)
      i = 1
      while i < prefix_lines.len()
          [new_prefix, line] = prefix_lines.at(i)
          if line and new_prefix.length <= len_prefix
              break
          i += 1
      # Rewind to exclude empty lines
      while i-1 > 0 and prefix_lines.at(i-1)[1] == ''
          i -= 1
      return i

  find_indentation: (line) ->
    re = RegExp('( *)(.*)')
    match = re.exec(line)
    prefix = match[1]
    line = match[2]
    prefix = '' if line == ''
    return [prefix, line]

indent_lines = (input, branch_method, line_method) ->
  recurse = (prefix_lines) ->
    while prefix_lines.length > 0
      [prefix, line] = prefix_lines[0]
      if line == ''
        prefix_lines.shift()
        line_method(prefix, line)
        continue

      block_size = IndentationHelper.get_indented_block ArrayView(prefix_lines, 0, prefix_lines.length)
      if block_size == 1
        [prefix, line] = prefix_lines.shift()
        line_method(prefix, line)
      else
        header = prefix_lines[0]
        block = prefix_lines[1...block_size]
        recurse_block = -> recurse(block)
        prefix_lines = prefix_lines[block_size..-1]
        branch_method(header, recurse_block)
    return
    
  prefix_lines = (IndentationHelper.find_indentation(line) for line in input.split('\n'))
  recurse(prefix_lines)

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
    
  branch_method = (header, recurse_block) ->
    [prefix, line] = header
    if html_syntax.exec(line)
      append(prefix + line)
      recurse_block()
      return
    [start_tag, end_tag] = get_tags(line)
    append(prefix + start_tag)
    recurse_block()
    append(prefix + end_tag)

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
  s = ''
  self =
    append: (data) ->
      s += data + '\n'
    text: ->
      s

convert = (s) ->  
  buffer = output()
  html = HTML(buffer.append)
  indent_lines(
    s, 
    html.branch_method,
    html.line_method
  )
  buffer.text()

if exports?
  # node.js has require mechanism
  exports.convert = convert
else
  # in browser use a more unique name
  this.pipedent_convert = convert

