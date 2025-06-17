---
title: Automation in the Classroom
layout: presentation
location: Clemson School of Computing Seminar
date: 2016-04-01
Summary: >
  The purpose of this talk is to introduce how instructors could approach the
  topic of using automation in the classroom.  We will make a case for automation
  both from a student's and instructor's perspective by showing that automation
  can save time, encourage test driven development, and improve testing for
  knowledge.  We will also address concerns regarding grading automation including
  accuracy, confidentiality, and security.  Then we will get into detail about
  techniques and tools that can be used for classroom automation.  Finally we will
  examine case studies of how automation has and can be implemented.  We will
  examine how this has been done technically as well as part of the classroom
  environment by faculty members at the School of Computing.
---
<section>
<section id="automation-in-the-classroom" class="title-slide slide level1">
<h1>Automation in the Classroom</h1>
<p>An introduction to Automation</p>
<p>Brought to you by Clemson ACM</p>
</section>
<section id="speakers" class="slide level2">
<h2>Speakers:</h2>
<p>Robert Underwood - ACM Vice President</p>
</section></section>
<section id="coming-up" class="title-slide slide level1">
<h1>Coming Up</h1>
<ul>
<li>Why would you want to automate your work?</li>
<li>What sorts of things can you automate?</li>
<li>When is automation and scripting applicable?</li>
<li>What tools should I use?</li>
<li>Thinking bigger: a case study</li>
<li>Common Objections</li>
</ul>
</section>

<section id="who-are-we" class="title-slide slide level1">
<h1>Who are we?</h1>

</section>

<section id="clemson-acm" class="title-slide slide level1">
<h1>Clemson ACM</h1>
<ul>
<li>Student Chapter of the ACM</li>
<li>Professional and social events for students</li>
<li>Competitive programming team coached by Dr. Dean</li>
<li>We want to make the School of Computing a better place</li>
</ul>
</section>

<section id="how-can-we-help-your-students" class="title-slide slide level1">
<h1>How can we help your students?</h1>
<ul>
<li>We teach introductory topics like Linux and Git</li>
<li>We bring in companies in to present technical topics</li>
<li>We host the programming team and seminar
<ul>
<li>Teaches teamwork</li>
<li>Teaches problem solving</li>
</ul></li>
<li>Open to everyone interested</li>
</ul>
</section>

<section id="why-would-you-want-to-automate-your-work" class="title-slide slide level1">
<h1>Why would you want to automate your work?</h1>

</section>

<section id="instructor-perspective" class="title-slide slide level1">
<h1>Instructor Perspective</h1>
<ul>
<li>Saves you time grading for large classes</li>
<li>Encourages students to submit early and often</li>
<li>Encourages students to use an iterative approach</li>
<li>Done correctly, reinforces Test Driven Development</li>
</ul>
</section>

<section id="student-perspective" class="title-slide slide level1">
<h1>Student Perspective</h1>
<ul>
<li>Same benefits as Test Driven Development</li>
<li>Early feedback on how the project is progressing.</li>
<li>Helps us determine when we have completed the project.</li>
<li>Avoid missing stupid mistakes</li>
</ul>
</section>

<section id="when-is-automation-and-scripting-applicable" class="title-slide slide level1">
<h1>When is automation and scripting applicable?</h1>

</section>

<section id="when-is-it-applicable" class="title-slide slide level1">
<h1>When is it applicable?</h1>
<ul>
<li>Generating test data</li>
<li>Grading programming projects</li>
<li>Many repetitive tasks</li>
</ul>
</section>

<section id="when-is-it-not-applicable" class="title-slide slide level1">
<h1>When is it not applicable?</h1>
<ul>
<li>Where output is</li>
<li>difficult to parse</li>
<li>non-deterministic</li>
</ul>
</section>

<section id="what-tools-should-i-use-for-automation" class="title-slide slide level1">
<h1>What Tools Should I Use for Automation?</h1>

</section>

<section id="hg" class="title-slide slide level1">
<h1>hg</h1>
<p>Source Control System</p>
<ul>
<li>Configure ssh access to avoid passwords</li>
<li><code>hg clone</code> clone a repository for the first time</li>
<li><code>hg incoming</code> check for updates without pulling them</li>
<li><code>hg pull -u</code> update to the latest submission</li>
</ul>
</section>

<section id="cloning-repositories" class="title-slide slide level1">
<h1>Cloning Repositories</h1>
<pre><code>hg clone ssh://handin@handin.cs.clemson.edu/semester_name/course_name 
pushd course_name
./update</code></pre>
</section>

<section id="time" class="title-slide slide level1">
<h1>time</h1>
<p>Time how long it takes a program to execute</p>
<div class="sourceCode" id="cb2"><pre class="sourceCode bash"><code class="sourceCode bash"><span id="cb2-1"><a href="#cb2-1" aria-hidden="true"></a>$ <span class="bu">time</span> tar -czf foobar file1.c file2.c</span>
<span id="cb2-2"><a href="#cb2-2" aria-hidden="true"></a><span class="ex">0.01s</span> user 0.00s system 0% cpu 4.656 total</span></code></pre></div>
</section>

<section id="timeout" class="title-slide slide level1">
<h1>timeout</h1>
<p>Kill a program after a timeout</p>
<ul>
<li><code>timeout 10 ./script.sh</code></li>
</ul>
</section>

<section id="bats" class="title-slide slide level1">
<h1>bats</h1>
<p>Unit testing for CLI Applications</p>
<ul>
<li>Written in bash</li>
<li>Ease to write</li>
<li>Parse-able output</li>
<li>Lightweight</li>
</ul>
</section>

<section id="sample-bats-file" class="title-slide slide level1">
<h1>Sample Bats file</h1>
<div class="sourceCode" id="cb3"><pre class="sourceCode bash"><code class="sourceCode bash"><span id="cb3-1"><a href="#cb3-1" aria-hidden="true"></a><span class="ex">@test</span> <span class="st">&quot;Set example code matches Sample Output&quot;</span> {</span>
<span id="cb3-2"><a href="#cb3-2" aria-hidden="true"></a>    <span class="ex">run</span> timeout 10 ./set <span class="op">&lt;</span> set.in</span>
<span id="cb3-3"><a href="#cb3-3" aria-hidden="true"></a>    [ <span class="st">&quot;</span><span class="va">$status</span><span class="st">&quot;</span> <span class="ex">-eq</span> 0 ]</span>
<span id="cb3-4"><a href="#cb3-4" aria-hidden="true"></a>    [ <span class="st">&quot;</span><span class="va">$output</span><span class="st">&quot;</span> = <span class="st">&quot;</span><span class="va">$(</span><span class="fu">cat</span> set.out<span class="va">)</span><span class="st">&quot;</span> ]</span>
<span id="cb3-5"><a href="#cb3-5" aria-hidden="true"></a>}</span></code></pre></div>
</section>

<section id="detailed-example" class="title-slide slide level1">
<h1>Detailed Example</h1>
<div class="sourceCode" id="cb4"><pre class="sourceCode bash"><code class="sourceCode bash"><span id="cb4-1"><a href="#cb4-1" aria-hidden="true"></a><span class="ex">@test</span> <span class="st">&quot;Tests using edit distance&quot;</span> {</span>
<span id="cb4-2"><a href="#cb4-2" aria-hidden="true"></a>    <span class="ex">run</span> timeout 10 ./strings_writer <span class="op">&lt;</span> test.in</span>
<span id="cb4-3"><a href="#cb4-3" aria-hidden="true"></a>    [ <span class="st">&quot;</span><span class="va">$status</span><span class="st">&quot;</span> <span class="ex">-eq</span> 0 ]</span>
<span id="cb4-4"><a href="#cb4-4" aria-hidden="true"></a>    <span class="ex">run</span> editdistance <span class="st">&quot;</span><span class="va">$output</span><span class="st">&quot;</span> <span class="st">&quot;</span><span class="va">$(</span><span class="fu">cat</span> expected.out<span class="va">)</span><span class="st">&quot;</span></span>
<span id="cb4-5"><a href="#cb4-5" aria-hidden="true"></a>    [ <span class="st">&quot;</span><span class="va">$status</span><span class="st">&quot;</span> <span class="ex">-eq</span> 0 ]</span>
<span id="cb4-6"><a href="#cb4-6" aria-hidden="true"></a>    [ <span class="st">&quot;</span><span class="va">$output</span><span class="st">&quot;</span> <span class="ex">-lt</span> 5 ]</span>
<span id="cb4-7"><a href="#cb4-7" aria-hidden="true"></a>}</span></code></pre></div>
</section>

<section id="testing-a-students-work" class="title-slide slide level1">
<h1>Testing a student’s work</h1>
<div class="sourceCode" id="cb5"><pre class="sourceCode bash"><code class="sourceCode bash"><span id="cb5-1"><a href="#cb5-1" aria-hidden="true"></a><span class="co">#!/bin/bash</span></span>
<span id="cb5-2"><a href="#cb5-2" aria-hidden="true"></a><span class="va">TESTS=$PWD</span></span>
<span id="cb5-3"><a href="#cb5-3" aria-hidden="true"></a><span class="va">OUTPUT=$PWD</span>/output</span>
<span id="cb5-4"><a href="#cb5-4" aria-hidden="true"></a><span class="bu">pushd</span> assignments/asg_name</span>
<span id="cb5-5"><a href="#cb5-5" aria-hidden="true"></a><span class="kw">for</span> <span class="fu">dir</span> in *</span>
<span id="cb5-6"><a href="#cb5-6" aria-hidden="true"></a><span class="kw">do</span></span>
<span id="cb5-7"><a href="#cb5-7" aria-hidden="true"></a>    <span class="kw">if</span><span class="bu"> [</span> <span class="ot">-d</span> <span class="st">&quot;</span><span class="va">$dir</span><span class="st">&quot;</span><span class="bu"> ]</span>;<span class="kw">then</span></span>
<span id="cb5-8"><a href="#cb5-8" aria-hidden="true"></a>        <span class="fu">mkdir</span> -p <span class="va">$OUTPUT</span>/<span class="st">&quot;</span><span class="va">$dir</span><span class="st">&quot;</span></span>
<span id="cb5-9"><a href="#cb5-9" aria-hidden="true"></a>        <span class="bu">pushd</span> <span class="va">$dir</span></span>
<span id="cb5-10"><a href="#cb5-10" aria-hidden="true"></a>        <span class="ex">timeout</span> 10 make <span class="op">&gt;</span> <span class="va">$OUTPUT</span>/<span class="va">$dir</span>/output-make.txt</span>
<span id="cb5-11"><a href="#cb5-11" aria-hidden="true"></a>        <span class="ex">timeout</span> 10 <span class="va">$TESTS</span>/test1.bats <span class="op">&amp;&gt;</span> <span class="va">$OUTPUT</span>/<span class="va">$dir</span>/output-1.txt</span>
<span id="cb5-12"><a href="#cb5-12" aria-hidden="true"></a>        <span class="ex">timeout</span> 10 <span class="va">$TESTS</span>/test2.bats <span class="op">&amp;&gt;</span> <span class="va">$OUTPUT</span>/<span class="va">$dir</span>/output-2.txt</span>
<span id="cb5-13"><a href="#cb5-13" aria-hidden="true"></a>        <span class="bu">popd</span></span>
<span id="cb5-14"><a href="#cb5-14" aria-hidden="true"></a>    <span class="kw">fi</span></span>
<span id="cb5-15"><a href="#cb5-15" aria-hidden="true"></a><span class="kw">done</span></span></code></pre></div>
</section>

<section id="cron" class="title-slide slide level1">
<h1>Cron</h1>
<pre><code>PATH=/usr/bin
SHELL=/bin/bash
MAILTO=acm
# minute hour dayOfMonth month dayOfWeek cmd
0 0 0 * * echo &quot;Monthly task&quot;
0 16 * * * echo &quot;Daily at 5pm&quot;
0 11 * * 1 echo &quot;Every Monday at noon&quot;</code></pre>
</section>

<section id="emailing-results" class="title-slide slide level1">
<h1>Emailing Results</h1>
<pre><code>#!/bin/bash
mail -s &#39;Autograder Results&#39; student@clemson.edu &lt; results.txt</code></pre>
</section>

<section id="generating-large-datasets" class="title-slide slide level1">
<h1>Generating large datasets</h1>
<pre><code>#!/usr/bin/env python3
import random
with open(&quot;testdata.in&quot;,&quot;w&quot;) as outfile:
    for i in range(100000):
        outfile.write(random.randint(0,100))</code></pre>
</section>

<section id="thinking-bigger-a-case-study" class="title-slide slide level1">
<h1>Thinking bigger: a Case Study</h1>

</section>

<section id="cpsc-3220" class="title-slide slide level1">
<h1>CPSC 3220</h1>
<ul>
<li>Set of public and private tests</li>
<li>Autograder run once a day at noon</li>
<li>Students emailed their results</li>
</ul>
</section>

<section id="demo" class="title-slide slide level1">
<h1>Demo</h1>

</section>

<section id="how-does-it-help-students" class="title-slide slide level1">
<h1>How does it help students?</h1>
<ul>
<li>Faster feedback</li>
</ul>
</section>

<section id="how-does-it-help-you" class="title-slide slide level1">
<h1>How does it help You?</h1>
<ul>
<li>Saves time in grading</li>
<li>Students start earlier and do better</li>
<li>Saves you defensive programming</li>
</ul>
</section>

<section id="common-objections" class="title-slide slide level1">
<h1>Common Objections</h1>

</section>

<section id="the-costs-of-automation" class="title-slide slide level1">
<h1>The Costs of Automation</h1>
<ul>
<li>Certain mess-ups can be <em>catastrophic</em>
<ul>
<li>Lost projects</li>
<li>Wrong grades</li>
<li>Accidental leaks</li>
</ul></li>
<li>Using well designed framework helps</li>
<li>Writing scripts will take time</li>
</ul>
</section>

<section id="however-youll-probably-use-it-again" class="title-slide slide level1">
<h1>However you’ll probably use it again</h1>
<p><img data-src="http://imgs.xkcd.com/comics/is_it_worth_the_time.png" /></p>
<p>source: xkcd</p>
</section>

<section id="a-word-on-security" class="title-slide slide level1">
<h1>A Word on Security</h1>
<ul>
<li>The risk isn’t much higher
<ul>
<li>Unless you currently carefully audit every line of code</li>
</ul></li>
<li>Tools like systrace, containers, vms can improve security.</li>
<li>Treat violations as Academic Integrity Issues.</li>
</ul>
</section>

<section id="wrap-up" class="title-slide slide level1">
<h1>Wrap-Up</h1>

</section>

<section id="summary" class="title-slide slide level1">
<h1>Summary</h1>
<ul>
<li>Automation can save time and effort</li>
<li>Please consider automation</li>
</ul>
</section>

<section id="further-resources" class="title-slide slide level1">
<h1>Further Resources</h1>
<ul>
<li>Additional command references:
<ul>
<li>UNIX <code>man</code> pages - most commands have a <code>man</code> page</li>
<li><a href="http://www.grymoire.com/">Grymoire</a> - great scripting resource</li>
<li><a href="https://wiki.archlinux.org/index.php/Main_Page">Archwiki</a> - great command resource</li>
</ul></li>
<li>My [Autograder] <a href="https://github.com/robertu94/autograder">3</a></li>
<li><a href="http://www.usaco.org/">USACO</a>, <a href="https://open.kattis.com/">OpenKatis</a></li>
</ul>
</section>

<section id="questions" class="title-slide slide level1">
<h1>Questions</h1>
<p>Send us feedback at <code>acm@cs.clemson.edu</code>!</p>
<p>This material available under <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC By-SA 4.0</a></p>
</section>
