---
layout: post
title:  "Learning to Learn: Reading"
date:   2018-08-08 08:00:00 -0500
tags: 
- Learning to Learn
- Reading
- Programming
---

From time to time, I get questions about how I read and retain as much information as I do.  While it is never easy -- especially with dry technical documents -- there are a few strategies that I have learned along the what that I find helpful.  In this post I provide some general suggestions along with some that are more useful in computer systems research.

# Strategies for Reading in General

My chemistry and physics teacher -- Dr. Brown -- in high school always began his classes by teaching the class a technique called P.Q.R.S.T. which I have found very helpful regardless of what genre I find myself reading. P.Q.R.S.T. stands for Pre-Read, Question, Read, Summarize, Test.

+	Pre-Read -- Scan the document quickly.  Look for key aspects such as abstracts, characters (for historical or fictional documents), topics, concepts, diagrams, formulas, figures, headings, comparisons, key sources and citations, quotations, and dates.  These often give you a mental schema on which you will associate the rest of the knowledge you are about to assimilate. For me, I try to take about 15 minutes for every 10 printed pages in a technical document.
+	Question -- Develop a list of questions that you would like answers to as you read the document.  The list of questions should be affected by the complexity of the document (more questions for denser documents), the key aspects you identified during Pre-Reading, and an appropriate set of questions the based on genre.  You should prioritize this list of questions based on what you hope to retain from the paper.
+	Read -- Read the document slowly.  Take time as you read to look for and answer the questions you developed during the last stage.  The purpose of this reading is to be able answers the questions throughly and prepare your self to summarize the material.
+	Summarize -- Summarize the document.  I find about 1 paragraph is for every 10 pages of a standard technical document to present a high level overview.  The summary should answer the most important questions you developed.  If you can't get 1 paragraph, there are three possible problems 1) the document is simply too dense and you need more text, or 2) you are not actually summarizing but paraphrasing, or 3) which is most likely you don't understand the paper well enough to summarize it, and you should read it again with some more questions based on what you learned last time.  I'll reiterate the key piece of advise I learned from his class: "be concise".
+ Test -- Test your knowledge of the document using the questions you developed.  If you can't retain the information without looking at your notes you should try again by starting at the question phase using the questions you did not retain well.  It will probably help you to go through the summarize and reading phases again so as to rehearse the information in your mind.

> 

+ try applying PQRST to a paper or book that you need to read.  How did the questions you asked help in your understanding?
{.activity}

# Strategies for Reading Source Code

Not all systems are well documented.  For example the Linux kernel has over 400,000 lines of Documentation which seems like a lot until you consider that it has 22,802,098 of C source files and headers as of 4.18-rc6.  This means that if you want to understand them you will need to do some digging.  Reading the source code can also give you insight at a level of detail that the documentation does not.  But how do you get started with a project that large?  Here are a few suggestions:

1.	Start with `main()` --  most user level applications have some concept of an entry point which start execution.  This is a bit more tricky in the kernel (which doesn't have a `main()`) or systems like `systemd` which have a lot of them. In the case of programs without a main, you can look for methods that are called some variant of "start", "init", or are decorated/marked as a constructor.  Additionally for kernels, there is often a custom linker script which specifies the entry section.  You can simply look for the method that decorated with that attribute.  In the case of systemd you can use documentation to help determine which ones are salient to your use case.
2. Read the tests -- most large computer systems have automated tests.  By design these are often easy to digest, currently working sections of code.  Therefore you can use them to better understand the functional aspects of the code.
3. Look for usages of a type or function in the code itself.  Aspects of how to use a type or a family of functions can often be found in other places throughout the code base.  You can use tools like cscope, ctags, or an IDE to provide some of this functionality.
4. Look for each access to a given variable.  This information should give you insight into the invariants that code expects.
5. Build an interaction diagram.  Look for which functions call other functions and in what contexts.  Having a clear picture of what functions call which other functions can give insight into the layers in the architecture or suggest what other aspects of the system to study next if necessary.
6. Use tools like ltrace, strace, xray, or perf to gather information about the runtime call usage.  This can provide insight into what the system does under live conditions.
7. Use a debugger. When you are curious about a specific use case of a system, you can use a debugger to see what values are set or where they are changed through the use of breakpoints and watchpoints; However this comes with a performance cost, and is notoriously difficult to do on distributed systems.

+ use the techniques in this section to summarize some source code for a project that you use, but are not familiar with.  What did you learn?
{.activity}

# Strategies for Reading Journals and Conference Papers

Reading Conference or Journals papers isn't much different than reading generally technical papers.
You can and should apply P.Q.R.S.T. to help cut them down to digestible portions.
However, there are a few things about the format of a well-written journals article or academic paper that makes them easier to process if you use them.

1.	Abstracts -- abstracts are designed to be short summaries of the key findings of the paper.  Read these very carefully as you Pre-Read because they can often provide useful hints for what questions you should be thinking about in the context of the paper.
2.	Citations -- academic work seldom appears in a vacuum.  A good paper will cite a mixture of old and new academic papers as well as other technical resources, tools, and datasets that compare, contrast, and support their research.  Once you have found a related paper, you can follow the citations in the paper to find other papers that are relevant or look at other papers by the sames authors.  This can help you better understand the context of the work before you.  Also pay attention to what authors cite as novel versus call out as their own contributions or general knowledge.
3.	Related Work -- Often papers will have a related work section that provides compares and contrasts a paper to others in the same field.  These comparisons and contrasts can help you better ascertain the exact contributions of the paper.
4.	Methodology --  Often papers will have a short section at the beginning of the methodology section that is much more down to earth than the often flowery and exaggerated language in the introduction and abstract.  Look in this section for what the authors actually did versus what they claimed they did.  High quality papers do exactly what they claim they did or more.
5.	Limitations -- a high-quality academic paper will engage seriously with the problems and limitations of their approach.  Read these carefully to help contextualize the work relative to other work in the same field.

Academic papers are often peer-reviewed.  It is also often helpful to think like a reviewer as reading papers:

1.	How interesting are these results to others in my field and why?
2.	How technically sound are these results?  Are their logical structure and statistical evidence of their results valid?
3.	How well presented is this paper? Is it clear, concise, make effective use of figures, tables, sectioning, titles, abstracts, and keywords?
4.	Are the reference sufficient and appropriate?  Is there some topic that they are missing? Do they have new and old papers?  How many of the citations are peer reviewed?
5.	How well organized is the paper?  Why did the authors organize the paper the way that they did, and does that reduce forward references and  duplication while presenting the information in a logically ordered manner that flows well?
6.	How confident am I about my ratings?  If you can't answer these questions confidently, you should probably read some more of the cited work in the paper so that you have a better understanding of norms and conventions in the field they are studying.  It may also be helpful to do a Google Scholar search for key concepts in the paper.

+ Identify 3 key citations and read papers that cite or are cited by the paper you read.  How does this work compare to similar papers?
{.activity}

Hope this helps!
