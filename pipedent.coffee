get_tags = (full_tag) ->
  tag = full_tag.split(' ')[0]
  ["<#{full_tag}>", "</#{tag}>"]
  
enclose_tag = (tag, text) ->
  [start_tag, end_tag] = get_tags(tag)
  start_tag + text + end_tag

branch_method = (output, block, recurse) ->
  [prefix, line] = block[0]
  [start_tag, end_tag] = get_tags(line)
  output.append(prefix + start_tag)
  recurse(block[1..-1])
  output.append(prefix + end_tag)

leaf_method = (s) ->
  raw_html =
    syntax: RegExp /(\<.*)/
    convert: (m) -> m[1]
  text_enclosing_tag =
    syntax: RegExp /(.*?)\s*\| (.*)/
    convert: (m) -> 
      return m[2] if m[1] == ''
      enclose_tag(m[1], m[2])
  translations = [
    raw_html,
    text_enclosing_tag
  ]
  
  for translation in translations
    m = translation.syntax.exec(s)
    return translation.convert(m) if m
  s

get_indented_block = (prefix_lines) ->
    [prefix, line] = prefix_lines[0]
    len_prefix = prefix.length
    # Find the first nonempty line with len(prefix) <= len(prefix)
    i = 1
    while i < prefix_lines.length
        [new_prefix, line] = prefix_lines[i]
        if line and new_prefix.length <= len_prefix
            break
        i += 1
    # Rewind to exclude empty lines
    while i-1 > 0 and prefix_lines[i-1][1] == ''
        i -= 1
    return i

find_indentation = (line) ->
  re = RegExp('( *)(.*)')
  match = re.exec(line)
  prefix = match[1]
  line = match[2]
  prefix = '' if line == ''
  return [prefix, line]

indent_lines = (input, output) ->
  append = output.append
  recurse = (prefix_lines) ->
    while prefix_lines.length > 0
      [prefix, line] = prefix_lines[0]
      if line == ''
        prefix_lines.shift()
        append('')
        continue

      block_size = get_indented_block(prefix_lines)
      if block_size == 1
        prefix_lines.shift()
        if line != "PASS"
          append(prefix + leaf_method(line))
      else
        block = prefix_lines[0...block_size]
        prefix_lines = prefix_lines[block_size..-1]
        branch_method(output, block, recurse)
    return
  prefix_lines = (find_indentation(line) for line in input.split('\n'))
  
  recurse(prefix_lines)

output = () ->
  s = ''
  self =
    append: (data) ->
      s += data + '\n'
    text: ->
      s

convert = (s) ->  
  buffer = output()
  indent_lines(
    s, 
    buffer,
  )
  buffer.text()

if exports?
  # node.js has require mechanism
  exports.convert = convert
else
  # in browser use a more unique name
  this.pipedent_convert = convert

