(function() {
  var ArrayView, HTML, IndentationHelper, convert, indent_lines, output;
  ArrayView = function(list, first, last) {
    var index;
    if (first == null) first = 0;
    if (last == null) last = list.length;
    index = first;
    return {
      shift: function() {
        var obj;
        obj = list[index];
        index += 1;
        return obj;
      },
      peek: function() {
        return list[index];
      },
      len: function() {
        return last - index;
      },
      at: function(offset) {
        return list[index + offset];
      },
      to_array: function() {
        return list.slice(first, last);
      },
      shift_slice: function(how_many) {
        var view;
        view = ArrayView(list, index, index + how_many);
        index += how_many;
        return view;
      }
    };
  };
  IndentationHelper = {
    get_indented_block: function(len_prefix, prefix_lines) {
      var i, line, new_prefix, _ref;
      i = 0;
      while (i < prefix_lines.len()) {
        _ref = prefix_lines.at(i), new_prefix = _ref[0], line = _ref[1];
        if (line && new_prefix.length <= len_prefix) break;
        i += 1;
      }
      while (i - 1 >= 0 && prefix_lines.at(i - 1)[1] === '') {
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
      if (line === '') prefix = '';
      return [prefix, line];
    }
  };
  indent_lines = function(input, branch_method, line_method) {
    var line, prefix_lines, recurse;
    recurse = function(prefix_lines) {
      var block_size, line, prefix, recurse_block, _ref;
      while (prefix_lines.len() > 0) {
        _ref = prefix_lines.shift(), prefix = _ref[0], line = _ref[1];
        if (line === '') {
          line_method(prefix, line);
          continue;
        }
        block_size = IndentationHelper.get_indented_block(prefix.length, prefix_lines);
        if (block_size === 0) {
          line_method(prefix, line);
        } else {
          recurse_block = function() {
            var block;
            block = prefix_lines.shift_slice(block_size);
            return recurse(block);
          };
          branch_method(prefix, line, recurse_block);
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
    return recurse(ArrayView(prefix_lines));
  };
  HTML = function(append) {
    var branch_method, enclose_tag, get_tags, html_syntax, leaf_method, line_method;
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
    line_method = function(prefix, line) {
      return append(prefix + leaf_method(line));
    };
    branch_method = function(prefix, line, recurse_block) {
      var end_tag, start_tag, _ref;
      if (html_syntax.exec(line)) {
        append(prefix + line);
        recurse_block();
        return;
      }
      _ref = get_tags(line), start_tag = _ref[0], end_tag = _ref[1];
      append(prefix + start_tag);
      recurse_block();
      return append(prefix + end_tag);
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
          if (m[1] === '') return m[2];
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
        if (m) return translation.convert(m);
      }
      return s;
    };
    return {
      branch_method: branch_method,
      line_method: line_method
    };
  };
  output = function() {
    var self, tokens;
    tokens = [];
    return self = {
      append: function(data) {
        return tokens.push(data);
      },
      text: function() {
        return tokens.join('\n');
      }
    };
  };
  convert = function(s) {
    var buffer, html;
    buffer = output();
    html = HTML(buffer.append);
    indent_lines(s, html.branch_method, html.line_method);
    return buffer.text();
  };
  if (typeof exports !== "undefined" && exports !== null) {
    exports.convert = convert;
  } else {
    this.pipedent_convert = convert;
  }
}).call(this);
