<h1>Overview</h1>
<p>
  PipeDent is a tool for creating HTML with small snippets
  of text that provide the semantics of HTML without the
  syntax.  It is implemented in Coffeescript.

  You can run it from the browser or run it from node.js.
</p>

<h1>Installation</h1>
<p>
  The best way to get started with PipeDent is to run the
  demo with two simple commands
</p>
<pre>
  git clone git@github.com:showell/PipeDent.git
  cd PipeDent && open demo.htm 
</pre>
<p>For usage in the browser, follow the model of example.htm.</p>
<p>For usage on the server, follow the model of example.coffee.</p>
<p>For command-line conversion, see convert.coffee.</p>
<pre>
  ~/WORKSPACE/PipeDent > coffee -c example.coffee && node example.js
  <h1>Hello World</h1>

  ~/WORKSPACE/PipeDent > echo "h1 | Hello World" > /tmp/foo.pipedent && node convert.js /tmp/foo.pipedent
  <h1>Hello World</h1>
</pre>


