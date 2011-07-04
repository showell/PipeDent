<h1>Overview</h1>
<div id="overview">
  <p>
    PipeDent is a tool for creating HTML with small snippets
    of text that provide the semantics of HTML without the
    syntax.  It is implemented in Coffeescript.
  </p>
  <p>
    You can run it from the browser or run it from node.js.
  </p>
</div>
<h1>Syntax</h1>
<ul>
  <li>
    Use indentation for HTML blocks.  (Use PASS for empty blocks.)
  </li>
  <li>
    Use pipes to separate markup from content.  Content goes to
    the right of pipes.
  </li>
</ul>
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
<p>To convert files from the command line, see convert.js.</p>
<p>
  Once you are ready to create your own programs, install
  pipedent.js on your web server or in a place where your
  node.js programs can find it.
</p>
<h1>Examples    </h1>
<p>
  See the Installation instructions for how to run the demo program.
</p>
<p>
  You can see a full example here:
</p>
<p>
  <a href="https://github.com/showell/PipeDent/blob/master/build_readme/build.coffee">Building a Readme dynamically</a>
</p>
<p>
  Here is an example PipeDent translation:
</p>
<div>
  <h2>INPUT</h2>
  <pre id="input">h1 | Overview
div id="overview"
  p
    | PipeDent is a tool for creating HTML with small snippets
    | of text that provide the semantics of HTML without the
    | syntax.  It is implemented in Coffeescript.
  p
    | You can run it from the browser or run it from node.js.
h1 | Syntax
ul
  li
    | Use indentation for HTML blocks.  (Use PASS for empty blocks.)
  li
    | Use pipes to separate markup from content.  Content goes to
    | the right of pipes.
h1 | Installation
p
  | The best way to get started with PipeDent is to run the
  | demo with two simple commands
pre
  | git clone git@github.com:showell/PipeDent.git
  | cd PipeDent && open demo.htm 
p | For usage in the browser, follow the model of example.htm.
p | For usage on the server, follow the model of example.coffee.
p | To convert files from the command line, see convert.js.
p
  | Once you are ready to create your own programs, install
  | pipedent.js on your web server or in a place where your
  | node.js programs can find it.
h1 | Examples    
p
  See the Installation instructions for how to run the demo program.
p
  | You can see a full example here:
p
  a href="https://github.com/showell/PipeDent/blob/master/build_readme/build.coffee" | Building a Readme dynamically
p
  | Here is an example PipeDent translation:
div
  h2 | INPUT
  pre id="input"
    PASS
div
  h2 | HTML OUTPUT
  pre id="output"
    PASS</pre>
</div>
<div>
  <h2>HTML OUTPUT</h2>
  <pre id="output">&lt;h1&gt;Overview&lt;/h1&gt;
&lt;div id="overview"&gt;
  &lt;p&gt;
    PipeDent is a tool for creating HTML with small snippets
    of text that provide the semantics of HTML without the
    syntax.  It is implemented in Coffeescript.
  &lt;/p&gt;
  &lt;p&gt;
    You can run it from the browser or run it from node.js.
  &lt;/p&gt;
&lt;/div&gt;
&lt;h1&gt;Syntax&lt;/h1&gt;
&lt;ul&gt;
  &lt;li&gt;
    Use indentation for HTML blocks.  (Use PASS for empty blocks.)
  &lt;/li&gt;
  &lt;li&gt;
    Use pipes to separate markup from content.  Content goes to
    the right of pipes.
  &lt;/li&gt;
&lt;/ul&gt;
&lt;h1&gt;Installation&lt;/h1&gt;
&lt;p&gt;
  The best way to get started with PipeDent is to run the
  demo with two simple commands
&lt;/p&gt;
&lt;pre&gt;
  git clone git@github.com:showell/PipeDent.git
  cd PipeDent &amp;&amp; open demo.htm 
&lt;/pre&gt;
&lt;p&gt;For usage in the browser, follow the model of example.htm.&lt;/p&gt;
&lt;p&gt;For usage on the server, follow the model of example.coffee.&lt;/p&gt;
&lt;p&gt;To convert files from the command line, see convert.js.&lt;/p&gt;
&lt;p&gt;
  Once you are ready to create your own programs, install
  pipedent.js on your web server or in a place where your
  node.js programs can find it.
&lt;/p&gt;
&lt;h1&gt;Examples    &lt;/h1&gt;
&lt;p&gt;
  See the Installation instructions for how to run the demo program.
&lt;/p&gt;
&lt;p&gt;
  You can see a full example here:
&lt;/p&gt;
&lt;p&gt;
  &lt;a href="https://github.com/showell/PipeDent/blob/master/build_readme/build.coffee"&gt;Building a Readme dynamically&lt;/a&gt;
&lt;/p&gt;
&lt;p&gt;
  Here is an example PipeDent translation:
&lt;/p&gt;
&lt;div&gt;
  &lt;h2&gt;INPUT&lt;/h2&gt;
  &lt;pre id="input"&gt;
  &lt;/pre&gt;
&lt;/div&gt;
&lt;div&gt;
  &lt;h2&gt;HTML OUTPUT&lt;/h2&gt;
  &lt;pre id="output"&gt;
  &lt;/pre&gt;
&lt;/div&gt;
</pre>
</div>

