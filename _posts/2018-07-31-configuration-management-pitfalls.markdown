---
layout: post
title:  "Configuration Management: Common Pitfalls"
date:   2018-07-31 10:00:00 -0500
tags: 
- Ansible
- Chef
- Puppet
- SaltStack
---

So you know you need a configuration management system and you have an idea of which one will work for you.
So what should I think about about before deploying one of this systems.
In this third and final post in this series, I present some suggestions about using these systems in a way that is flexible and scalable to larger numbers of systems.

Even within an operating system like Linux, there is a lot of variation between Linux distributions.
You would be surprised how often different Linux distributions will name software, which options they will build with, what paths they expect software to be installed at, which users are expected to run the software.
So if you want to support different distributions here are a few things to keep in mind:

1.	Try installing and getting the provisioning working on one distribution rather than multiple at first.  It will help you learn the Provisioner's tools, and it introduces substantial complexity to get this done right.  So don't add it if you don't need it.
2.	When installing a software package, prefer to install a list of software packages.  It is not uncommon for distributions to split or combine packages relative to other distributions.  For example `clang-query` and `clang` are both part of the `sys-devel/clang` package on Gentoo but on Fedora, they are split between `clang` and `clang-tools-extra`.  By installing a list of software, the list can simply include 2 packages on Fedora while only one on Gentoo.
3.	When installing a new/uncommon software package consider creating a package and serve it from a local package repository rather than building from source using the provisioner.  Some distributions (looking at you CentOS) have ancient upstream package repositories (even with epel) so some newer things like `neovim` aren't in the upstream repositories.  Doing this isn't too hard, and it is way easier than using a provisioner as a package build system.
4.	When installing a configuration file, consider using a variable for the path.  Almost every Distribution installs configuration files into different directories.  Systemd has done wonderful things standardizing this, but consider networking configuration is installed.  Is it `/etc/network/interfaces`, `/etc/sysconfig/network-scripts/*` or `/etc/systemd/network/*.network`?  It depends which Linux distribution you are using.
5.	Different Linux distributions require different users as system user accounts.  For example, some distributions use the user `www` to serve web files, some use `apache`, some use `httpd`.  In short keep in mind that you may need to support different user identities.
6.	Always test from both existing and new systems. Configuration Management that rebuilds your entire infrastructure is of no use if it does not work.  Additionally it does you no good if it doesn't respond to the updates that you intend to deliver to your systems.  I would recommend using an approach similar to Chef's kitchen with a set of VMs to manage testing.  An alternative is to use containers, just be aware that certain key features of your system that you might like to manage using configuration management may not be amenable to containers.
7.	Use `group vars`, `hiera`, `pillars` or `attributes` to separate production and testing machines.  One of the worst feelings that exists is when you apply a half-baked configuration module to production machines that requires you to reinstall them from scratch because you've bricked your login.
8.	Beware of how variable merging occurs.  Each system has some concept of merging information from multiple sources, and they are almost all different and may not work the way that you would hope they would. Pay very close attention to how multiple variables get applied to the same host if it is part of conflicting groups.
9.	Manage each resources in at most one module if at all possible.  The more that you split out these tasks the harder it is to debug your modules and ensure that they operate correctly.  Make use of dependency management systems in the tools to ensure dependent modules execute before the modules that depend on them.
10.	Most importantly, **always make changes only via the configuration management tool**.  Often user set changes will get overwritten later by the tool, and debugging why a hot-fix disappeared is not a problem that you want to have.  This takes discipline, but its worth it -- trust me.

Well that wraps up my suggestions for configuration management tools.  Good luck and happy computing!
