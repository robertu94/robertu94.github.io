---
layout: post
title:  "Learning to Learn: Linux"
date:   2019-08-25 08:00:00 -0500
tags: 
- Learning to Learn
- Linux
---

So you want to or have to try this thing called "Linux."
Just like curry powder isn't just one thing, but a distinct mix of spices that come together into a tasty mixture, Linux is much the same.
Also like curry, Linux isn't for everyone.
In this post I describe the process of choosing the "flavor" of Linux that will work best for you, introduce a powerful tool that will help you to make the most of Linux, and describe some first steps to take when things go wrong.



# Choosing a Distribution

What even is Linux?
Without going too far into the weeds, Linux is an "operating system".
There is something of a debate about what exactly the words "operating systems" means amongst operating systems developers.
If you think of Windows and macOS you probably envision a pretty substantial collection of software including graphical interfaces.
However, the developers of the BSD family of operating systems would argue that it would be slightly smaller and includes only critical software for server use which has practically ubiquitous use.
Even more so, developers like Linus Torvalds -- the primary maintainer and original developer of Linux -- argue that an operating system is relatively tiny -- just a set of functions that abstract away the differences between different sets of hardware that can be used by applications that you care about.
And there are those who would argue for an [even smaller definition](https://www.minix3.org/)

Since Linux is so small compared to proprietary operating systems, the user has to make a comparatively large number of choices in order to have a practically usable system:
What kind of desktop do I want? Do I even want a desktop?
What kinds of applications do I want? How will they work together?
This is where "distributions" come in.
Distributions make to various degrees decisions about these important questions to make a system like Linux easier to use.
But this leaves users with yet another question: What Distribution should I choose and why?

So how can I find a list of Linux distributions for my usecase?
You can literally just search the Internet for "Linux distribution for \[type of user\]" and generally come up with the list of more supported distributions for your use case.
You can also use sites like [DistroWatch](https://www.distrowatch.com) which list maintain an active list of distributions by some measure of popularity.
However, by virtue of the site, it tends to highlight more "boutique" or frequently updated distributions.
You can also listen to podcasts about Linux to get a feel for some different distributions:
I like the shows by the [Jupiter Broadcasting Network](https://www.jupiterbroadcasting.com/).
Once you have a list of distributions to consider, I argue that you should consider 3 factors when choosing a Linux distribution:

1. The rate of change and the support cycle.
2. The availability of software
2. The choices of default software

## Rate of Change and Support Cycle

The first factor to consider when choosing a Linux distribution is the questions of rate of change and support cycle.
The rate of change is rate at which the maintainers provide new versions and changes to the software.
Since rate of change is hard to measure directly, it is often easer to look at the related to the question of the length of the  support cycle.
The support cycle is the length of time the developers provide security patches other services to support to older versions the software.
Almost always, a short support cycle is coupled with a high rate of change and visa versa.

There are Linux distributions at many points along the spectrum of possible options.
At one extreme, distributions -- like CentOS -- adopt changes very slowly favoring the test of time to weed out bugs.
At the time of writing CentOS has a 10 year support cycle.
However there are costs to long support cycles, some you may use may get to be quite old.
In the middle are distributions that offer a 1 year, and 2 year, and 5 year support cycle.
At the other extreme, other so-called "rolling" distributions -- like ArchLinux -- adopt changes very quickly to provide users with the latest and "greatest" of software.
Rolling distributions often expect their users to adopt changes every few weeks if not every few days.

So when considering what Linux distribution to install, consider where you fall along this spectrum:

+ Do you want to be installing updates every few days, or are is a monthly or yearly update with some critical security patches more often more what you are looking for?
+ Do you do work that benefits from the latest and "greatest" versions of software?
+ Do you want a "set it and forget" paradigm, or are you looking for something you can "tinker" with?


So how can I tell where a Linux distribution falls on this spectrum?
First search for terms such as "support life-cycle" or "rolling release" on the distribution web page.
Unfortunately, it also important to see if the distribution is actively maintained especially if a distribution is not backed by a company.
Just because a distribution says they have a 5 or 10 year support cycle doesn't mean it is still actively supported or maintained.
Occasionally leaders retire from maintaining the distribution and for smaller distributions that can cause the distribution to die along with them.
Signs a distribution have may have died include:

+ No patches for critical and widely publicized security vulnerabilities
+ A stale website or source code repository that hasn't been updated racily
+ Large numbers of broken links
+ A social media or blog post that describes that distribution is ending

Considering how stable or rolling you want your system to be is an important first step to choosing a Linux distribution.

## Availability of Software: Package Management and Software Selection

Another factor to consider is will the particular distribution support the software packages that I want to run?
If you ultimately cannot find software for your distribution, then Linux may not be for you.
However, in recent years, there have been great strides in availability for many kinds of software.
Here are the steps that I recommend users take to find software for their distribution:

1. Is the software available for your distribution? Either in:
    1. Packages in your distribution's software repository
    2. Packages in cross-distribution Container Package Managers
    3. From a custom build script or self-contained archive
2. Is the there an alternative for the software?
    1. Look in the previous sources (1.1-1.3) for software that has the same function
    2. Consider "web-based" alternatives
3. If all else fails consider virtualization

### Distribution Package Managers

You may have used an "app store" on various proprietary operating systems.  Linux had these long before the proprietary alternatives and they are called "package managers".  They are the primary way of installing software on Linux. And, just like the app stores you are familiar with each have different applications, each Linux distribution has its own software available for it.

Package managers have many benefits.  They manage updates for the software on your computer eliminating the need for separate updater processes for each program. They help eliminate the redundancy of having multiple copies of the same libraries and data on your computer.  They also install required dependencies automatically.   Generally packages from your distributions package manager will be the most tested software for your particular distribution meaning you are less likely to run into bugs.  For these reasons, you should always check your package manager first before installing from other sources.

Linux package managers are not universal between distributions -- in fact many distributions have their own unique package manager.  While these package managers offer similar feature sets, each offers its own features that distinguish it for the particular use case the developers had when they designed it.  This means that if you decide to change Linux distributions you will likely need to learn a new package manager.

Even between Linux distributions that use the same package manager there can be differences.  For example, almost every distribution that I have ever used had a different name for the package containing the graphical version of the vim text editor.  These different names make it difficult to use packages even for the same package manager from a different distribution because the dependency listings have the wrong name for the corresponding dependencies on a different distribution.  And that doesn't even consider the possibility of differently choose default options for packages of software that can conflict.

Some package managers support the ability to add third-party application sources.  The quality of these third-party packages can vary greatly.  Some such as [EPEL (Extra Packages for Enterprise Linux) for RedHat Enterprise Linux or CentOS](https://fedoraproject.org/wiki/EPEL) are very reliable, but others can fall out of date quickly, miss important security updates, be untested, or even worse contain malicious software.  If you choose to use them, use them with care.

### Container Package Managers

Recently there have been efforts to create package repositories that work across Linux distributions.  These work by packaging a "runtime" with the applications so that it works regardless of what distribution they are installed on.  These run-times can be large, but through some functionality in the Linux kernel, they can be shared between applications.  They also offer features to lock down applications so that they can only access part of the system by default.

At time of writing there are 3 leading contenders for desktop applications: [flatpak](https://flathub.org/home), [snap](https://snapcraft.io/), and [appimage](https://appimage.org/).  Each has their own advantages and disadvantages which are changing daily.  Additionally not all distributions support all of these formats -- they may not have a new enough kernel or have the right kernel features enabled.  However, most distributions support them.

Another alternative is to use software designed for packaging server software such as [Docker](https://hub.docker.com/) or [Podman](https://podman.io/).  Because docker was designed for server software, the default security options are so strict that it tends disallow things that desktop software needs to properly function.  However it can be an option for software with fewer permission requirements.

### Custom built software

Unlike other proprietary operating systems, Linux has a long tradition of users building their own software from source code.  This source software can be found on company websites in `.tgz` or `.zip` archives or in git repositories like [github](https://www.github.com).  Once you have the source you will need to build and install it. There are a number of tools for doing this, including [cmake](https://cmake.org/), [meson](https://mesonbuild.com), and [autotools](https://www.gnu.org/software/automake/) but each package adopts a different approach. By convention the instructions for how to compile and install software can be found in a file called `README` or `INSTALL`.

There are reasons to use custom build software:

1. You have software that you developed yourself and are only using on a small number of computers.
2. You are using a Linux environment where you don't have access to the package manager such as work, school, or a super computer.
3. You want an software option selected that isn't widely enabled.

That said, there are a number of reasons to avoid installing a number of packages this way.  First, it won't update with the other packages. Second, it doesn't manage dependencies like the previous methods.  Finally, it is substantially more complicated than the previous methods.


### Where to find alternatives

While software availability for Linux is much better than it was a decade ago, there will be software you use that doesn't exist on Linux.  However, often times there are good alternatives that preform the same or a similar enough function. Good places to look for alternatives include the extensive [ArchLinux list of applications](https://wiki.archLinux.org/index.php/List_of_applications), specialized search engines such as [alternativeto](https://alternativeto.net/), and general web search. Once you've found an alternative you like, you can install it using any of the previously described methods.

In addition to native applications, its also important to consider web applications as possible alternatives.  For example Microsoft has a version of Office called Office 365 Online which implements many of features of Desktop versions of Office except it runs in a web browser.  While it doesn't do everything that the Desktop version does, it gets me most of the way to doing everything I need to do for the few cases that Libreoffice doesn't work.

One final area to consider is [Google Chrome's Android app runtime](https://developer.chrome.com/apps/getstarted_arc) environment.  It allows you to run many android apps as in the Chrome browser.  It doesn't work for all applications on Android -- for example my preferred Bible reader software Olive Tree --  but can provide some needed applications not available otherwise.

### Consider Virtualization

Lastly if all else fails, Linux has excellent virtualization support.  Virtualization allows users to run other operating systems on top of Linux.  While this is a heavy weight solution for the situation where there is absolutely no substitutes for the software that you need.  A complete treatment of virtualization is out of scope for this article, but [Red Hat's Documentation is best in class](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_getting_started_guide/index) albeit a tad technical.

You may see recommendations to use Virtual Box for for the virtualization host.  While this is true for Windows -- and perhaps MacOS -- this is largely not true for Linux. Virtual Box is notorious for being harder to maintain and less efficient with resources than other alternatives for Linux such as QEMU/KVM.  Previously, Virtual Box offered trade offs like better client tools, but this is no longer the case with the advent virtio drivers for most major operating systems (including recent versions of MacOS and Windows).

## So What Distributions do I Recommend?

The distributions that I recommend most often are:

| Distribution            | Purpose                                                                       |
|-------------------------|-------------------------------------------------------------------------------|
| [Fedora Workstation](https://getfedora.org/)      | Daily use for users who are early adopters                                    |
| [Ubuntu LTS](https://ubuntu.com/download/desktop)              | Daily use for users who prefer stability                                      |
| [Fedora Server](https://getfedora.org/)           | For a server with more modern software              |
| [CentOS](https://www.centos.org/download/)                  | For a server that needs to run with minimal changes for 10 years              |
| [ArchLinux](https://www.archlinux.org/)               | If you want bleeding edge sometimes unstable software                                            |
| [Gentoo](https://www.gentoo.org/)                  | If you have a highly customized workload that nothing else works for          |



# Desktop Environments

One piece of software that new Linux users will need to select that they probably haven't before is the desktop environment. The desktop environment is the software that provides the desktop that you see when you log into a graphical environment.  Unlike Windows and MacOS, Linux offers multiple desktop environments that serve particular needs.  I think there are roughly three types of desktop environments to consider:

## Modern Environments

Modern Environments tend to be heavier on resources, but offer more ease of use features and smooth animations in exchange.  The two leading examples of these are KDE's Plasma desktop and Gnome.

[KDE](https://kde.org/plasma-desktop) is the more customizable of the two.  It allows customization of nearly every aspect of the desktop experience, from where windows for recently started applications are drawn to how and when notifications are sent.  It offers a relatively sane set of defaults, but often takes some tinkering to get it exactly how you want it.  If you favor lots of customization options, KDE may be for you.

[Gnome](https://www.gnome.org/) offers a simple and reliable out of the box experience.  It doesn't have nearly the customization options that KDE had; instead, it offers a opinionated, easy to use, modern desktop.  Gnome does have some weird opinions that may be foreign to new users.  For example, it at time of writing doesn't allow icons on the desktop.  Instead, users should search for the application and documents they want using the built-in search feature.  However, if you embrace the Gnome work flow, I have found it to be quite productive.

## Classic Environments

Classic desktop environments will be more conservative with animations and features, but instead try to replicate a computing paradigm from an earlier time.

[XFCE](https://xfce.org/) is probably the most conservative of the bunch.  The offer an extremely light weight computing experience that performs well even on older hardware that doesn't feature a built-in GPU.  That doesn't mean it is completely lacking in features.  It offers significant capability to power users who are willing to peer in to some of the hidden functionality using scripting.  Even though, I don't use XFCE as my main desktop, I actually choose to use their file manager Thunar for this reason.

[Mate](https://mate-desktop.org/) is based on an earlier version of the Gnome desktop before they became quite as modern.  It offers several default appearances that resemble MacOS, and different versions of Microsoft Windows.  It requires a bit more resources than XFCE, but in exchange offers a few more options without having to adopt scripting.

## Non-Traditional Environments

Linux also offers a number of non-traditional desktop environments that may not be for new users, but offer substantial productivity improvements in the long run.

One such family is tiling window managers such as [i3](https://i3wm.org/). Tiling window managers don't encourage you to place windows manually, but rather they are automatically tiled to make the most use of the screen.  They are often the most customizable desktop environments, but also require the user to find the functionality they want and either adopt or implement it.  However in exchange the user gets a custom fit experience that can be quiet efficient.

It is also possible to use Linux with a graphical environment and instead manage it using the command line.  While this probably isn't great for desktop use, it is very common for server environments.  A graphical desktop and its dependancies are just one more thing to take up resources on the machine and simply aren't needed of machines that are primarily web-servers or network attached storage for example.

# Using the Command Line

You won't be able to use Linux to its fullest without using its command line.
However, learning it use it can be daunting.
In this section, I want to motivate why you should take the effort and suggest a path for doing so.

## Why use the command line?

Using the command line grants the power to automate, access to additional functionality, and the ability to quickly integrate several smaller tools to solve larger problems.

Unix -- the predecessor to Linux -- was designed as time sharing system where companies would automate large batch processes.  It is unsurprising then that Linux retains much of this heritage to automate tasks.  The command line gives the user the ability to trigger tasks at a particular time, when a file or directory is modified, when status of a service changes and many others.  The power to run a task when events occur allows the user to respond to them in a way that may require a large army of humans to do individually.  Because the command line only produces and accepts streams of text, it becomes easy to have an interface that adapts to all of these kinds of events as well as new events as they are developed and introduced.

Additionally, many commands expose additional functionality via their command line interfaces.  It is often easier to develop command line interfaces for a particular task than graphical ones.  In fact, most programming languages do not provide graphical window interface toolkits in their standard libraries.  This means that developers will often put provide interfaces to the command line before they develop a graphical interface so they can prototype functionality.  Rather than remove this functionality, the command line interface is retained to allow for batch processing and automation.

Finally, chaining several small commands yields a combinatorial explosion of functionality.  The developers of Unix developed a design philosophy for how tools in their system should be used.  While the whole of the philosophy is worth consideration, let's focus on guideline 1 and 2.

>  1. Make each program do one thing well. To do a new job, build afresh rather than complicate old programs by adding new "features"
>  2. Expect the output of every program to become the input on another, as yet unknown, program.  Don't clutter output with extraneous information.  Avoid stringently columnar or binary input formats.  Don't insist on interactive input.
>
>  [Quoted from: UNIX Time-Sharing System: Foreword](https://doi.org/10.1002/j.1538-7305.1978.tb02135.x)

Tools that adhere to guideline one are likely to have only one specific side effect if they have any at all.
While tools that adhere to guideline two are [endomorphisms]({% post_url 2017-02-17-suprisingly-funtional %}) which means they are inherently compose-able.
Together tools that follow both guidelines one and two can be combined and pipelined without fear of unwanted side-effects.
This creates a combinatorial exposition of functionality that provides great power to the user.

So for example, imagine you have a tool that monitors how full your hard disk is, another tool that makes graphs out of numeric data, and another tool that sends email.  You could use these tools to send an email if the drive gets too full, or you could use them to make a plot of how your disk has filled over time.  Then if you got a new application that allows sending text messages, you could easily swap out the last tool  in the change and send the alert the user via text message with minimal changes to the rest of the pipeline.

## Common Objections

Some will argue that the command line is harder to use than graphical applications.

They might argue that the textual interface of the command line is harder to use than a graphical interface.  For some tasks this is almost certainly true: video editing, document formatting, or web browsing.  However, more often than not, it is an expression of personal lack of experience than actual measurable increases in difficulty.  When you face this frustration, consider if you are working with or against the strengths of the command line.  Are you working on an aesthetic or interactive task or are you working on a data-oriented, batch/non-interactive task where you are integrating many data sources where a command line pipeline will shine?  Using the tool for its intended purpose will improve its ergonomics.

They may also argue that its daunting to learn due to the sheer number commands.  They might compare it to the relative elegance of a language like C or python.  Yes, the shell does have a large number of possible commands, but that doesn't mean you need to use them all.  My computer has at least 2661 such commands installed; I have used no more than 384 of them.  To get useful things done you need even less you need no more than about 30.  And because each tool is designed to do one thing, each tool is not particularly complicated.

Lastly they may argue that command line tools don't share a set of design guidelines for how commands should respond to arguments.  This is obviously true, the [oft maligned tar]( https://xkcd.com/1168/) is one of the most egregious examples.  However, are graphical interfaces any better?  Especially graphical tools that are supposed to be designed so "Expect the output of every program to become the input on another, as yet unknown, program".  I would argue graphical tools are more complicated and just as inconsistent.  Yes, many graphical programs implement `<ctrl-s>` to save the current state, but not all.  And despite exceptions, the command line has similar conventions: `-h` or `--help` for help, `-v` or `--verbose` for increased verbosity, `-q` or `--quiet` for less, etc.

## What to learn

This is a minimal set of tools that I would recommend learning in the order that I would learn them:

| Purpose                       | Tool                        | Why                                                                        |
| ---------------               | ------------                | -------------------------------------------                                |
| Files and Directories         | ls                          | List the working directory                                                 |
| Files and Directories         | cd                          | Change the working directory                                               |
| Files and Directories         | mv                          | Move a file                                                                |
| Files and Directories         | cp                          | Copy a file                                                                |
| Files and Directories         | rm                          | Permanately Delete a file                                                  |
| Files Path Manipulation       | dirname                     | Get the name of the directory a file is in                                 |
| Files Path Manipulation       | basename                    | Get the name of the file without its directory                             |
| Files and Directories         | cat                         | Concatonate one or more files to the terminal                              |
| Pagination                    | less                        | Create a scrollable view on the output                                     |
| Documenation                  | man                         | View documenation                                                          |
| Control Flow                  | bash                        | Most common shell on Linux platforms; the glue used to put things together |
| Files and Directories         | find                        | Identify files with a set of properties                                    |
| Archive management            | tar                         | Work with many compressed archives; often used with downloads              |
| Text Processing               | head                        | Print the first lines or bytes from a file                                 |
| Text Processing               | tail                        | Print the last lines or bytes from a file                                  |
| Text Processing               | grep                        | Search for lines in a set of files that match a pattern                    |
| Text Processing               | sort                        | Sort lines on some criterion                                               |
| Text Processing               | uniq                        | Remove duplicate lines from sorted lines                                   |
| Text Processing               | wc                          | count the number of words, lines or characters in a file                   |
| Text Processing               | echo                        | Convert arguements to a string and print it to the command line            |
| Privledge Escalation          | sudo                        | Request administrative priledges                                           |
| Package Mangement             | apt/dnf/pacman/emerge/etc...| Install, remove, or update software                                        |

`sudo` warrants a more detailed explanation.  Linux and other Unix like operating systems protect key functions such as installing software system-wide by often restricting them to a user called by convention "root" which is nearly omnipotent on the system.  Sudo stands for `Su`peruser `Do`.  `sudo` allows requests the root user (super user on the system) to take an action on your behalf.  You generally should avoid using this power.  However one place you will need to use it is with package management.

Package managers also warrant additional explanation.  Many Linux distributions sadly seem to suffer from not-invented here syndrome and has reinvented their own package manager with its own esoteric options and usage. Don't try to learn them all, just learn how to use the one for your distribution.  Refer to the [Pacman Rosetta](https://wiki.archLinux.org/index.php/Pacman/Rosetta) to see how to accomplish common tasks for your distribution.


If you have some more time or a special need, I would additionally pick up these commands:

| Purpose                       | Tool                        | Why                                                                        |
| ---------------               | ------------                | -------------------------------------------                                |
| Advanced text processing      | awk                         | Work with field delimited data; i.e. CSV, log files                        |
| Advanced text processing      | sed                         | Make sophsticated changes to lines of a file                               |
| Scheduling and events         | systemd-run                 | Schedule commands to run in the future or after an event                   |
| Network transport             | curl                        | Download files using a wide range of protocols                             |
| Network transport             | ssh                         | Run commands securely on a remote machine                                  |
| Format Converters             | convert                     | Convert between image formats                                              |
| Format Converters             | pandoc                      | Convert between text/document formats                                      |
| Format Converters             | jq                          | Extract information from JSON formatted data                               |
| Format Converters             | xpath                       | Extract information from XML formatted data                                |


For small problems, you can often write everything you need in the command line prompt.
However eventually, you will probably want to put combinations of commands into a file.
When you do, you'll need a text editor
Text editors are a very personal tool and no one tool will satisfy all users.
I'll elaborate on the choice between these in a later post, but I encourage new users to try one of these:

+ [vi/vim/neovim](https://neovim.io/) -- the vi-family of text editors feature a focused feature set and a famously powerful keyboard shortcuts, and they are nearly ubiquitous on Linux systems.
+ [emacs](https://www.gnu.org/software/emacs/tour/) -- is a powerful "batteries included" text editor and extensible text editor.
+ [vscode](https://code.visualstudio.com/) -- a more modern graphical text editor
+ An Integrated Development Environment (IDE) -- generally focused on a specific programming language or programming language.  Examples include Eclipse or the JetBrains IDEs

It is also possible to use other lighter-weight tools that are often packaged by default with Linux distributions, but I don't encourage this.  Other tools don't always offer the room to grow and require the user to learn a different tool when they no longer meets their needs.  These editors scale to even large projects such as the Linux kernel with million lines of code.


# Finding help and Debugging first steps

So, where do you find examples of how to use these command line commands and find help when I need it?

1. Is the problem replicate-able?  If the problem cannot be reproduced, it is much harder to fix so it is worth taking some time to figure out how to replicate the problem.
2. `-h` or `--help` options on specific commands
3. `man` pages.  Linux has a set of built-in manuals. Most of them can be accessed by calling `man` followed by the name of the command. 
4. Online documentation
    1. Often each project will have a home page with documentation and examples of usage.  Look here first if it exists.
    2. [The Grymoire](https://www.grymoire.com/) -- Extensive documentation on a number of older Linux/Unix commands.  They have some of the best free `awk` and `sed` documentation.
    3. [The Archwiki](https://wiki.archLinux.org/) -- ArchLinux -- a Linux distribution for experienced power users who want to live at the bleeding left -- has very detailed documentation on a number of Linux commands.
    4. search engines -- you can often search "name of command" with the word "example" to get examples on sites like Stack Overflow or Geeks4Geeks. **However**, sometimes these resources can be inefficient uses of computer resources, wrong, or out of date.  Prefer official documentation whenever possible.  When looking at forums like Stack Overflow, consider the following: (1) how old is the post? (2) is the recommendation consistent with the documentation? From time to time, a post will live on way past the project being updated and will reccomend a deprecated or inefficent way of doing things.  Checking the documentation can help avoid that.  (3) Is it recommending a hack-ish work arround that will leave you insecure?  For example, some posts on Stack Overflow will recommend disabling role based access control or the firewall which will greatly compromise the security of your system.  It's worth reading and understanding what the suggested fix does before using it. 


There are also a number of paid resources that I feel are worth considering reading for specific tools:

- "Unix Powertools" a pretty comprehensive book on command line utilities by  Shelly Powers, Jerry Peek, Tim O'Reilly, and Mike Loukides
- "sed & awk" - by Dale Dougherty and Arnold Robbins
