---
title: "Thou Shall Not Pass! Introduction to Open Source Firewalls"
layout: presentation
location: Clemson ACM Seminar
date: 2016-02-01
description: >
  This talks talks about what firewalls are, why you need one, and how to
  setup a basic firewall using iptables, firewalld, and pf.
acknowledgments: Foster McLane collaborated on these slides
video: https://youtu.be/bdoZYUVMkPg
...
<section>
<section id="thou-shall-not-pass" class="title-slide slide level1">
<h1>Thou Shall Not Pass!</h1>
<p>An introduction to iptables, firewalld, and pf, brought to you by Clemson ACM</p>
<p>We’re on <a href="http://steamcommunity.com/groups/clemsonacm">Steam</a> &amp; <a href="irc://chat.freenode.net/clemsonacm">freenode #clemsonacm</a>!</p>
</section>
<section id="speakers" class="slide level2">
<h2>Speakers:</h2>
<p>Robert Underwood - ACM Vice President</p>
<p>Foster McLane- ACM Webmaster</p>
</section></section>
<section id="coming-up" class="title-slide slide level1">
<h1>Coming Up</h1>
<ul>
<li>What is a firewall, how do I secure it?</li>
<li>How are they different?
<ul>
<li><code>iptables</code></li>
<li><code>firewalld</code></li>
<li><code>pf</code></li>
</ul></li>
<li>Look at some sample configurations</li>
</ul>
</section>

<section id="what-is-a-firewall-how-do-i-secure-it" class="title-slide slide level1">
<h1>What is a firewall, how do I secure it?</h1>
<ul>
<li>Firewall is a set of rules that control traffic</li>
<li>Try to use a default reject policy</li>
<li>Only open up the required ports
<ul>
<li>Not using ssh? Block it</li>
<li>Not using IPv6? Block it</li>
</ul></li>
<li>Log unusual traffic</li>
</ul>
</section>

<section id="how-are-they-different" class="title-slide slide level1">
<h1>How are they different?</h1>

</section>

<section id="iptables" class="title-slide slide level1">
<h1>iptables</h1>
<ul>
<li>Legacy firewall for Linux</li>
<li>Very simple, very powerful</li>
<li>Uses a series of chains based on traffic</li>
<li>Use on Linux and where you need fine control</li>
</ul>
</section>

<section id="important-files" class="title-slide slide level1">
<h1>Important files</h1>
<ul>
<li><code>/etc/sysconfig/iptables</code> # Permanent rules</li>
<li><code>/etc/services</code> # List of services</li>
</ul>
</section>

<section id="important-commands" class="title-slide slide level1">
<h1>Important commands</h1>
<ul>
<li><code>iptables</code></li>
<li><code>service iptables {start,stop,status}</code></li>
<li><code>systemctl {start,stop,status} iptables</code></li>
<li><code>iptables-save &gt; /etc/sysconfig/iptables</code></li>
<li><code>iptables-restore /etc/sysconfig/iptables</code></li>
</ul>
</section>

<section id="firewalld" class="title-slide slide level1">
<h1>firewalld</h1>
<ul>
<li>Inspired by the systemd project</li>
<li>Provides a ease of use layer for <code>iptables</code></li>
<li>Puts the focus on “zones” and “services”</li>
<li>Controls to what apps may change the firewall</li>
<li>Use on newer Linux where clarity is important</li>
</ul>
</section>

<section id="important-files-1" class="title-slide slide level1">
<h1>Important Files</h1>
<ul>
<li><code>/usr/lib/firewalld/</code> # Definitions</li>
<li><code>/etc/firewalld/</code> # Overrides</li>
</ul>
</section>

<section id="important-commands-1" class="title-slide slide level1">
<h1>Important commands</h1>
<ul>
<li><code>firewall-cmd</code></li>
<li><code>systemctl {start,stop,status} firewalld</code></li>
</ul>
</section>

<section id="pf" class="title-slide slide level1">
<h1>pf</h1>
<ul>
<li>Standard firewall for BSD</li>
<li>The last rule in the list wins</li>
<li>Use on BSD and on your router if possible</li>
</ul>
</section>

<section id="important-files-2" class="title-slide slide level1">
<h1>Important Files</h1>
<ul>
<li><code>/etc/rc.conf</code> # Enable pf here</li>
<li><code>/etc/pf.conf</code> # Actual firewall configuration</li>
</ul>
</section>

<section id="important-commands-2" class="title-slide slide level1">
<h1>Important commands</h1>
<ul>
<li><code>pfctl -f /etc/pf.conf</code> # Load the firewall config
<ul>
<li>This is the only way to change the running config!</li>
</ul></li>
<li><code>pfctl -sa</code> # See configuration status</li>
<li><code>kldload pf</code> # Load the pf kernel module</li>
</ul>
</section>

<section id="example-firewalls" class="title-slide slide level1">
<h1>Example firewalls</h1>

</section>

<section id="iptables-1" class="title-slide slide level1">
<h1>iptables</h1>

</section>

<section id="set-up" class="title-slide slide level1">
<h1>Set Up</h1>
<pre><code>iptables -F &amp;&amp; iptables -X
iptables -A INPUT -i lo -j ACCEPT
ext_if=$(ip route | head -n 1 | awk &#39;{print $5}&#39;)
broken=&quot;224.0.0.22 127.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12, \
      10.0.0.0/8, 169.254.0.0/16, 192.0.2.0/24, \
      192.0.2.0/24, 198.51.100.0/24, 203.0.113.0/24, \
      169.254.0.0/16, 0.0.0.0/8, 240.0.0.0/4, 255.255.255.255/32&quot;</code></pre>
</section>

<section id="bad-packets-and-default-deny" class="title-slide slide level1">
<h1>Bad packets and default deny</h1>
<pre><code>iptables -P INPUT DROP</code></pre>
</section>

<section id="block-ipv6" class="title-slide slide level1">
<h1>Block ipv6</h1>
<pre><code>ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP</code></pre>
</section>

<section id="block-misbehaving-addresses-and-log-them" class="title-slide slide level1">
<h1>Block misbehaving addresses and log them</h1>
<pre><code>iptables -N LOGDROP
iptables -A LOGDROP -m log --log-level info --log-prefix &quot;IPTABLES&quot; 
   -m limit --limit 5/m --limit-burst 10 -j LOG
iptables -A LOGDROP -j DROP</code></pre>
</section>

<section id="block-more-bad-packets" class="title-slide slide level1">
<h1>Block more bad packets</h1>
<pre><code>iptables -A INPUT -m conntrack --ctstate INVALID -j LOGDROP
iptables -t raw -I PREROUTING -m rpfilter -j LOGDROP
for addr in $broken; do
   iptables -A INPUT tcp -i $ext_if -s $addr -j REJECT 
done</code></pre>
</section>

<section id="exceptions-for-applications" class="title-slide slide level1">
<h1>Exceptions for applications</h1>
<pre><code>iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m limit --limit 5/m --limit-burst 10 -m conntrack \
    --ctstate NEW -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -m limit --limit 5/m --limit-burst 10 -m conntrack \
    --ctstate NEW -p tcp --dport http -j ACCEPT
iptables -A INPUT -m limit --limit 5/m --limit-burst 10 -m conntrack \
    --ctstate NEW -p tcp --dport https -j ACCEPT
iptables -A INPUT -j DROP</code></pre>
</section>

<section id="firewalld-1" class="title-slide slide level1">
<h1>firewalld</h1>

</section>

<section id="zone" class="title-slide slide level1">
<h1>Zone</h1>
<pre><code>&lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt;
&lt;zone&gt;
   &lt;short&gt;Public&lt;/public&gt;
   &lt;description&gt;This is our external interface&lt;/description&gt;
   &lt;interface name=&quot;enp0s3&quot;/&gt;
   &lt;service name=&quot;https&quot;/&gt;
   &lt;rule family=&quot;ipv4&quot;&gt;
      &lt;source address=&quot;10.0.0.0/8&quot;/&gt;
      &lt;log&gt;
         &lt;limit address=&quot;5/m&quot;/&gt;
      &lt;/log&gt;
      &lt;drop/&gt;
   &lt;/rule&gt;
&lt;/zone&gt;</code></pre>
</section>

<section id="services" class="title-slide slide level1">
<h1>Services</h1>
<pre><code>&lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt;
&lt;service&gt;
   &lt;short&gt;FOO&lt;/short&gt;
   &lt;description&gt;Foo is a program that allows bar&lt;/description&gt;
   &lt;port protocol=&quot;tcp&quot; port=&quot;21&quot;/&gt;
   &lt;module name=&quot;nf_conntrack_foo&quot;/&gt;
&lt;/service&gt;</code></pre>
</section>

<section id="configuration" class="title-slide slide level1">
<h1>Configuration</h1>
<pre><code>firewall-cmd --zone=public --add-interface=$ext_if
for addr in $broken; do
    firewall-cmd --zone=public  --add-rich-rule=&quot;rule family=&#39;ipv4&#39; \
        source address=\&quot;$addr\&quot; log limit value=&#39;5/m&#39; drop&quot;
done
firewall-cmd --permanent --zone=public --add-service=ssh
firewall-cmd --zone=public --add-service=ssh
firewall-cmd --zone=public --add-service=https
firewall-cmd --runtime-to-permanent</code></pre>
</section>

<section id="pf-1" class="title-slide slide level1">
<h1>pf</h1>

</section>

<section id="set-up-1" class="title-slide slide level1">
<h1>Set Up</h1>
<pre><code>#Adapted from bsdnow tutorial
ext_if = &quot;em0&quot;
broken=&quot;224.0.0.22 127.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12, \
        10.0.0.0/8, 169.254.0.0/16, 192.0.2.0/24, \
        192.0.2.0/24, 198.51.100.0/24, 203.0.113.0/24, \
       169.254.0.0/16, 0.0.0.0/8, 240.0.0.0/4, 255.255.255.255/32&quot;
set block-policy drop
set skip on lo0</code></pre>
</section>

<section id="bad-packets-and-default-deny-1" class="title-slide slide level1">
<h1>Bad packets and default deny</h1>
<pre><code>match in all scrub (no-df max-mss 1440)
block in all
pass out quick on $ext_if inet keep state
antispoof quick for ($ext_if) inet</code></pre>
</section>

<section id="block-ipv6-1" class="title-slide slide level1">
<h1>Block ipv6</h1>
<pre><code>block out quick inet6 all
block in quick inet6 all</code></pre>
</section>

<section id="block-more-bad-packets-1" class="title-slide slide level1">
<h1>Block more bad packets</h1>
<pre><code>block in quick from { $broken urpf-failed no-route } to any
block out quick on $ext_if from any to { $broken no-route }</code></pre>
</section>

<section id="block-misbehaving-addresses-and-log-them-1" class="title-slide slide level1">
<h1>Block misbehaving addresses and log them</h1>
<pre><code>#Block bad actors
table &lt;childrens&gt; persist
block in log quick proto tcp from &lt;childrens&gt; to any

#Block Chinese address to ssh and web
table &lt;chuugoku&gt; persist file &quot;/etc/cn.zone&quot;
block in quick proto tcp from &lt;chuugoku&gt; to any port { 80 22 }</code></pre>
</section>

<section id="exceptions-for-applications-1" class="title-slide slide level1">
<h1>Exceptions for applications</h1>
<pre><code>pass in on $ext_if proto tcp from any to any port 80 flags S/SA synproxy state
pass in on $ext_if proto tcp from 1.2.3.4 to any port { 137, 139, 445, 138 }
pass in on $ext_if proto tcp to any port ssh flags S/SA keep state \
(max-src-conn 5, max-src-conn-rate 5/5, overload &lt;childrens&gt; flush)
pass inet proto icmp icmp-type echoreq</code></pre>
</section>

<section id="summary" class="title-slide slide level1">
<h1>Summary</h1>
<ul>
<li>Know your network</li>
<li>Please use a firewall to secure your device</li>
<li>Open source firewalls are powerful and can be easy to implement</li>
</ul>
</section>

<section id="further-resources" class="title-slide slide level1">
<h1>Further Resources</h1>
<ul>
<li><a href="https://wiki.archlinux.org/index.php/Iptables">iptables</a></li>
<li><a href="http://www.linuxhomenetworking.com/wiki/index.php/Quick_HOWTO_:_Ch14_:_Linux_Firewalls_Using_iptables#.VWvGz-chtcQ">linux homenetworking</a></li>
<li><a href="https://fedoraproject.org/wiki/FirewallD">Firewalld</a></li>
<li><a href="https://www.freebsd.org/doc/handbook/firewalls-pf.html">pf</a></li>
<li><a href="http://www.bsdnow.tv/tutorials/pf">bsdnow pf tutorial</a></li>
</ul>
</section>

<section id="questions" class="title-slide slide level1">
<h1>Questions</h1>
<p>Send us feedback at <code>acm@cs.clemson.edu</code>!</p>
<p>This material available under <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC By-SA 4.0</a></p>
</section>
