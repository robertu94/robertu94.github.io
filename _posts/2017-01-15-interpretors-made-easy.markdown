---
layout: post
title: "Interpreters Made Easy"
date:   2017-01-15 10:14:14 -0500
tags:
- "C/C++"
- "flex/bison"
- programming
---


The Interpreter pattern from the ["Design Patterns: Elements of Reusable Object Oriented Software"][designpatterns] can potentially be a very powerful pattern.
It allows you to use a domain specific language to represent a complex computational situation.
However, writing interpreters in practice can be tricky and time consuming.
It really helps to know something about some fundamental parsing algorithms and techniques.

The most naive approach to writing an interpret involves manually matching
each possible next phrase and creating an if else soup to match each possible outcome.
Although, doing string parsing in C or even C++ can be a real pain point in implementing interpreters.
Often you result to character by character comparisons using methods like `std::string::compare` or `strcmp`

However, it is often not necessary to write these scanning and parsing routines by hand.
One way to generate this boilerplate code is to use tools such as flex and bison.
[Flex][flex] is a scanner generator; it handles the job of finding tokens in a corpus.
[Bison][bison] is a parser generator; it handles the job of assembling tokens into a semantic tree.
Unlike most unix tools, the full manuals for Flex and Bison are not contained in the `man` pages.
Instead, you will need to use the `info` utility to read how to use these tools.

By default, these flex and bison generate code that is suitable for a standalone executable.
However, it is possible to embed flex and bison as part of a larger program.
Using this facility you can write an interpreter with ease.
Here are a few things to note when embedding parsers:

## Getting Output

Normally, the entry point to bison parsers is the function `int yyparse(void)`.
This doesn't provide a way to get access to data from the scanner or parser.
But, if you use the `%parse-param` option in bison, you can change the arguments to `yyparse` to whatever you desire.
Here, I get an integer via pointer to make the signature `int yyparse(int * output)`:

```bison
%parse-param { int * output }
```

If you need to pass multiple arguments, you can either use a pointer to a struct, or you can pass multiple parameters like so:
Note the second pair of braces, the effected functions are being generated like macros so you need both sets of braces.


```bison
%parse-param { int * output } { void * more_output }
```

## Multiple Scanners and Parsers

If you have multiple scanners and parsers in a program, it becomes important to name space them.
Especially, if you use you put a scanner in a library that others might use.
You can namespace all external facing bison functions using the `%define api.prefix` option.
Here I rename `yyparse()` and friends  with names like `ab_parse()`:

```bison
%define api.prefix {ab_}
```

## Embedding a Scanner and Parser

Finally, here is an example of embedding a flex and bison scanner-parser into an application.
Here I pass a socket as input to flex and bison:

```c
int client_fd = accept(...) /* arguments omitted for conciseness */
FILE * client_file = fdopen(client_fd, "r+");
if(!client_file){
	perror("failed to create file for socket");
	exit(errno);
}
yyset_in(client_file);
if(yyparse(&value)==0){ 
	/* the parse succeded and value is valid */
} else {
	/* the parse failed */
}
```

It is even possible to [use flex and bison in threaded applications][reentrant].
Getting this setup can be tricky and nuanced, but once setup it is pretty easy.
Once we have this, we have everything that we need to write a threaded library that uses an embedded flex scanner and bison parser.

Happy coding!

[designpatterns]: https://en.wikipedia.org/wiki/Design_Patterns
[flex]: https://github.com/westes/flex
[bison]: https://www.gnu.org/software/bison
[reentrant]: https://stanislaw.github.io/2016/03/29/reentrant-parser-using-flex-and-bison.html
