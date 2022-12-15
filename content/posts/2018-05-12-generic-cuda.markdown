---
layout: post
title:  "Generic Cuda"
date:   2018-05-12 08:00:14 -0500
tags: 
- C++
- programming
- Cuda
---

GPU programming has the potential to make embarrassingly parallel tasks very quick.
But what if you want to perform the same task on a variety of different types?
In this post, I walk through a generic testing code that preforms a vector add on GPU and CPU to verify the correctness.

# The Test Harness

Our main function is pretty simple:

```c++
int
main(int argc, char* argv[])
{
  check_type<int>();
  check_type<long>();
  check_type<double>();
  check_type<float>();
  return 0;
}
```

So how do we write `check_type`?
Since it does most of our work, let's break it down step by step.
First we create a function that will perform our check and allcoate some data pointers we will use later.

```c++
template <class T>
void
check_type()
{
  //create an array for 1024 items of type T
  constexpr int elms = 1024;
  std::array<T, elms> a, b, c, d;
  T *d_a = nullptr, *d_b = nullptr, *d_c = nullptr; // device vectors

```

# Generating random data

To have the best guarentee that the code is working, it is best to test with random data.
To do that we need to generate random data according to a distribution.
In C++11, you do this by creating a random number distribution and seeding it with a random number engine.

```c++
  //create a random number generator
  std::random_device rd;
  std::mt19937 eng(rd());
  typedef typename std::conditional<
    std::is_integral<T>::value, std::uniform_int_distribution<T>,
    std::uniform_real_distribution<T>>::type generator;
  generator dist(0, 100);
  auto trand = [&dist, &eng]() { return dist(eng); };
```

In the code above we first create a `std::random_device` which is responsible to seed our random number generator.
However, since this uses hardware randomness (if available), it can be slow.
So it is not uncommon to switch to a pseduo-random number generator which we do with the marsenne twister generator `mt19937` on the next line.
For the generator, we need to decide if we need integral data (i.e. integers) or floating point data.
We accomplish this using `std::conditional` and `std::is_integral` to select at template instantiation time between a `std::uniform_int_distribution` and a `std::uniform_real_distribution`.
Finally we create a lambda expression to create a version that behaves like classic C style `rand`.

# Computed expected on the CPU

If you've never worked with C++'s `<algorithm>` header it makes boiler plate code like this a dream.

```c++
  //check_type cont...
  //generate random inputs
  std::generate(std::begin(a), std::end(a), trand);
  std::generate(std::begin(b), std::end(b), trand);

  //compute the expected output on the CPU
  std::plus<T> pl;
  std::transform(std::begin(a), std::end(a), std::begin(b), std::begin(d), pl);
  std::fill(std::begin(c), std::end(c), 0);
```

First we generate two arrays with random numbers.
After that we compute the results by transforming the two arrays we generated into the result array by adding them.
Finally we fill the result array with zeros to ensure the comparison fails latter if some thing goes poorly.

# Moving data to the device

Unlike CPU programming, GPU programming requires explicit data movement to be efficient.
Before we run the kernel, we need to explicitly request space on the GPU and move the data to it.

```c++

  //check_type cont...
  //allocate the device buffers for inputs and outputs
  size_t size = (sizeof(T) * elms);
  check_error(cudaMalloc((void**)&d_a, size));
  check_error(cudaMalloc((void**)&d_b, size));
  check_error(cudaMalloc((void**)&d_c, size));

  //load the inputs onto the device
  check_error(cudaMemcpy(d_a, a.data(), size, cudaMemcpyHostToDevice));
  check_error(cudaMemcpy(d_b, b.data(), size, cudaMemcpyHostToDevice));
```

Notice we compute the size based off the number of elements and the size of the type, but for C programmers who use malloc this isn't a huge surprise.
We take advantage of the `.data()` routine to work with `std::array` instead of raw data pointers.

You'll notice calls to a method called `check_error`, for now just remember that it performs error handling.
We'll talk more about it in a later section.

# Creating and Launching the Kernel

Not much changes in launching the kernel and retrieving the results.
All we have to do is add `<T>` to dispatch to the correct typed version of `vadd`.

```c++
  //check_type cont...
  //launch the kernel
  int threadsPerBlock = 256;
  int blocksPerGrid = (elms + threadsPerBlock - 1) / threadsPerBlock;
  vadd<T><<<threadsPerBlock, blocksPerGrid>>>(d_a, d_b, d_c, elms);

  //copy the results back to the host
  check_error(cudaMemcpy(c.data(), d_c, size, cudaMemcpyDeviceToHost));
```

So, how is `vadd` defined?

```c++
template <class T>
__global__ void
vadd(const T* a, const T* b, T* c, int elms)
{
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  if (idx < elms) {
    c[idx] = a[idx] + b[idx];
  }
}
```

If you've ever used cuda, this code isn't that surprising.
They only key difference is the introduction of the `template <class T>` bit to make the code generic.

We could have accomplished the same impact with some code like this:

```c++
#define vadd_impl(T)                                  \
  __global__ void                                     \
  vadd_##T(const T * a, const T * b, T * c, int elms) \
  {                                                   \
    int idx = blockIdx.x * blockDim.x + threadIdx.x;  \
    if (idx < elms) {                                 \
      c[idx] = a[idx] + b[idx];                       \
    }                                                 \
  }
vadd_impl(int)
vadd_impl(long)
vadd_impl(float)
vadd_impl(double)

# define vadd(T) vadd_##T
```

which would then be called in the driver like so:

```c++
vadd(T)<<<threadsPerBlock,blocksPerGrid>>>(d_a, d_b, d_c, elems)
```

But what do we lose by doing this?
We loose some readability and compiler support.
Notice the `vadd_impl(int)`, `vadd_impl(long)`, and so on.
This has to be explicitly defined for each type.
Not only is this tedious, if cuda decided to add a new type, we have to update our library to support it.
We also generate the code for each method whether or not we use it.
But what do we gain by doing it this way?
As much as I hate to say it, opencl support for most hardware available right now.
Opencl 2.2 introduced the c++ kernel language which includes template support, but very few vendors support this syntax.
Without it, you are left to use macros to get the same generic code.

# Printing results

```cpp
  //check_type cont...
  //check if the results are the same and report to the user
  std::cout << name<T>::n << " "
            << (std::equal(std::begin(c), std::end(c), std::begin(d))
                  ? "success"
                  : "failed")
            << std::endl;

cleanup:
  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);
```

What is `name<T>::n`?
You may recall that C++ currently doesn't really have fully featured reflection (that may change if Herb Sutter gets his way...).
So if you want the name of a class, you have two choices, `typeid` or some clever template programming.
The problem with `typeid.name()` is that it returns an implementation defined name.
For clang and gcc, this is the mangled name that is generated by the compiler for purposes getting unique names for linking.
This can be cleaned up into a human readable name using an implementation specific demangle function.
However, this is far from a perfect procedure, so I opted for some clever template programming.
`name` is a struct that defines the name of the type is passed in as its template parameter.
It is defined like this:

```cpp
template <class T>
struct name
{
  static const char* n;
};

#define decl_name(T)                                                           \
  template <>                                                                  \
  struct name<T>                                                               \
  {                                                                            \
    static const char* const n;                                                \
  };                                                                           \
  const char* const name<T>::n = #T;

decl_name(int);
decl_name(double);
decl_name(float);
decl_name(long);
```

It defines a macro and uses the `#` operator to convert the template type parameter to a string.
The macro creates a template specialization of the `name` base template provided above.
This provides a compile-time way to get the appropriate type name with requiring demangling.
There is a weakness to this method.
It can't have separate entries for type aliases (i.e. `size_t`).
But since I didn't need that flexibility for my code, it was fine.

So what is with the label `cleanup`?
Remember the method called `check_error`?
It prints a failure message and cleans up memory if a cuda function fails.
It is defined like this:

```cpp
#define check_error(x)                                                         \
  do {                                                                         \
    cudaError_t err = (x);                                                     \
    if (err != cudaSuccess) {                                                  \
      std::cerr << "Failed: " << __LINE__ << " " << cudaGetErrorString(err)    \
                << std::endl;                                                  \
      goto cleanup;                                                            \
    }                                                                          \
  } while (0)
```

Macros that are intended to act like functions can have bizarre interactions if used in non-standard places.
Wrapping a macro in a `do { } while(0)}` allows the macro to be used almost everywhere a function call can.
It also has the effect of creating a scope that can prevent naming conflicts.
The parens about `(x)` are also to prevent weird order of operations bugs that can results from macros.
Finally we `goto cleanup` if the error happens which simplifies the control flow from being a huge `if` pyramid.


I hope you find this helpful.   Until next time, happy programming!
