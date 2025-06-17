---
title: Dockerize All the Things!
layout: presentation
location: Clemson ACM Technology Seminar
date: 2017-02-01
Summary: >
  This talk introduces Docker and why you should care about it.  It highlights
  differences between Docker and VMs while clarifying common misconceptions.  I
  talk about how to create docker containers and containerize applications.
---
<section>
<section id="dockerize-all-the-things" class="title-slide slide level1">
<h1>Dockerize All the Things!</h1>
<p>Robert Underwood</p>
</section>
<section id="coming-up" class="slide level2">
<h2>Coming Up</h2>
<ul>
<li>What is a Docker, and why do I care?
<ul>
<li>Compare to Native and VM</li>
<li>Common Misconceptions</li>
</ul></li>
<li>How can I use a Docker container?</li>
<li>How can I dockerize all the things?</li>
</ul>
</section></section>
<section>
<section id="what-is-a-docker-and-why-do-i-care" class="title-slide slide level1">
<h1>What is a Docker, and why do I care?</h1>

</section>
<section id="what-is-docker" class="slide level2">
<h2>What is Docker?</h2>
<ul>
<li>Docker is a set of tools that make it easy to build, ship, and run applications
<ul>
<li>Commands to create containers and images</li>
<li>Standard to share those images with others</li>
<li>A thin runtime layer using <code>namespaces</code> and <code>cgroups</code></li>
</ul></li>
</ul>
</section>
<section id="what-is-a-docker-images" class="slide level2">
<h2>What is a Docker images?</h2>
<ul>
<li>A set of layers that tell the history of an environment</li>
<li>The state of the current environment</li>
<li>An easy to use template to build new environments</li>
</ul>
</section>
<section id="what-is-a-docker-container" class="slide level2">
<h2>What is a Docker Container?</h2>
<ul>
<li>A definition of an environment for which to run software</li>
<li>Meant to be throw away</li>
<li>Like a VM without the bloat</li>
<li>Like a chroot with process isolation</li>
<li>Like a BSD Jail without the BSD</li>
</ul>
</section>
<section id="why-do-i-care" class="slide level2">
<h2>Why do I care?</h2>
<ul>
<li>Much better scalability than VMs</li>
<li>Faster deployment than VMs</li>
<li>Better isolation and security than a chroot</li>
<li>For some applications better performances</li>
</ul>
</section>
<section id="common-misconceptions" class="slide level2">
<h2>Common Misconceptions</h2>
<ul>
<li>Docker is <em>not</em> a vm.
<ul>
<li>The kernel is shared but <code>namespaced</code></li>
<li>No emulation of hardware</li>
<li>Uses <code>cgroups</code> to control resources</li>
</ul></li>
<li>Not the same as native
<ul>
<li><code>AUFS</code> - <code>COW</code> Filesystem</li>
<li><code>Docker NAT Bridge</code></li>
</ul></li>
</ul>
</section></section>
<section>
<section id="how-do-i-use-docker" class="title-slide slide level1">
<h1>How do I use Docker?</h1>

</section>
<section id="gotchas" class="slide level2">
<h2>Gotchas</h2>
<ul>
<li>Older versions are fairly unsupported</li>
<li>Requires docker service to be running</li>
<li>Requires <code>root</code> access to access daemon</li>
<li><code>docker</code> group has password-less root access</li>
<li><code>Docker</code> and <code>selinux</code> don’t always play nice.</li>
</ul>
</section>
<section id="life-cycle-of-a-container" class="slide level2">
<h2>Life Cycle of a container</h2>
<ul>
<li>Create a new container – <code>docker run</code></li>
<li>Stop a running container – <code>docker stop</code></li>
<li>Start a stopped container – <code>docker start</code></li>
<li>Restart a container – <code>docker restart</code></li>
<li>Delete container – <code>docker rm</code></li>
</ul>
</section>
<section id="run-a-container" class="slide level2">
<h2>Run a container</h2>
<div class="sourceCode" id="cb1"><pre class="sourceCode bash"><code class="sourceCode bash"><span id="cb1-1"><a href="#cb1-1" aria-hidden="true"></a><span class="ex">docker</span> run <span class="op">&lt;</span>options<span class="op">&gt;</span> <span class="op">&lt;</span>container<span class="op">&gt;</span> <span class="op">&lt;</span>arguments<span class="op">&gt;</span></span>
<span id="cb1-2"><a href="#cb1-2" aria-hidden="true"></a><span class="ex">docker</span> run -it ubuntu /bin/bash</span>
<span id="cb1-3"><a href="#cb1-3" aria-hidden="true"></a><span class="ex">docker</span> run --name nginx -d -p 8080:80  <span class="kw">\</span></span>
<span id="cb1-4"><a href="#cb1-4" aria-hidden="true"></a>   <span class="ex">-v</span> /docker/nginx.conf:/etc/nginx/nginx.conf:ro nginx</span></code></pre></div>
<ul>
<li><code>-it</code> – keep <code>STDIN</code> open and allocate <code>pesdo-tty</code></li>
<li><code>-v</code> – mount a volume</li>
<li><code>-p</code> – map a port</li>
<li><code>--net=host</code> – host level networking</li>
<li><code>--privileged</code> – removes security features</li>
<li>Default entry point is <code>/bin/sh</code></li>
</ul>
</section>
<section id="manage-images" class="slide level2">
<h2>Manage Images</h2>
<ul>
<li>Download a new image – <code>docker pull</code></li>
<li>Upload an image – <code>docker push</code></li>
<li>Build an image – <code>docker build</code></li>
<li>Delete an image – <code>docker rmi</code></li>
</ul>
</section>
<section id="get-information" class="slide level2">
<h2>Get information</h2>
<ul>
<li>List containers – <code>docker ps</code></li>
<li>List images – <code>docker images</code></li>
<li>Port mappings – <code>docker port</code></li>
<li>Detailed information – <code>docker inspect</code></li>
</ul>
</section>
<section id="administrative-tasks" class="slide level2">
<h2>Administrative tasks</h2>
<ul>
<li>Get a prompt – <code>docker attach</code> or <code>nsenter</code></li>
<li>Run a command – <code>docker exec</code></li>
<li>See the output – <code>docker logs</code></li>
<li>Get usage stats – <code>docker stats</code></li>
</ul>
</section></section>
<section>
<section id="how-can-i-dockerize-all-the-things" class="title-slide slide level1">
<h1>How can I dockerize all the things?</h1>

</section>
<section id="committing-images" class="slide level2">
<h2>Committing images</h2>
<ul>
<li>Run a new image</li>
<li>Make your changes</li>
<li>Commit your changes – <code>docker commit</code></li>
<li>Tag the result – <code>docker tag</code></li>
</ul>
</section>
<section id="writing-a-dockerfile" class="slide level2">
<h2>Writing a Dockerfile</h2>
<ul>
<li>Describes how container is to be built</li>
<li>Each command <code>=</code> an image layer</li>
<li>Only changed layers are built</li>
<li>Similar commands to the command line</li>
</ul>
</section>
<section id="example-dockerfile" class="slide level2">
<h2>Example Dockerfile</h2>
<div class="sourceCode" id="cb2"><pre class="sourceCode dockerfile"><code class="sourceCode dockerfile"><span id="cb2-1"><a href="#cb2-1" aria-hidden="true"></a><span class="co">## Development Tools</span></span>
<span id="cb2-2"><a href="#cb2-2" aria-hidden="true"></a><span class="kw">FROM</span> centos:7</span>
<span id="cb2-3"><a href="#cb2-3" aria-hidden="true"></a><span class="kw">MAINTAINER</span> <span class="st">&quot;Robert Underwood&quot;</span> &lt;email@example.com&gt;</span>
<span id="cb2-4"><a href="#cb2-4" aria-hidden="true"></a><span class="kw">RUN</span> yum install -y vim git python &amp;&amp; yum update -y</span>
<span id="cb2-5"><a href="#cb2-5" aria-hidden="true"></a><span class="kw">ENV</span> EDITOR=vim</span>
<span id="cb2-6"><a href="#cb2-6" aria-hidden="true"></a><span class="kw">ADD</span> [<span class="st">&quot;dotfiles/&quot;</span>, <span class="st">&quot;/root&quot;</span>]</span>
<span id="cb2-7"><a href="#cb2-7" aria-hidden="true"></a><span class="kw">EXPOSE</span> 443/tcp 1094/udp</span></code></pre></div>
</section>
<section id="current-gotchas" class="slide level2">
<h2>Current Gotchas</h2>
<ul>
<li>Builds are unpriviliged</li>
<li>Builds will fail if there is a prompt</li>
<li>Init systems tend not to play nice
<ul>
<li>But you can use <code>supervisord</code>, <code>--init</code></li>
</ul></li>
<li>Some files are based on the host</li>
<li>No manpages inside by default</li>
</ul>
</section>
<section id="other-advice" class="slide level2">
<h2>Other Advice</h2>
<ul>
<li>Consider container OSes like <code>alpine</code> linux</li>
<li>Consider one app per container</li>
</ul>
</section>
<section id="summary" class="slide level2">
<h2>Summary</h2>
<ul>
<li>Docker is a new way to package applications</li>
<li>It makes it easy to ensure the compatibility</li>
<li>Docker is not a VM, jail, or chroot</li>
<li>It provides serious advantages
<ul>
<li>some disadvantages too</li>
</ul></li>
</ul>
</section>
<section id="further-resources" class="slide level2">
<h2>Further Resources</h2>
<ul>
<li><a href="https://docs.docker.com/" title="Project Documentation">Docker Docs</a></li>
<li><a href="https://registry.hub.docker.com/" title="Base image repo">Docker Hub</a></li>
<li><a href="https://www.digitalocean.com/community/tutorials/the-docker-ecosystem-an-introduction-to-common-components" title="Great Tutorial Series">Digital Ocean Tutorial</a></li>
<li><a href="http://domino.research.ibm.com/library/cyberdig.nsf/papers/0929052195DD819C85257D2300681E7B/$File/rc25482.pdf" title="very detailed benchmarks">IBM Benchmarks</a></li>
<li><a href="https://blog.docker.com/2014/06/why-you-dont-need-to-run-sshd-in-docker/" title="tools to administrate docker containers">Why You Don’t Need sshd</a></li>
</ul>
</section>
<section id="questions" class="slide level2">
<h2>Questions</h2>
<p>Send us feedback at <code>acm@cs.clemson.edu</code>!</p>
<p>This material available under <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC By-SA 4.0</a></p>
</section></section>
