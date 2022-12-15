---
layout: post
title:  "Qt is for more than just GUIs"
date:   2017-05-23 10:58:14 -0500
tags: 
- programming
- c++
---

When most people think of Qt, I imagine that they think about the Graphical User Interface components.
But Qt has a variety of other components beyond just being a GUI framework.
In this post, I highlight some of what I find to be the more interesting features.

## Object Communication via Signals and Slots

One of the coolest features of Qt is its very clean implementation of signals and slots.
Signals and slots are a means of communicating information (called signals) between objects via special callbacks (called slots).
For example, a class may define a signal for when its state has changed.
Other classes may then `connect()` to that signal to indicate their interest in the event.
In c++11 or later, you can also `connect()` a lambda function that will be called when the event occurs.

So what can you use this for?
The clearest example is the implementing pub-sub pattern (also known as the Observer pattern).
However unlike traditional Object Oriented observer which requires coupling between the Subject and the Observer (generally in the Subject having a list of Observers or calling a method on the Observer)
The signals and slots implementation need not have this coupling.
All that is required is that the signature of the slot accepts at least all of the connected signal.
This allows for a very robust framework of communication that makes it easy to implement a variety of different class frameworks.

## Class Meta-Data via Properties

Classes that inherit from `QObject` and use the `Q_OBJECT` macro may use also the `Q_PROPERTY` macro.
`Q_PROPERTY` provides a set of neat features over standard c++ member variables variables.

First, they are observable.
The user can define a `NOTIFY` function name that will be called whenever the value is changed.
Other classes can then `connect` to this "signal" to respond to changes in the value.

Second, they support reflection.
Qt registers each of the property values exposed in a class with the meta-object system.
This allows the user to ask the meta-object what properties are present on an object and make decisions appropriately.

Thirdly, properties can be dynamic, and additional properties can be added to a class instance at run-time.
This allows the application to add meta data about an object as needed.

Finally, they expose the value to Qt's other framework components such as the scripting system or gui framework.

## Even more features

Its hard to cover so many features in such a short post, but here are a few more features that peaked my interest.
`QtConcurrent` provides a non-c++11 implementation of parallel `std::transform`, `std::reduce`, and futures called `mapped()`, `mappedReduced()`, and `QFuture` respectively which as of the time of writing is not yet fully implemented in gnu's `libstdc++` or clang's `libc++` standard libraries.
Qt provides versions of the standard data types that are inherently serialize able allowing them to be easily marshalled out to disk or across the network.
Qt provides a robust state machine framework which can be used to implement the state pattern, and it can transition from signals to make transitions easy.
Qt also provides an event system to allow applications to listen to a variety of application inputs.

## What black magic is this?

Most these features are made possible by Qt's meta-object compiler (moc).
The Moc uses a combination of special templates, macros, and other special compiler directives that Qt uses to generate a c++ file to implement these features.
This makes it such that 1) you don't have to write quite as many trivial methods, 2) it works even on really old/bizarre compilers, 3) it takes very little source code.

Qt has a bunch of useful features beyond standard C++. Check them out, you are bound to learn something.
