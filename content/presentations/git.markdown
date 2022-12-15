---
title: Git Well Soon
layout: presentation
location: Clemson ACM Seminar
date: 2015-09-01
Summary: >
  This talks overviews the git distributed version control system, what
  problems it solves, and how to use it.  This talk was presented multiple times
  also under the title "Git Thee to a Version Control System"
acknowledgments: Austin Anderson collaborated on these slides
video: https://youtu.be/7ffteDNW-WA
---
<section id="git-well-soon" class="title-slide slide level1">
<h1>Git Well Soon!</h1>

</section>

<section id="how-to-keep-your-code-straight-with-git" class="title-slide slide level1">
<h1>How to keep your code straight with Git</h1>
<p>Brought to you by Clemson ACM. Join us on <code>#clemsonacm</code> @ <code>irc.freenode.net</code>!</p>
</section>

<section id="speakers" class="title-slide slide level1">
<h1>Speakers:</h1>
<p>Robert Underwood - ACM Vice President<br />
Austin Anderson - ACM President</p>
</section>

<section id="coming-up" class="title-slide slide level1">
<h1>Coming Up</h1>
<ol type="1">
<li>Git is a VCS. Huh?</li>
<li>Why on Earth do I care?</li>
<li>How can I <em>git</em> started?</li>
<li>Wrap-up and Reminders</li>
</ol>
</section>

<section id="git-sounds-unpleasant." class="title-slide slide level1">
<h1>Git? Sounds… unpleasant.</h1>
<ul>
<li>git - (n) An unpleasant or contemptible person.</li>
<li>git - (n) Free, Open Source, Fast, Scalable, and Distributed Version Control System
<ul>
<li>Free as in lunch</li>
<li>Open Source as in Linux
<ul>
<li>Git was built as a VCS <em>for</em> Linux!</li>
</ul></li>
<li>Distributed Version Control System??</li>
</ul></li>
</ul>
</section>

<section id="what-is-dvcs-and-why-do-i-care" class="title-slide slide level1">
<h1>What is DVCS, and Why Do I Care?</h1>
<ul>
<li>Consider this…</li>
</ul>
</section>

<section id="your-projects-in-the-present-day" class="title-slide slide level1">
<h1>Your Projects, in the Present Day</h1>
<ul>
<li>Backing up your code?
<ul>
<li>Create a file</li>
<li>Save several copies (with different names?)</li>
<li>Oops, we overwrote our backup … it’s gone!</li>
</ul></li>
<li>Trying new things?
<ul>
<li>Save old code to a new file</li>
<li>Merging good stuff with bad stuff is hard!</li>
<li>Found a bug later on? When did it get here?</li>
</ul></li>
</ul>
</section>

<section id="trying-to-work-in-a-group-yuck." class="title-slide slide level1">
<h1>Trying to work in a group? Yuck.</h1>
<ul>
<li>Emailing versions back and forth</li>
<li><code>diff</code> and <code>patch</code></li>
<li>What if you screwed up?
<ul>
<li>How does everyone get the fix?</li>
</ul></li>
<li>What if a new group member joins?</li>
</ul>
</section>

<section id="a-version-control-system-handles-it-all" class="title-slide slide level1">
<h1>A <em>Version Control System</em> handles it all!</h1>
<ul>
<li>Store a file to a <strong>repository</strong> (a.k.a. a <strong>repo</strong>)</li>
<li>The software tracks the versions</li>
<li>Provides tools for…
<ul>
<li>Finding when bugs were added</li>
<li>Finding who wrote a piece of code</li>
<li>Restoring old versions of code</li>
<li>Merging different versions of the same code (teams, etc.)</li>
<li>And more!</li>
</ul></li>
<li>New team members checkout/clone the repo</li>
<li>Now we’re <em>gitting</em> somewhere!</li>
</ul>
</section>

<section id="getting-started-with-git" class="title-slide slide level1">
<h1>Getting Started with git</h1>
<ul>
<li>First, <code>git config --global</code>:
<ul>
<li>user.name “Mr. President”</li>
<li>user.email acm@cs.clemson.edu</li>
<li>core.editor Vim</li>
<li>color.ui True</li>
</ul></li>
<li><code>git init</code> - creates a new repo in the current folder</li>
<li><code>git clone &lt;url&gt;</code> - get your own copy of another repo</li>
</ul>
</section>

<section id="tracking-and-updating-files" class="title-slide slide level1">
<h1>Tracking and Updating Files</h1>
<ul>
<li><code>git add files...</code> - staging new changes and files</li>
<li><code>git status</code> - see the current status</li>
<li><code>git commit</code> - saves a set of changes and a <em>commit message</em></li>
</ul>
</section>

<section id="commit-to-good-commit-messages" class="title-slide slide level1">
<h1>Commit to Good Commit Messages</h1>
<ul>
<li>A good commit addresses the following:
<ol type="1">
<li>Why is this change necessary?</li>
<li>How does this address this the issue?</li>
<li>Big picture what was changed?</li>
</ol></li>
</ul>
</section>

<section id="investigating-the-past" class="title-slide slide level1">
<h1>Investigating the Past</h1>
<ul>
<li><code>git log</code> - See what you did</li>
<li><code>git diff</code> - See the actual changes as a <em>diff</em></li>
<li><code>git blame</code> - See when a line was last changed</li>
<li><code>git reflog</code> - Look through <em>all</em> recent commits!</li>
</ul>
</section>

<section id="dealing-with-mistakes" class="title-slide slide level1">
<h1>Dealing with Mistakes</h1>
<ul>
<li><code>git checkout -- &lt;file&gt;</code> to reset a file to the last commit</li>
<li><code>git reset</code>: reset state to a specific commit</li>
<li><code>git revert</code>: record that you’re reverting to a specific commit</li>
<li>As a last resort: <code>git reset HEAD --hard</code></li>
</ul>
</section>

<section id="what-is-a-branch" class="title-slide slide level1">
<h1>What is a branch?</h1>
<ul>
<li>A branch is a set of related versions</li>
<li>Great for…
<ul>
<li>Trying something new</li>
<li>Building new features</li>
</ul></li>
<li>Toss it or Merge it when you’re done</li>
</ul>
</section>

<section id="what-is-master" class="title-slide slide level1">
<h1>What is Master?</h1>
<ul>
<li>One Branch to rule them all?</li>
<li>Stable, Final, Sharable Product</li>
<li>Try not to make changes directly here
<ul>
<li>at least for team projects</li>
</ul></li>
<li><strong>Always</strong> test changes merged into Master</li>
</ul>
</section>

<section id="because-branches" class="title-slide slide level1">
<h1>Because Branches</h1>
<ul>
<li><code>git branch</code></li>
<li><code>git checkout -b MyNewBranch</code></li>
<li><code>git merge MyNewBranch</code></li>
</ul>
</section>

<section id="sharing-code" class="title-slide slide level1">
<h1>Sharing code</h1>
<ul>
<li>GitHub and Bitbucket offer free “hosts”
<ul>
<li>Free stuff for <code>.edu</code> email addresses!</li>
<li>Check out <code>buffet.cs.clemson.edu</code>!</li>
</ul></li>
<li>Fairly easy to set up a git “server”</li>
<li><code>git remote add origin</code></li>
<li><code>git push -u MyNewBranch</code></li>
<li><code>git push</code> after the first push</li>
</ul>
</section>

<section id="when-sharing-is-not-caring" class="title-slide slide level1">
<h1>When sharing is not caring</h1>
<ul>
<li>Some files should not be shared
<ul>
<li>May contain sensitive information
<ul>
<li>API Keys</li>
<li>Passwords</li>
</ul></li>
<li>May be machine/developer specific</li>
<li>May be a breach of academic integrity</li>
</ul></li>
<li>Use a <code>.gitignore</code> or <code>core.excludes</code> file</li>
</ul>
</section>

<section id="merge-conflicts" class="title-slide slide level1">
<h1>Merge Conflicts</h1>
<ul>
<li><code>git mergetool</code></li>
<li>There are also tools to do this better</li>
<li>Often fairly painless</li>
<li>Don’t forget to retest after merges</li>
</ul>
</section>

<section id="need-more-power" class="title-slide slide level1">
<h1>Need more power?</h1>
<ul>
<li>Some hosts provide wikis and issue trackers</li>
<li>Pull Requests are a great code review tool</li>
<li>Git provides hooks for automating tasks</li>
<li>Create your own commands with git!</li>
<li>Vim’s Fugitive plugin</li>
<li><code>git help</code></li>
</ul>
</section>

<section id="but-my-lovely-ui" class="title-slide slide level1">
<h1>But my lovely UI… <span id="emoticon">:(</span></h1>
<ul>
<li>There are tools that use git with GUIs</li>
<li>Some of them are quite good
<ul>
<li>Github has a great desktop client</li>
</ul></li>
<li>Meld is fantastic, but there are others
<ul>
<li>Downside is Meld is not on lab machines</li>
<li>gvimdiff and vimdiff for the Vim crowd</li>
<li>For the emacs OS use <code>emerge</code></li>
</ul></li>
</ul>
</section>

<section id="wrap-up" class="title-slide slide level1">
<h1>Wrap-Up</h1>

</section>

<section id="summary" class="title-slide slide level1">
<h1>Summary</h1>
<ul>
<li>Please use version control!</li>
<li>Git is an easy to use DVCS</li>
<li>Spend less time reverting, more time coding</li>
</ul>
</section>

<section id="further-resources" class="title-slide slide level1">
<h1>Further Resources</h1>
<ul>
<li><a href="http://git-scm.com/book">Great Book</a></li>
<li><a href="https://www.atlassian.com/dms/wac/images/landing/git/atlassian_git_cheatsheet.pdf">Cheatsheet</a></li>
<li><a href="https://www.atlassian.com/git/workflows">Workflows</a></li>
<li><a href="http://blogs.atlassian.com/2012/02/mercurial-vs-git-why-mercurial/?utm_source=wac-dvcs&amp;utm_medium=text&amp;utm_content=dvcs-options-git-or-mercurial">Mecurial (hg)</a></li>
<li><a href="https://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message">Why commits messages are important</a></li>
</ul>
</section>

<section id="questions" class="title-slide slide level1">
<h1>Questions</h1>
<p>Send us feedback at <code>acm@cs.clemson.edu</code>!</p>
<p>This material available under <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC By-SA 4.0</a></p>
</section>
