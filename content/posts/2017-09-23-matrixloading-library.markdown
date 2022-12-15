---
layout: post
title:  "Design of A Matrix loading Library"
date:   2017-09-23 07:00:00 -0500
tags: 
- matrix
- graph
- programming
---

Ever notice that every matrix and graph library seems to have a different interface for constructing matrices?
Also notice that each only only supports some subset of common matrix formats?
With a little help from the Adapter and Builder design patterns we can actually solve this problem.

# Design Overview

![overview-diagram][overview]

In this design, we have 2 main actors: `Parser` and`Builder` as well as their implementations `ParserImpl` and  `BuilderImpl`.
It allows us to write code like this in c++:

```cpp
#include <fstream>
#include <matrixloader/parser/matrixmarket.hpp>
#include <matrixloader/builder/boostgraph.hpp>

int main(int argc, char *argv[])
{
	using namespace matrixloader;
	typedef BoostGraphBuilder<double> bgb;
	std::ifstream matrix_file{argv[1]};
	auto builder = std::make_unique<bgb>();
	auto parser = std::make_unique<MatrixMarketParser<bgb>>(std::move(builder));
	auto matrix = parser.load(matrix_file);
	return 0;
}
```


I have chosen to mock up the interface in `C++` because of its expressiveness with generic types.
I have also created an implementation of the library in `python` and as a header only library in `C++`.

## Builder Interface

The `Builder` class is an implementation of the Builder pattern so that `Parser` classes have a common interface to use to construct matrices and graphs.  The `Builder` class is an abstract generic class that provides three methods: `add_edge`, `reserve` and `build`, and require 2 types: `Value` and `Matrix`.

The `Value` type represents the type of a particular edge weight. The `Matrix` type represents the graph or matrix of `Values`.  Often these types vary jointly, but are, in fact, different.  For example `double` is not viable where a `vector<dobule>` is.   Additionally it is not always possible to extract the subtype from the collection like it is with `vector<int>::value_type`.  Sure, you could probably do some `SFINAE` or reflection nonsense to make a reasonable guess for most cases, but this is not always possible.

### reserve

`reserve` is used to provide hints about the size of the resulting matrix and takes 3 parameters `rows`, `columns`, and `nonzeros`.

An earlier version of this interface did not provide the nonzeros argument.  It was added because the earlier interface was not suitable for providing accurate hints for sparse matrices which often expect the number of nonzero entries for efficient construction.

Notice, the use of the word `hints`.  The implementation is not required to honor the arguments to this function if not practical.  Take for example the `Graph` class form `python`'s networkx package, it provides no means to indicate how many nodes or edges -- let alone nonzeros -- to expect.  Therefore its implementation of Builder has a no-op for this method.


### add_edge

`add_edge` is used to indicate a value of an edge.   This function unconditionally requires an edge value because in the event that weights are not meaningful, the parser implantation can simply pass `1` to create an adjacency matrix.

### build

`build` constructs or returns the final matrix.  Some libraries like `networkx` do not provide batch more efficient batch construction methods, whereas libraries like `scipy.sparse` are not efficient without them.  Therefore the implementation could choose to construct the graph/matrix representation when the constructor is called, or wait until `build` is called to finally construct the matrix.  For this reason, calling `build` more than one time may cause undefined behavior.

### BuilderImpl

The BuilderImpl is simply an Adapter to the specific matrix interface of the matrix construction methods.  It exists so that we have a common interface for matrix construction.

## Parser Design

`Parser` is an abstract generic class that provides one method `Builder::Matrix parse(std::istream&)`.  It is generic on only one type Builder which is expected to conform the Interface Builder.  For languages that do not allow for type alias to be members of a class (IE Java), It should be generic on two types `Builder` and `Matrix` where `Matrix` is the `Matrix` type passed to Builder.

The reason for taking an `std::istream` over something more common like a `std::string` or a `const char *` is threefold: 

1. There is a class called `std::istringstream` that provides an adapter from these types to `std::istream`
2. The most common use case for this use case is loading from a file.
3. For several reasons we may not read the whole file and thus do not need to load it all into memory.

A previous version of the this interface accepted `std::string` by line and return void (requiring a call to build on Builder), but this was changed for three reasons:

1. It avoids excess code on the common case by wrapping it.
2. Some matrix file formats are not newline delimited making an awkward interface to implement for binary files.
3. It reduces the number of objects that need to be passed around.

### ParserImpl

`ParserImpl` simply implements the `Parser` interface for the format desired such as MatrixMarket or EdgeList in terms of contained the `Builder` interface by reading the file.

# Conclusion

While by no means is this a definitive interface for matrix construction, I think it serves a good start.  Well until next time happy coding!



[overview]: {{site.url}}/static/posts/matrixbuilder/overview.png


