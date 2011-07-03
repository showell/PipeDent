(function() {
  var branch_method, find_indentation, get_indented_block, get_tags, indent_lines, leaf_method, output;
  get_tags = function(full_tag) {
    var tag;
    tag = full_tag.split()[0];
    return ["<" + full_tag + ">", "</" + tag + ">"];
  };
  branch_method = function(output, block, recurse) {
    var end_tag, line, prefix, start_tag, _ref, _ref2;
    _ref = block[0], prefix = _ref[0], line = _ref[1];
    _ref2 = get_tags(line), start_tag = _ref2[0], end_tag = _ref2[1];
    output.append(prefix + start_tag);
    recurse(block.slice(1));
    return output.append(prefix + end_tag);
  };
  leaf_method = function(s) {
    return s;
  };
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
  indent_lines = function(input, output) {
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
        block_size = get_indented_block(prefix_lines);
        if (block_size === 1) {
          prefix_lines.shift();
          if (line === "PASS") {
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
  exports.convert = function(s) {
    var buffer;
    buffer = output();
    indent_lines(s, buffer);
    return buffer.text();
  };
}).call(this);
