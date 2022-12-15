---
title: "How to export a C API from a C++ code"
layout: post
date: 2022-10-24
---

# tl;dr


1. define a version of your API using only C compatible types in a header
2. Do NOT include a C++ header in the transitive set of headers
3. make the header compatible with C and C++ using `#ifdef __cplusplus` and `extern "C"`

# Why is this needed

C++ is (mostly) a super set of C.  If you want C++ to be callable from C, you
need to stick to this subset for the declaring code and mark the functions as
having a C ABI. C++ by default includes type information in its ABI (to allow
things like templates and overloads) Using `extern "C"` turns this off and
defaults back to C-style the user provided name.

# How to remove C++ from your API

Depends on what you are trying to remove.

## Using `void*`

A common pattern is to use a type `enum` + a void pointer.  For example:

```cpp
template <class T>
T sum(std::vector<T> const& vec) {
  return std::accumulate(vec.begin(), vec.end(), 0, std::plus<>{});
}
```

Could become

```c
typedef enum {
  int32_dtype,
  int64_dtype
  //other types are possible
} dtype;

double sum_c(void const* data, dtype type, size_t n);
```

in the header file, and in the implementation file:

```c
double sum_c(void const* data, dtype type, size_t n) {
  switch(type) {
    case int32_dtype:
      {
        const int32_t* begin = static_cast<int32_t const*>data;
        const int32_t* end = begin + n;
        return sum(std::vector<int32_t>(begin,end));
      }
    // ... other implementations
  }
}
```

## Using `#define`

Another powerful (but error prone) option is to use C's pre-processor.

```c
#define sum_definition(type) \
  type sum_##type(type const*, size_t n);
#define sum_impl(type) \
  extern "C" type sum_##type(type const* v, size_t n) { \
        type const * begin = static_cast<type const*>(data); \
        type const * end = begin + n; \
        return sum(std::vector<type>(begin,end)); \
  }
```

Then the user can put `sum_definition(my_numeric_type)` to add new types that they defined,
and instantiate their own implementations as needed with `sum_impl(my_numeric_type)`.  Note
many pre-processors will allow the second macro in a C header since the code
isn't type checked until the macro is expanded.

It is also pretty common to have code like this in a header

```cpp
sum_definition(float)
sum_definition(double)
sum_definition(int)
// continue for more types
```

And this in an implementation

```cpp
sum_impl(float)
sum_impl(double)
sum_impl(int)
// continue for more types
```

## Using vtable `struct`s

Another option is to define a set of function pointers that implement the same idea:
```c
//header
typedef struct  {
  my_numeric_type* (zero*)();
  my_numeric_type* (add*)(struct my_numeric_type*, struct my_numeric_type*);
  my_numeric_type* (free*)(struct my_numeric_type*);
} my_numeric_vtable;

typedef struct {
  my_numeric_vtable const* vtable;
  void* data;
} my_numeric_type;

my_numeric_type* new_double(double d);
my_numeric_type* sum(my_numeric_type* nums[], size_t n);

//impl
my_numeric_type* double_zero() {
  return new_double(0);
}
my_numeric_type* double_add(my_numeric_type* a, my_numeric_type* b) {
  double a_v = *((double*)a->data);
  double b_v = *((double*)b->data);
  return new_double(a_v+b_v);
}
my_numeric_type* double_free(my_numeric_type* p) {
  free(p->data);
  free(p);
}
my_numeric_vtable double_vtbl {
  double_zero,
  double_add,
  double_free
};
my_numeric_type* new_double(double d) {
  my_numeric_type* ret = malloc(sizeof(my_numeric_type));
  ret->vtable = double_vtbl;
  ret->data = malloc(sizeof(double));
  *((double*)ret->data) = 0;
  return ret;
}

my_numeric_type* sum(my_numeric_type* nums[], size_t n) {
  my_numeric_vtable* vtbl = nums[0]->vtable;
  my_numeric_type* total = vtbl->zero();
  for(size_t i; i < n; ++i) {
    my_numeric_type* next = vtbl->sum(total, nums[i]);
    vtbl->free(total);
    total = next;
  }
  return total;
}
```

This has the cost of being verbose and allocation heavy, but allows you to hide
the underlying types and allow you or the user to add new ones.

Additionally You could replace the definition of `my_numeric_type` in the
header with just `struct my_numeric_type;`.  With this done, it is also
possible to make `my_numeric_vtable` private by removing it from the header
since it is only used via pointer.    These changes have the trade-off
of not allowing users to provide new implementations which may or
may not be desirable.

# Avoiding dependencies in headers

These tricks can help you avoid needing to pull in extra headers.

Use forward declarations generously for non-template C++ types. Except for
things in the C++ standard library (because of reserved.names.general), you can
forward declare functions and thus not need their implementation as long as all
APIs in which you use them consume only pointers.  Use this to reduce the number 
of headers you pull in.

`void*` pointers can be cast to anything except function pointers and anything
can be cast to them.  You can use them as "data" pointers which are casted an
interepeted correctly in C++.

Don't include implementation details in headers, and you can get away with many fewer headers.

Tools like `include-what-you-use` can help with this.

# Using a common header file for C and C++

Once you have a header for your API that uses only C compatible functions, simply mark it as such like so


```cpp
//a header guard is a nice thing to do, protects against duplicate definitions
#ifndef EXPORTING_C_MARKDOWN_YGKLQ24P
#define EXPORTING_C_MARKDOWN_YGKLQ24P


#ifdef __cplusplus
extern "C" {
#endif

// all functions here are C accessible

#ifdef __cplusplus
}
#endif

#endif /* end of include guard: EXPORTING_C_MARKDOWN_YGKLQ24P */

```


The `extern "C"` bit here declares the function as having the C ABI rather than the C++ one.


Hope this helps!
