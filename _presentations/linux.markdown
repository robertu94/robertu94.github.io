---
title: Linux is Scary
layout: presentation
location: Clemson ACM Seminar
date: 2016-02-01
description: >
  Introduction to Linux for new computer science students.  Presented multiples times,
acknowledgments: Slide content was a adapted from an earlier presentation by a former Clemson ACM member.
...
<section>
<section id="linux-is-scary" class="title-slide slide level1">
<h1>Linux is Scary</h1>
<p>Brought to you by Clemson ACM</p>
<p>We’re on <a href="http://steamcommunity.com/groups/clemsonacm">Steam</a> and Freenode on <code>#clemsonacm</code></p>
</section>
<section id="speakers" class="slide level2">
<h2>Speakers:</h2>
<p>Robert Underwood - ACM Vice President</p>
<p>Marshall Clyburn - ACM President</p>
</section>
<section id="coming-up" class="slide level2">
<h2>Coming up</h2>
<ol type="1">
<li>What’s up with Linux?</li>
<li>The Linux file system</li>
<li>Terminal Power</li>
<li>Getting owned by Permissions</li>
<li>Working from Other Machines</li>
<li>Your free web hosting at people.cs.clemson.edu</li>
<li>Wrap-up</li>
</ol>
</section></section>
<section>
<section id="whats-up-with-linux" class="title-slide slide level1">
<h1>What’s up with Linux?</h1>

</section>
<section id="linux-a-short-history" class="slide level2">
<h2>Linux: A Short History</h2>
<ul>
<li>Created in 1991 by <strong>Linus Torvalds</strong></li>
<li>Written in C and Assembly Languages</li>
<li>Uses a <em>Unix-like</em> file structure (more on that later)</li>
<li>Kernel is still being maintained by Torvalds et al
<ul>
<li>You could contribute if you wanted!</li>
</ul></li>
</ul>
</section>
<section id="whats-a-distribution" class="slide level2">
<h2>What’s a Distribution?</h2>
<ul>
<li>A “flavor” of Linux with small differences</li>
<li>Might differ in…
<ul>
<li><em>Desktop Environment</em> - controls windows
<ul>
<li>Examples are <strong>Mate</strong>, <strong>Gnome</strong>, and <strong>KDE</strong></li>
</ul></li>
<li><em>Package manager</em> - install and update software</li>
<li>Behind-the-scenes <em>applications</em> and <em>settings</em></li>
<li>Default <em>applications</em></li>
</ul></li>
</ul>
</section>
<section id="common-distributions" class="slide level2">
<h2>Common Distributions</h2>
<ul>
<li><strong>Debian based</strong>: uses the DEB package system
<ul>
<li>Ubuntu (Xubuntu, Kubuntu, Ubuntu Mate)</li>
<li>Elementary OS, Linux Mint, et al</li>
</ul></li>
<li><strong>RedHat based</strong>: uses the RPM package system
<ul>
<li>Fedora, CentOS, Scientific Linux</li>
</ul></li>
</ul>
</section>
<section id="common-distributions-1" class="slide level2">
<h2>Common Distributions</h2>
<ul>
<li><strong>OpenSUSE</strong>: heavy focus on OS innovation</li>
<li><strong>Source based</strong>: focus on customization
<ul>
<li>Gentoo, ArchLinux</li>
</ul></li>
</ul>
</section>
<section id="big-names-in-nix" class="slide level2">
<h2>Big Names in *nix</h2>
<ul>
<li><strong>Linus Torvalds</strong>: creator of Linux,</li>
<li><strong>Greg Kroah-Hartman</strong>: stable branch maintainer</li>
<li><strong>Richard Stallman</strong>: founder of GNU</li>
<li><strong>GNU Project</strong>: “GNU’s Not Unix”,
<ul>
<li>leader in Open Source Software Licensing</li>
<li>Wrote GNU Public License (GPL)</li>
</ul></li>
</ul>
</section>
<section id="kernel-and-other-scary-words" class="slide level2">
<h2>“Kernel” and Other Scary Words</h2>
<ul>
<li><strong>Kernel</strong>: part of Linux that interacts with hardware</li>
<li><strong>Shell</strong>: terminal-based control application
<ul>
<li>manipulate anything on the system</li>
<li>starts programs</li>
</ul></li>
<li><strong>Bash</strong>: is the most common shell</li>
</ul>
</section>
<section id="kernel-and-other-scary-words-1" class="slide level2">
<h2>“Kernel” and Other Scary Words</h2>
<ul>
<li><strong>Environment Variables</strong>: variable that controls program behavior</li>
<li><strong>PATH</strong>: where to the shell searches for executables</li>
<li><strong>EDITOR</strong>: what editor to use when needed</li>
<li><strong>HOME</strong> where your files are kept</li>
</ul>
</section>
<section id="kernel-and-other-scary-words-2" class="slide level2">
<h2>“Kernel” and Other Scary Words</h2>
<ul>
<li><strong>Version control systems</strong>: track history of code
<ul>
<li>Common VCSs include <code>git</code>, <code>mercurial</code>, and <code>svn</code></li>
<li>Web handin uses <code>mercurial</code> as a back end</li>
<li>See our seminars on <code>git</code> or projects for more</li>
</ul></li>
<li><code>make</code> and <code>Makefile</code>: a tool for installing software</li>
</ul>
</section>
<section id="building-from-source" class="slide level2">
<h2>“Building from Source”</h2>
<ul>
<li>When you can’t get a pre-compiled executable</li>
<li>Download the source code</li>
<li>Read the README file, then often run</li>
<li><code>./configure</code></li>
<li><code>make</code></li>
<li><code>sudo make install</code></li>
</ul>
</section>
<section id="packaging-systems" class="slide level2">
<h2>Packaging systems</h2>
<ul>
<li>Easy way to install many applications</li>
<li>Most distributions have <strong>Package Managers</strong>
<ul>
<li>package managers need to be run using <code>sudo</code></li>
</ul></li>
</ul>
</section>
<section id="apt" class="slide level2">
<h2>APT</h2>
<ul>
<li><code>apt</code> - used on Debian based systems, including Ubuntu.
<ul>
<li><code>apt update</code> - update metadata</li>
<li><code>apt search &lt;package&gt;</code> - find package</li>
<li><code>apt install &lt;package&gt;</code> - install package</li>
<li><code>apt upgrade</code> - update all packages</li>
</ul></li>
</ul>
</section>
<section id="other-packaging-systems" class="slide level2">
<h2>Other Packaging systems</h2>
<ul>
<li><code>dnf</code>: installed on Fedora</li>
<li><code>rpm</code>: backend for yum, dnf, et al</li>
<li><code>pacman</code>: used on Arch Linux</li>
</ul>
</section></section>
<section>
<section id="the-linux-file-system" class="title-slide slide level1">
<h1>The Linux File System</h1>

</section>
<section id="basic-hierarchy" class="slide level2">
<h2>Basic Hierarchy</h2>
<ul>
<li>Based on <em>one</em> root directory, not drives like C: or D:</li>
<li>Physical devices (drives, output) and important folders are <em>mounted</em> to subdirectories of <code>/</code></li>
</ul>
<p><strong>Some distros are a little different in how they manage these folders</strong></p>
</section>
<section id="basic-hierarchy-1" class="slide level2">
<h2>Basic Hierarchy</h2>
<ul>
<li><code>/home</code>: where user’s files normally live</li>
<li><code>/bin</code>: stores system executables</li>
<li><code>/usr</code>: where system libraries and the like are</li>
<li><code>/dev</code>: device nodes; Don’t mess with things here</li>
<li><code>/mnt</code>: where you can mount things like USB drives</li>
</ul>
</section>
<section id="everything-is-a-file" class="slide level2">
<h2>Everything is a File</h2>
<ul>
<li>Linux sees every object as a subclass of a file</li>
<li>Folders, links, devices, and executables are “files”!</li>
</ul>
</section>
<section id="where-are-my-.exes" class="slide level2">
<h2>Where are my .exes?</h2>
<ul>
<li>File extensions categorize, not restrict</li>
<li>A file with any name could be executed
<ul>
<li><code>a.out</code>, <code>prog1</code>, <code>.bashrc</code></li>
</ul></li>
<li>Files starting with a dot like <code>.bashrc</code> are usually <em>hidden</em> from listings</li>
<li>Running a command like <code>sl</code> is really just running an executable file within the <code>PATH</code></li>
</ul>
</section></section>
<section>
<section id="terminal-power" class="title-slide slide level1">
<h1>Terminal Power</h1>

</section>
<section id="echo-navigation-commands" class="slide level2">
<h2>echo “navigation commands”</h2>
<ul>
<li>Stuck? <code>Ctrl+c</code> often quits the running program</li>
<li><code>pwd</code> lists your current directory</li>
<li><code>cd directory</code> moves the terminal to <code>directory</code></li>
<li><code>ls</code> lists files and folders in the current directory
<ul>
<li><code>ls -l</code> gives additional file information</li>
<li><code>ls -a</code> shows even <code>.hidden-files</code></li>
</ul></li>
</ul>
</section>
<section id="echo-file-commands" class="slide level2">
<h2>echo “file commands”</h2>
<p>*** THERE IS NO TRASH CAN! ***</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode bash"><code class="sourceCode bash"><span id="cb1-1"><a href="#cb1-1" aria-hidden="true"></a><span class="fu">mv</span> orig.file new.file  # move a file</span>
<span id="cb1-2"><a href="#cb1-2" aria-hidden="true"></a><span class="fu">cp</span> orig.file copy.file <span class="co"># copy a file</span></span>
<span id="cb1-3"><a href="#cb1-3" aria-hidden="true"></a><span class="fu">rm</span> orig.file           # remove a file</span>
<span id="cb1-4"><a href="#cb1-4" aria-hidden="true"></a><span class="fu">rm</span> -r directory        # remove a directory and contents</span></code></pre></div>
</section>
<section id="flags-command-structure" class="slide level2">
<h2>–Flags?! : Command Structure</h2>
<ul>
<li>Generally <code>progname -one-letter-flags --longer-flag parameter</code> <code>[optional parameters]  parameter-list...</code></li>
<li>Some flags need arguments after them
<ul>
<li><code>ping -c 12</code> OR <code>ping --count=12</code></li>
</ul></li>
</ul>
</section>
<section id="common-flags" class="slide level2">
<h2>Common Flags</h2>
<ul>
<li>Structure varies by program</li>
<li>for help try: <code>progname --help</code> or <code>-h</code>
<ul>
<li>Sometimes simpler than <code>man progname</code></li>
</ul></li>
<li>for output try: <code>progname --verbose</code> or <code>-v</code></li>
</ul>
</section>
<section id="terminal-symbols-shorthand" class="slide level2">
<h2>Terminal Symbols &amp; Shorthand</h2>
<ul>
<li><code>.</code> (one dot) is the <em>current directory</em></li>
<li><code>..</code> (two dots) is the <em>parent directory</em></li>
<li><code>/</code> is the <em>root directory</em></li>
<li><code>~</code> is your <em>user directory</em></li>
<li><code>!!</code> is the <em>previously entered command</em>
<ul>
<li>Use <code>sudo !!</code> to run the last command under sudo</li>
</ul></li>
</ul>
</section>
<section id="terminal-symbols-shorthand-1" class="slide level2">
<h2>Terminal Symbols &amp; Shorthand</h2>
<ul>
<li><code>\</code> begins an escape character sequence
<ul>
<li><code>\n</code> is a newline character</li>
<li><code>\</code> (space) inserts a space into one argument (otherwise the argument will break)</li>
<li><code>\\</code> actually inserts a backslash</li>
</ul></li>
</ul>
</section>
<section id="terminal-symbols-shorthand-2" class="slide level2">
<h2>Terminal Symbols &amp; Shorthand</h2>
<ul>
<li><code>$(command)</code> or `command` inserts the output of <code>command</code> into</li>
<li><code>command &amp;</code> will run <code>command</code> in the background</li>
</ul>
</section>
<section id="messing-with-output" class="slide level2">
<h2>Messing with Output</h2>
<ul>
<li>Any text output you see in the terminal comes from <strong>standard out</strong>
<ul>
<li>Think <strong>cout</strong> in C++ and <strong>printf()</strong> in C</li>
</ul></li>
<li><code>echo input</code> - print <code>input</code> to standard out</li>
<li><code>cat input.file</code> - print <code>file</code> to the terminal</li>
</ul>
</section>
<section id="messing-with-output-1" class="slide level2">
<h2>Messing with Output</h2>
<ul>
<li>Many commands like <code>grep</code> and <code>less</code> read from <strong>standard in</strong>
<ul>
<li>Think <strong>cin</strong> in C++ and <strong>scanf()</strong> reads from in C</li>
</ul></li>
<li><code>grep pattern input.file</code>: filters a pattern</li>
<li><code>less input.file</code>: buffers output</li>
</ul>
</section>
<section id="piping-and-redirection" class="slide level2">
<h2>Piping and Redirection</h2>
<ul>
<li><strong>Piping</strong> <code>command-a | command-b</code>
<ul>
<li>connects the <em>standard output</em> of <code>command-a</code></li>
<li>to <em>standard input</em> of <code>command-b</code></li>
<li>useful for chaining commands</li>
<li>Ex: <code>command-a | less</code> easy reading</li>
</ul></li>
</ul>
</section>
<section id="redirection" class="slide level2">
<h2>Redirection</h2>
<ul>
<li><strong>Redirection</strong> reassign standard in/out/error to files</li>
<li><code>progname &gt; output.file</code> overwrites <code>output.file</code> with output</li>
<li><code>&gt;&gt;</code> <em>appends to</em> <code>file</code> with <code>progname</code>’s output</li>
<li><code>&amp;&gt;</code> overwrites <code>file</code> with <code>progname</code>’s <em>error output</em></li>
<li><code>&amp;&gt;&gt;</code> <em>appends to</em> <code>file</code> with <code>progname</code>’s <em>error output</em></li>
<li><code>progname &lt; input.file</code> uses <code>input.file</code>’s content as input for <code>progname</code></li>
</ul>
</section>
<section id="shell-history" class="slide level2">
<h2>Shell History</h2>
<p>*** How did I run that again? ***</p>
<ul>
<li>Press the up key to cycle through your previously entered commands</li>
<li><code>history</code> - print previous commands</li>
<li>Search it with grep – <code>history | grep ls</code></li>
<li><code>Ctrl-r</code> for a history search</li>
</ul>
</section>
<section id="shell-configuration" class="slide level2">
<h2>Shell configuration</h2>
<ul>
<li>On your home machine, you could replace <strong>bash</strong> with another shell like <strong>zsh</strong> or <strong>ksh</strong></li>
<li>Editing <code>~/.bashrc</code> can customize your shell with functions, <strong>aliases</strong>, and <strong>functions</strong>.</li>
<li>Aliases are simple: <code>alias sl=echo "Steam Locomotive"</code></li>
<li>There are a ton of tutorials on customizing the shell, so we’ll skip it for now.</li>
</ul>
</section>
<section id="man-and-other-awesome-commands" class="slide level2">
<h2><code>man</code> and Other Awesome Commands</h2>
<ul>
<li><code>man</code> - summons an <em>extensive</em> manual page for about anything
<ul>
<li><code>man stdio.h</code>, <code>man grep</code>, <code>man man</code></li>
</ul></li>
<li><code>touch name.file</code> creates an empty <code>name.file</code> if none exists</li>
<li><code>find</code> locate a file on your computer</li>
</ul>
</section>
<section id="man-and-other-awesome-commands-1" class="slide level2">
<h2><code>man</code> and Other Awesome Commands</h2>
<ul>
<li><code>vim [edit.file]</code> awesome text editor with steep learning curve</li>
<li><code>emacs -nw [edit.file]</code> great OS needing a good editor</li>
<li><code>curl -LO [URL]</code> copies a file from the web</li>
</ul>
</section>
<section id="man-and-other-awesome-commands-2" class="slide level2">
<h2><code>man</code> and Other Awesome Commands</h2>
<ul>
<li><code>tar</code> - manage tar ball (.tar) and tar ball + gzipped (.tgz, .tar.gz) archives
<ul>
<li><code>tar -xzf</code> (e<strong>x</strong>tract <strong>z</strong>e <strong>f</strong>iles!!) <code>&lt;archive&gt;</code>
<ul>
<li><code>tar -xf</code> for just <code>.tar</code></li>
</ul></li>
<li><code>tar -czf</code> (<strong>c</strong>reate <strong>z</strong>e <strong>f</strong>iles!!) <code>archivename.tgz files...</code> to create an archive</li>
<li><a href="http://imgs.xkcd.com/comics/tar.png">Relevant XKCD comic</a></li>
</ul></li>
</ul>
</section>
<section id="shell-scripts" class="slide level2">
<h2>Shell Scripts</h2>
<ul>
<li>put commands into a file to run them all at once repeatedly</li>
<li>add <code>#!/bin/bash</code> as the first line</li>
<li>one command per line</li>
<li><code>chmod u+x script.sh</code></li>
<li><code>./script.sh</code></li>
</ul>
</section></section>
<section>
<section id="getting-owned-by-permissions" class="title-slide slide level1">
<h1>Getting Owned by Permissions</h1>

</section>
<section id="users-root-and-groups" class="slide level2">
<h2>Users, Root and Groups</h2>
<ul>
<li><em>Users</em> are unique accounts</li>
<li><em>Root</em> is the <strong>superuser</strong> and can do <em>anything</em>.
<ul>
<li><strong>DON’T TRY TO USE ROOT ON THE CU MACHINES</strong>.</li>
<li>Run a command as root with <code>sudo &lt;command&gt;</code></li>
<li>temporarily login as root with <code>sudo --login</code></li>
</ul></li>
</ul>
</section>
<section id="users-root-and-groups-1" class="slide level2">
<h2>Users, Root and Groups</h2>
<ul>
<li>Users in the same <em>Groups</em> share permissions pertaining to that group
<ul>
<li>Ex:users in <code>sudoers</code> can use <code>sudo</code></li>
<li>the admin group might be different</li>
<li>Users can be in multiple groups</li>
</ul></li>
<li><code>man chmod</code> and <code>man chgrp</code> for more info on permissions and groups</li>
</ul>
</section></section>
<section>
<section id="working-from-other-machines" class="title-slide slide level1">
<h1>Working from other machines</h1>

</section>
<section id="getting-to-your-files-with-ssh" class="slide level2">
<h2>Getting to your files with SSH</h2>
<ul>
<li><code>ssh username@access.cs.clemson.edu</code> starts a remote connection to the Lab computer</li>
<li>Pick one of the servers listed in the message and <code>ssh</code> to it</li>
<li><strong>DON’T RUN/COMPILE ON access.cs.clemson.edu</strong></li>
</ul>
</section>
<section id="using-a-vm" class="slide level2">
<h2>Using a VM</h2>
<ul>
<li>VirtualBox
<ul>
<li>Can run a Linux VM inside of Windows/Mac OS X</li>
</ul></li>
</ul>
</section>
<section id="windows-cygwin" class="slide level2">
<h2>Windows: Cygwin?</h2>
<p>*** Bad Idea ***</p>
</section>
<section id="ubuntu-for-windows" class="slide level2">
<h2>Ubuntu for Windows?</h2>
<p>*** Better Idea ***</p>
</section>
<section id="dual-boot-or-vm" class="slide level2">
<h2>Dual-boot or VM</h2>
<p>*** Best Idea ***</p>
</section>
<section id="final-warnings" class="slide level2">
<h2>Final warnings</h2>
<p>*** NEVER RUN A RANDOM COMMAND FROM THE INTERNET ***</p>
<ul>
<li><strong>DON’T CHEAT</strong>
<ul>
<li>Professors use advanced software that checks the algorithms your code uses</li>
<li>Changing variable names won’t help</li>
</ul></li>
<li>Don’t use <code>sudo</code> on the lab machines
<ul>
<li>They yell at you and phone home to the sysadmins</li>
</ul></li>
<li>Want to install something? Email <code>ithelp@clmeson.edu</code> and put <code>School of Computing</code> in the subject line.</li>
</ul>
</section>
<section id="the-snapshot-system" class="slide level2">
<h2>The snapshot system</h2>
<ul>
<li>Contents are in <code>~/.snapshot</code></li>
<li>Keeps hourly, nightly, and weekly backups of files in <code>~</code></li>
<li>Especially useful when you accidentally overwrite a project at 2 am</li>
</ul>
<p>*** SNAPSHOTS ARE UNIQUE TO CLEMSON. DON’T RELY ON IT! ***</p>
</section>
<section id="your-free-clemson-web-hosting" class="slide level2">
<h2>Your Free Clemson Web Hosting</h2>
<ul>
<li>Run <code>cd /web/home/username/public_html</code>
<ul>
<li>Trust us, it’s there</li>
</ul></li>
<li>Files you put there will be served on the web at <code>people.cs.clemson.edu/~username/</code></li>
<li>Change permissions so the web server can access them
<ul>
<li><code>chmod a+r [serving files]</code></li>
<li><code>chmod a+g [sub-directories]</code></li>
</ul></li>
</ul>
</section></section>
<section>
<section id="wrap-up" class="title-slide slide level1">
<h1>Wrap up</h1>

</section>
<section id="further-resources" class="slide level2">
<h2>Further resources</h2>
<ul>
<li><a href="http://linuxjourney.com/">Linux Journey</a></li>
<li><a href="http://www.cs.clemson.edu/help/linux-workshop/soc_linux_cheatsheet.pdf">Cheetsheet</a> of commands</li>
<li>Plug a long command into <a href="http://explainshell.com/">ExplainShell.com</a> to see what it does</li>
<li>We’re on <a href="http://steamcommunity.com/groups/clemsonacm">Steam</a> and freenode at <code>#clemsonacm</code></li>
<li>Admins work in the main hallway</li>
</ul>
</section>
<section id="questions" class="slide level2">
<h2>Questions</h2>
<p>Send us feedback at <code>acm@cs.clemson.edu</code>!</p>
<p>This material available under <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC By-SA 4.0</a></p>
</section></section>
