---
layout: post
title:  "Julia: Could There be One Language?"
date:   2019-04-04 09:00:00 -0500
tags: 
- Julia
- programming
...

There is a constant problem with programming language design: fast, generic, easy to write; pick two.
The principle is that programming languages cannot be all three at once.
Code that is Fast and Generic like C++ isn't exactly easy to write.
Code that is Generic and easy to write like Python isn't always fast in the sense that C/C++ programmers mean it.
Code that is Fast and Easy to Write isn't always Generic in the sense that Python is.
There is a new language on the block -- Julia -- which strives to challenge these assumptions.
In the remainder of this post, I highlight what I like about it and describe my experience using it over the last semester.


# The Good

## Complexity when you want it, but fast by default

A friend of mine recently wanted to write this python, but was surprised when it was slow:

```python
from collections import defaultdict
import numpy as np
import timeit

data = (np.random.rand(1000000, 40) * 100).astype(np.int)
rows,cols = data.shape

def locs(data):
    locs = defaultdict(list)
    for row in range(rows):
        for col in range(cols):
            locs[data[row,col]].append((row,col))
    return locs

print(timeit.timeit('locs(data)', globals=globals(), number=1), "seconds")
```

I thought to myself, I could make that run faster in c++:

```cpp
#include <random>
#include <unordered_map>
#include <chrono>
#include <vector>
#include <iostream>

class Matrix{
  public:
  Matrix(int x, int y): values(x*y), shape(std::make_pair(x,y)) {}
  int get(int x, int y) const {return values.at(x + shape.first*y);}
  void set(int x, int y, int value) { values.at(x + shape.first*y) = value;}
  std::pair<int,int> size() const {return shape;}

  private:
  std::vector<int> values;
  const std::pair<int,int> shape;
};

std::unordered_map<int, std::vector<std::pair<int,int>>>
locs(Matrix const& data)
{
  std::unordered_map<int, std::vector<std::pair<int,int>>> locs;
  auto shape = data.size();
  for (int i = 0; i < shape.first; ++i) {
    for (int j = 0; j < shape.second; ++j) {
      auto value = data.get(i,j);
      locs[value].emplace_back(i,j);
    }
  }
  return locs;
}

int main(int argc, char *argv[])
{
  Matrix data(1000000, 40);
  std::default_random_engine eng;
  std::uniform_int_distribution<int> dist{1,100};
  auto rand = [&]{ return dist(eng); };

  auto shape = data.size();
  for (int i = 0; i < shape.first; ++i) {
    for (int j = 0; j < shape.second; ++j) {
      data.set(i,j, rand());
    }
  }

  auto begin = std::chrono::high_resolution_clock::now();
  locs(data);
  auto end = std::chrono::high_resolution_clock::now();

  std::cout << std::chrono::duration_cast<std::chrono::milliseconds>(end-begin).count()/1000.0 << std::endl;

  return 0;
}
```

But as you can see this isn't the most readable code, and I've had to re-implement a 2D Matrix class to make the code as readable as this is.  My friend who knows python probably wouldn't have been able to write this.

So I decided to explore Julia as an option:

```julia
module Locs

import DataStructures
#slowest
function find_locs_generic(A)
  locs = DataStructures.DefaultDict(() -> Vector())
  rows, cols = size(A)
  for i = 1:rows
    for j = 1:cols
      push!(locs[A[i,j]], (i,j))
    end
  end
  locs
end


#faster
function find_locs_partial(A::AbstractArray{T,2}) where {T}
  locs = DataStructures.DefaultDict(() -> Vector{Tuple{Int,Int}}())
  rows, cols = size(A)
  for i = 1:rows
    for j = 1:cols
      push!(locs[A[i,j]], (i,j))
    end
  end
  locs
end

#fastest
function find_locs_full(A::AbstractArray{T,2}) where {T}
  locs = DataStructures.DefaultDict{T, Vector{Tuple{Int, Int}}}(
    () -> Vector{Tuple{Int,Int}}()
  )
  rows, cols = size(A)
  for i = 1:rows
    for j = 1:cols
      push!(locs[A[i,j]], (i,j))
    end
  end
  locs
end


data = rand(1:100, 1000000, 40)

macro benchmark(exp)
  quote
    println($exp)
    local val = @time $(esc(exp))(data)
    val
  end
end

@benchmark find_locs_generic
@benchmark find_locs_partial
@benchmark find_locs_full
end
```

So how does Julia stack up?  I'm pretty sure my friend could have written the slowest version fairly quickly.  I could have helped them add the type annotations in a few minutes to get it to the last version.

I ran some quick benchmark numbers on my machine:

```
#python (9 lines of code)
14.683772362000127 seconds

#julia (10 lines of code)
Main.Locs.find_locs_generic
  6.856236 seconds (80.11 M allocations: 2.282 GiB, 48.27% gc time)
Main.Locs.find_locs_partial
  2.661613 seconds (80.10 M allocations: 1.989 GiB, 12.73% gc time)
Main.Locs.find_locs_full
  1.364066 seconds (40.26 M allocations: 823.874 MiB, 11.68% gc time)

#C++ (26 lines of code, algorithm 13)
	0.548 seconds

```

As you can tell, even the slowest version of julia is twice as fast as Python.  Yes, we probably could have gotten the python faster using something like numbra, but that's not what they are familiar with and wasn't packaged for their distribution.  There looks like there is still some room for C++ for the absolutely performance critical applications, but Julia strikes a remarkable balance between being fast and easy to write.

## Powerful features

Julia has a few very powerful features that make it a true developer's language.

The first is static multiple dispatch.  Multiple dispatch allows a function call to dispatch based on all types in the function signature.  This might seem like a small feature, but it allows for a incredibly robust programming model.  It completely obviates the need for object oriented programming while also eliminating the need for some of the more complicated object oriented patterns such as visitor pattern.

```juila
add(x::Integer, y::Integer) = println("int int ", x+y)
add(x::Integer, y::AbstractFloat) = println("int float ", x+y)
add(x::AbstractFloat, y::AbstractFloat) = println("float float ", x+y)
add(x::AbstractFloat, y::Integer) = println("float int ", x+y)
```

The second is functions as a first class citizens in the type system.  This allows a robust functional style programing style when it makes sense such as for data oriented processing code.  Combined with multiple dispatch and by-default generic typing, this almost completely eliminates the need for many of the traditional gang of four patterns making it a surprisingly productive language.

```julia
function mymap(func, list)
  results = []
  for i in list
    push!(results, func(i))
  end
  results
end
```

The third is Julia's sophisticated user-defined type promotion system.  This allows the user to quickly make adaptations when a type does not conform to the interfaces provided by some library author.  It also means that any type can utilize the rich promotion facilities allowed by the language and standard library so even a average developer can modify core classes if needed.  Look at the promotion.jl file to see how this works.


Macros are the final and perhaps most power feature that I'll highlight.  These are not textual macros in the style of C, but rather object oriented macros in the style of Lisp.  This allows the average developer to make extensions to the compiler or add feature to the language.  The developers often brag that these features allow them to implement most of Julia in Julia itself with a concise syntax. There is (admittedly simple) example of this above that does the benchmarking of the julia code printing out the method name of the method passed in.

## Packaging System

Julia's packaging system takes the best from modern package managers like golang and rust.  It accomplishes this with a few neat tricks:

1. It uses git as a package manager like golang.  This makes distributing julia packages really easy.  This particular features is a blessing and a curse; there is a lot of garbage out there.  But it also means that its pretty simple to get started which encourages future developments as people scratch their own itches.
2. It internally stores a commit hash for every library that is installed in the current environment so it is trivial to reproduce a package set installed on someone else's computer making reproducing bugs easy.
3. Unlike python and ruby it only stores exactly one copy of each version of each library that you have installed.  This makes it easy to have different versions where it is needed, but save space where it is possible.

## Best in Class Packages

Julia has a number of excellent packages that I would say challenge the packages that I use on a regular basis.
For example, `Plots.jl` is what I wanted Matplotlib to be.  More builtin types just work with `plot` and the names of arguments are in my opinion easier to remember and use.
Other great packages include `OnlineStats` and `JuliaDB` which allow for distributed massive statistics applications.
It also has great packages for machine learning such as `Flux` and differential equations `DifferentialEquations`.


## Really Good Interoperability with Other Languages

Julia has more interop packages than any other language that I've ever used.  Several of them are quite good including `PyCall`, `RCall`, `JavaCall`.
This allows you to use packages that you know and are familiar with without having to learn something new right away or if it doesn't exist.


# The Bad

## Matlabisms

Julia does have a number of matlabisms the most annoying of which is that container indexes begin at 1.  This also shows itself in the name of several function names, the use of `^` for exponentiation rather than `**`, and the whitespace is used to separate array literals.  None of these Matlabisms disqualify it in my opinion, but explain some of the more annoying syntactical quirks of the language.

## Relative Maturity of Packages

Julia is a new language, and that means that the libraries that support it are also immature.  For example the Cxx package for c++ foreign function calls still doesn't compile on the stable release of the language.  Other examples include the `Clustering` library which uses rows for features rather than columns unlike almost every other machine learning library I've ever used.  I'm confident that both of these will be fixed soon.  There are GitHub issues open about both of these problems which are actively worked on.

This is largely ameliorated by the vast array of high quality interop packages that allow you to pull libraries from other languages while they are being ported to Julia natively.

# The Ugly

The absolute worst aspect of Julia is the ability to discover packages.

Right now -- just after the 1.0 release -- there are a number of packages that are broadly recommended (including at time of writing `Cxx` an amazing best in class C++ wrapper) but no longer compile on the latest release.
Allegedly, this should get better now that Julia has made a stable release.
However, only will time will tell on this issue.

Its also not clear to determine what package to use at any given time.
The Julia Observatory is a graveyard to packages that were highly used on previous releases, but have been abandoned since the 1.0 or even in some cases 0.6 release in favor of newer less discoverable packages.
A clear example of that of this would be the Debuggger.  Now there is a great package called `Debugger` that works super well, but if you search for debuggers you will find `Gallium` or `ASTInterpreter2` which don't really work for the 1.0 release.

There is a similar problem with determining which function to use.
Let's say you want to generate interpreter-like printing output of some datatype.
So you search for `print` in the help menu and you find the builtin function, but it's not clear which `print` you are looking for.  You can find it if you follow the hint that `print` calls `show`.  `show` has two overloads, one that takes a mime-type and one that doesn't, but even it doesn't print exactly like the repl.  What does that is `repr`, but only if the MIME type passed in is `text/plain` which is documented only in the `repr` help page.  This is further confused by the difference between `show(stdout, "text/plain", [1 2; 3 4])` and `show(stdout, [1 2; 3 4])` which is supposed to use a default argument of `text/plain` according to the docs.
These kinds of bumps appear in a surprising number of places in the language.
Again, this is not to say that these bumps won't be ironed out, but they do exist.

# Conclusion

So could there only be one?  Maybe.  Julia is the first language that I've encountered in a while that I've decided to learn in my own time.  With recent developments like a full featured Debugger, it has me interested enough to keep using it. Hope this helps!

Happy Programming!
