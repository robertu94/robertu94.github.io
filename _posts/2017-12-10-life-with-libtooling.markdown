---
layout: post
title:  "Life with Libtooling"
date:   2017-12-10 11:21:00 -0500
tags: 
- C++
- programming
---

Over the last two months, I spent a significant amount of time using Clang's libtooling.
Libtooling is a great way to quickly develop tools to analyze and modify large quantizes of C++.
In this article, I share some lessons learned working with libtooling.


#Beware the Stability Guarantees.

The biggest problem with libtooling is that it has very few if any Stability guarantees.
When I was learning libtooling, I watched Peter Goldsborough's video excellent ["clang-useful: Building useful tools with LLVM and clang for fun and profit"][clanguseful].  The video was filmed in May of 2017, and by September 2017, the code samples no longer compiled on the latest Clang.  The developers made one of the methods he overloaded non-virtual. It wasn't super difficult to patch his code to make it compile, and Clang/LLVM [explicitly warns][clangstable] that you should use libclang instead if you desire a stable interface.

However, this makes it really difficult to learn the interfaces when they are constantly changing.  Hopefully, after a few years, libtooling will become slightly more stable and adopt at least a 6 month stability guarantee, or perhaps some refactoring tools to update to the new interfaces such as what has suggested by Google's project [Abseil][abseil].

#Learning Libtooling is an Exercise in Code Reading

For the most part Clang, LLVM, and Libtooling codebases are paragons of exceptional code.
They are clear, use meaningful names consistently, public interfaces are documented.
However, there are few unclear passages of code that I stumbled across (Clang 6.0):

+	`clang::SourceManager` has several methods for getting locations: such as `getSpellingLoc`, `getImmediateSpellingLoc`, `getExpansionLoc`, `getFileLoc`, `PresumedLoc`. However it is not immediately clear what the difference between them.
+	`RecursiveASTVisitor` contains some macro-processing black magic to generate the stub methods for each AST class.  While you would be hard pressed to write a simpler implementation, it makes to very hard to know that you have written correct code.  Additionally they choose not to make these methods virtual (presumably for performance reasons), so you can't even use `override` to check correctness.

There is also some very high level documentation about the roughs aspects of libtooling usage.
However, this documentation too leaves much to be desired:

+	Some important features for writing tools aren't discussed in the high level docs, such as SourceManager [aren't even mentioned][libtooling].
+	There isn't even an attempt to describe the full grammar of C++.  This makes it hard to determine if you have caught all the possible edges cases in the grammar which have a nasty habit of showing up large low-level codebases.  The closest is the very useful, [ASTMatchers Reference][astmatchers], but it still leaves a lot to figure out with the deep inheritance hierarchies in Clang.

The best reference for learning libtooling is the [clang-tools-extra][clangextra] repository.
Unlike the myriad of other examples on the Internet, these get updated whenever the libtooling API changes because they are managed by the upstream release. Some of these tools are fairly complex, and perhaps aren't great starting places. Another essential tool is `clang-query` which allows you to dump the AST of programs that you may encounter.

#The LLVM Support Library is Great

For various reasons, I needed to compile and run my libtooling application on a CentOS 6 box.  CentOS 6 uses GCC 4.4 which at the time of writing is ancient in terms of compilers (2009) before gcc (or libstdc++) had many C++11 features.  Not only did it compile without user-visible ugly kludges, LLVM's support library provides interfaces to provide useful C++ features like `std::make_unique` as `llvm::make_unique` even when `std::make_unique` isn't available in your standard library which was useful when I went to use the code on an up-to-date Gentoo box with gcc 7.2.0.

Even if you don't have to support bizarre compiler versions, LLVM support library provides a large variety of useful data structures that I found useful such as `llvm::BitVector`

#Follow the Build Instructions

LLVM and Clang recommend building your clang/llvm tools inside of an LLVM build tree.
To me, this feels kind of gross, requiring users to download clang/llvm sources to build their applications even if they are already installed on your box for using `clang`.
However, from this project I found this is truly for the best.
It is surprising how many different locations distributions install Clang and LLVM libraries.
Sometimes they don't even install clang and LLVM libraries in the same directories.
While it is doable, I found it to be much more trouble than its worth.
For example, libtooling needs to lookup paths to clang/llvm headers during execution, it references them with a relative path installed at compile time.
If the build is done out of source, you have to add a symlink so that your application can find the libraries.
While you could just patch libtooling to respect the system location, I found this to be surprising difficult to locate where this setting was made, and gave up after two hours of searching.
Just build your applications in tree, you'll be much happier.

#Conclusion

All and all, I found libtooling to be very useful and despite the faults listed above reasonably easy to learn and use. I reccomend that you take a look at it if you need to write tools for C++. I hope you found this helpful.  Until next time happy programming!


[clanguseful]: https://youtu.be/E6i8jmiy8MY
[clangstable]: https://clang.llvm.org/docs/Tooling.html
[abseil]: https://abseil.io/about/compatibility
[libtooling]: https://clang.llvm.org/docs/LibTooling.html
[astmatchers]: https://clang.llvm.org/docs/LibASTMatchersReference.html
[clangextra]: https://github.com/llvm-mirror/clang-tools-extra
