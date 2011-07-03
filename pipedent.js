(function() {
  var branch_method, find_indentation, get_indented_block, indent_lines, leaf_method, output;
  get_indented_block = function(prefix_lines) {
    var i, len_prefix, line, new_prefix, prefix, _ref, _ref2;
    _ref = prefix_lines[0], prefix = _ref[0], line = _ref[1];
    len_prefix = prefix.length;
    i = 1;
    while (i < prefix_lines.length) {
      _ref2 = prefix_lines[i], new_prefix = _ref2[0], line = _ref2[1];
      if (line && new_prefix.length <= len_prefix) {
        break;
      }
      i += 1;
    }
    while (i - 1 > 0 && prefix_lines[i - 1][1] === '') {
      i -= 1;
    }
    return i;
  };
  find_indentation = function(line) {
    var match, prefix, re;
    re = RegExp('( *)(.*)');
    match = re.exec(line);
    prefix = match[1];
    line = match[2];
    if (line === '') {
      prefix = '';
    }
    return [prefix, line];
  };
  indent_lines = function(input, output, branch_method, leaf_method, pass_syntax, indentation_method, get_block) {
    var append, line, prefix_lines, recurse;
    append = output.append;
    recurse = function(prefix_lines) {
      var block, block_size, line, prefix, _ref;
      while (prefix_lines.length > 0) {
        _ref = prefix_lines[0], prefix = _ref[0], line = _ref[1];
        if (line === '') {
          prefix_lines.shift();
          append('');
          continue;
        }
        block_size = get_block(prefix_lines);
        if (block_size === 1) {
          prefix_lines.shift();
          if (line === pass_syntax) {
            pass;
          } else {
            append(prefix + leaf_method(line));
          }
        } else {
          block = prefix_lines.slice(0, block_size);
          prefix_lines = prefix_lines.slice(block_size);
          branch_method(output, block, recurse);
        }
      }
    };
    prefix_lines = (function() {
      var _i, _len, _ref, _results;
      _ref = input.split('\n');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        line = _ref[_i];
        _results.push(find_indentation(line));
      }
      return _results;
    })();
    return recurse(prefix_lines);
  };
  output = function() {
    var s, self;
    s = '';
    return self = {
      append: function(data) {
        return s += data + '\n';
      },
      text: function() {
        return s;
      }
    };
  };
  branch_method = function(output, block, recurse) {
    var line, prefix, _ref;
    _ref = block[0], prefix = _ref[0], line = _ref[1];
    output.append(prefix + line);
    recurse(block.slice(1));
    return output.append(prefix + "END");
  };
  leaf_method = function(s) {
    return s;
  };
  exports.convert = function(s) {
    var buffer;
    buffer = output();
    indent_lines(s, buffer, branch_method, leaf_method, 'PASS', find_indentation, get_indented_block);
    return buffer.text();
  };
}).call(this);
