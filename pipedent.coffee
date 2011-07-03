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

indent_lines = (input, output, branch_method, leaf_method, pass_syntax, indentation_method, get_block) ->
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
        if line == pass_syntax
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

branch_method = (output, block, recurse) ->
  [prefix, line] = block[0]
  output.append(prefix + line)
  recurse(block[1..-1])
  output.append(prefix + "END")

leaf_method = (s) ->
  s

exports.convert = (s) ->  
  buffer = output()
  indent_lines(
    s, 
    buffer,
    branch_method,
    leaf_method,
    'PASS',
    find_indentation,
    get_indented_block
  )
  buffer.text()

