---
title: Provisioning at the Speed of Thought
layout: presentation
location: Clemson ACM Technology Seminar
date: 2016-10-01
Summary: >
  Ever sit down to setup a set of computers and wonder, “why on earth do I have to do this manually on each and every node?” Writing scripts can solve the problem, but handling error is annoying and time consuming. It does not have to be that way. Configuration management tools such as Ansible, SaltStack, and Puppet take the pain out of managing small to large groups of computers. By the end of the presentation, You’ll learn some of the strengths and weaknesses of each so that you can decide which tool will fit your needs.
video: https://youtu.be/cEEXpQaXUyg
---
<section>
<section id="provisioning-at-the-speed-of-thought" class="title-slide slide level1">
<h1>Provisioning At the Speed of Thought</h1>
<ul>
<li>An Intro to Ansible, Salt, and Puppet *</li>
</ul>
</section>
<section id="speakers" class="slide level2">
<h2>Speakers:</h2>
<p>Robert Underwood - ACM Vice President</p>
</section></section>
<section id="overview" class="title-slide slide level1">
<h1>Overview</h1>
<ol type="1">
<li>Why provisioning?</li>
<li>What is provisioning?</li>
<li>How can I get started?
<ul>
<li>Puppet</li>
<li>Ansible</li>
<li>Salt</li>
</ul></li>
</ol>
</section>

<section id="why-provisioning" class="title-slide slide level1">
<h1>Why provisioning?</h1>
<ul>
<li>How long does it take to install a machine?</li>
<li>What if you get a new machine?</li>
<li>What if you have 5, 10, 100, or more?</li>
<li>Ever forget to install updates?</li>
</ul>
</section>

<section id="what-is-provisioning" class="title-slide slide level1">
<h1>What is provisioning?</h1>
<ul>
<li>Manage files, users, and software</li>
<li>Discover facts about managed systems</li>
<li>Create “cloud” and “virtual” resources</li>
<li>Install automatically on new machines</li>
</ul>
</section>

<section id="how-do-i-get-started" class="title-slide slide level1">
<h1>How do I get started?</h1>

</section>

<section>
<section id="puppet" class="title-slide slide level1">
<h1>Puppet</h1>
<ul>
<li>Written in Ruby</li>
<li>Master/Agent architecture</li>
<li><strong>Out of Order</strong> Processing</li>
<li>Configured in <code>puppet</code>
<ul>
<li>Mix of Object Oriented and Declarative</li>
</ul></li>
</ul>
</section>
<section id="puppet-specs---basics" class="slide level2">
<h2>Puppet Specs - Basics</h2>
<pre class="puppet"><code>user { &#39;acm&#39;:
    ensure =&gt; &#39;present&#39;,
    managehome =&gt; true
    shell =&gt; &#39;bash&#39;,
    group =&gt; &#39;acm&#39;,
    requires =&gt; Group[&#39;acm&#39;]
}
group { &#39;acm&#39;: 
    ensure =&gt; &#39;present&#39;
}</code></pre>
</section>
<section id="puppet-specs---collectors" class="slide level2">
<h2>Puppet Specs - Collectors</h2>
<pre class="puppet"><code>$users = [&#39;acm&#39;, &#39;foo&#39;, &#39;bar&#39;]
group { &#39;acm&#39;: 
    ensure =&gt; &#39;present&#39;
}
user { $users:
    ensure =&gt; &#39;present&#39;,
    managehome =&gt; true
    shell =&gt; &#39;bash&#39;,
    group =&gt; &#39;acm&#39;,
}
Group &lt;||&gt; -&gt; User &lt;||&gt;</code></pre>
</section>
<section id="puppet-specs---packages" class="slide level2">
<h2>Puppet Specs - Packages</h2>
<pre class="puppet"><code>$gvim_package = osfamily ? {
    &#39;RedHat&#39; =&gt; &quot;vim-X11&quot;,
    &#39;Debian&#39; =&gt; &quot;vim-gtk3&quot;,
    default  =&gt; &quot;gvim&quot;
}
package { &#39;gvim&#39;:
    name =&gt; $gvim_package,
    ensure =&gt; &#39;latest&#39;
}</code></pre>
</section>
<section id="puppet-specs---services" class="slide level2">
<h2>Puppet Specs - Services</h2>
<pre class="puppet"><code>file {&#39;/etc/ssh/sshd_config&#39;:
    ensure =&gt; file,
    owner =&gt; &#39;root&#39;,
    group =&gt; &#39;root&#39;,
    mode =&gt; &#39;0644&#39;,
    contents =&gt; template(&quot;sshd_config.erb&quot;),
    notify =&gt; Service[&#39;sshd&#39;]
}
service {&#39;sshd&#39;:
    ensure =&gt; running,
    enable =&gt; true
    subscribe =&gt; File[&#39;/etc/ssh/sshd_config&#39;]
}</code></pre>
</section>
<section id="external-facts---common-code" class="slide level2">
<h2>External Facts - Common Code</h2>
<div class="sourceCode" id="cb5"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb5-1"><a href="#cb5-1" aria-hidden="true"></a><span class="im">from</span> subprocess <span class="im">import</span> Popen, PIPE</span>
<span id="cb5-2"><a href="#cb5-2" aria-hidden="true"></a><span class="kw">def</span> git_version()</span>
<span id="cb5-3"><a href="#cb5-3" aria-hidden="true"></a>    <span class="co">&quot;&quot;&quot;Get the git version&quot;&quot;&quot;</span></span>
<span id="cb5-4"><a href="#cb5-4" aria-hidden="true"></a>    <span class="cf">try</span>: </span>
<span id="cb5-5"><a href="#cb5-5" aria-hidden="true"></a>        p <span class="op">=</span> Popen([<span class="st">&#39;git&#39;</span>, <span class="st">&#39;--version&#39;</span>, stdout<span class="op">=</span>PIPE, stderr<span class="op">=</span>PIPE)</span>
<span id="cb5-6"><a href="#cb5-6" aria-hidden="true"></a>        out, _ <span class="op">=</span> p.communicate()</span>
<span id="cb5-7"><a href="#cb5-7" aria-hidden="true"></a>    <span class="cf">except</span> <span class="pp">OSError</span>:</span>
<span id="cb5-8"><a href="#cb5-8" aria-hidden="true"></a>        out <span class="op">=</span> <span class="st">u&#39;0.0.0&#39;</span></span>
<span id="cb5-9"><a href="#cb5-9" aria-hidden="true"></a>    version_str <span class="op">=</span> out.split()[<span class="dv">2</span>].decode()</span>
<span id="cb5-10"><a href="#cb5-10" aria-hidden="true"></a>    major, minor, patch <span class="op">=</span> [<span class="bu">int</span>(i) <span class="cf">for</span> i <span class="kw">in</span> version_str.split(<span class="st">&#39;.&#39;</span>)][:<span class="dv">3</span>]</span>
<span id="cb5-11"><a href="#cb5-11" aria-hidden="true"></a>    <span class="cf">return</span> {</span>
<span id="cb5-12"><a href="#cb5-12" aria-hidden="true"></a>        <span class="st">&quot;major&quot;</span> : major,</span>
<span id="cb5-13"><a href="#cb5-13" aria-hidden="true"></a>        <span class="st">&quot;minor&quot;</span> : minor,</span>
<span id="cb5-14"><a href="#cb5-14" aria-hidden="true"></a>        <span class="st">&quot;patch&quot;</span> : patch,</span>
<span id="cb5-15"><a href="#cb5-15" aria-hidden="true"></a>        <span class="st">&quot;version_str&quot;</span> : version_str</span>
<span id="cb5-16"><a href="#cb5-16" aria-hidden="true"></a>    }</span></code></pre></div>
</section>
<section id="external-facts" class="slide level2">
<h2>External Facts</h2>
<div class="sourceCode" id="cb6"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb6-1"><a href="#cb6-1" aria-hidden="true"></a><span class="co">#!/usr/bin/env python</span></span>
<span id="cb6-2"><a href="#cb6-2" aria-hidden="true"></a><span class="im">from</span> __future__ <span class="im">import</span> print_function</span>
<span id="cb6-3"><a href="#cb6-3" aria-hidden="true"></a>facts <span class="op">=</span> git_version()</span>
<span id="cb6-4"><a href="#cb6-4" aria-hidden="true"></a><span class="cf">for</span> key <span class="kw">in</span> facts:</span>
<span id="cb6-5"><a href="#cb6-5" aria-hidden="true"></a>    <span class="bu">print</span>(<span class="st">&quot;</span><span class="sc">%s</span><span class="st">=</span><span class="sc">%s</span><span class="st">&quot;</span> <span class="op">%</span> (key, facts[key]))</span></code></pre></div>
</section></section>
<section id="puppet-modules" class="title-slide slide level1">
<h1>Puppet Modules</h1>
<p><code>puppet module generate mymodule</code> + <code>mymodule</code> + <code>manifests</code> - puppet files + <code>files</code> - static files to serve + <code>templates</code> - templated files to serve + <code>lib</code> - custom facts and types + <code>facts.d</code> - non-ruby facts + <code>examples</code> - test cases for manifests + <code>spec</code> - tests for plugins</p>
</section>

<section id="the-good" class="title-slide slide level1">
<h1>The Good</h1>
<ul>
<li>Better for weird systems</li>
<li>Most community modules: forge</li>
<li>Out-of-Order processing</li>
<li>Apache Licensed</li>
</ul>
</section>

<section id="the-bad" class="title-slide slide level1">
<h1>The Bad</h1>
<ul>
<li>Ruby</li>
<li>Out-of-Order processing</li>
<li>Documentation</li>
</ul>
</section>

<section>
<section id="ansible" class="title-slide slide level1">
<h1>Ansible</h1>
<ul>
<li>Written in Python 2.7.X but moving to 3.X</li>
<li>Agentless architecture
<ul>
<li>Requires only Python 2.7 and OpenSSH Server</li>
</ul></li>
<li><strong>In Order</strong> processing with dependencies</li>
<li>Configured in <code>yaml</code> and <code>jinja</code></li>
</ul>
</section>
<section id="ansible-play-books---basics" class="slide level2">
<h2>Ansible Play Books - Basics</h2>
<div class="sourceCode" id="cb7"><pre class="sourceCode yaml"><code class="sourceCode yaml"><span id="cb7-1"><a href="#cb7-1" aria-hidden="true"></a><span class="pp">---</span></span>
<span id="cb7-2"><a href="#cb7-2" aria-hidden="true"></a><span class="kw">-</span><span class="at">   </span><span class="fu">hosts</span><span class="kw">:</span><span class="at"> all</span></span>
<span id="cb7-3"><a href="#cb7-3" aria-hidden="true"></a><span class="at">    </span><span class="fu">tasks</span><span class="kw">:</span></span>
<span id="cb7-4"><a href="#cb7-4" aria-hidden="true"></a><span class="at">    </span><span class="kw">-</span><span class="at"> </span><span class="fu">name</span><span class="kw">:</span><span class="at"> create acm group</span></span>
<span id="cb7-5"><a href="#cb7-5" aria-hidden="true"></a><span class="at">      </span><span class="fu">group</span><span class="kw">:</span><span class="at"> name=acm state=present</span></span>
<span id="cb7-6"><a href="#cb7-6" aria-hidden="true"></a><span class="at">    </span><span class="kw">-</span><span class="at"> </span><span class="fu">name</span><span class="kw">:</span><span class="at"> create users</span></span>
<span id="cb7-7"><a href="#cb7-7" aria-hidden="true"></a><span class="at">      </span><span class="fu">user</span><span class="kw">:</span><span class="at"> name=&quot;{{item}}&quot; state=present</span></span>
<span id="cb7-8"><a href="#cb7-8" aria-hidden="true"></a><span class="at">      </span><span class="fu">with_items</span><span class="kw">:</span></span>
<span id="cb7-9"><a href="#cb7-9" aria-hidden="true"></a><span class="at">        </span><span class="kw">-</span><span class="at"> </span><span class="st">&quot;acm&quot;</span></span>
<span id="cb7-10"><a href="#cb7-10" aria-hidden="true"></a><span class="at">        </span><span class="kw">-</span><span class="at"> </span><span class="st">&quot;foo&quot;</span></span>
<span id="cb7-11"><a href="#cb7-11" aria-hidden="true"></a><span class="at">        </span><span class="kw">-</span><span class="at"> </span><span class="st">&quot;bar&quot;</span></span></code></pre></div>
</section>
<section id="ansible-play-books---packages" class="slide level2">
<h2>Ansible Play Books - Packages</h2>
<div class="sourceCode" id="cb8"><pre class="sourceCode yaml"><code class="sourceCode yaml"><span id="cb8-1"><a href="#cb8-1" aria-hidden="true"></a><span class="kw">-</span><span class="at"> </span><span class="fu">hosts</span><span class="kw">:</span><span class="at"> all</span></span>
<span id="cb8-2"><a href="#cb8-2" aria-hidden="true"></a><span class="at">  </span><span class="fu">tasks</span><span class="kw">:</span></span>
<span id="cb8-3"><a href="#cb8-3" aria-hidden="true"></a><span class="at">    </span><span class="kw">-</span><span class="at"> </span><span class="fu">name</span><span class="kw">:</span><span class="at"> install vim Debian</span></span>
<span id="cb8-4"><a href="#cb8-4" aria-hidden="true"></a><span class="at">      </span><span class="fu">package</span><span class="kw">:</span><span class="at"> name=vim-gtk3</span></span>
<span id="cb8-5"><a href="#cb8-5" aria-hidden="true"></a><span class="at">      </span><span class="fu">when</span><span class="kw">:</span><span class="at"> ansible_os_family == &#39;Debian&#39;</span></span>
<span id="cb8-6"><a href="#cb8-6" aria-hidden="true"></a><span class="at">    </span><span class="kw">-</span><span class="at"> </span><span class="fu">name</span><span class="kw">:</span><span class="at"> install vim RedHat</span></span>
<span id="cb8-7"><a href="#cb8-7" aria-hidden="true"></a><span class="at">      </span><span class="fu">package</span><span class="kw">:</span><span class="at"> name=vim-X11</span></span>
<span id="cb8-8"><a href="#cb8-8" aria-hidden="true"></a><span class="at">      </span><span class="fu">when</span><span class="kw">:</span><span class="at"> ansible_os_family == &#39;RedHat&#39;</span></span>
<span id="cb8-9"><a href="#cb8-9" aria-hidden="true"></a><span class="at">    </span><span class="kw">-</span><span class="at"> </span><span class="fu">name</span><span class="kw">:</span><span class="at"> install vim other</span></span>
<span id="cb8-10"><a href="#cb8-10" aria-hidden="true"></a><span class="at">      </span><span class="fu">package</span><span class="kw">:</span><span class="at"> name=vim-X11</span></span>
<span id="cb8-11"><a href="#cb8-11" aria-hidden="true"></a><span class="at">      </span><span class="fu">when</span><span class="kw">:</span><span class="at"> ansible_os_family != &#39;RedHat&#39; or ansible_os_family != &#39;Debian&#39;</span></span></code></pre></div>
</section>
<section id="ansible-specs---packages-better" class="slide level2">
<h2>Ansible Specs - Packages Better</h2>
<div class="sourceCode" id="cb9"><pre class="sourceCode yaml"><code class="sourceCode yaml"><span id="cb9-1"><a href="#cb9-1" aria-hidden="true"></a><span class="co">#in main.yaml</span></span>
<span id="cb9-2"><a href="#cb9-2" aria-hidden="true"></a><span class="pp">---</span></span>
<span id="cb9-3"><a href="#cb9-3" aria-hidden="true"></a><span class="kw">-</span><span class="at"> </span><span class="fu">hosts</span><span class="kw">:</span><span class="at"> all</span></span>
<span id="cb9-4"><a href="#cb9-4" aria-hidden="true"></a><span class="at">  </span><span class="fu">tasks</span><span class="kw">:</span></span>
<span id="cb9-5"><a href="#cb9-5" aria-hidden="true"></a><span class="at">    </span><span class="kw">-</span><span class="at">   </span><span class="fu">group_by</span><span class="kw">:</span><span class="at"> key=os_{{ansible_os_family}}</span></span>
<span id="cb9-6"><a href="#cb9-6" aria-hidden="true"></a><span class="at">    </span><span class="kw">-</span><span class="at">   </span><span class="fu">name</span><span class="kw">:</span><span class="at"> install gvim</span></span>
<span id="cb9-7"><a href="#cb9-7" aria-hidden="true"></a><span class="at">        </span><span class="fu">package</span><span class="kw">:</span><span class="at"> name=&quot;{{gvim}}&quot; state=latest</span></span>
<span id="cb9-8"><a href="#cb9-8" aria-hidden="true"></a></span>
<span id="cb9-9"><a href="#cb9-9" aria-hidden="true"></a><span class="co">#in group_vars/os_RedHat</span></span>
<span id="cb9-10"><a href="#cb9-10" aria-hidden="true"></a><span class="pp">---</span></span>
<span id="cb9-11"><a href="#cb9-11" aria-hidden="true"></a><span class="fu">gvim</span><span class="kw">:</span><span class="at"> vim-X11</span></span>
<span id="cb9-12"><a href="#cb9-12" aria-hidden="true"></a></span>
<span id="cb9-13"><a href="#cb9-13" aria-hidden="true"></a><span class="co">#in group_vars/os_Debian</span></span>
<span id="cb9-14"><a href="#cb9-14" aria-hidden="true"></a><span class="pp">---</span></span>
<span id="cb9-15"><a href="#cb9-15" aria-hidden="true"></a><span class="fu">gvim</span><span class="kw">:</span><span class="at"> vim-gtk3</span></span></code></pre></div>
</section>
<section id="ansible-play-books---services" class="slide level2">
<h2>Ansible Play Books - Services</h2>
<div class="sourceCode" id="cb10"><pre class="sourceCode yaml"><code class="sourceCode yaml"><span id="cb10-1"><a href="#cb10-1" aria-hidden="true"></a><span class="co"># in main.yaml</span></span>
<span id="cb10-2"><a href="#cb10-2" aria-hidden="true"></a><span class="kw">-</span><span class="at"> </span><span class="fu">hosts</span><span class="kw">:</span><span class="at"> all</span></span>
<span id="cb10-3"><a href="#cb10-3" aria-hidden="true"></a><span class="at">  </span><span class="fu">tasks</span><span class="kw">:</span></span>
<span id="cb10-4"><a href="#cb10-4" aria-hidden="true"></a><span class="at">    </span><span class="kw">-</span><span class="at"> </span><span class="fu">name</span><span class="kw">:</span><span class="at"> configure sshd </span></span>
<span id="cb10-5"><a href="#cb10-5" aria-hidden="true"></a><span class="at">      </span><span class="fu">template</span><span class="kw">:</span><span class="at"> </span></span>
<span id="cb10-6"><a href="#cb10-6" aria-hidden="true"></a><span class="at">        src:&#39;/etc/ssh/sshd_config&#39;</span></span>
<span id="cb10-7"><a href="#cb10-7" aria-hidden="true"></a><span class="at">        </span><span class="fu">dest</span><span class="kw">:</span><span class="at"> sshd_config </span></span>
<span id="cb10-8"><a href="#cb10-8" aria-hidden="true"></a><span class="at">        </span><span class="fu">mode</span><span class="kw">:</span><span class="at"> </span><span class="dv">0644</span><span class="at"> </span></span>
<span id="cb10-9"><a href="#cb10-9" aria-hidden="true"></a><span class="at">        </span><span class="fu">owner</span><span class="kw">:</span><span class="at"> root </span></span>
<span id="cb10-10"><a href="#cb10-10" aria-hidden="true"></a><span class="at">        </span><span class="fu">group</span><span class="kw">:</span><span class="at"> root</span></span>
<span id="cb10-11"><a href="#cb10-11" aria-hidden="true"></a><span class="at">      </span><span class="fu">notify</span><span class="kw">:</span><span class="at"> restart sshd</span></span>
<span id="cb10-12"><a href="#cb10-12" aria-hidden="true"></a><span class="at">    </span><span class="kw">-</span><span class="at"> </span><span class="fu">name</span><span class="kw">:</span><span class="at"> start sshd</span></span>
<span id="cb10-13"><a href="#cb10-13" aria-hidden="true"></a><span class="at">      </span><span class="fu">service</span><span class="kw">:</span><span class="at"> name=sshd state=running</span></span>
<span id="cb10-14"><a href="#cb10-14" aria-hidden="true"></a></span>
<span id="cb10-15"><a href="#cb10-15" aria-hidden="true"></a><span class="at">  </span><span class="fu">handlers</span><span class="kw">:</span></span>
<span id="cb10-16"><a href="#cb10-16" aria-hidden="true"></a><span class="at">    </span><span class="kw">-</span><span class="at"> </span><span class="fu">name</span><span class="kw">:</span><span class="at"> restart sshd</span></span>
<span id="cb10-17"><a href="#cb10-17" aria-hidden="true"></a><span class="at">      </span><span class="fu">service</span><span class="kw">:</span><span class="at"> name=sshd state=restarted</span></span></code></pre></div>
</section>
<section id="external-facts-1" class="slide level2">
<h2>External Facts</h2>
<div class="sourceCode" id="cb11"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb11-1"><a href="#cb11-1" aria-hidden="true"></a><span class="co">#!/usr/bin/env python</span></span>
<span id="cb11-2"><a href="#cb11-2" aria-hidden="true"></a><span class="im">from</span> __future__ <span class="im">import</span> print_function</span>
<span id="cb11-3"><a href="#cb11-3" aria-hidden="true"></a><span class="im">import</span> json</span>
<span id="cb11-4"><a href="#cb11-4" aria-hidden="true"></a></span>
<span id="cb11-5"><a href="#cb11-5" aria-hidden="true"></a>facts <span class="op">=</span> {</span>
<span id="cb11-6"><a href="#cb11-6" aria-hidden="true"></a>    <span class="st">&quot;changed&quot;</span>: <span class="va">False</span>,</span>
<span id="cb11-7"><a href="#cb11-7" aria-hidden="true"></a>    <span class="st">&quot;ansible_facts&quot;</span>: git_version()</span>
<span id="cb11-8"><a href="#cb11-8" aria-hidden="true"></a>}</span>
<span id="cb11-9"><a href="#cb11-9" aria-hidden="true"></a></span>
<span id="cb11-10"><a href="#cb11-10" aria-hidden="true"></a><span class="bu">print</span>(json.dumps(facts))</span></code></pre></div>
</section></section>
<section id="ansible-modules" class="title-slide slide level1">
<h1>Ansible Modules</h1>
<p>*** Only create what you need ***</p>
<ul>
<li><code>mymodule</code>
<ul>
<li><code>tasks</code> - ansible playbooks to run</li>
<li><code>handlers</code> - Ansible handlers</li>
<li><code>library</code> - external code to run</li>
<li><code>templates</code> - templated files</li>
<li><code>files</code> - static files</li>
<li><code>vars</code> - variable for this module</li>
<li><code>defaults</code> - vars with lower precedence</li>
<li><code>meta</code> - dependencies</li>
</ul></li>
</ul>
</section>

<section id="the-good-1" class="title-slide slide level1">
<h1>The Good</h1>
<ul>
<li>Agentless</li>
<li>Documentation</li>
<li>Simple, Concise</li>
<li>Python</li>
<li>Ansible Vault</li>
<li>GPL Licensed</li>
</ul>
</section>

<section id="the-bad-1" class="title-slide slide level1">
<h1>The Bad</h1>
<ul>
<li>Slower (but not much)</li>
<li>Regressions in 2.0</li>
<li>Very opinionated</li>
<li>Less featureful</li>
</ul>
</section>

<section id="saltstack" class="title-slide slide level1">
<h1>SaltStack</h1>
<ul>
<li>Written in python 2.7.X but moving to 3.X</li>
<li>Mixed architecture
<ul>
<li>Requires python 2.7 and OpenSSH Server for Agentless</li>
</ul></li>
<li><strong>Computed Ordering</strong></li>
<li>Configured in <code>yaml</code> with <code>jinja</code> or <code>python</code></li>
</ul>
</section>

<section id="salt-basics" class="title-slide slide level1">
<h1>Salt Basics</h1>
<div class="sourceCode" id="cb12"><pre class="sourceCode yaml"><code class="sourceCode yaml"><span id="cb12-1"><a href="#cb12-1" aria-hidden="true"></a><span class="kw">{</span><span class="at">% raw %</span><span class="kw">}</span></span>
<span id="cb12-2"><a href="#cb12-2" aria-hidden="true"></a><span class="fu">acm</span><span class="kw">:</span></span>
<span id="cb12-3"><a href="#cb12-3" aria-hidden="true"></a><span class="at">    group.present</span></span>
<span id="cb12-4"><a href="#cb12-4" aria-hidden="true"></a><span class="kw">{</span><span class="at">% for user in [</span><span class="st">&#39;acm&#39;</span><span class="kw">,</span><span class="at"> </span><span class="st">&#39;foo&#39;</span><span class="kw">,</span><span class="at"> </span><span class="st">&#39;bar&#39;</span><span class="at">] %</span><span class="kw">}</span></span>
<span id="cb12-5"><a href="#cb12-5" aria-hidden="true"></a><span class="fu">users</span><span class="kw">:</span></span>
<span id="cb12-6"><a href="#cb12-6" aria-hidden="true"></a><span class="at">    </span><span class="fu">user.present</span><span class="kw">:</span></span>
<span id="cb12-7"><a href="#cb12-7" aria-hidden="true"></a><span class="at">        </span><span class="fu">name</span><span class="kw">:</span><span class="at"> </span><span class="kw">{</span><span class="at">{user</span><span class="kw">}</span><span class="at">}</span></span>
<span id="cb12-8"><a href="#cb12-8" aria-hidden="true"></a><span class="at">        </span><span class="fu">shell</span><span class="kw">:</span><span class="at"> bash</span></span>
<span id="cb12-9"><a href="#cb12-9" aria-hidden="true"></a><span class="at">        </span><span class="fu">groups</span><span class="kw">:</span><span class="at"> acm</span></span>
<span id="cb12-10"><a href="#cb12-10" aria-hidden="true"></a><span class="kw">{</span><span class="at">% endfor %</span><span class="kw">}</span></span>
<span id="cb12-11"><a href="#cb12-11" aria-hidden="true"></a><span class="kw">{</span><span class="at">% endraw %</span><span class="kw">}</span></span></code></pre></div>
</section>

<section id="salt-packages" class="title-slide slide level1">
<h1>Salt Packages</h1>
<div class="sourceCode" id="cb13"><pre class="sourceCode yaml"><code class="sourceCode yaml"><span id="cb13-1"><a href="#cb13-1" aria-hidden="true"></a><span class="kw">{</span><span class="at">% raw %</span><span class="kw">}</span></span>
<span id="cb13-2"><a href="#cb13-2" aria-hidden="true"></a><span class="kw">{</span><span class="at">% if grains[</span><span class="st">&#39;os_family&#39;</span><span class="at">] == </span><span class="st">&#39;RedHat&#39;</span><span class="at"> %</span><span class="kw">}</span></span>
<span id="cb13-3"><a href="#cb13-3" aria-hidden="true"></a><span class="fu">vim-X11</span><span class="kw">:</span></span>
<span id="cb13-4"><a href="#cb13-4" aria-hidden="true"></a><span class="kw">{</span><span class="at">% elif grains[</span><span class="st">&#39;os_family&#39;</span><span class="at">] == </span><span class="st">&#39;Debian&#39;</span><span class="at"> %</span><span class="kw">}</span></span>
<span id="cb13-5"><a href="#cb13-5" aria-hidden="true"></a><span class="fu">vim-gtk3</span><span class="kw">:</span></span>
<span id="cb13-6"><a href="#cb13-6" aria-hidden="true"></a><span class="kw">{</span><span class="at">% endif %</span><span class="kw">}</span></span>
<span id="cb13-7"><a href="#cb13-7" aria-hidden="true"></a><span class="at">    pkg.installed</span></span>
<span id="cb13-8"><a href="#cb13-8" aria-hidden="true"></a><span class="kw">{</span><span class="at">% endraw %</span><span class="kw">}</span></span></code></pre></div>
</section>

<section id="salt-packages---better" class="title-slide slide level1">
<h1>Salt Packages - Better</h1>
<div class="sourceCode" id="cb14"><pre class="sourceCode yaml"><code class="sourceCode yaml"><span id="cb14-1"><a href="#cb14-1" aria-hidden="true"></a><span class="co">#in sls file</span></span>
<span id="cb14-2"><a href="#cb14-2" aria-hidden="true"></a><span class="kw">{</span><span class="at">{ pillar[</span><span class="st">&#39;gvim&#39;</span><span class="at">] </span><span class="kw">}</span><span class="fu">}</span><span class="kw">:</span></span>
<span id="cb14-3"><a href="#cb14-3" aria-hidden="true"></a><span class="at">    pkg.installed</span></span></code></pre></div>
</section>

<section id="salt-packages---better-1" class="title-slide slide level1">
<h1>Salt Packages - Better</h1>
<div class="sourceCode" id="cb15"><pre class="sourceCode yaml"><code class="sourceCode yaml"><span id="cb15-1"><a href="#cb15-1" aria-hidden="true"></a><span class="co">#in pillar/top.sls</span></span>
<span id="cb15-2"><a href="#cb15-2" aria-hidden="true"></a><span class="fu">&#39;base&#39;</span><span class="kw">:</span></span>
<span id="cb15-3"><a href="#cb15-3" aria-hidden="true"></a><span class="at">  </span><span class="fu">&#39;*&#39;</span><span class="kw">:</span></span>
<span id="cb15-4"><a href="#cb15-4" aria-hidden="true"></a><span class="at">   </span><span class="kw">-</span><span class="at"> package.defaults</span></span>
<span id="cb15-5"><a href="#cb15-5" aria-hidden="true"></a><span class="at">  </span><span class="fu">&#39;os_family:RedHat&#39;</span><span class="kw">:</span></span>
<span id="cb15-6"><a href="#cb15-6" aria-hidden="true"></a><span class="at">   </span><span class="kw">-</span><span class="at"> package.redhat</span></span>
<span id="cb15-7"><a href="#cb15-7" aria-hidden="true"></a><span class="at">  </span><span class="fu">&#39;os_family:Debian&#39;</span><span class="kw">:</span></span>
<span id="cb15-8"><a href="#cb15-8" aria-hidden="true"></a><span class="at">   </span><span class="kw">-</span><span class="at"> package.debian</span></span>
<span id="cb15-9"><a href="#cb15-9" aria-hidden="true"></a></span>
<span id="cb15-10"><a href="#cb15-10" aria-hidden="true"></a><span class="co">#in pillar/package/defaults.sls</span></span>
<span id="cb15-11"><a href="#cb15-11" aria-hidden="true"></a><span class="fu">gvim</span><span class="kw">:</span><span class="at"> gvim</span></span>
<span id="cb15-12"><a href="#cb15-12" aria-hidden="true"></a></span>
<span id="cb15-13"><a href="#cb15-13" aria-hidden="true"></a><span class="co">#in pillar/package/redhat.sls</span></span>
<span id="cb15-14"><a href="#cb15-14" aria-hidden="true"></a><span class="fu">gvim</span><span class="kw">:</span><span class="at"> vim-X11</span></span>
<span id="cb15-15"><a href="#cb15-15" aria-hidden="true"></a></span>
<span id="cb15-16"><a href="#cb15-16" aria-hidden="true"></a><span class="co">#in pillar/package/debian.sls</span></span>
<span id="cb15-17"><a href="#cb15-17" aria-hidden="true"></a><span class="fu">gvim</span><span class="kw">:</span><span class="at"> vim-gtk3</span></span></code></pre></div>
</section>

<section id="salt-services" class="title-slide slide level1">
<h1>Salt Services</h1>
<div class="sourceCode" id="cb16"><pre class="sourceCode yaml"><code class="sourceCode yaml"><span id="cb16-1"><a href="#cb16-1" aria-hidden="true"></a><span class="fu">/etc/ssh/sshd_config</span><span class="kw">:</span></span>
<span id="cb16-2"><a href="#cb16-2" aria-hidden="true"></a><span class="at">    </span><span class="fu">file.managed</span><span class="kw">:</span></span>
<span id="cb16-3"><a href="#cb16-3" aria-hidden="true"></a><span class="at">      </span><span class="kw">-</span><span class="at"> </span><span class="fu">source</span><span class="kw">:</span><span class="at"> salt://sshd/sshd_conf</span></span>
<span id="cb16-4"><a href="#cb16-4" aria-hidden="true"></a><span class="at">      </span><span class="kw">-</span><span class="at"> </span><span class="fu">user</span><span class="kw">:</span><span class="at"> root</span></span>
<span id="cb16-5"><a href="#cb16-5" aria-hidden="true"></a><span class="at">      </span><span class="kw">-</span><span class="at"> </span><span class="fu">group</span><span class="kw">:</span><span class="at"> root</span></span>
<span id="cb16-6"><a href="#cb16-6" aria-hidden="true"></a><span class="at">      </span><span class="kw">-</span><span class="at"> </span><span class="fu">mode</span><span class="kw">:</span><span class="at"> </span><span class="dv">644</span></span>
<span id="cb16-7"><a href="#cb16-7" aria-hidden="true"></a><span class="at">      </span><span class="kw">-</span><span class="at"> </span><span class="fu">template</span><span class="kw">:</span><span class="at"> jinja</span></span>
<span id="cb16-8"><a href="#cb16-8" aria-hidden="true"></a></span>
<span id="cb16-9"><a href="#cb16-9" aria-hidden="true"></a><span class="fu">sshd</span><span class="kw">:</span></span>
<span id="cb16-10"><a href="#cb16-10" aria-hidden="true"></a><span class="at">  </span><span class="fu">service.running</span><span class="kw">:</span></span>
<span id="cb16-11"><a href="#cb16-11" aria-hidden="true"></a><span class="at">    </span><span class="kw">-</span><span class="at"> </span><span class="fu">enabled</span><span class="kw">:</span><span class="at"> </span><span class="ch">True</span></span>
<span id="cb16-12"><a href="#cb16-12" aria-hidden="true"></a><span class="at">    </span><span class="kw">-</span><span class="at"> </span><span class="fu">reload</span><span class="kw">:</span><span class="at"> </span><span class="ch">True</span></span>
<span id="cb16-13"><a href="#cb16-13" aria-hidden="true"></a><span class="at">    </span><span class="kw">-</span><span class="at"> </span><span class="fu">watch</span><span class="kw">:</span></span>
<span id="cb16-14"><a href="#cb16-14" aria-hidden="true"></a><span class="at">      </span><span class="kw">-</span><span class="at"> </span><span class="fu">file</span><span class="kw">:</span><span class="at"> /etc/ssh/sshd_config</span></span></code></pre></div>
</section>

<section id="external-facts-2" class="title-slide slide level1">
<h1>External Facts</h1>
<div class="sourceCode" id="cb17"><pre class="sourceCode python"><code class="sourceCode python"><span id="cb17-1"><a href="#cb17-1" aria-hidden="true"></a><span class="co">#!/usr/bin/env python</span></span>
<span id="cb17-2"><a href="#cb17-2" aria-hidden="true"></a></span>
<span id="cb17-3"><a href="#cb17-3" aria-hidden="true"></a><span class="kw">def</span> main():</span>
<span id="cb17-4"><a href="#cb17-4" aria-hidden="true"></a>    <span class="co">&quot;&quot;&quot;gather facts&quot;&quot;&quot;</span></span>
<span id="cb17-5"><a href="#cb17-5" aria-hidden="true"></a>    <span class="cf">return</span> git_version()</span></code></pre></div>
</section>

<section id="salt-modules" class="title-slide slide level1">
<h1>Salt Modules</h1>
<p>*** other than init.sls names don’t matter ***</p>
<ul>
<li>mymodule
<ul>
<li>init.sls</li>
<li>varient.sls</li>
<li>varient1.sls</li>
<li>files</li>
</ul></li>
</ul>
</section>

<section id="the-good-2" class="title-slide slide level1">
<h1>The Good</h1>
<ul>
<li>Fast</li>
<li>Jinja + YAML work great</li>
<li>Master/Slave isn’t painful</li>
<li>Also Agentless</li>
<li>Simple, Consise</li>
<li>Reactions and Provisioning are 1st class</li>
<li>Python</li>
<li>Apache Licensed</li>
</ul>
</section>

<section id="the-bad-2" class="title-slide slide level1">
<h1>The Bad</h1>
<ul>
<li>Documenation lacks organization</li>
<li>Python only for extensions</li>
<li>No custom jinja filters</li>
</ul>
</section>

<section id="further-resources" class="title-slide slide level1">
<h1>Further Resources</h1>
<ul>
<li><a href="https://docs.puppet.com/puppet">puppet</a>
<ul>
<li>visual index – how does the language work</li>
<li>type reference – what types exist</li>
<li>facter, hiera</li>
</ul></li>
<li><a href="https://docs.ansible.com">ansible</a></li>
<li><a href="https://docs.saltstack.com/en/latest/">salt</a></li>
</ul>
</section>

<section id="questions" class="title-slide slide level1">
<h1>Questions</h1>
<p>Send us feedback at <code>acm@cs.clemson.edu</code>!</p>
<p>This material available under <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC By-SA 4.0</a></p>
</section>
