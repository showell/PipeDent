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
<h1>Example</h1>
<table id="example" border="1">
  <tr valign="top">
    <td id="input">
      <h2>INPUT</h2>
      <pre>h1 | Overview
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
h1 | Example
table id="example" border=1
  tr valign="top"
    td id="input"
      h2 | INPUT
      pre
        PASS
    td id="output"
      h2 | HTML OUTPUT
      pre
        PASS</pre>
    </td>
    <td id="output">
      <h2>HTML OUTPUT</h2>
      <pre>&lt;h1&gt;Overview&lt;/h1&gt;
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
&lt;h1&gt;Example&lt;/h1&gt;
&lt;table id="example" border=1&gt;
  &lt;tr valign="top"&gt;
    &lt;td id="input"&gt;
      &lt;h2&gt;INPUT&lt;/h2&gt;
      &lt;pre&gt;
      &lt;/pre&gt;
    &lt;/td&gt;
    &lt;td id="output"&gt;
      &lt;h2&gt;HTML OUTPUT&lt;/h2&gt;
      &lt;pre&gt;
      &lt;/pre&gt;
    &lt;/td&gt;
  &lt;/tr&gt;
&lt;/table&gt;
</pre>
    </td>
  </tr>
</table>

