---
title: "C++ Templates: Starring into the Abyss"
layout: presentation
location: Clemson ACM Technology Seminar
date: 2017-08-01
description: >
  C++ templates are one of the most powerful, and probably least understood aspects of C++ programming. Trying to understand error messages from templates code can feel like staring into the abyss. In this talk, I introduce many of the various features and dive into applications of C++ templates that are used in the wild. I will cover several of the common pitfalls and design patterns that result from this feature of C++. I will also stare right into the heart of the abyss and explain why the error messages can be cryptic, why its a good thing, and how to begin to decipher those error messages. 
...
<section id="c-templates" class="title-slide slide level1">
<h1>C++ Templates</h1>
<p>Staring into the abyss</p>
<p>Robert Underwood</p>
</section>

<section id="overview" class="title-slide slide level1">
<h1>Overview</h1>
<ol type="1">
<li>Why templates?</li>
<li>Basics
<ol type="1">
<li>Template Methods</li>
<li>Templates with Polymorphism</li>
<li>Classes vs Functions</li>
</ol></li>
<li>Applications
<ol type="1">
<li>Trait Specialization and Policies</li>
<li>Template Meta-programming</li>
<li>Tuples</li>
<li>Functors</li>
<li>Other Uses</li>
</ol></li>
</ol>
</section>

<section id="warning" class="title-slide slide level1">
<h1>Warning</h1>
<p>Here be dragons!</p>
</section>

<section id="why-templates" class="title-slide slide level1">
<h1>Why templates?</h1>
<ul>
<li>Generics – code that accepts any type</li>
<li>Performance – type specific implementation</li>
<li>Code Reuse – let the compile do the writing</li>
</ul>
</section>

<section>
<section id="basics" class="title-slide slide level1">
<h1>Basics</h1>

</section>
<section id="what-are-they" class="slide level2">
<h2>What are they?</h2>
<ul>
<li>Allows you to:
<ul>
<li>delay binding of type to variables</li>
<li>write generic code of some type T</li>
<li>trades code size for binary size (and readability?)</li>
</ul></li>
</ul>
</section>
<section id="template-methods" class="slide level2">
<h2>Template Methods</h2>
<ul>
<li>Will deduce but not coerce types</li>
<li>They can be overloaded</li>
</ul>
</section>
<section id="classes-vs-functions" class="slide level2">
<h2>Classes vs Functions</h2>
<ul>
<li>Functions have type deduction</li>
<li>Classes/Structs have partial specialization</li>
<li>At least for now…</li>
</ul>
</section>
<section id="templates-with-polymorphism" class="slide level2">
<h2>Templates with Polymorphism</h2>
<ul>
<li>If possible,
<ul>
<li>Put only template methods in a template class</li>
<li>Each expansion takes space in the binary</li>
<li>Each expansion increases compile time</li>
</ul></li>
</ul>
</section>
<section id="variadic-templates" class="slide level2">
<h2>Variadic Templates</h2>
<ul>
<li>Templates of many arguments</li>
<li>Use overloading to handle recursion</li>
</ul>
</section>
<section id="sfinae" class="slide level2">
<h2>SFINAE</h2>
<blockquote>
<p>Substitution Failure is not an Error</p>
</blockquote>
<ul>
<li>A blessing and a curse
<ul>
<li>Almost incomprehensible error messages</li>
<li>Allows overloading and “compile-time reflection”
<ul>
<li>Reflection – change behavior on class attribute/methods</li>
</ul></li>
</ul></li>
</ul>
</section></section>
<section>
<section id="applications" class="title-slide slide level1">
<h1>Applications</h1>

</section>
<section id="trait-specialization-and-policies" class="slide level2">
<h2>Trait Specialization and Policies</h2>
<ul>
<li>Select an algorithm/behavior through:
<ul>
<li>reflection on types</li>
<li>template arguments</li>
</ul></li>
<li>Implementations vary
<ul>
<li>SFINAE-based – more flexible, harder to implement</li>
<li>Specialization-base – less flexible, almost trivial</li>
</ul></li>
</ul>
</section>
<section id="template-meta-programming" class="slide level2">
<h2>Template Meta-programming</h2>
<ul>
<li>Solve a recursive problem at compile time</li>
<li>often inline, beware template recursion depth</li>
</ul>
</section>
<section id="tuples" class="slide level2">
<h2>Tuples</h2>
<ul>
<li>collections of types</li>
<li>very similar to a struct</li>
<li>can be expanded and passed as function arguments</li>
<li>can be used to extract variables via <code>std::tie</code></li>
</ul>
</section>
<section id="functors" class="slide level2">
<h2>Functors</h2>
<ul>
<li>Accept a function as argument</li>
<li>Write functional paradigm code
<ul>
<li>Easier to parallelize</li>
<li>Easier to reason about</li>
</ul></li>
</ul>
</section>
<section id="other-uses" class="slide level2">
<h2>Other Uses</h2>
<ul>
<li>Smart Pointers</li>
<li>Iterator Generics</li>
<li>Curiously Recurring Template Pattern</li>
<li>Parameterized Type Attributes</li>
<li>Generic implementations of Design Patterns</li>
</ul>
</section></section>
<section id="further-reading" class="title-slide slide level1">
<h1>Further Reading</h1>
<ul>
<li>Many of concepts are found
<ul>
<li>C++ Templates: The Complete Guide</li>
<li>Modern C++ Design</li>
</ul></li>
</ul>
</section>

<section id="questions" class="title-slide slide level1">
<h1>Questions</h1>
<p>Send us feedback at <a href="mailto:rr.underwood94@gmail.com" class="email">rr.underwood94@gmail.com</a>!</p>
<p>This material available under <a href="http://creativecommons.org/licenses/by-sa/4.0/">CC By-SA 4.0</a></p>
</section>
