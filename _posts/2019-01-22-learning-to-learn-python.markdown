---
layout: post
title:  "Learning to Learn: Python"
date:   2019-01-23 08:00:00 -0500
tags: 
- Learning to Learn
- Programming
- Python
---

Python is a relatively simple language compared to others such as C++.  Despite its simplicity, Python really shines because of its robust standard library, extensive 3rd party library ecosystem (especially for statistics and data analysis), and intuitiveness.  This post tracks my process of learning how to program well in Python.

## Order of Topics

The listing of topics here is arbitrary and represents the path that I took to learn Python roughly organized by topic.  My advice is that with Python you choose topics that are useful to you and focus on them.

## Beginning Python

Everyone needs to start somewhere, but there are limited, current, comprehensive, and free documents that describe an overview for the language.

I would recommend in starting in one of two ways:

1. Read ["Dive into Python 3" by Mark Pilgrim](https://www.diveinto.org/python3/).  It used to be that this book was all you needed to read to get started.  However the author of this book has since retired and Python has grown since version 3.0.  To supplement this reading, I would recommend reading up on the following newer topics from the [Python Release Notes](https://docs.python.org/whatsnew/):
    1. Pathlib -- the newer and more user friendly file interface introduced in Python 3.4.
    2. f-Strings -- a newer way for writing formatted strings which cuts down on the verbosity.
    3. Async-IO -- as of Python 3.5, Python developed a robust set of faculties for asynchronous programming.  While you probably won't start out writing async programs, know what they are and how they work will make reading them less surprising.
    4. Type Hints -- as of Python 3.5 Python now supports the ability to provide type information for arguments.  While the information is only a hint and is automatically ignored at runtime, it can be checked statically by tools.
2. Read the ["Python Tutorial"](https://docs.python.org/tutorial) which is part of the standard documentation.  This resource is a bit terse for non-programmers, but provides a well written and more modern introduction to the language. 

I also would read "The Zen of Python" by Tim Peters.  You can find it by typing `import this` in a Python interpreter.  It is poem that describes some of the design philosophy about Python.  Keep these lines in mind as you watch and read the following items in this post.

I would also watch these videos by Raymond Hettinger who is one of the Python Core Developers that overview the design philosophy around Python:

+ [Transforming Code into Beautiful Idiomatic](https://youtu.be/OSGv2VnC0go)
+ [Beyond PEP8 -- Best Practices for Beautiful Intelligible Code](https://youtu.be/wf-BqAjZb8M)

    
# Tooling and Libraries

Python is famous for the set of libraries and tools that it supports and that are built using it. In this section I give a limited overview of the libraries and tools that I use most often.

## Standard Library

Python's claim to fame is that it has one of the best "batteries included" standard libraries.  Learning to use it well is essential to any budding Python programmer.  For these tools, I reccomend the web documentation on [docs.python.org](https://docs.python.org/library). These docs are written in such a way so that they can be read as introduction rather than using the `help()` method which is intended to be a reference.  Here are some of the parts of the standard library that I use most.

| Name                   | Use                                          |
|------------------------|----------------------------------------------|
| datetime               | Parsing, formatting, and calculating dates   |
| collections            | A set of useful data structures              |
| random                 | A robust but easy to use random numbers      |
| pathlib                | Modern, easy to use filesystems library      |
| os                     | OS generic facilitates                       |     
| sqlite3                | Built-in SQLite support                      |
| csv                    | CSV parsing                                  |
| json                   | JSON parsing                                 |
| logging                | A robust easy to use logging library         |
| argparse               | All but the most complex command line parsing|
| threading              | Spawning and using threads                   |
| multiprocessing        | Spawning and using multiple processes        |
| concurrent.futures     | Modern futures based multithreaded/process   |
| subprocess             | Run other programs and get their results     |
| asyncio                | Asynchronous IO library                      |
| typing                 | Type hint support                            |
| itertools              | Tools for working with iterators             |
| functools              | Tools for higher level functions             |
| unittest               | Built-in unit testing framework.              |
| doctest.               | Another unit testing framework that uses doc strings |

## 3rd Party Libraries

In addition to the fantastic standard library, Python has a number of famous 3rd party libraries that are considered the best in class across all programming languages.  While I list these specifically later, I would be remiss in failing to mention the [NumFOCUS libraries](https://numfocus.org) which includes MatplotLib, NumPy, SciPy, Pandas, and others up front as some of the best open source (arguably overall) libraries for statistical analysis and numerical calculation that exist.  Unfortunately the quality of the documentation for these tools varies highly.  One alternative to strictly reading the documentation is to look at the unit-tests for the library.  Because of the builtin unit testing frameworks being quite good, Python libraries often have extensive test suites.

| Name                 |Use                   |Description                                |
|----------------------|----------------------|-------------------------------------------|
| pandas               | data anlaysis        |Data analysis framework for tabular data   |
| scipy                | data anlaysis        |Fast scientific functions                  |
| numpy                | data anlaysis        |Fast numeric framework famous for arrays   |
| matplotlib           | plotting             |Defacto plotting library for Python        |
| seabourn             | plotting             |Ease of use layer for matplotlib           |
| bokeh                | plotting             |Web-first plotting library                 |
| plotly               | plotting             |Interactive plotting library               |
| beautiful soup       | scraping             |Sane HTML parsing                          |
| scrapy               | scraping             |Web Scraping Framework                     |
| requests             | scraping/web requests|Vastly superior HTTP library               |
| django               | web app              |opinionated easy to use CMS framework      |
| flask                | web app              |Flexible web app framework                 |
| selenium             | testing              |Automated web browser controller           |
| psycog2              | database             |PostgreSQL bindings                        |
| simpy                | simulation           |Simulation library                         |
| mpi4py               | HPC                  |Distributed memory programming executor    |
| tensorflow           | machine learning     |Faster but more complex machine learning   |
| sklearn              | machine learning     |Easy to use but slower machine learning    |
| networkx             | graphs               |Easy to use but slow graph library         |
| networkit            | graphs               |Slightly harder to use but faster graphs   |


## Tools for developing Python

Due to the popularity of Python, there are a number of tools that exist to make it easier to work with.  A number of these tools have great documentation.  There is one key exception which is `setuputils`.  For `setuputils` I would read [this guide on packaging Python libraries](https://packaging.python.org/guides/distributing-packages-using-setuptools/).

| Name                   | Use                                            |
| -----------------------|------------------------------------------------|
| pdb                    | Python debugger                                |
| pip                    | Tool for installing packaged libraries         |
| setuputils             | Python library/tool for packaging libraries    |
| flake8                 | Linter for Python that respects PEP 8          |
| jedi                   | Code completion for Python                     |
| mypy                   | Python Static Type                             |
| iPython                | Friendly interactive shell                     |
| JuPyter                | Notebook software commonly used for science    |
| python-language-server | Implementation of the language server protocol |

## Other tools that work well with Python

Another reason to learn Python is be able to use it as part of other tools.  Most of the time, the libraries are fairly straight forward to use and to learn to use with good project level documentation.  Generally speaking these tools come in one of two flavors, applications that are written in Python and are easy to extend and those that are written in C/C++ and need a wrapper library.

| name                     | purpose                                       |
|--------------------------|-----------------------------------------------|
| gdb                      | well supported native executable debugger     |
| lldb                     | easy to use native executable debugger        |
| ansible                  | easy to use system orchestration tool         |
| saltstack                | more "Pythonic" system orchestration tool     |

GDB and LLDB are C/C++ applications that use a wrapper library.
There are two good tools for doing generating Python bindings for lower level C/C++ applications:

+ `swig` -- easy to use, but can have significant overhead for some applications. Supports other languages.
+ `boost::Python` --  harder to use, but lower overhead

Both have extensive examples of how to get started with these tools online and pretty good project documentation.  The biggest hiccup that people find when they go to use these tools is that they require the use of the development libraries for Python which are often installed separately from the Python interpreter.

Generally, the strategy that is recommended for using these tools is to create  a class or module that exposes the functionality you would like to configure from Python and applying these tools to just that module.  Then as an added benefit, you have a façade for your library to make it easier to use in the lower level library.

Watch this [video from CppCon](https://youtu.be/za0_FiMqjKE) that describes why you may want to do this and how to do it well.

# Functional Programming in Python

One common misconception about Python is that it is primarily object oriented programming language.  Rather, Python is primarily a functional language that supports object orientation where it makes sense.  In functional programming, programmers avoid the use of state and have so called "higher level programming" faculties that accept functions and return functions. You should watch this [video on why object oriented Python is overused](https://youtu.be/o9pEzgHorH0).

The functional capabilities of Python are best seen in the following features of the language:

+ Functions as first class types.
+ List, Generator, and Dictionary Comprehensions.
+ Easy to write Iterators.
+ Great library support for iterators, and higher-level programming.

I would read the appropriate sections of the Python docs especially `itertools` and `functools`.


One common question that comes up when considering generators versus list comprehensions is which to use.  Generally, you should prefer generators because they use less memory and can be converted to lists later if multiple passes or random access is required.  This [video is on Python 2, but shows why you should prefer generators over lists](https://youtu.be/07-K4LFhBMc)

# Object Oriented Programming in Python

That said, Objects in Python are not considered second class citizens.  If you have not read the key text on Object Oriented design [Design Patterns Elements of Reusable Software](Python's Class Development Toolkit https://youtu.be/HTLu2DFOdTg) you should read that first.  It explains why you would want to use object oriented design in the first place. However much of what is in this book is a language feature of Python.  I would [read this site](https://python-patterns.guide/)  which shows that many of the classical patterns of Object Oriented design are just features of Python. I would also watch/read the following resources to better understand object oriented Python:

+ [Python's Class Development Toolkit](https://youtu.be/HTLu2DFOdTg) which provides a high level overview of how to write good classes in Python.
+ [Super Considered Super!](https://youtu.be/EiOglTERPEo) this video overviews Python's multiple inheritance model and how to use it effectively.

# Other helpful topics

There are a number of other useful topics that I would commend to your consideration when you have finished reading about the topics above.

+ **Coroutines/Asynchronous Programming** are a really easy way to write iterators and are an easy way to abstract asyncronous programming in Python in general.  Read the standard library docs on AsyncIO to get an overview of why and how to use these.
+ **Decorators** are a great way to do aspect oriented programming in Python.  I would read this [paper on decorators](https://realpython.com/primer-on-python-decorators/) and I would read about how Flask uses them to get the high points.
+ **Metaclasses** are a powerful way to change how classes are constructed.  If you are in doubt if you need meta-classes you probably don't need them.  However they are how Django built their `Model` class and how much of the standard library is built.  I would read this [Stack Overflow answer about how they work ](https://stackoverflow.com/a/6581949) if you need to learn how to use them.
+ **Performance** Python generally is slower than compiled languages such as C/C++.  You can look into tools like embedded C/C++ modules, cython, pypy, or numbra if things are too slow. Understanding profiling tools is also helpful consider [watching this video](https://youtu.be/yrRqNzJTBjk) as a starting place.
+ **Parallel and Distributed Programming** Python has some of the best parallel and distributed programming features out there.  I would read/watch the following resources:
  + Read the docs for `multiprocess` and `theading` in the standard library.  They describe the executor abstraction which is core to parallel and distributed programming in Python.
  + Watch this [video from Raymond Hettinger on parallel programming](https://youtu.be/9zinZmE3Ogk) which describes some common pitfalls and tools for parallel programming.
  + `mpi4py` documentation -- `mpi4py` is a Python binding for openmpi, but providing substantial ease of use benefits.  If you want to run on a HPC cluster, `mpi4py` is the way to do it.


# What's Next

Once you've done the above, I would consider the following resources for father reading:

+ PyCon -- PyCon is a set of related conferences about Python programming.  Some of the keynotes and presentations are quite well done.  Many are posted online.
+ Read the standard library code for some advanced examples of good Python code.  As a reminder, Python code is almost always distributed as source code which means you can read it.
+ Read the Python Enhancement Proposals (PEPs) to get an idea about where the language is going.

# Suggestions to Learn the Language

I have one key suggestion to learning Python:

1. Pick a project that is useful you:  Python has libraries for almost everything.  Some much better than others.  I would suggest picking a project then do some quick research about what libraries people use to do that kind of work.
2. Refuse the temptation to write C in Python.  Python has great functional and object oriented facilities use them.
3. After you have written the code, re-write it after watching videos like the ones from Raymond Hettinger or considering the Zen of Python.  This will help you understand Pythonic style more and write more natural code.

Hope this helps!


