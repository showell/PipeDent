(function() {
  var ArrayView, HTML, IndentationHelper, convert, convert_widget_package, output, parse;
  ArrayView = function(list, first, last) {
    var index, self;
    if (first == null) first = 0;
    if (last == null) last = list.length;
    index = first;
    return self = {
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
      },
      shift_while: function(f) {
        var _results;
        _results = [];
        while (self.len() > 0) {
          if (!f(self.peek())) return;
          _results.push(self.shift());
        }
        return _results;
      }
    };
  };
  IndentationHelper = {
    eat_empty_lines: function(indented_lines) {
      return indented_lines.shift_while(function(elem) {
        var line, prefix;
        prefix = elem[0], line = elem[1];
        return line === '';
      });
    },
    get_indented_block: function(len_prefix, indented_lines) {
      var i, line, new_prefix, _ref;
      i = 0;
      while (i < indented_lines.len()) {
        _ref = indented_lines.at(i), new_prefix = _ref[0], line = _ref[1];
        if (line && new_prefix.length <= len_prefix) break;
        i += 1;
      }
      while (i - 1 >= 0 && indented_lines.at(i - 1)[1] === '') {
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
  parse = function(s, parser) {
    var line, prefix_line_array;
    prefix_line_array = (function() {
      var _i, _len, _ref, _results;
      _ref = s.split('\n');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        line = _ref[_i];
        _results.push(IndentationHelper.find_indentation(line));
      }
      return _results;
    })();
    return parser(ArrayView(prefix_line_array));
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
    branch_method = function(indented_lines) {
      var block, block_size, end_tag, line, prefix, start_tag, _ref, _ref2;
      if (indented_lines.len() === 0) return;
      _ref = indented_lines.shift(), prefix = _ref[0], line = _ref[1];
      if (line === '') {
        line_method(prefix, line);
      } else {
        block_size = IndentationHelper.get_indented_block(prefix.length, indented_lines);
        if (block_size === 0) {
          line_method(prefix, line);
        } else {
          block = indented_lines.shift_slice(block_size);
          if (html_syntax.exec(line)) {
            append(prefix + line);
            branch_method(block);
          } else {
            _ref2 = get_tags(line), start_tag = _ref2[0], end_tag = _ref2[1];
            append(prefix + start_tag);
            branch_method(block);
            append(prefix + end_tag);
          }
        }
      }
      return branch_method(indented_lines);
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
    parse(s, html.branch_method);
    return buffer.text();
  };
  convert_widget_package = function(s) {
    var obj, parser;
    obj = {};
    parser = function(indented_lines) {
      var block, block_size, buffer, html, key, line, prefix, _ref, _results;
      _results = [];
      while (indented_lines.len() > 0) {
        IndentationHelper.eat_empty_lines(indented_lines);
        _ref = indented_lines.shift(), prefix = _ref[0], line = _ref[1];
        key = line;
        _results.push((function() {
          var _ref2;
          if (key === 'HTML') {
            block_size = IndentationHelper.get_indented_block(prefix.length, indented_lines);
            block = indented_lines.shift_slice(block_size);
            IndentationHelper.eat_empty_lines(block);
            if (block.len() > 0) {
              buffer = output();
              html = HTML(buffer.append);
              html.branch_method(block);
              return obj[key] = buffer.text();
            }
          } else {
            block_size = IndentationHelper.get_indented_block(prefix.length, indented_lines);
            block = indented_lines.shift_slice(block_size);
            buffer = output();
            while (block.len() > 0) {
              _ref2 = block.shift(), prefix = _ref2[0], line = _ref2[1];
              buffer.append(prefix + line);
            }
            return obj[key] = buffer.text();
          }
        })());
      }
      return _results;
    };
    parse(s, parser);
    return obj;
  };
  if (typeof exports !== "undefined" && exports !== null) {
    exports.convert = convert;
    exports.convert_widget_package = convert_widget_package;
  } else {
    this.pipedent_convert = convert;
    this.convert_widget_package = convert_widget_package;
  }
}).call(this);
