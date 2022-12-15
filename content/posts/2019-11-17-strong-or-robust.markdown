---
layout: post
title:    "Strong or Robust?"
date:     2019-11-17 08:00:00 -0500
tags: 
- Software Engineering
---

Should a software design be strong or robust?
This is a debate that seems to have been developing in recent years with the recent proponents so-called "strong-typing" advocating new API designs.
In this post, I go a little into the debate and discuss its consequences.

# What does it mean to be strong vs robust?

Robustness in software engineering is not a new concept, and intuitively a attractive one.
Who doesn't want their software to be robust?
However, robust to what?
And more importantly, at what costs?

One of the [most lasting definitions of robustness comes](https://tools.ietf.org/html/rfc1122) from Jon Postel -- one of the early architects of the Internet.

> Be liberal in what you accept, and conservative in what you send

By this he argued, that systems should accept a wide array of types and formats as input, while sending out a highly specified return value.
Now Postel meant this in terms of the design of inter-networked systems such as the Internet;
However, the same principles apply to API design.
What is an API except a means by which we accept input from others and return to them a response or do some work on their behalf.

However this comes at a cost.
Network programming has bedeviled many a computer science undergraduate and later engineers as they attempt to cope with the proliferation of implementations on the Internet.
In some senses, these systems are not easy to use.

In a different domain, developers and teachers such as Jonathan Bocara have been [advocating for so-called "strong types".](https://www.fluentcpp.com/2016/12/08/strong-types-for-strong-interfaces/)
Bocara describes strong types this way:

> A strong type is a type used in place of another type to carry specific meaning through its name

At first this might not make a ton of sense so consider this example which is slightly different than the one Bocara uses:

```cpp
template <class Type, class Tag> 
struct NamedType {
  Type value;
  template<class... Args>
  explicit NamedType(Args&&... value_args): value(std::forward<Args>(value_args)...) {}
  operator Type() { return value; }
};
using NumThreads = NamedType<unsigned int, struct threads>;
```

This allows instances of `NumThreads` to be used as an `unsigned int` but instances of `unsigned int` cannot be used as `NumThreads` without explicitly converting it to a `NumThreads` first.
Likewise, each class instantiated from, NamedType is incompatible with each other.
That means if we made another type called `NumProcesses` from `NamedType` it would also be incompatible.
You can only use `NumThreads` for `NumThreads` and `NumProcesses` for `NumProcesses`

Bocara and others argue that this design makes it easier to use APIs that use types like this.
Specifically, it helps with the wrong argument order problem and the problems associated with not understanding what a argument means from a call site.
To use the example above, if all you have is `4` at the call sight, you have no idea what `4` means, but if you see `NumThreads(4)` you can be reasonably sure that the function will use `4` threads.

# What are the trade-offs?

I see there are two major areas of trade-offs between strong and robust types.

First is the tradeoff between ease of implementation and ease of use and flexibility.
Strong Types are self-evidently easier to implement and use.
They are self-documenting at the call site, and they are trival to write with helpers such as `NamedType` above.
Additionally, since strong types can only be used in one way, they require less effort to implement.

Strong types are less flexible.
Consider a concurrency library that allows tasks to be executed in parallel.
At first, this library could be implemented using operating system threads.
This library could have a type called `NumThreads` which determines the number of threads that are to be used.
However, an enterprising developer could add another back-end that uses operating system processes instead.
At this point, the developer could use `NumThreads` for both and the name would be misleading, he could could create a new type called `NumProcesses`, or he could rename `NumThreads` to a new name which implies some other other concurrency model that users have to learn and understand while breaking the API for all downstream users who have `NumThreads` in their code.
The second choice is even more insidious because it now makes it harder from some down-stream user to have a generic parallel solution that works regardless of what kind of parallelism the user wants to employ because they now need to introspect the task queue to determine which argument it needs to have passed.

Second is modifiability.
For either, contracting the API -- i.e. allowing fewer inputs than previously allowed -- is a breaking change to users of the API.
This is illustrated by Hyrum's law:

> With a sufficient number of users of an API, it does not matter what you promise in the contract: all observable behaviors of your system will be depended on by somebody.  ~ [Hyrum's Law](https://www.hyrumslaw.com/)

For strong types, expanding the API is typically not a breaking change unless users are doing something unusual (i.e. making a function pointer from your API, need ABI compatibility for an API with default arguments, etc) and requires only an additional overload.
For robust APIs, they necessarily allow expansion by definition, but then require a substantially more robust design to accept a wider possible array of input types.



# How can we do implement these principles?

Every language has different capabilities to implement these design patterns.
I take a few case studies from a few languages that I have used: Java, C++, and Python.

![Strong Types Vs Robust Designs]({{site.url}}/static/posts/strongtypes/StrongTypesRobust.png)

Statically typed languages such as Java and C++ have the ability to implement something like a strong type.
Where they differ is their ability to implement robust types.

Java which prides itself as a language for software engineers and architects has a wide array of options for complementing robust types.
It has interfaces, bounded generics and unbounded generics.
Using these facilities is straight forward.


C++ has fewer but arguably more powerful options with template and SFINAE.
Since C++ templates are turning complete, it is possible to implement very sophisticated code generation facilities in templates if you don't care about compile times.
However unlike Java, these changes are typical not trivial.
To implement constrained templates uses will take advantage of SFINAE and built-in classes such as `std::enable_if` and `std::void_t` to enable and disable functionality.
In C++20, C++ gained concepts which allow an easier way to specify this kind of functionality, but these are as of writing not yet widely available.

Dynamically typed languages such as Python have very little ability to implement strong types without going against the principles of the language.
In recent versions, python has gained a facility called Type Hints which can provide some additional information to API users, but it isn't widely used, and isn't as complete a full type system in a language such as C++ or Java.

# Why does it matter?

So why do these design choices matter?
They matter because they change the quality attributes of our designs.
As we chose between strong types and robust types, we make decisions that impact the maintainability, usability, and modifiability of our designs.
Thinking carefully through these trade-offs will improve our designs.

Hope this helps!


