---
title: N Unix Tools in O(N ) Minutes
layout: presentation
location: Clemson ACM Seminar
date: 2015-03-01
description: >
  Overview of command line tools for POSIX platforms.  This talk covers some of the most useful
  POSIX scripting tools including awk, sed, gdb, find, and more.
acknowledgments: Austin Anderson collaborated on these slides
...
<section id="n-unix-tools-in-on-minutes" class="title-slide slide level1">
<h1>N Unix tools in O(N) minutes</h1>

</section>

<section id="brought-to-you-by-clemson-acm" class="title-slide slide level1">
<h1>Brought to you by Clemson ACM</h1>
<p>We’re on <a href="http://steamcommunity.com/groups/clemsonacm">Steam</a> &amp; <a href="https://www.facebook.com/groups/283823058297107/">Facebook</a>! Join #clemsonacm on chat.freenode.net!</p>
</section>

<section id="speakers" class="title-slide slide level1">
<h1>Speakers:</h1>
<p>Robert Underwood - ACM Vice President<br />
Austin Anderson - ACM President</p>
</section>

<section id="coming-up" class="title-slide slide level1">
<h1>Coming Up</h1>
<ul>
<li>For each tool:
<ul>
<li>Purpose</li>
<li>Common use cases</li>
<li>Important flags</li>
<li>Alternatives</li>
</ul></li>
</ul>
</section>

<section id="awk" class="title-slide slide level1">
<h1>awk</h1>
<p>Pattern scanning and processing</p>
<ul>
<li><code>BEGIN {action}</code> executes before processing</li>
<li><code>pattern {action}</code> default pattern style</li>
<li><code>END {action}</code> executes after the file is processed</li>
<li>patterns are based on <code>re_format</code></li>
<li>missing patterns always match, missing actions always print</li>
<li><code>perl</code></li>
</ul>
</section>

<section id="example-awk-script" class="title-slide slide level1">
<h1>Example awk Script</h1>
<pre><code>#computes the average of space delimited data
#where the second column is even
BEGIN {n = 0}
$2%2 == 0 {s += $1; n++}
END {print &quot;sum is&quot;, s, &quot; average is&quot;, s/n}</code></pre>
</section>

<section id="sed" class="title-slide slide level1">
<h1>sed</h1>
<p>Command line text manipulation</p>
<ul>
<li><code>sed 's/hello/goodbye/g [file]'</code> replaces “hello” with “goodbye”
<ul>
<li>Prints to stdout, redirect it!</li>
</ul></li>
<li><code>sed /bad/d</code> deletes lines containing “bad”</li>
<li><code>sed 1d;$d</code> deletes first and last line</li>
<li>Can use <code>/regexes/</code> or other rules, check <code>man sed</code></li>
</ul>
</section>

<section id="bash" class="title-slide slide level1">
<h1>bash</h1>
<p>Gluing programs together</p>
<ul>
<li><code>|</code> pipelining</li>
<li><code>&amp;&gt; dest</code> redirect stderr and stdout to dest</li>
<li><code>word</code> executes word in a subshell first</li>
<li>support <code>for</code> and <code>while</code> loops</li>
<li>even includes functions!</li>
<li><code>zsh</code>, <code>fish</code></li>
</ul>
</section>

<section id="example-bash-script" class="title-slide slide level1">
<h1>Example bash script</h1>
<pre><code>for i in $(ls)
    do
    cd $i
    git pull
    cd ..
done</code></pre>
</section>

<section id="cron" class="title-slide slide level1">
<h1>cron</h1>
<p>Running jobs at fixed times</p>
<ul>
<li>Probably the least standardized tool on this list</li>
<li>On most modern Linux boxes replaced by systemd</li>
<li><code>crontab -e</code> edit user crontab</li>
<li>persistent crontab; system dependent location</li>
<li><em>warning</em> cron ignores <em>all</em> environment variables</li>
<li><code>anacron</code> and <code>systemd</code> timers</li>
</ul>
</section>

<section id="example-crontab" class="title-slide slide level1">
<h1>Example crontab</h1>
<pre><code>PATH=/usr/bin
SHELL=/bin/bash
MAILTO=acm
# minute hour dayOfMonth month dayOfWeek cmd
0 0 0 * * echo &quot;Cron Example&quot;</code></pre>
</section>

<section id="find" class="title-slide slide level1">
<h1>find</h1>
<p>Find files on the file system</p>
<ul>
<li><p>can be filtered by user, size, time, name</p></li>
<li><p>can be used to preform batch operations</p></li>
<li><p><code>locate</code></p>
<pre><code>  find /etc name &quot;*.pdf&quot; -user acm -size +2G -mtime -2w</code></pre></li>
</ul>
</section>

<section id="gcc" class="title-slide slide level1">
<h1>gcc</h1>
<p>Cross compile C, C++, Fortran, Ada, and java (apparently)</p>
<ul>
<li><code>-std=standard</code> adjust the standard used</li>
<li><code>-c</code> just compile; don’t link</li>
<li><code>-s</code> just generate assembly</li>
<li><code>-g</code> turn on debug flags</li>
<li><code>-D</code> Conditional compilation</li>
<li><code>&lt;machine&gt;-gcc-&lt;version&gt;</code> for cross-compilation</li>
<li><code>clang</code></li>
</ul>
</section>

<section id="gdb" class="title-slide slide level1">
<h1>gdb</h1>
<p>Debug C and C++ code</p>
<ul>
<li>accepts format flags for print</li>
<li>use the <code>set</code> command to force a value</li>
<li><code>-tui</code> for a gui</li>
<li>can be run in a batch mode <code>-batch -x script</code></li>
<li><em>warning</em> ignores arguments in batch mode</li>
</ul>
</section>

<section id="gdb-script" class="title-slide slide level1">
<h1>gdb Script</h1>
<pre><code>b f
commands 2
    p x
    p y
    continue
end</code></pre>
</section>

<section id="grep" class="title-slide slide level1">
<h1>grep</h1>
<p>Find pattern in a text</p>
<ul>
<li>uses <code>re_format</code> style regex</li>
<li><code>-C3</code> print 3 lines of context around match</li>
<li><code>-c</code> print number of matches</li>
<li><code>-e</code> specify multiple patterns</li>
<li><code>-r</code> recursively search</li>
<li><code>--exclude</code> ignore file paths</li>
<li><code>ack</code> and <code>ag</code></li>
</ul>
</section>

<section id="make" class="title-slide slide level1">
<h1>make</h1>
<p>Intelligently compile, test, and install</p>
<ul>
<li>variables and functions</li>
<li>targets - what is to be built</li>
<li>dependencies - what must be built first</li>
<li>rules - how to build it</li>
<li>tabs only before rules</li>
<li><code>autotools</code>, <code>cmake</code>, <code>scons</code></li>
</ul>
</section>

<section id="makefile-example" class="title-slide slide level1">
<h1>makefile Example</h1>
<pre><code>SRCS=$(wildcard *.cpp)
all: $(SRCS)
    g++ $(SRCS) -g -Wall
clean:
    -rm a.out
test: all
    ./a.out</code></pre>
</section>

<section id="ssh" class="title-slide slide level1">
<h1>ssh</h1>
<p>Connect to a remote computer</p>
<ul>
<li><p><code>ssh-keygen</code> create ssh keys</p></li>
<li><p><code>ssh-copy-id user@host</code> send them to remote machines</p></li>
<li><p><code>-YC</code> forward X11 compressed</p></li>
<li><p>takes an optional command argument last</p>
<pre><code>  ssh acm@joey1.cs.clemson.edu ls </code></pre></li>
</ul>
</section>

<section id="scp" class="title-slide slide level1">
<h1>scp</h1>
<p>Copy files to and from remote locations</p>
<ul>
<li><p><code>-r</code> recursive</p></li>
<li><p><code>user@location:path</code></p></li>
<li><p><code>rsync</code></p>
<pre><code>  scp -r acm@access.cs.clemson.edu:/repos/clemson-acm .</code></pre></li>
</ul>
</section>

<section id="tmux" class="title-slide slide level1">
<h1>tmux</h1>
<p>Terminal Multiplexer</p>
<ul>
<li><code>tmux new -s SESSION</code></li>
<li><code>tmux attach [-t SESSION]</code></li>
<li><code>tmux detach</code> or <code>&lt;C-b&gt; d</code></li>
<li><code>tmux split-window</code> or <code>&lt;C-b&gt; "</code> or %`</li>
<li><code>tmux select-pane</code> or <code>&lt;C-b&gt; o</code></li>
<li><code>screen</code></li>
</ul>
</section>

<section id="sudo" class="title-slide slide level1">
<h1>sudo</h1>
<p>Request root privileges</p>
<ul>
<li><code>-e filename</code> edit the file with <code>$EDITOR</code></li>
<li><code>-g group</code> run command as group</li>
<li><code>-u user</code> run command as user</li>
<li><code>visudo</code> edit the sudoers file</li>
<li><code>user host = (useralias) commandspec</code></li>
<li><code>selinux</code></li>
</ul>
</section>

<section id="sudoers-file" class="title-slide slide level1">
<h1>sudoers file</h1>
<pre><code>#allow root to run all commands
root ALL=(ALL) ALL
#allow the admin group to run all commands
%admin ALL=(ALL) ALL
#allow acm to reset passwords for all except root
acm    ALL  = /usr/bin/passwd [A-Za-z]*, !/usr/bin/passwd root
#allow president to edit the crontab on foobar
president foobar= sudoedit /etc/crontab</code></pre>
</section>

<section id="systemctl" class="title-slide slide level1">
<h1>systemctl</h1>
<p>Control system processes</p>
<ul>
<li><code>start</code> start a service</li>
<li><code>stop</code> stop a service</li>
<li><code>reload</code> reload a service</li>
<li><code>status</code> get the status of a process</li>
<li><code>isolate</code> change target</li>
<li><code>sysVinit</code>, <code>syslog</code>, <code>network-manager</code>, etc</li>
</ul>
</section>

<section id="systemctl-unitfile" class="title-slide slide level1">
<h1>systemctl Unitfile</h1>
<pre><code>[unit]
    Description=Sample Systemd Unitfile
    Requires=network.target
    After=network.target
[service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/usr/bin/wpa-supplicant
[install]
    WantedBy=network.target
    
    </code></pre>
</section>

<section id="tar" class="title-slide slide level1">
<h1>tar</h1>
<p>Create and extract archives</p>
<ul>
<li><p><code>-c</code> create archive</p></li>
<li><p><code>-x</code> extract archive</p></li>
<li><p><code>-j</code> use bzip2 compression <em>smaller</em></p></li>
<li><p><code>-z</code> use gzip compressed <em>faster</em></p></li>
<li><p><code>-v</code> list files as stored/extracted</p></li>
<li><p><code>-f</code> output file</p></li>
<li><p><code>zip</code></p>
<pre><code>  tar -cvzf project1.tgz README Makefile *.c
  tar -xvf project1.tgz</code></pre></li>
</ul>
</section>

<section id="time" class="title-slide slide level1">
<h1>time</h1>
<p>Time how long it takes a program to execute</p>
<ul>
<li><code>time tar -czf foobar</code></li>
</ul>
</section>

<section id="valgrind" class="title-slide slide level1">
<h1>valgrind</h1>
<p>A debugger that detects memory leaks and other profiling + <code>gdb</code></p>
<pre><code>    valgrind --leak-check=yes program-name
    valgrind --tool=callgrind program-name
    valgrind --tool=cachegrind program-name</code></pre>
</section>

<section id="watch" class="title-slide slide level1">
<h1>watch</h1>
<p>Repeatedly print the output of a command</p>
<ul>
<li><p><code>-n</code> Change the update interval</p></li>
<li><p><code>-d</code> highlight differences</p>
<pre><code>  watch -n 1 ls -r</code></pre></li>
</ul>
</section>

<section id="wget" class="title-slide slide level1">
<h1>wget</h1>
<p>Download file from the Internet</p>
<ul>
<li><p><code>-c</code> continue the download</p></li>
<li><p><code>-r</code> recursively download files</p></li>
<li><p><code>-N</code> only download <em>new</em> files</p></li>
<li><p><code>curl</code></p>
<pre><code>  wget -N www.google.com</code></pre></li>
</ul>
</section>

<section id="xargs" class="title-slide slide level1">
<h1>xargs</h1>
<p>Construct argument lists</p>
<ul>
<li><p><code>-P maxprocs</code> run commands in parallel<br />
</p></li>
<li><p><code>-s size</code> limits argument size; default size 4096 bytes</p></li>
<li><p><code>-n number</code> max number of arguments</p>
<p>find src/215 -name “*.java”|xargs wc -l</p></li>
</ul>
</section>

<section id="further-resources" class="title-slide slide level1">
<h1>Further Resources</h1>
<ul>
<li><a href="http://www.grymoire.com/">Grymoire</a></li>
<li><a href="https://wiki.archlinux.org/index.php/Main_Page">Archwiki</a></li>
</ul>
</section>

<section id="questions" class="title-slide slide level1">
<h1>Questions</h1>
<p>Send feedback to acm@cs.clemson.edu</p>
<p>This material available under <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC By-SA 4.0</a></p>
</section>
