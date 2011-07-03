get_tags = (full_tag) ->
  tag = full_tag.split()[0]
  ["<#{full_tag}>", "</#{tag}"]

branch_method = (output, block, recurse) ->
  [prefix, line] = block[0]
  [start_tag, end_tag] = get_tags(line)
  output.append(prefix + start_tag)
  recurse(block[1..-1])
  output.append(prefix + end_tag)

leaf_method = (s) ->
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

      block_size = get_block(prefix_lines)
      if block_size == 1
        prefix_lines.shift()
        if line == "PASS"
          pass
        else
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


exports.convert = (s) ->  
  buffer = output()
  indent_lines(
    s, 
    buffer,
  )
  buffer.text()

