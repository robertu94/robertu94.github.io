---
title: Think Different
layout: presentation
location: Clemson ACM Seminar
date: 2016-02-01
Summary: >
  A talk that provides an overview of how to approach computer science projects
  with less stress and effort.  This talk was given multiple times at various Clemson ACM
  venues.  Also titled, "Perfecting Your Projects".
acknowledgments: Austin Anderson collaborated on these slides
---
<section>
<section id="think-different" class="title-slide slide level1">
<h1>Think Different</h1>
<p>How to Code Smarter, not harder</p>
</section>
<section id="brought-to-you-by-clemson-acm" class="slide level2">
<h2>Brought to you by Clemson ACM</h2>
<p>We’re on Freenode! Join <code>#clemsonacm</code> on chat.freenode.net!</p>
</section>
<section id="speaker" class="slide level2">
<h2>Speaker:</h2>
<p>Robert Underwood - ACM Vice President</p>
</section></section>
<section id="coming-up" class="title-slide slide level1">
<h1>Coming Up</h1>
<ul>
<li>Starting out Strong</li>
<li>Automate the Tedium</li>
<li>What to Do When Things Go Bad</li>
<li>Finishing Smart</li>
</ul>
</section>

<section id="starting-out-strong" class="title-slide slide level1">
<h1>Starting out Strong</h1>

</section>

<section id="happy-thoughts" class="title-slide slide level1">
<h1>Happy Thoughts</h1>
<ul>
<li>Think about what you’re doing before you code
<ul>
<li>Make sure you understand the spec first</li>
</ul></li>
<li>Try using paper or a whiteboard to plan</li>
<li>Give yourself enough time to do the project!
<ul>
<li>Do a little bit of work, regularly</li>
</ul></li>
</ul>
</section>

<section id="consider-version-control" class="title-slide slide level1">
<h1>Consider Version Control</h1>
<ul>
<li>Check out our <a href="http://present.protractor.ninja?git">git seminar</a> to get started</li>
<li>Easily track and search through your development history</li>
<li>Commit whenever you make progress</li>
<li>Tools: <code>git</code>, <code>mercurial</code></li>
</ul>
</section>

<section id="consider-test-driven-development-tdd" class="title-slide slide level1">
<h1>Consider Test Driven Development (TDD)</h1>
<ul>
<li>Basics:
<ul>
<li>Write tests first</li>
<li>Make sure the tests fail</li>
<li>Code until you pass the tests</li>
</ul></li>
<li>Extensive tests help you track progress</li>
<li>Tools: <a href="http://check.sourceforge.net/"><code>check</code></a>, <a href="https://github.com/sstephenson/bats"><code>bats</code></a>, <code>python unittest</code></li>
</ul>
</section>

<section>
<section id="automate-the-tedium" class="title-slide slide level1">
<h1>Automate the Tedium</h1>

</section>
<section id="save-your-time-and-sanity" class="slide level2">
<h2>Save your time and sanity!</h2>
</section></section>
<section id="makefiles-in-brief" class="title-slide slide level1">
<h1>Makefiles, in brief</h1>
<ul>
<li>Makefiles are a great way to automate building, testing…</li>
</ul>
<p>Simple example</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode makefile"><code class="sourceCode makefile"><span id="cb1-1"><a href="#cb1-1" aria-hidden="true"></a><span class="dv">a.out:</span><span class="dt"> project.c</span></span>
<span id="cb1-2"><a href="#cb1-2" aria-hidden="true"></a>   gcc project.c</span>
<span id="cb1-3"><a href="#cb1-3" aria-hidden="true"></a></span>
<span id="cb1-4"><a href="#cb1-4" aria-hidden="true"></a><span class="dv">run:</span><span class="dt"> a.out</span></span>
<span id="cb1-5"><a href="#cb1-5" aria-hidden="true"></a>   ./a.out <span class="st">&quot;arguments&quot;</span></span></code></pre></div>
<p>Same thing, with Make’s automatic compilation rules</p>
<div class="sourceCode" id="cb2"><pre class="sourceCode makefile"><code class="sourceCode makefile"><span id="cb2-1"><a href="#cb2-1" aria-hidden="true"></a><span class="dt">CC</span><span class="ch">=</span><span class="st">gcc</span></span>
<span id="cb2-2"><a href="#cb2-2" aria-hidden="true"></a><span class="dt">CFLAGS</span><span class="ch">=</span><span class="st">-g -Wall</span></span>
<span id="cb2-3"><a href="#cb2-3" aria-hidden="true"></a></span>
<span id="cb2-4"><a href="#cb2-4" aria-hidden="true"></a><span class="dv">a.out:</span><span class="dt"> project.c</span></span>
<span id="cb2-5"><a href="#cb2-5" aria-hidden="true"></a></span>
<span id="cb2-6"><a href="#cb2-6" aria-hidden="true"></a><span class="dv">run:</span><span class="dt"> a.out</span></span>
<span id="cb2-7"><a href="#cb2-7" aria-hidden="true"></a>   ./a.out <span class="st">&quot;arguments&quot;</span></span></code></pre></div>
</section>

<section id="automate-builds" class="title-slide slide level1">
<h1>Automate Builds</h1>
<ul>
<li>Create targets for each executable and task</li>
<li>Consider using multiple compilers
<ul>
<li><code>gcc</code> is what professors test with</li>
<li><code>clang</code> for readable error messages</li>
</ul></li>
<li><code>all</code> and <code>clean</code> targets are convention (and useful)
<ul>
<li>Use <code>.PHONY</code> for tasks that aren’t files</li>
</ul></li>
</ul>
<div class="sourceCode" id="cb3"><pre class="sourceCode makefile"><code class="sourceCode makefile"><span id="cb3-1"><a href="#cb3-1" aria-hidden="true"></a><span class="ot">.PHONY:</span><span class="dt"> all run clean</span></span>
<span id="cb3-2"><a href="#cb3-2" aria-hidden="true"></a><span class="dv">all:</span><span class="dt"> a.out</span></span>
<span id="cb3-3"><a href="#cb3-3" aria-hidden="true"></a><span class="dv">clean:</span></span>
<span id="cb3-4"><a href="#cb3-4" aria-hidden="true"></a>   rm a.out</span>
<span id="cb3-5"><a href="#cb3-5" aria-hidden="true"></a><span class="dv">run:</span><span class="dt"> a.out</span></span>
<span id="cb3-6"><a href="#cb3-6" aria-hidden="true"></a>   ./a.out <span class="st">&quot;arguments&quot;</span></span></code></pre></div>
</section>

<section id="automate-testing" class="title-slide slide level1">
<h1>Automate Testing</h1>
<ul>
<li>Create a <code>test</code> target</li>
<li>With TDD, commit when you pass more tests</li>
<li>Things you can test
<ul>
<li>Output
<ul>
<li>tools: <code>awk</code>, <code>bash</code>, <code>diff</code>, <code>grep</code></li>
</ul></li>
<li>Exit status
<ul>
<li>tools: <code>bash</code> using <code>$?</code>, <code>bats</code></li>
</ul></li>
<li>Memory leaks
<ul>
<li>tools: <a href="http://valgrind.org/"><code>valgrind</code></a></li>
</ul></li>
</ul></li>
</ul>
</section>

<section id="automate-other-stuff" class="title-slide slide level1">
<h1>Automate Other Stuff</h1>
<ul>
<li>Documentation?
<ul>
<li>Create a <code>docs</code> target</li>
<li>Write documentation as you go</li>
<li>Use doxygen, javadocs, or sphinx</li>
</ul></li>
<li>Log files?
<ul>
<li>Use Python or Bash</li>
</ul></li>
<li>Bash and Python scripts can do a lot!</li>
</ul>
</section>

<section id="automate-submission" class="title-slide slide level1">
<h1>Automate Submission</h1>
<ul>
<li>Saves time, effort, and stress</li>
<li>Handin is Mercurial-based, so you can use the command line</li>
<li>Or, <a href="http://www.grymoire.com/">Austin made a makefile for you already</a></li>
</ul>
</section>

<section id="what-to-do-when-things-go-bad" class="title-slide slide level1">
<h1>What To Do When Things Go Bad</h1>

</section>

<section id="talk-to-your-professors" class="title-slide slide level1">
<h1>Talk to your professors</h1>
<ul>
<li>Go to office hours with your problems</li>
<li>Good professors want to help you learn</li>
<li>Go early! Everyone goes the night before</li>
</ul>
</section>

<section id="debugging" class="title-slide slide level1">
<h1>Debugging</h1>
<ul>
<li><code>gdb</code></li>
<li><code>valgrind</code></li>
<li><code>git bisect</code> helps find where a bug was introduced
<ul>
<li>Only works if commits are testable</li>
</ul></li>
</ul>
</section>

<section id="reverting-old-changes" class="title-slide slide level1">
<h1>Reverting Old Changes</h1>
<ul>
<li>Version control makes this easy</li>
<li>Commit (and branch) prior to big changes</li>
<li><code>git revert</code> can undo a specific earlier commit</li>
</ul>
</section>

<section id="finishing-smart" class="title-slide slide level1">
<h1>Finishing Smart</h1>
<ul>
<li>Test everything again before you submit!</li>
<li>Submit early, submit often
<ul>
<li>Handin lets you submit as many times as you want</li>
</ul></li>
<li>Don’t share your code without permission</li>
</ul>
</section>

<section id="further-resources" class="title-slide slide level1">
<h1>Further Resources</h1>
<ul>
<li>More command reference:
<ul>
<li>UNIX <code>man</code> pages - most commands have a <code>man</code> page</li>
<li><a href="http://www.grymoire.com/">Grymoire</a> - great scripting resource</li>
<li><a href="https://wiki.archlinux.org/index.php/Main_Page">Archwiki</a> - great command resource</li>
</ul></li>
<li><a href="https://github.com/protractorninja/cu-handin-magic-make/">Austin’s magic makefile</a> automates submission and testing on the lab machines</li>
</ul>
</section>

<section id="useful-commands" class="title-slide slide level1">
<h1>Useful Commands</h1>
<ul>
<li><code>time</code></li>
<li><code>watch</code></li>
<li><code>scp</code> and <code>ssh</code></li>
<li><code>find</code></li>
<li><code>sed</code></li>
<li><code>ag</code>, the <a href="https://github.com/ggreer/the_silver_searcher">Silver Searcher</a></li>
</ul>
</section>

<section id="questions" class="title-slide slide level1">
<h1>Questions</h1>
<p>Send feedback to acm@cs.clemson.edu</p>
<p>This material available under <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC By-SA 4.0</a></p>
</section>
