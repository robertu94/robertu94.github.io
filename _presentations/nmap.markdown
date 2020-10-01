---
title: NMAP
layout: presentation
location: CU Cyber
date: 2015-10-01
description: >
  This talk overviews NMAP a network mapping tool that is useful for
  understanding and monitoring your network.
...
<section>
<section id="intro-to-nmap" class="title-slide slide level1">
<h1>Intro to nmap</h1>
<p>Brought to you by Clemson ACM</p>
<p>We’re on <a href="http://steamcommunity.com/groups/clemsonacm">Steam</a> &amp; Freenode! Join #clemsonacm on chat.freenode.net!</p>
</section>
<section id="speakers" class="slide level2">
<h2>Speakers:</h2>
<p>Robert Underwood - ACM Vice President</p>
</section>
<section id="coming-up" class="slide level2">
<h2>Coming Up</h2>
<ul>
<li>What is nmap?</li>
<li>When should it be used?</li>
<li>What can it do?</li>
</ul>
</section></section>
<section>
<section id="what-is-nmap" class="title-slide slide level1">
<h1>What is nmap?</h1>

</section>
<section id="what-is-nmap-1" class="slide level2">
<h2>What is nmap?</h2>
<ul>
<li>nmap exploration and security tool</li>
<li>Essential diagnostic tool</li>
<li>Available for most OS</li>
</ul>
</section></section>
<section>
<section id="when-should-i-use-it" class="title-slide slide level1">
<h1>When should I use it?</h1>

</section>
<section id="when-should-i-use-it-1" class="slide level2">
<h2>When should I use it?</h2>
<ul>
<li>Determining hosts in IPv4 Network</li>
<li>When you want to examine ports on a host</li>
</ul>
</section></section>
<section>
<section id="what-can-it-do" class="title-slide slide level1">
<h1>What can it do?</h1>

</section>
<section id="what-can-it-do-1" class="slide level2">
<h2>What can it do?</h2>
<ul>
<li>Host enumeration</li>
<li>Service enumeration</li>
<li>Vulnerability enumeration</li>
</ul>
</section>
<section id="key-commands" class="slide level2">
<h2>Key Commands</h2>
<ul>
<li><code>nmap -sn network</code> scan network</li>
<li><code>nmap -T4 -A host</code> intense scan host</li>
</ul>
</section>
<section id="target-specifications" class="slide level2">
<h2>Target Specifications</h2>
<pre><code>192.168.1.1 # Single IPv4 host
192.168.1.0 # IPv4 network 254 hosts
2::dead:beaf:cafe # A host in IPv6
2::dead:beaf:cafe/24 # A host in IPv6 (use -6 flag)
www.foobar.com # A host by hostname</code></pre>
</section>
<section id="host-discovery" class="slide level2">
<h2>Host Discovery</h2>
<ul>
<li><code>-sL</code> list Scan</li>
<li><code>-sn</code> ping scan</li>
<li>Various types of packets <code>-Pn</code>, <code>-PS</code>, <code>-PA</code>, <code>-PU</code>, and <code>-PY</code></li>
</ul>
</section>
<section id="port-scanning" class="slide level2">
<h2>Port Scanning</h2>
<ul>
<li><code>-p</code> Scan specified ports</li>
<li><code>--allports</code> scan every port</li>
<li>Various port scans <code>-sS</code>, <code>-sT</code>, <code>-sU</code> <code>-sY</code></li>
</ul>
</section>
<section id="service-scanning" class="slide level2">
<h2>Service Scanning</h2>
<ul>
<li><code>-O</code> Use OS detection</li>
<li><code>-sV</code> Use version checking</li>
</ul>
</section>
<section id="scripts" class="slide level2">
<h2>Scripts</h2>
<ul>
<li><code>-sC</code> use default scripts</li>
<li><code>--script "&lt;option&gt;"</code></li>
<li>look for these in <code>/usr/share/nmap/scripts</code></li>
</ul>
</section>
<section id="timing-and-optimizations" class="slide level2">
<h2>Timing and Optimizations</h2>
<ul>
<li><code>-T[1-5]</code> timing levels
<ul>
<li><code>1</code> is the slowest</li>
<li><code>5</code> is the slowest</li>
</ul></li>
<li>evasive options</li>
</ul>
</section>
<section id="output-formats" class="slide level2">
<h2>Output Formats</h2>
<ul>
<li><code>-oN &lt;file&gt;</code> normal output</li>
<li><code>-oG &lt;file&gt;</code> grep-able output</li>
<li><code>-oX &lt;file&gt;</code> xml output</li>
</ul>
</section>
<section id="further-resources" class="slide level2">
<h2>Further Resources</h2>
<ul>
<li><a href="https://nmap.org/">nmap</a> developers of <code>nmap</code></li>
<li><a href="https://wiki.archlinux.org/index.php/Main_Page">Archwiki</a> useful command reference</li>
</ul>
</section>
<section id="questions" class="slide level2">
<h2>Questions</h2>
<p>Send feedback to acm@cs.clemson.edu</p>
<p>This material available under <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC By-SA 4.0</a></p>
</section></section>
