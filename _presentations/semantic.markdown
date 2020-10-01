---
title: "Writing Semantic Code: Using Refactoring Patterns for Better Code"
layout: presentation
location: Clemson ACM Technology Seminar
date: 2016-08-01
description: >
  Spaghetti code is a nightmare.  It is hard to read, harder to understand, and harder still to debug and change.  In this talk, I introduce the discipline of refactoring which transforms code in a way that maintains its external behavior while improving it's internal structure.  I will present several examples of poor design often seen in imperative code, and describe some techniques to refactor this code  to easier to understand semantic code from Martin Fowler's book "Refactoring: Improving the Design of Existing Software".
...
<section id="writing-semantic-code" class="title-slide slide level1">
<h1>Writing Semantic Code</h1>
<p>Using refactoring and patterns for better code</p>
<p>Robert Underwood</p>
</section>

<section id="overview" class="title-slide slide level1">
<h1>Overview</h1>
<ol type="1">
<li>What is bad code?</li>
<li>What we can do about it</li>
<li>Get practical</li>
<li>Further Resources</li>
</ol>
</section>

<section id="who-is-this-for" class="title-slide slide level1">
<h1>Who is this for?</h1>
<ol type="1">
<li>Intermediate to advanced talk</li>
<li>Experienced with imperative languages</li>
<li>Want to write better code</li>
</ol>
</section>

<section id="bad-code-is-a-problem" class="title-slide slide level1">
<h1>Bad code is a problem</h1>
<ul>
<li>Bad code takes longer to: understand, edit, and get right</li>
<li>Time is the most valuable resource you have</li>
</ul>
</section>

<section id="what-is-bad-code" class="title-slide slide level1">
<h1>What is bad code?</h1>
<ul>
<li>We know it when we see it
<ul>
<li>But we can be more precise <!-- .element class="fragment" data-fragment-index="1" --></li>
<li>Often called “code smells” or “spaghetti code”<!-- .element class="fragment" data-fragment-index="1" --></li>
</ul></li>
</ul>
</section>

<section id="codes-smells" class="title-slide slide level1">
<h1>Codes Smells</h1>
<p class="fragment current-visible" data-fragment-index="1">
From Martin Fowler’s Refactoring
</p>
<div class="fragment" style="float: left;" data-fragment-index="1">
<pre><code>&lt;ol&gt;
    &lt;li&gt;Duplicate Code&lt;/li&gt;
    &lt;li&gt;Long Methods&lt;/li&gt;
    &lt;li&gt;Long Parameter Lists&lt;/li&gt;
    &lt;li&gt;Data Clumps&lt;/li&gt;
    &lt;li&gt;Primitive Obsession&lt;/li&gt;
&lt;ol&gt;</code></pre>
</div>
<div class="fragment" style="float: right;" data-fragment-index="1">
<pre><code>&lt;ol start=&quot;6&quot;&gt;
    &lt;li&gt;Speculative Generality&lt;/li&gt;
    &lt;li&gt;Incomplete Library&lt;/li&gt;
    &lt;li&gt;Heavy Comments&lt;/li&gt;
    &lt;li class=&quot;fragment&quot; data-fragment-index=&quot;2&quot; &gt;Magic Values&lt;/li&gt;
    &lt;li class=&quot;fragment&quot; data-fragment-index=&quot;2&quot; &gt;Pyramid of Death&lt;/li&gt;
&lt;ol&gt;</code></pre>
</div>
</section>

<section id="how-do-we-fix-it" class="title-slide slide level1">
<h1>How do we fix it?</h1>
<ol type="1">
<li>Do it right the first time <!-- .element:  class="fragment"--></li>
<li>Style Guides <!-- .element:  class="fragment"--></li>
<li>Code Review/Testing <!-- .element:  class="fragment"--></li>
<li>Rewrite <!-- .element:  class="fragment"--></li>
<li>Refactor <!-- .element:  class="fragment"--></li>
</ol>
</section>

<section id="what-is-refactoring" class="title-slide slide level1">
<h1>What is Refactoring?</h1>
<blockquote>
<p>Refactoring is the process of changing a software system in such a way that it does not alter the external behavior of the code yet improves its internal structure.</p>
</blockquote>
<p><cite>Martin Fowler “Refactoring: Improving the Design of Existing Code”</cite></p>
</section>

<section id="lets-get-practical" class="title-slide slide level1">
<h1>Let’s Get Practical</h1>
<p>And go to some case studies</p>
</section>

<section id="tooling-to-make-it-easier" class="title-slide slide level1">
<h1>Tooling to make it easier</h1>
<ul>
<li>LLVM’s libtooling (C/C++)</li>
<li>Eclipse and Eclim (Java et al)</li>
<li>Pycharm, Rope, et al (Python)</li>
</ul>
</section>

<section id="further-resources" class="title-slide slide level1">
<h1>Further Resources</h1>
<ul>
<li>Martin Fowler
<ul>
<li><a href="refactoring.com">Refactoring: Improving the Design of Existing Code</a></li>
<li><a href="martinfowler.com">Personal Site</a></li>
</ul></li>
<li><a href="https://www.industriallogic.com/xp/refactoring/">Refactoring to Patterns</a> by Joshua Kerievsky</li>
<li><a href="http://fsharpforfunandprofit.com/fppatterns/">Functional Programming</a> by Scott Wlaschin</li>
</ul>
</section>

<section id="questions" class="title-slide slide level1">
<h1>Questions</h1>
<p>Send feedback to <a href="mailto:robertu@clemson.edu" class="email">robertu@clemson.edu</a></p>
<p>This material available under <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC By-SA 4.0</a></p>
</section>
