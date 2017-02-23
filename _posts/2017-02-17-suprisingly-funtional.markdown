---
layout: post
title:  "Surprisingly Functional"
date:   2017-02-23 08:38:14 -0500
tags: 
- shell
- C++11
- functional programming
---

Functional programming is a surprisingly useful programming paradigm.
The best aspects of functional programming have this odd habit of showing in places you would never expect.


## The Shell and Endomorphisms

Arguably one of the most powerful features of the Unix shell is the pipe.
It is one of the core building blocks of the Unix philosophy of many small tools working together each doing one thing well.
However, long before Unix, the idea of the endomorphisms was developed.
The endomorphisms are a cornerstone of functional programming and I would argue why the pipe is so powerful.

A few rough definitions:

+	A `morphism` is "A structure preserving map from one type to another"  For example, functions are morphism.
+	A `endomorphism` is a morphism for which the co-domain (or range) is the domain of the morphism.

In functional programming, endomorphisms are useful because they are can be composed in arbitrary order.
That is not to say that they are associative, only that the output of the function is well formed regardless of how they are composed.

Now consider what a standard Unix process uses as input and output:
They accept text as input. 
They and emit text as output.
In other words, they are endomorphisms.

Which brings us to the pipe operator.
Pipes take take the standard output of one processes and use it as the standard input to another process.
So in essence, pipe is the composition operator of shell programming.
With compositions and endomorphisms you will go far.

## of Optional types and Pointers

Pointers are the source of many a computer science student's frustration.
However, used wisely, they can be used to implement an moadic Optional type.

To be a monad, a type must:

1.	be parameterized by a specific type
2.	have a unit function that converts an instance of the type to an instance of the monad
3.	have 

A couple observations from the bowels of standards for C and C++:

+	 `free(nullptr);` and `delete nullptr;` both perform no operation.
+	`NULL` and its C++11 cousin `nullptr` evaluates to false, all other pointers evaluate to true.

With these two facts we can write a type generic Optional monad (see this [repository][repo]) for a full implementation).

```c++
//in Optional.h
class OptionalBase {
  // for type safety
public:
  OptionalBase() = default;
  virtual ~OptionalBase() = default;
};

template <class T>
class Optional: public OptionalBase
{
public:
	Optional<T>() : OptionalBase(), managed(nullptr) {}
	Optional<T>(T v) : OptionalBase(), managed(new T(v)) {}
	Optional<T>(T* v) : OptionalBase(), managed((v)? new T(*v) : nullptr) {}
	Optional<T>(const Optional<T> &v)
		: OptionalBase(), managed((v.managed) ? new T(*v.managed) : nullptr) {}
	~Optional() {delete managed;}
	Optional& operator= (const Optional& rhs)
	{
		if(&rhs == this) return *this;
		delete managed;
		managed = ((rhs.managed) ? (new T(rhs.managed)): (nullptr));
		return *this;
	}
	bool operator==(const Optional<T> &rhs) {
		if (managed == nullptr && rhs.managed == nullptr)
			return true; // empty == empty
		else if (managed == nullptr || rhs.managed == nullptr)
			return false; // empty != full
		else
			return *managed == *rhs.managed;
	}
	template <class Ret, class Args>
		Ret Bind(std::function<Ret(Args)> &f,
				typename std::enable_if<
				std::is_object<Ret>{} && std::is_pointer<Args>{} &&
				std::is_convertible<T, typename std::remove_pointer<Args>::type>{} &&
				std::is_base_of<OptionalBase, Ret>{}>::type * = 0) const {
			return f(managed);
		}
private:
	T* managed;
};
```

And to show that it verifies the monad laws (which is more than you can say about [Java's][java] implementation)

```c++
#include <iomanip>
#include <funtional>
#include "Optional.h"
int main()
{
	std::function<Optional<int*>> f = [](int* v){
			if(v == nullptr)
			{
				return Optional<int>(-1);
			} else if (*v == 2) {
				return Optional<int>();
			} else {
				return Optional<int>(*v + 1);
			}
		};
	int * one = new int(1);
	int * two = new int(2);

	cout << (Optional<int>{2}.Bind<int>(f) == f(two)) << std::endl;
	cout << (Optional<int>{1}.Bind<int>(f) == f(one)) << std::endl;
	cout << (Optional<int>{nullptr}.Bind<int>(f) == f(nullptr)) << std::endl; //doesn't work in java Option type
}
```

Happy programming!

[java]: https://dzone.com/articles/whats-wrong-java-8-part-iv
[repo]: https://github.com/robertu94/optional
