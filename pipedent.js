(function() {
  var HTML, IndentationHelper, convert, indent_lines, output;
  IndentationHelper = {
    get_indented_block: function(prefix_lines) {
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
    },
    find_indentation: function(line) {
      var match, prefix, re;
      re = RegExp('( *)(.*)');
      match = re.exec(line);
      prefix = match[1];
      line = match[2];
      if (line === '') {
        prefix = '';
      }
      return [prefix, line];
    }
  };
  indent_lines = function(input, output, branch_method, leaf_method) {
    var append, line, prefix_lines, recurse;
    append = output.append;
    recurse = function(prefix_lines) {
      var block, block_size, header, line, prefix, _ref, _ref2;
      while (prefix_lines.length > 0) {
        _ref = prefix_lines[0], prefix = _ref[0], line = _ref[1];
        if (line === '') {
          prefix_lines.shift();
          append('');
          continue;
        }
        block_size = IndentationHelper.get_indented_block(prefix_lines);
        if (block_size === 1) {
          _ref2 = prefix_lines.shift(), prefix = _ref2[0], line = _ref2[1];
          append(prefix + leaf_method(line));
        } else {
          header = prefix_lines[0];
          block = prefix_lines.slice(1, block_size);
          prefix_lines = prefix_lines.slice(block_size);
          branch_method(output, header, block, recurse);
        }
      }
    };
    prefix_lines = (function() {
      var _i, _len, _ref, _results;
      _ref = input.split('\n');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        line = _ref[_i];
        _results.push(IndentationHelper.find_indentation(line));
      }
      return _results;
    })();
    return recurse(prefix_lines);
  };
  HTML = function() {
    var branch_method, enclose_tag, get_tags, html_syntax, leaf_method;
    get_tags = function(full_tag) {
      var tag;
      tag = full_tag.split(' ')[0];
      return ["<" + full_tag + ">", "</" + tag + ">"];
    };
    enclose_tag = function(tag, text) {
      var end_tag, start_tag, _ref;
      _ref = get_tags(tag), start_tag = _ref[0], end_tag = _ref[1];
      return start_tag + text + end_tag;
    };
    html_syntax = RegExp(/(^\<.*)/);
    branch_method = function(output, header, block, recurse) {
      var end_tag, line, prefix, start_tag, _ref;
      prefix = header[0], line = header[1];
      if (html_syntax.exec(line)) {
        output.append(prefix + line);
        recurse(block);
        return;
      }
      _ref = get_tags(line), start_tag = _ref[0], end_tag = _ref[1];
      output.append(prefix + start_tag);
      recurse(block);
      return output.append(prefix + end_tag);
    };
    leaf_method = function(s) {
      var empty_closed_tag, m, raw_html, text_enclosing_tag, translation, translations, _i, _len;
      raw_html = {
        syntax: html_syntax,
        convert: function(m) {
          return m[1];
        }
      };
      text_enclosing_tag = {
        syntax: RegExp(/(.*?)\s*\| (.*)/),
        convert: function(m) {
          if (m[1] === '') {
            return m[2];
          }
          return enclose_tag(m[1], m[2]);
        }
      };
      empty_closed_tag = {
        syntax: RegExp(/(.+?)\s*\|$/),
        convert: function(m) {
          return enclose_tag(m[1], '');
        }
      };
      translations = [raw_html, text_enclosing_tag, empty_closed_tag];
      for (_i = 0, _len = translations.length; _i < _len; _i++) {
        translation = translations[_i];
        m = translation.syntax.exec(s);
        if (m) {
          return translation.convert(m);
        }
      }
      return s;
    };
    return {
      branch_method: branch_method,
      leaf_method: leaf_method
    };
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
  convert = function(s) {
    var buffer, html;
    buffer = output();
    html = HTML();
    indent_lines(s, buffer, html.branch_method, html.leaf_method);
    return buffer.text();
  };
  if (typeof exports !== "undefined" && exports !== null) {
    exports.convert = convert;
  } else {
    this.pipedent_convert = convert;
  }
}).call(this);
