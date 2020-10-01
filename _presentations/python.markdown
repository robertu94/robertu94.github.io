---
title: "Python: A Parser Tongue Primer"
layout: presentation
location: Clemson ACM Seminar
date: 2016-04-01
description: >
  An introduction to idiomatic python programming for new computer science students.
video: https://youtu.be/yzILULoVQzg
...
<section id="python" class="title-slide slide level1">
<h1>Python</h1>
<p>A Parser Tongue Primer</p>
</section>

<section>
<section id="brought-to-you-by-clemson-acm" class="title-slide slide level1">
<h1>Brought to you by Clemson ACM</h1>
<p>We’re on Freenode! Join <code>#clemsonacm</code> on chat.freenode.net!</p>
</section>
<section id="speakers" class="slide level2">
<h2>Speakers:</h2>
<p>Robert Underwood - ACM Vice President</p>
</section></section>
<section id="coming-up" class="title-slide slide level1">
<h1>Coming Up</h1>
<ul>
<li>The Zen of Python</li>
<li>Imperative programming</li>
<li>Functional programming</li>
<li>String Parsing</li>
<li>Object Oriented</li>
<li>Learning more</li>
</ul>
</section>

<section>
<section id="getting-into-the-zen-of-python" class="title-slide slide level1">
<h1>Getting into the Zen of Python</h1>

</section>
<section id="getting-started" class="slide level2">
<h2>Getting Started</h2>
<ul>
<li>Which version of python?
<ul>
<li>I recommend python3.X</li>
<li>Provided setup from class is python 2.7</li>
</ul></li>
<li>Which interpreter?
<ul>
<li>I recommend ipython for development</li>
</ul></li>
</ul>
</section>
<section id="the-zen-of-python" class="slide level2">
<h2>The Zen of Python</h2>
<p><code>import this</code></p>
<ul>
<li>“Beautiful is better than ugly”</li>
<li>“Simple is better than complex”</li>
<li>“There should be one obvious way to do it”</li>
</ul>
</section></section>
<section>
<section id="imperative-programming" class="title-slide slide level1">
<h1>Imperative Programming</h1>

</section>
<section id="variables" class="slide level2">
<h2>Variables</h2>
<ul>
<li>Python uses duck typing</li>
<li>Immutable Types
<ul>
<li>None, int, float, bool,</li>
<li>tuple, complex, str</li>
<li>function</li>
</ul></li>
<li>Mutable Types
<ul>
<li>dictionary, lists</li>
</ul></li>
</ul>
</section>
<section id="container-types" class="slide level2">
<h2>Container Types</h2>
<ul>
<li>Dictionary - Mutable set unique of keys to values</li>
<li>Set - Mutable set of unique keys</li>
<li>List - Mutable ordered list</li>
<li>Tuple - Immutable version of a list</li>
<li>See <code>collections</code> for more examples</li>
</ul>
</section>
<section id="what-is-true" class="slide level2">
<h2>What is True?</h2>
<ul>
<li>0, False, and None are False</li>
<li>Everything else is True</li>
</ul>
</section>
<section id="conditionals" class="slide level2">
<h2>Conditionals</h2>
<div class="sourceCode" id="cb1"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb1-1"><a href="#cb1-1" aria-hidden="true"></a><span class="cf">if</span> x <span class="op">==</span> <span class="dv">1</span> <span class="kw">or</span> y <span class="op">==</span> <span class="dv">2</span>:</span>
<span id="cb1-2"><a href="#cb1-2" aria-hidden="true"></a>    <span class="bu">print</span>(x)</span>
<span id="cb1-3"><a href="#cb1-3" aria-hidden="true"></a><span class="cf">elif</span> x <span class="kw">in</span> [<span class="dv">3</span>,<span class="dv">4</span>,<span class="dv">5</span>]:</span>
<span id="cb1-4"><a href="#cb1-4" aria-hidden="true"></a>    <span class="bu">print</span>(<span class="st">&quot;foo&quot;</span>, x)</span>
<span id="cb1-5"><a href="#cb1-5" aria-hidden="true"></a><span class="cf">else</span>:</span>
<span id="cb1-6"><a href="#cb1-6" aria-hidden="true"></a>    <span class="bu">print</span>(<span class="st">&quot;bar&quot;</span>)</span></code></pre></div>
</section>
<section id="looping" class="slide level2">
<h2>Looping</h2>
<div class="sourceCode" id="cb2"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb2-1"><a href="#cb2-1" aria-hidden="true"></a><span class="cf">for</span> a <span class="kw">in</span> <span class="bu">range</span>(<span class="dv">1</span>,<span class="dv">10</span>,<span class="dv">2</span>):</span>
<span id="cb2-2"><a href="#cb2-2" aria-hidden="true"></a>    <span class="bu">print</span>(a)</span>
<span id="cb2-3"><a href="#cb2-3" aria-hidden="true"></a>    <span class="cf">if</span> a <span class="op">==</span> <span class="dv">5</span>:</span>
<span id="cb2-4"><a href="#cb2-4" aria-hidden="true"></a>        <span class="cf">break</span></span>
<span id="cb2-5"><a href="#cb2-5" aria-hidden="true"></a><span class="cf">else</span>:</span>
<span id="cb2-6"><a href="#cb2-6" aria-hidden="true"></a>    <span class="bu">print</span>(<span class="st">&quot;never called&quot;</span>)</span></code></pre></div>
</section>
<section id="lists" class="slide level2">
<h2>Lists</h2>
<div class="sourceCode" id="cb3"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb3-1"><a href="#cb3-1" aria-hidden="true"></a>a <span class="op">=</span> [<span class="dv">1</span>,<span class="dv">2</span>,<span class="dv">3</span>,<span class="dv">4</span>,<span class="dv">5</span>]</span>
<span id="cb3-2"><a href="#cb3-2" aria-hidden="true"></a>a.append(<span class="dv">0</span>)</span>
<span id="cb3-3"><a href="#cb3-3" aria-hidden="true"></a>position <span class="op">=</span> a.index(<span class="dv">3</span>)</span>
<span id="cb3-4"><a href="#cb3-4" aria-hidden="true"></a><span class="cf">for</span> value <span class="kw">in</span> <span class="bu">sorted</span>(a):</span>
<span id="cb3-5"><a href="#cb3-5" aria-hidden="true"></a>    <span class="bu">print</span>(value)</span></code></pre></div>
</section>
<section id="dictionaries" class="slide level2">
<h2>Dictionaries</h2>
<div class="sourceCode" id="cb4"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb4-1"><a href="#cb4-1" aria-hidden="true"></a>a <span class="op">=</span> {</span>
<span id="cb4-2"><a href="#cb4-2" aria-hidden="true"></a>    <span class="st">&quot;a&quot;</span>: <span class="dv">1</span>,</span>
<span id="cb4-3"><a href="#cb4-3" aria-hidden="true"></a>    <span class="st">&quot;b&quot;</span>: <span class="dv">2</span>,</span>
<span id="cb4-4"><a href="#cb4-4" aria-hidden="true"></a>    <span class="st">&quot;c&quot;</span>: <span class="dv">3</span>,</span>
<span id="cb4-5"><a href="#cb4-5" aria-hidden="true"></a>}</span>
<span id="cb4-6"><a href="#cb4-6" aria-hidden="true"></a>a[<span class="st">&#39;a&#39;</span>] <span class="op">+=</span> <span class="dv">2</span></span>
<span id="cb4-7"><a href="#cb4-7" aria-hidden="true"></a>a[<span class="st">&#39;d&#39;</span>] <span class="op">=</span> <span class="dv">4</span></span>
<span id="cb4-8"><a href="#cb4-8" aria-hidden="true"></a>a.get(<span class="st">&#39;e&#39;</span>,<span class="dv">0</span>)</span>
<span id="cb4-9"><a href="#cb4-9" aria-hidden="true"></a><span class="cf">for</span> key <span class="kw">in</span> a:</span>
<span id="cb4-10"><a href="#cb4-10" aria-hidden="true"></a>    <span class="bu">print</span>(key,a[key])</span></code></pre></div>
</section>
<section id="functions" class="slide level2">
<h2>Functions</h2>
<div class="sourceCode" id="cb5"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb5-1"><a href="#cb5-1" aria-hidden="true"></a><span class="kw">def</span> add(a<span class="op">=</span><span class="dv">0</span>,b<span class="op">=</span><span class="dv">4</span>):</span>
<span id="cb5-2"><a href="#cb5-2" aria-hidden="true"></a>    <span class="co">&quot;returns the sum of a and b&quot;</span></span>
<span id="cb5-3"><a href="#cb5-3" aria-hidden="true"></a>    <span class="cf">return</span> a<span class="op">+</span>b</span>
<span id="cb5-4"><a href="#cb5-4" aria-hidden="true"></a></span>
<span id="cb5-5"><a href="#cb5-5" aria-hidden="true"></a>add()</span>
<span id="cb5-6"><a href="#cb5-6" aria-hidden="true"></a>add(<span class="dv">1</span>)</span>
<span id="cb5-7"><a href="#cb5-7" aria-hidden="true"></a>add(<span class="dv">1</span>,<span class="dv">1</span>)</span>
<span id="cb5-8"><a href="#cb5-8" aria-hidden="true"></a>add(b<span class="op">=</span><span class="dv">3</span>)</span>
<span id="cb5-9"><a href="#cb5-9" aria-hidden="true"></a>add(<span class="fl">1.0</span>,<span class="dv">2</span>)</span></code></pre></div>
</section>
<section id="functions-cont" class="slide level2">
<h2>Functions cont…</h2>
<p>You can also have lists of arguments</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb6-1"><a href="#cb6-1" aria-hidden="true"></a><span class="kw">def</span> add_all(<span class="op">*</span>args, <span class="op">**</span>kwargs):</span>
<span id="cb6-2"><a href="#cb6-2" aria-hidden="true"></a>    <span class="co">&quot;adds a arbitary sequence&quot;</span></span>
<span id="cb6-3"><a href="#cb6-3" aria-hidden="true"></a>    <span class="cf">for</span> key <span class="kw">in</span> kwargs:</span>
<span id="cb6-4"><a href="#cb6-4" aria-hidden="true"></a>        <span class="bu">print</span>(key, <span class="st">&quot;--&gt;&quot;</span>, kwargs[key])</span>
<span id="cb6-5"><a href="#cb6-5" aria-hidden="true"></a>    <span class="cf">return</span> <span class="bu">sum</span>(args)</span>
<span id="cb6-6"><a href="#cb6-6" aria-hidden="true"></a></span>
<span id="cb6-7"><a href="#cb6-7" aria-hidden="true"></a>add_all(<span class="dv">1</span>,<span class="dv">2</span>,<span class="dv">2</span>,<span class="dv">3</span>,<span class="dv">4</span>,<span class="dv">5</span>)</span>
<span id="cb6-8"><a href="#cb6-8" aria-hidden="true"></a>add_all(<span class="dv">1</span>,<span class="dv">2</span>, b<span class="op">=</span><span class="st">&quot;foo&quot;</span>, c<span class="op">=</span><span class="st">&quot;asdf&quot;</span>)</span></code></pre></div>
</section>
<section id="context-managers" class="slide level2">
<h2>Context Managers</h2>
<ul>
<li>Use when you change “contexts”
<ul>
<li>think open/close, connect/disconnect</li>
<li>Uses the <code>with</code> syntax</li>
<li>define <code>__enter__</code> and <code>__exit__</code></li>
</ul></li>
</ul>
<div class="sourceCode" id="cb7"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb7-1"><a href="#cb7-1" aria-hidden="true"></a><span class="cf">with</span> <span class="bu">open</span>(<span class="st">&quot;/path/to/file.txt&quot;</span>, <span class="st">&quot;w&quot;</span>) <span class="im">as</span> essay:</span>
<span id="cb7-2"><a href="#cb7-2" aria-hidden="true"></a>    essay.write(boring_paper)</span></code></pre></div>
</section></section>
<section>
<section id="functional-programming" class="title-slide slide level1">
<h1>Functional Programming</h1>

</section>
<section id="iterators" class="slide level2">
<h2>Iterators</h2>
<ul>
<li>Iterators are objects that define:
<ul>
<li>Represent a collection of objects</li>
<li><code>__iter__</code> and <code>__next__</code></li>
</ul></li>
<li>dictionaries, lists, sets are all iterators</li>
<li>Most standard functions accept iterators</li>
</ul>
</section>
<section id="generators" class="slide level2">
<h2>Generators</h2>
<ul>
<li>Generators are iterable functions that call yield</li>
<li>Generators <strong>can be</strong> more memory efficient</li>
</ul>
<div class="sourceCode" id="cb8"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb8-1"><a href="#cb8-1" aria-hidden="true"></a><span class="kw">def</span> count_by_3(x):</span>
<span id="cb8-2"><a href="#cb8-2" aria-hidden="true"></a>    x <span class="op">=</span> <span class="dv">0</span></span>
<span id="cb8-3"><a href="#cb8-3" aria-hidden="true"></a>    <span class="cf">while</span> <span class="va">True</span>:</span>
<span id="cb8-4"><a href="#cb8-4" aria-hidden="true"></a>        <span class="cf">yield</span> x<span class="op">+</span><span class="dv">3</span></span></code></pre></div>
</section>
<section id="operator" class="slide level2">
<h2>Operator</h2>
<ul>
<li>Python operators as functions</li>
<li>Useful in Lambda functions and comprehensions</li>
</ul>
<div class="sourceCode" id="cb9"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb9-1"><a href="#cb9-1" aria-hidden="true"></a><span class="im">from</span> operator <span class="im">import</span> add</span>
<span id="cb9-2"><a href="#cb9-2" aria-hidden="true"></a>x, y <span class="op">=</span> <span class="dv">1</span>, <span class="dv">2</span></span>
<span id="cb9-3"><a href="#cb9-3" aria-hidden="true"></a>x <span class="op">+</span> y <span class="op">==</span> add(x,y)</span></code></pre></div>
</section>
<section id="lambda-expressions" class="slide level2">
<h2>Lambda Expressions</h2>
<p>Simple “anonymous” functions</p>
<div class="sourceCode" id="cb10"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb10-1"><a href="#cb10-1" aria-hidden="true"></a>a <span class="op">=</span> [<span class="st">&quot;red&quot;</span>, <span class="st">&quot;orange&quot;</span>, <span class="st">&quot;yellow&quot;</span>, <span class="st">&quot;greeen&quot;</span>,</span>
<span id="cb10-2"><a href="#cb10-2" aria-hidden="true"></a>     <span class="st">&quot;blue&quot;</span>, <span class="st">&quot;indego&quot;</span> <span class="st">&quot;volit&quot;</span>]</span>
<span id="cb10-3"><a href="#cb10-3" aria-hidden="true"></a><span class="bu">sorted</span>(a, key<span class="op">=</span><span class="kw">lambda</span> x: <span class="bu">len</span>(x) <span class="op">%</span> <span class="dv">3</span>)</span>
<span id="cb10-4"><a href="#cb10-4" aria-hidden="true"></a></span>
<span id="cb10-5"><a href="#cb10-5" aria-hidden="true"></a>b <span class="op">=</span> <span class="bu">map</span>(<span class="kw">lambda</span> x: x<span class="op">+</span><span class="dv">1</span>, <span class="bu">range</span>(<span class="dv">10</span>))</span></code></pre></div>
</section>
<section id="comprehensions" class="slide level2">
<h2>Comprehensions</h2>
<p>Syntactic sugar for building collections</p>
<div class="sourceCode" id="cb11"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb11-1"><a href="#cb11-1" aria-hidden="true"></a>[i<span class="op">+</span><span class="dv">2</span> <span class="cf">for</span> i <span class="kw">in</span> <span class="bu">range</span>(<span class="dv">10</span>)] <span class="co">#Lists</span></span>
<span id="cb11-2"><a href="#cb11-2" aria-hidden="true"></a>{i<span class="op">+</span><span class="dv">2</span> <span class="cf">for</span> i <span class="kw">in</span> <span class="bu">range</span>(<span class="dv">10</span>)} <span class="co">#Sets</span></span>
<span id="cb11-3"><a href="#cb11-3" aria-hidden="true"></a>{i:i<span class="op">+</span><span class="dv">2</span> <span class="cf">for</span> i <span class="kw">in</span> <span class="bu">range</span>(<span class="dv">10</span>)} <span class="co">#Dictionaries</span></span>
<span id="cb11-4"><a href="#cb11-4" aria-hidden="true"></a>(i<span class="op">+</span><span class="dv">2</span> <span class="cf">for</span> i <span class="kw">in</span> <span class="bu">range</span>(<span class="dv">10</span>)) <span class="co">#Generators</span></span></code></pre></div>
</section>
<section id="functools" class="slide level2">
<h2>Functools</h2>
<p>Useful methods from functional programming</p>
<ul>
<li><code>map</code> built-ins</li>
<li><code>reduce</code> – used to be built-in now in functools</li>
<li><code>partial/partialmethod</code> – simplifying call signature</li>
<li><code>singledispatch</code> – overloading type generic functions</li>
<li><code>total_ordering</code> – writing comparisons</li>
</ul>
<div class="sourceCode" id="cb12"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb12-1"><a href="#cb12-1" aria-hidden="true"></a><span class="im">from</span> functools <span class="im">import</span> <span class="bu">reduce</span></span>
<span id="cb12-2"><a href="#cb12-2" aria-hidden="true"></a><span class="im">from</span> operator <span class="im">import</span> add</span>
<span id="cb12-3"><a href="#cb12-3" aria-hidden="true"></a>values <span class="op">=</span> <span class="bu">range</span>(<span class="dv">10</span>)</span>
<span id="cb12-4"><a href="#cb12-4" aria-hidden="true"></a><span class="bu">print</span>(<span class="bu">reduce</span>(add,values))</span></code></pre></div>
</section>
<section id="itertools" class="slide level2">
<h2>Itertools</h2>
<p>Working with iterators</p>
<ul>
<li><code>zip</code> – built-in</li>
<li><code>chain</code> – link iterators together</li>
<li><code>cycle</code> – repeat iterators infinitely</li>
<li><code>groupby</code> – return iterator of groups</li>
<li><code>zip_longest</code> – zip until longest iterator consumed</li>
</ul>
<div class="sourceCode" id="cb13"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb13-1"><a href="#cb13-1" aria-hidden="true"></a><span class="im">from</span> itertools <span class="im">import</span> cycle</span>
<span id="cb13-2"><a href="#cb13-2" aria-hidden="true"></a>jobs <span class="op">=</span> [<span class="dv">1</span>,<span class="dv">2</span>,<span class="dv">3</span>,<span class="dv">4</span>]</span>
<span id="cb13-3"><a href="#cb13-3" aria-hidden="true"></a>servers <span class="op">=</span> [<span class="st">&#39;a&#39;</span>,<span class="st">&#39;b&#39;</span>,<span class="st">&#39;c&#39;</span>]</span>
<span id="cb13-4"><a href="#cb13-4" aria-hidden="true"></a><span class="cf">for</span> job, server <span class="kw">in</span> <span class="bu">zip</span>(jobs, cycle(servers))</span>
<span id="cb13-5"><a href="#cb13-5" aria-hidden="true"></a>    <span class="bu">print</span> (job,<span class="st">&quot;--&gt;&quot;</span>, server)</span></code></pre></div>
</section></section>
<section>
<section id="string-parsing" class="title-slide slide level1">
<h1>String Parsing</h1>

</section>
<section id="several-types-of-strings" class="slide level2">
<h2>Several types of strings</h2>
<div class="sourceCode" id="cb14"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb14-1"><a href="#cb14-1" aria-hidden="true"></a>raw_string <span class="op">=</span> <span class="vs">r&#39;^\d+\s\S+$&#39;</span></span>
<span id="cb14-2"><a href="#cb14-2" aria-hidden="true"></a>double_quoted <span class="op">=</span> <span class="st">&quot;asdf</span><span class="ch">\n</span><span class="st">&quot;</span></span>
<span id="cb14-3"><a href="#cb14-3" aria-hidden="true"></a>single_quoted <span class="op">=</span> <span class="st">&#39;This is literal</span><span class="ch">\n</span><span class="st">&#39;</span></span>
<span id="cb14-4"><a href="#cb14-4" aria-hidden="true"></a>byte_string <span class="op">=</span> b<span class="st">&quot;asdf&quot;</span></span></code></pre></div>
</section>
<section id="str-methods" class="slide level2">
<h2>str methods</h2>
<ul>
<li>Strings are sequences!</li>
<li>Important methods
<ul>
<li>index – return first index of substring</li>
<li>split – separate on token</li>
<li>join – combine a list of str</li>
<li>upper/lower – capitalize or lowercase</li>
<li>startswith/endswith – compare prefix/suffixes</li>
</ul></li>
</ul>
<div class="sourceCode" id="cb15"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb15-1"><a href="#cb15-1" aria-hidden="true"></a>words <span class="op">=</span> [<span class="st">&quot;all&quot;</span>, <span class="st">&quot;you&quot;</span>, <span class="st">&quot;need&quot;</span>, <span class="st">&quot;is&quot;</span>, <span class="st">&quot;join&quot;</span></span>
<span id="cb15-2"><a href="#cb15-2" aria-hidden="true"></a><span class="st">&quot; &quot;</span>.join(s.title() <span class="cf">for</span> s <span class="kw">in</span> words)</span></code></pre></div>
</section>
<section id="ever-seen-this" class="slide level2">
<h2>Ever seen this?</h2>
<p>What on earth does this print??</p>
<div class="sourceCode" id="cb16"><pre class="sourceCode c"><code class="sourceCode c"><span id="cb16-1"><a href="#cb16-1" aria-hidden="true"></a>printf(<span class="st">&quot;%4d%c%c%g%15.4f %20s%n</span><span class="sc">\n</span><span class="st">&quot;</span>, ...);</span></code></pre></div>
</section>
<section id="format" class="slide level2">
<h2>Format()</h2>
<ul>
<li>Python has, printf() style formatting but…
<ul>
<li>It doesn’t handle collections well</li>
<li>Doesn’t solve the fundamental readability problem</li>
</ul></li>
<li>format() is more powerful and more readable</li>
</ul>
<div class="sourceCode" id="cb17"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb17-1"><a href="#cb17-1" aria-hidden="true"></a><span class="co">&quot;Welcome {user}, today is {date:%B %d, %Y}&quot;</span><span class="op">\</span></span>
<span id="cb17-2"><a href="#cb17-2" aria-hidden="true"></a>    .<span class="bu">format</span>(user<span class="op">=</span><span class="st">&quot;Mr. President&quot;</span>, date<span class="op">=</span>datetime.date.today())</span></code></pre></div>
</section>
<section id="regular-expressions" class="slide level2">
<h2>Regular Expressions</h2>
<ul>
<li>Mostly Perl compatible regular expressions
<ul>
<li>Notably the <code>?{}</code> syntax is absent</li>
<li>Useful when str doesn’t quite cut it</li>
<li><em>DONT USE IT TO PARSE <a href="http://stackoverflow.com/questions/1732348/regex-match-open-tags-except-xhtml-self-contained-tags/">HTML</a></em></li>
</ul></li>
</ul>
<div class="sourceCode" id="cb18"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb18-1"><a href="#cb18-1" aria-hidden="true"></a><span class="im">import</span> re</span>
<span id="cb18-2"><a href="#cb18-2" aria-hidden="true"></a>pattern <span class="op">=</span> re.<span class="bu">compile</span>(<span class="vs">r&quot;^(\d+)\s+([a-z]*)\s+$&quot;</span>)</span>
<span id="cb18-3"><a href="#cb18-3" aria-hidden="true"></a><span class="cf">with</span> <span class="bu">open</span>(<span class="st">&quot;example.txt&quot;</span>) <span class="im">as</span> infile:</span>
<span id="cb18-4"><a href="#cb18-4" aria-hidden="true"></a>    <span class="cf">for</span> match <span class="kw">in</span> pattern.finditer(infile.read()):</span>
<span id="cb18-5"><a href="#cb18-5" aria-hidden="true"></a>        <span class="bu">print</span>(match.group(<span class="dv">1</span>), match.group(<span class="dv">2</span>))</span></code></pre></div>
</section>
<section id="well-known-formats" class="slide level2">
<h2>Well known formats</h2>
<ul>
<li>csv, xml, html, and json have parsers</li>
<li>Parsers for yaml and other common formats exist
<ul>
<li>If using xml consider <code>defuesedxml</code></li>
<li>If using html consider “Beautiful Soup” a.k.a <code>bs4</code></li>
</ul></li>
</ul>
<div class="sourceCode" id="cb19"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb19-1"><a href="#cb19-1" aria-hidden="true"></a><span class="im">import</span> csv</span>
<span id="cb19-2"><a href="#cb19-2" aria-hidden="true"></a><span class="kw">def</span> parse_csv_line(line):</span>
<span id="cb19-3"><a href="#cb19-3" aria-hidden="true"></a>    <span class="co">&quot;&quot;&quot;parse a stirng of csv that is NOT in a file&quot;&quot;&quot;</span></span>
<span id="cb19-4"><a href="#cb19-4" aria-hidden="true"></a>    reader <span class="op">=</span> csv.reader(line.splitlines())</span>
<span id="cb19-5"><a href="#cb19-5" aria-hidden="true"></a>    <span class="cf">for</span> entry <span class="kw">in</span> reader:</span>
<span id="cb19-6"><a href="#cb19-6" aria-hidden="true"></a>        yeild entry</span></code></pre></div>
</section></section>
<section>
<section id="object-oriented-programming" class="title-slide slide level1">
<h1>Object Oriented Programming</h1>

</section>
<section id="classes" class="slide level2">
<h2>Classes</h2>
<ul>
<li>Not like classes in other languages</li>
<li>Classes are <em>only</em> a tool for code reuse</li>
<li>DRY – Don’t Repeat Yourself</li>
<li>There is nothing sacred about it</li>
</ul>
</section>
<section id="how-are-they-different" class="slide level2">
<h2>How are they different?</h2>
<ul>
<li>Constructor is called <code>__init__</code></li>
<li>All methods need to be passed <code>self</code></li>
<li>No such thing as private
<ul>
<li><code>_non_public</code> - avoid using this method</li>
<li><code>__mangeled</code> - do not subclass this method</li>
</ul></li>
</ul>
</section>
<section id="multiple-inheritance" class="slide level2">
<h2>Multiple Inheritance</h2>
<ul>
<li>Multiple Inheritance via <code>super()</code>
<ul>
<li><code>super()</code> delegates to the next in line</li>
<li>Remember the Method Resolution Order (MRO)
<ul>
<li>children are called before parents</li>
<li>order in class declaration breaks ties</li>
</ul></li>
</ul></li>
</ul>
</section>
<section id="decorator-objects" class="slide level2">
<h2>Decorator Objects</h2>
<ul>
<li>Implement the decorator function with ease</li>
<li>Decorators work “inside out”</li>
</ul>
<div class="sourceCode" id="cb20"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb20-1"><a href="#cb20-1" aria-hidden="true"></a><span class="im">import</span> logging</span>
<span id="cb20-2"><a href="#cb20-2" aria-hidden="true"></a><span class="kw">def</span> log_entry_exit(orig):</span>
<span id="cb20-3"><a href="#cb20-3" aria-hidden="true"></a>    <span class="co">&quot;&quot;&quot;adds logging a function&quot;&quot;&quot;</span></span>
<span id="cb20-4"><a href="#cb20-4" aria-hidden="true"></a></span>
<span id="cb20-5"><a href="#cb20-5" aria-hidden="true"></a>    <span class="kw">def</span> logged_function(<span class="op">*</span>args, <span class="op">**</span>kwargs):</span>
<span id="cb20-6"><a href="#cb20-6" aria-hidden="true"></a>        logging.info(<span class="st">&quot;starting </span><span class="sc">%s</span><span class="st">&quot;</span>, orig.<span class="va">__name__</span>)</span>
<span id="cb20-7"><a href="#cb20-7" aria-hidden="true"></a>        orig(<span class="op">*</span>args, <span class="op">**</span>kwargs)</span>
<span id="cb20-8"><a href="#cb20-8" aria-hidden="true"></a>        logging.info(<span class="st">&quot;exiting </span><span class="sc">%s</span><span class="st">&quot;</span>, orig.<span class="va">__name__</span>)</span>
<span id="cb20-9"><a href="#cb20-9" aria-hidden="true"></a></span>
<span id="cb20-10"><a href="#cb20-10" aria-hidden="true"></a>    <span class="cf">return</span> logged_function</span>
<span id="cb20-11"><a href="#cb20-11" aria-hidden="true"></a></span>
<span id="cb20-12"><a href="#cb20-12" aria-hidden="true"></a><span class="at">@log_entry_exit</span></span>
<span id="cb20-13"><a href="#cb20-13" aria-hidden="true"></a><span class="kw">def</span> print_wrapper(a):</span>
<span id="cb20-14"><a href="#cb20-14" aria-hidden="true"></a>    <span class="bu">print</span>(a)</span></code></pre></div>
</section>
<section id="properties" class="slide level2">
<h2>Properties</h2>
<p>Functions exposed as variables</p>
<ul>
<li>Useful for:
<ul>
<li>simpler code</li>
<li>ensuring data integrity</li>
<li>controlling access (ie locking)</li>
</ul></li>
</ul>
</section>
<section id="an-example" class="slide level2">
<h2>An Example</h2>
<div class="sourceCode" id="cb21"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb21-1"><a href="#cb21-1" aria-hidden="true"></a><span class="kw">class</span> Square():</span>
<span id="cb21-2"><a href="#cb21-2" aria-hidden="true"></a>    <span class="kw">def</span> <span class="fu">__init__</span>(<span class="va">self</span>, side<span class="op">=</span><span class="dv">0</span>):</span>
<span id="cb21-3"><a href="#cb21-3" aria-hidden="true"></a>        <span class="va">self</span>.side <span class="op">=</span> side</span>
<span id="cb21-4"><a href="#cb21-4" aria-hidden="true"></a></span>
<span id="cb21-5"><a href="#cb21-5" aria-hidden="true"></a>    <span class="at">@property</span></span>
<span id="cb21-6"><a href="#cb21-6" aria-hidden="true"></a>    <span class="kw">def</span> area(<span class="va">self</span>):</span>
<span id="cb21-7"><a href="#cb21-7" aria-hidden="true"></a>        <span class="co">&quot;area of a square&quot;</span></span>
<span id="cb21-8"><a href="#cb21-8" aria-hidden="true"></a>        <span class="cf">return</span> side <span class="op">**</span> <span class="dv">2</span></span>
<span id="cb21-9"><a href="#cb21-9" aria-hidden="true"></a></span>
<span id="cb21-10"><a href="#cb21-10" aria-hidden="true"></a>    <span class="at">@area.setter</span></span>
<span id="cb21-11"><a href="#cb21-11" aria-hidden="true"></a>    <span class="kw">def</span> area(<span class="va">self</span>, a):</span>
<span id="cb21-12"><a href="#cb21-12" aria-hidden="true"></a>        side <span class="op">=</span> math.sqrt(a)</span>
<span id="cb21-13"><a href="#cb21-13" aria-hidden="true"></a></span>
<span id="cb21-14"><a href="#cb21-14" aria-hidden="true"></a>a <span class="op">=</span> Square()</span>
<span id="cb21-15"><a href="#cb21-15" aria-hidden="true"></a>a.area <span class="op">=</span> <span class="dv">25</span></span>
<span id="cb21-16"><a href="#cb21-16" aria-hidden="true"></a>a.area</span></code></pre></div>
</section>
<section id="method-types" class="slide level2">
<h2>Method Types</h2>
<ul>
<li>method – normal methods</li>
<li><code>classmethod</code> – provide alternative constructors</li>
<li><code>staticmethod</code> – conceptually related functionality</li>
<li><code>raise UnimplementedError</code> to force implementation</li>
</ul>
</section>
<section id="down-the-rabbit-hole" class="slide level2">
<h2>Down the Rabbit hole</h2>
<ul>
<li>Magic Methods
<ul>
<li>Allow for operator overloading</li>
<li>Used for singletons, decorators, callable-classes</li>
</ul></li>
<li>Objects can be callable
<ul>
<li>Simply define the <code>__call__</code> method</li>
</ul></li>
<li>Every object is a dictionary
<ul>
<li>Introspection - get information about a class</li>
<li>Meta-classes - create a class of classes (ie black magic)</li>
</ul></li>
</ul>
</section>
<section id="a-quick-note-on-modules" class="slide level2">
<h2>A quick note on modules</h2>
<ul>
<li>Python has a module for everything or soon will
<ul>
<li>First check the standard library</li>
<li>Then check PyPI</li>
</ul></li>
<li>You can even make your own <a href="http://python-packaging.readthedocs.org/en/latest/minimal.html">modules!</a></li>
</ul>
</section></section>
<section id="further-resources" class="title-slide slide level1">
<h1>Further Resources</h1>
<ul>
<li><a href="http://www.diveintopython.net/">Dive Into Python</a></li>
<li><a href="http://www.diveintopython3.net/">Dive Into Python 3</a></li>
<li><a href="https://docs.python.org">Standard Library Reference</a></li>
<li>PyCon Talks on YouTube
<ul>
<li><a href="https//www.youtube.com/results?search_query=raymond-hettinger">Raymond Hettinger</a></li>
<li><a href="https://www.youtube.com/watch?v=cSbD5SKwak0">Decorators Context Managers</a></li>
</ul></li>
<li>the <code>help()</code> function or <code>?</code> and <code>??</code></li>
</ul>
</section>

<section id="questions" class="title-slide slide level1">
<h1>Questions</h1>
<p>Send feedback to acm@cs.clemson.edu</p>
<p>This material available under <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC By-SA 4.0</a></p>
</section>
