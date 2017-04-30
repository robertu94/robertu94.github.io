---
layout: post
title:  "Smart Pool"
date:   2017-04-30 9:58:14 -0500
tags: 
- C++
- Templates
- programming
---

Object Pools are a commonly used pattern used in operating systems, game, and high performance computing development.
However just as it can be easy to forget to return a pointer to memory, it can be easy to forget to return the memory to the pool.
In this article, I layout a class that I recently used to automatically manage memory from a pool.

The template pool class has 4 parts: an onEmpty policy, an allocation policy, a reset policy, and an object proxy.
Let's take these one at a time:


## Allocation Policy

The allocation policy is responsible for allocating (and possibly deallocating) instances of the class.
It also provides some meta-data about the state of the allocated objects.

Here is an implementation of an allocation policy that use perfect forwarding to a constructor:
Other policies might call a factory method.

```c++
#include <memory>
template <class Value>
class ForwardingAllocation
{
	public:

	ForwardingAllocation(): allocated(0U) {}

	template <class... Args>
	std::make_unique<Value> Allocate(Args&&... args)
	{
		allocated++;
		return std::make_unique<Value>(std::forward<Args>(args)...);
	}

	void Deallocate(std::unique_ptr<Value>&&)
	{
		//intensional no-op unique_ptrs
		//free their own memory when they fall of of scope
		allocated--;
	}

	unsigned int getAllocated() const
	{
		return allocated;
	}

	protected:
	~ForwardingAllocation()=default;

	private:
	unsigned int allocated;
};
```

## Reset Policy

The reset policy is responsible for resetting an object after it is allocated before it is returned
This implementation uses perfect forwarding and in-place construction.
Other policies might call a specific reset method.

```c++
template <class Value>
class inPlaceReset
{
	public:
	void Reset(Value* ptr, Args&&... args)
	{
		new (ptr) Value (std::forward<Args>(args)...);
	}

	protected:
	~ForwardingAllocation()=default;
}
```

## onEmpty Policy

Now to put these policies together.
The onEmpty policy is responsible for what the pool should do when it exhausts all avail bile pointers.
Here is an implementation of the onEmpty policy that allocates a single new object when the pool is empty.

```c++
template <class Value,
		  class ListType,
		  class AllocationPolicy = ForwardingAllocation<Value>,
		  class ResetPolicy = inPlaceReset<Value>
		  >
class onEmptyLoad: public AllocationPolicy, public ResetPolicy
{
	public:
	template<class... Args>
	void onEmpty(ListType& free_list, Args&&... args)
	{
		free_list.emplace_back(
			this->Allocate(std::forward<Args>(args)...)
			);
	}

};

```


## Object Proxy

The object proxy is where the magic happens.
It is responsible for calling release on an object when it falls out of scope.
I implemented it as a enclosed class in the pool.

```c++
class ProxyType
{
	public:
	typedef std::shared_ptr<ObjectPool> Pool;

	ProxyType(Ptr&& ptr, Pool pool): ptr(std::move(ptr)), pool(pool) {}
	ProxyType(ProxyType&& rhs)=default;
	ProxyType& operator=(ProxyType&& rhs)=default;

	ProxyType(ProxyType&)=delete;

	~ProxyType()
	{
		//don't forget that moved from pointers also also destructed!!
		if(ptr.get() != nullptr)
		{
			pool->release(std::move(ptr)); 
		}
	}


	//expose pointer a la std::{shared,unique}_ptr
	Value* operator->() const 
	{
		return ptr.get(); 
	}

	Value& operator*() const 
	{
		return *ptr.get(); 
	}

	Value* get()
	{
		return ptr.get();
	}

	private:
	Ptr ptr;
	std::shared_ptr<ObjectPool> pool;
};

```

## Putting it all together

Now we simply need a class that puts all of this together.
This class uses a free list but other implementations are possible.

```c++
template <class Value,
		 template <class...> class EmptyPolicy = onEmptyLoad,
		 template <class...> class ListType = std::vector
		 >
class ObjectPool: public std::enable_shared_from_this<ObjectPool<Value,EmptyPolicy,ListType>>,
				  public EmptyPolicy<Value, ListType<std::unique_ptr<Value>>>
{
	public:
	typedef std::unique_ptr<Value> Ptr;
	typedef ListType<Ptr> List;

	ObjectPool()=default;
	ObjectPool(List&& free): EmptyPolicy<Value, List>(free.size()), free(std::move(free)) {}

	class ProxyType {...};

	template <class... Args>
	ProxyType request(Args&&... args)
	{
		Ptr back;
		if(free.empty())
		{
			this->onEmpty(free, std::forward<Args>(args)...);
			back = std::move(free.back());
			free.pop_back();
		} else {
			back = std::move(free.back());
			this->Reset(back.get(), std::forward<Args>(args)...);
			free.pop_back();
		}
		return ProxyType(std::move(back), this->shared_from_this());

	}

	void release(Ptr&& ptr)
	{
		if(ptr.get()==nullptr)
		{
			throw std::logic_error("ptr cannot be null");
		}
		free.emplace_back(std::move(ptr));
	}

	size_t getFree() const { return free.size(); }
	size_t getInUse() const { return this->getAllocated() - free.size(); }

	private:
	ListType<std::unique_ptr<Value>> free;
};
```

And that's it; a pool that auto-magically manages memory using c++14.
Happy programming!
