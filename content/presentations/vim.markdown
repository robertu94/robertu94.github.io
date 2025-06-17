---
title: Intermediate Vim
layout: presentation
location: Clemson ACM Seminar
date: 2015-02-01
Summary: >
  An intermediate level talk that aims to showcase neat features of vim above
  and beyond what is covered in vimtutor.
acknowledgments: Austin Anderson collaborated on these slides
video: https://youtu.be/v0W7JkzQAzA
---
<section>
<section id="intermediate-vim" class="title-slide slide level1">
<h1>Intermediate Vim</h1>
<p>Brought to you by Clemson ACM</p>
<p>We’re on <a href="http://steamcommunity.com/groups/clemsonacm">Steam</a> &amp; <a href="https://www.facebook.com/groups/283823058297107/">Facebook</a>!</p>
</section>
<section id="speakers" class="slide level2">
<h2>Speakers:</h2>
<p>Robert Underwood - ACM Vice-President<br />
Austin Anderson - ACM President</p>
</section></section>
<section id="coming-up" class="title-slide slide level1">
<h1>Coming Up</h1>
<ol type="1">
<li>Setting Expectations</li>
<li>What is Vim?</li>
</ol>
</section>

<section id="setting-some-expectations" class="title-slide slide level1">
<h1>Setting some Expectations</h1>
<ul>
<li>This discussion will <em>not</em>:
<ul>
<li>Cover what <code>vimtutor</code> will teach you</li>
<li>Magically make you a Vim guru</li>
<li>Show even 10% of the power of Vim</li>
</ul></li>
<li>This discussion <em>will</em>:
<ul>
<li>Show you some of the coolest features of Vim</li>
<li>Teach you enough to teach yourself</li>
</ul></li>
</ul>
<blockquote>
<p>Most people use only 10% of the functionality of Vim. The 10% only differs from person to person</p>
</blockquote>
</section>

<section>
<section id="what-is-vim" class="title-slide slide level1">
<h1>What is Vim?</h1>

</section>
<section id="vim-is" class="slide level2">
<h2>Vim is…</h2>
<ul>
<li>A programmer’s text editor</li>
<li>An extremely valuable tool to master</li>
</ul>
</section>
<section id="vim-is-not" class="slide level2">
<h2>Vim is NOT</h2>
<ul>
<li>A replacement for <strong>all</strong> of the tools in your tool box</li>
</ul>
</section></section>
<section id="composability" class="title-slide slide level1">
<h1>Composability</h1>
<ul>
<li>Most commands are composed of an action and a motion
<ul>
<li>Actions do something</li>
<li>Motions move the cursor</li>
</ul></li>
<li>Most editors don’t have anything like this!</li>
</ul>
</section>

<section id="uncommon-motions" class="title-slide slide level1">
<h1>Uncommon Motions</h1>
<ul>
<li>Last point in the change list: <code>g;</code> (<code>g,</code> to go back)</li>
<li>Text objects: <code>w</code>, <code>s</code>, <code>p</code>, <code>b</code>, <code>B</code>, etc.
<ul>
<li>Pneumonic?
<ul>
<li>“a word” -&gt; <code>aw</code></li>
<li>“inner block” -&gt; <code>ib</code></li>
</ul></li>
</ul></li>
</ul>
</section>

<section id="more-uncommon-motions" class="title-slide slide level1">
<h1>More Uncommon Motions</h1>
<ul>
<li>Next character:
<ul>
<li><code>f&lt;char&gt;</code> (inclusive)</li>
<li><code>t&lt;char&gt;</code> (exclusive)</li>
</ul></li>
<li><code>{number}|</code>: to a certain column</li>
<li><code>gj</code>, <code>gk</code> move up and down over window-wrapped lines</li>
<li><code>(</code> and <code>)</code>: sentences</li>
<li><code>{</code> and <code>}</code>: paragraphs</li>
<li>More: see <code>:h motion.txt</code></li>
</ul>
</section>

<section id="antipatterns" class="title-slide slide level1">
<h1>Antipatterns</h1>
<ul>
<li>A less efficient way of doing something that becomes a bad habit
<ul>
<li><code>ddO</code> instead of <code>S</code></li>
<li><code>dbx</code> instead of <code>daw</code></li>
<li><code>f&lt;lvt&gt;U</code> instead of <code>gUit</code></li>
</ul></li>
<li>Be careful not to worry about optimization more than working, though</li>
</ul>
</section>

<section id="fixing-some-common-annoyances" class="title-slide slide level1">
<h1>Fixing Some Common Annoyances</h1>
<ul>
<li>Use .vimrc to store preferences</li>
<li>Turn on the mouse: <code>set mouse=a</code></li>
<li>Turn on syntax highlighting: <code>syntax on</code></li>
<li>Set your background color: <code>set bg=dark</code></li>
</ul>
</section>

<section id="copy-and-paste" class="title-slide slide level1">
<h1>Copy and Paste</h1>
<ul>
<li>Forget Copy and Paste</li>
<li>Think registers
<ul>
<li>You now have 35 copy buffers</li>
</ul></li>
<li><code>"+</code> is the X server (i.e. system) copy/paste register, copy to here to copy out of Vim</li>
<li><code>:reg</code> - view the contents of registers</li>
<li><code>&lt;C-r&gt;</code> in insert mode puts the register</li>
</ul>
</section>

<section id="common-registers" class="title-slide slide level1">
<h1>Common registers</h1>
<ul>
<li><code>"[1-9]</code> history registers</li>
<li><code>"0</code> the yank register</li>
<li><code>"[a-z]</code> are named registers</li>
<li><code>"[A-Z]</code> same as "[a-z] but append</li>
</ul>
</section>

<section id="important-registers" class="title-slide slide level1">
<h1>Important registers</h1>
<ul>
<li><code>"/</code> current search pattern</li>
<li><code>"-</code> small delete</li>
<li><code>"=</code> expression register<br />
</li>
<li><code>"_</code> the black hole register</li>
</ul>
</section>

<section id="read-only-registers" class="title-slide slide level1">
<h1>Read-only registers</h1>
<ul>
<li><code>":</code> last <code>:</code> command</li>
<li><code>".</code> last inserted text</li>
<li><code>"%</code> filename of the current buffer.</li>
<li><code>"#</code> filename of the alternate file
<ul>
<li>More on that in a minute</li>
</ul></li>
<li><code>:h registers</code></li>
</ul>
</section>

<section id="macros" class="title-slide slide level1">
<h1>Macros</h1>
<ul>
<li><code>.</code> the short macro operator
<ul>
<li><code>.</code> repeats the last change</li>
</ul></li>
<li><code>qa</code> record a macro in register <code>a</code></li>
<li><code>q</code> to finish recording</li>
<li><code>@a</code> execute the macro in register <code>a</code></li>
<li>Macros are saved as text, so you can edit them manually!</li>
</ul>
</section>

<section id="multiple-files" class="title-slide slide level1">
<h1>Multiple Files</h1>
<ul>
<li>From <code>:h windows</code>:
<ul>
<li>A buffer is the in-memory text of a file.</li>
<li>A window is a viewport on a buffer.</li>
<li>A tab page is a collection of windows.</li>
</ul></li>
<li>Use buffers, windows, and tabs</li>
<li><code>:argdo</code>, <code>:bufdo</code>, <code>:tabdo</code></li>
</ul>
</section>

<section id="buffers" class="title-slide slide level1">
<h1>Buffers</h1>
<ul>
<li>Just a window into a file on disk.</li>
<li>Vim remembers a lot of them.</li>
<li><code>:ls</code> - check out the buffer list</li>
<li><code>set hidden</code> - don’t unload buffers when they’re not being looked at.</li>
</ul>
</section>

<section id="using-buffers" class="title-slide slide level1">
<h1>Using Buffers</h1>
<ul>
<li><code>:bn</code> - Next buffer in the list.</li>
<li><code>:bp</code> - Previous buffer in the list.</li>
<li><code>:bd</code> - Unload and delete the buffer from the buffer list</li>
<li><code>&lt;C-^&gt;</code> - Toggle between this and the “alternate” file (usually the last edited)</li>
<li><code>:b num</code> change to buffer number &lt;num&gt;</li>
<li><code>:b name</code> fuzzy match buffer change (use tab complete)</li>
</ul>
</section>

<section id="windows" class="title-slide slide level1">
<h2>Windows</h2>
<ul>
<li>Very handy for viewing multiple files at once</li>
<li><code>&lt;C-w&gt;</code> prefixes most window commands</li>
<li><code>&lt;C-w&gt;v</code> vertical split</li>
<li><code>&lt;C-w&gt;s</code> horizontal split</li>
<li><code>&lt;C-w&gt;n</code> new buffer in a horizontal split window</li>
<li><code>&lt;C-w&gt;c</code> close the window – useful for escaping from <code>:h &lt;anything&gt;</code>.</li>
<li>Tons of window commands! Check <code>:h windows</code></li>
</ul>
</section>

<section id="tabs" class="title-slide slide level1">
<h1>Tabs</h1>
<ul>
<li>Not quite the tabs you’re used to in, say, Gedit</li>
<li>Useful for holding different sets of windows</li>
<li><code>gt</code> go to the next tab</li>
<li><code>gT</code> go to the previous tab</li>
<li><code>:tabnew</code> create a new tab</li>
</ul>
</section>

<section id="syntax-completion" class="title-slide slide level1">
<h1>Syntax Completion</h1>
<ul>
<li>Syntax Completion in insert mode
<ul>
<li><code>&lt;C-n&gt;</code> - Next default completion</li>
<li><code>&lt;C-p&gt;</code> - Previous default completion</li>
</ul></li>
<li>Omni-completion <code>&lt;C-x&gt;&lt;C-o&gt;</code>
<ul>
<li>C (limited C++)</li>
<li>CSS, HTML, XHTML, JS</li>
<li>PHP, RUBY</li>
</ul></li>
</ul>
</section>

<section id="programming-completion" class="title-slide slide level1">
<h1>Programming Completion</h1>
<ul>
<li><code>&lt;C-x&gt;&lt;C-f&gt;</code> File paths</li>
<li><code>&lt;C-x&gt;&lt;C-d&gt;</code> Definition</li>
<li><code>&lt;C-x&gt;&lt;C-]&gt;</code> Tags</li>
<li><code>&lt;C-x&gt;&lt;C-i&gt;</code> Keywords</li>
<li><code>&lt;C-x&gt;&lt;C-l&gt;</code> lines</li>
</ul>
</section>

<section id="other-completions" class="title-slide slide level1">
<h1>Other Completions</h1>
<ul>
<li><code>&lt;C-x&gt;&lt;C-t&gt;</code> Thesaurus</li>
<li><code>&lt;C-x&gt;&lt;C-k&gt;</code> Dictionary</li>
<li><code>&lt;C-x&gt;&lt;C-s&gt;</code> Spelling</li>
<li><code>&lt;C-x&gt;&lt;C-v&gt;</code> Vim commands</li>
</ul>
</section>

<section id="digraphs-special-characters" class="title-slide slide level1">
<h1>Digraphs &amp; Special Characters</h1>
<ul>
<li>Digraphs: insert weird characters like ë, Ω, etc.
<ul>
<li>In insert mode: <code>&lt;c-k&gt;</code>, followed by one or two characters</li>
<li>Example: <code>i&lt;c-k&gt;a:</code> yields ä.</li>
<li>Check <code>:h digraphs</code> for a list of them all!</li>
</ul></li>
<li><code>&lt;c-v&gt;</code> in insert mode: insert the next character literally
<ul>
<li>Tab key doesn’t insert a tab character? <code>&lt;c-v&gt;&lt;tab&gt;</code></li>
</ul></li>
</ul>
</section>

<section id="templates" class="title-slide slide level1">
<h1>Templates</h1>
<ul>
<li><code>0r ~/path/to/template</code></li>
<li>Reads in a template to new files</li>
<li>Can be blocked on file type using autocmds</li>
</ul>
</section>

<section id="snippets" class="title-slide slide level1">
<h1>Snippets</h1>
<ul>
<li>Abbreviations will do simple snippets</li>
<li><code>:ab</code> create/view abbreviations</li>
<li>Snipmate and Ultisnips
<ul>
<li>Better snippets support</li>
<li>Provide advanced completion features</li>
</ul></li>
</ul>
</section>

<section id="plugins-and-plugin-managers" class="title-slide slide level1">
<h1>Plugins and Plugin Managers</h1>
<ul>
<li>Vim is extensible via plugins</li>
<li>Can be written in <code>vimscript</code> (VimL), and other languages</li>
<li>Stored in <code>~/.vim</code></li>
<li><a href="https://github.com/gmarik/Vundle.vim"><code>vundle</code></a> is a plugin that can manage your plugins</li>
<li>Plugin commands can use <code>&lt;LEADER&gt;</code> keybind for uniqueness
<ul>
<li>You might need to set them up in <code>.vimrc</code></li>
<li><code>&lt;LEADER&gt;</code> is <code>\\</code> by default, some like space or comma</li>
</ul></li>
</ul>
</section>

<section id="some-useful-plugins" class="title-slide slide level1">
<h1>Some Useful Plugins</h1>
<ul>
<li><code>scrooloose/NERDTree</code> - Tree-style file listing sidebar</li>
<li><code>scrooloose/syntastic</code> - Check syntax while typing</li>
<li><code>tpope/vim-fugitive</code> - Git interaction</li>
<li><code>tpope/vim-surround</code> - Change surrounding characters</li>
<li><code>SirVer/ultisnips</code> - Better snippet system</li>
<li><code>honza/vim-snippets</code> - Useful standard snippets</li>
<li>Anything by Tim Pope (<code>tpope</code>) is going to be useful.</li>
</ul>
</section>

<section id="navigating-large-code-bases" class="title-slide slide level1">
<h1>Navigating large code bases</h1>
<ul>
<li>Ctags
<ul>
<li><code>&lt;C-]&gt;</code> go to tag under cursor</li>
<li><code>&lt;C-T&gt;</code> go back to last place</li>
<li><code>:tags</code> show the tag stack</li>
</ul></li>
<li>Cscope
<ul>
<li>More powerful but confined to C/C++</li>
<li>Much more intelligent</li>
<li>Can be configured otherwise, but it’s hacky</li>
</ul></li>
</ul>
</section>

<section id="using-vim-to-test-faster" class="title-slide slide level1">
<h1>Using Vim to Test faster</h1>
<ul>
<li><code>:make &lt;make_target&gt;</code></li>
<li><code>:set makeprg</code></li>
<li><code>:cn</code> <code>:cw</code> <code>:cp</code> <code>]c</code> <code>[c</code></li>
<li><code>:copen</code></li>
<li><code>:shell</code></li>
</ul>
</section>

<section id="other-cool-commands" class="title-slide slide level1">
<h1>Other Cool Commands</h1>
<ul>
<li><code>gq&lt;motion&gt;</code>: hard word wrap a line, paragraph, etc.</li>
<li><code>v</code> and <code>V</code>: visual and linewise visual modes.
<ul>
<li>Check <code>:h visual-mode</code>: super useful!</li>
</ul></li>
<li><code>:</code> command line - substitute text, run commands, and more! <code>:h :</code></li>
</ul>
</section>

<section id="further-resources" class="title-slide slide level1">
<h1>Further Resources</h1>
<ul>
<li><a href="https://pragprog.com/book/dnvim/practical-vim">Practical Vim by Drew Neil</a></li>
<li><a href="http://vimcasts.org/">Vimcasts by Drew Neil</a></li>
<li><a href="http://vim.wikia.com/wiki/Vim_Tips_Wiki">Vimtips wiki</a></li>
<li><a href="https://github.com/gmarik/Vundle.vim">Vundle</a></li>
<li><a href="http://vimawesome.com/">Vim Awesome</a> - tons of plugins!</li>
<li><code>:help</code> – an incredible resource!</li>
</ul>
</section>

<section id="questions" class="title-slide slide level1">
<h1>Questions?</h1>
<p>Send us feedback at <code>acm@cs.clemson.edu</code>!</p>
<p>This material available under <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC By-SA 4.0</a></p>
</section>
