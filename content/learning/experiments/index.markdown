---
layout: post
title:  "Suggestions for the Design of Computational Experiments"
date:   2022-10-18 08:00:00 -0500
tags: 
- Learning to Learn
- HPC
- Experiments
---


So you want to do empirical computer science? Doing good science is difficult. It requires discipline and attention to detail. However there are strategies that can help you focus on answering the questions you can attempt to answer. First you should ask, “is this a scientific question?” Not all questions are scientific questions. Questions about aesthetics, values, ethics are not science questions. “Is A better than B?” is not a scientific question, it’s a question of values. Questions of values require trade offs, and while important can’t be solved with the scientific method of stating assumptions, posing questions, designing experiments, collecting data, and interpreting results.  “Can method A achieve more flops than method B in a given specific context?” Is more of a scientific question. 

Another of the most important questions to ask is, “What are you trying to measure and what could it tell you?”. The latter part about what it could tell you is essential because it helps protect you from spurious conclusions that were not central when designing your system. Answering this pair of questions will often require you to clearly specify a model of your system and understand or at least have an educated guess about how your system works. Once you have answered that question (at least for now; you’ll often have to revise it with new data), my hope is that this document can give you some pointers on how to most efficiently and confidently answer your question.

# Systems Modeling

The process of science begins with a hypothesis — a testable statement about the state or behavior of a system. Constructing a rigorous hypothesis requires a description of your system under test. The description is almost certain underdetermative of the total behavior of a system. It has been said that a model that is just as complex as the real system is just the real system. By design, models omit aspects of the systems they describe because these simplifications allow us to reason about the underlying behaviors we actually care about.

The process of creating these models is called systems modeling. While targeted, accurate, and concise systems modeling is challenging often relying on experience and expertise of the modeler or scientist constructing the model, there are a few principles that can be helpful:

Start with a broad model that is not refined. Done appropriately you may be surprised about how accurate it is. 
You can always refine a broad model into a more accurate one by decomposing its parts into a more accurate model.
Focus on the interfaces, inputs and outputs. These are the trickiest to get right, but also can give you the most leverage to tweak the behavior of your model.

A rigorous model can often be phrased as a set of logical syllogisms. For example:

1. Larger cache sizes have fewer evictions when executing code
2. The more evictions there are, the slower the system will be on application 1
3. System A has a larger cache than System B
4. Therefore System A will be faster than system B on Application 1

Readers familiar with caching know that is a pretty reductive model. You’ll probably need to account for factors like clock speed, algorithm, and eviction policy to get the accuracy you’re looking for on new applications of your model, but you could certainly start here and account for these differences later as you need them. As you make these changes, you’ll adjust the premises of your model to reflect the system and what you learn about it. 

# Statistical Primer

One of the most common mistakes I see in empirical computer science is to ignore the statistical principles when designing the experiments. Statistical principles can help you avoid drawing incorrect conclusions due to measurement or random error in your system. 

There are a few key principles to keep in mind:

### Consider the 3Rs

randomness, replication, and reduction of noise. When designing experiments as much as is practicable you should repeat the experiments, reduce the effects of non-studied factors, and randomize what you can’t control.

### Consider your assumptions and consequences of violation

Every statistical method has assumptions and consequences of violation. The most common consequence is so called “liberal inference” which means that your experiment could give misleading results. Careful attention to assumptions can protect you from false conclusions.

### Know the basis of Statistical Inference

Statistical Inference is the process of inferring the probability of the truth of some claim based on the results of some experiment. These methods can be either parametric and non-parametric. Parametric methods make assumptions about the distribution of the values of your observations. Non-parametric make fewer or weaker assumptions. One of the benefits of parametric methods is that they offer stronger evidence of a claim (I.e. require fewer replicas to draw a conclusion) than non parametric methods. The benefit of non parametric methods is that they make fewer assumptions and can be used validly in more cases.

### Know some basics of Experimental Designs

There are several common designs including factorial, Latin squares/hyper cubes.  When the experimental design space becomes large, tools such as orthogonal arrays can reduce the testing space. These methods can help provide structure that can help you avoid violating certain assumptions and keep the cost of your experiments down.

### Choose an appropriate Sample size

Statistical Inference offers a trade off between the rate of false positives and the sample size. Tests that require smaller sample sizes are called more powerful but often require more strict assumptions.

There is a lot more to statistics than what I can cover here. It’s worth reading a book or two on statistics methods. One such book is “A first course in design and analysis of experiments” by Gary W. Oehlert.


# Separating Concerns

There generally are three concerns when conducting a computer science experiment:

1. Running the experiment
2. Parsing the results into a machine readable form
3. Taking the results and running analysis
   
I would advise writing a single script for each of these. That way you can easily run each part of the process independently if needed.

## Running experiments
When writing scripts and programs to run your experiments there are a number of tricks that can enable more productive code.

*Write scalable code*. Most experimental codes can be formulated as the execution of a “do\_experiment” function that takes a configuration as an argument which can then be constructed using the Cartesian product of a set of factors.

```python
from itertools import product


def do_experiment(args):
     # run experiment
     return ex_results

Approaches = [1,2,3]
Replicates = 5
Results = []
for _, approach in product(range(replicates), approaches):
    Results.append(do_experiment(approach))
```


Code like this can be easily parallelize and distributed using something like a MPI4Py MPICommExecutor (python) or libdistributed work queue (c++).  The C++ equivalent of product is `std::views::cartesian_product` or range-v3’s `cartesian_product`.



### Know how to accurately measure things

Measuring fine grained timing can be a nuanced process. First, for sub-millisecond timings, the clock resolution can matter. Second, not all clocks are monotonic. Third, some clocks have high measurement overhead for the first three cases in c++ you generally want the `std::chrono::steady_clock` in Python the equivalent is `time.perf_counter_ns` . Fourth, your compiler may optimize away your benchmark unless you force it to keep it (Google Benchmark has a function called `benchmark::DoNotOptimize`) which generally does the right thing). Fifth, other processes may interfere with your measurement (especially print statements) so avoid doing expensive operations during your benchmark timings. Lastly not all clocks can measure all processes, for example the C++ clock functions cannot measure the timing of Cuda operations accurately because they cannot observe device state.

### Know your scheduler
A common mistake that I see new students make is to run all jobs interactively, and not make use of the scheduler to run their job. Additionally your scheduler can do many things for you such as email you when your job finishes, start one job after a previous job finishes, handle process pinning and resource allocation and more. Its worth reading what it is capable of.

### Know a higher level programming language

Systems programming languages like C,C++ and Rust are remarkably powerful and useful tools for writing benchmarks and experiments. However not all parts of the experimental process need this level of performance. For example plotting and data scraping tasks often aren’t as well suited to lower level languages and require large volumes of code for simple tasks. Likewise only recently has C++ gained higher level abstraction for Cartesian iteration. Prefer a higher level language for these tasks when possible.

### Understand sources of variability and control them if possible

 Computer systems have many sources of variability. This could be clock variability, interference variability, seed variability, or process variability. Many, but not all of these sources of variability can be mitigated with appropriate steps. Attempt to control this variability if it is practical to do so.

### Output as much context as possible

Especially with long running tasks having appropriate debugging information is key to reduce the number of run, interpret, modify cycles to a minimum. In doing so, remember what the system can record for you such as core dumps when the system crashes. Some context to specifically record include timestamps, task ids (if they are deterministic), complete error messages, error status, and progress indicators.

### Know a distributed programming framework

For many problems running code on a single node isn’t enough. You want to be able to run experiments over several nodes collaboratively. While it is possible to do this with TCP/IP, it isn’t often the best way. In HPC the tool of choice is often MPI which provides both tools that are easy to start with and provides room to grow. However, other choices include RPC systems such as Mochi and GRPC.

### Make the testing environment reproducible (spack, docker, etc…)

 Reproducibility is a crisis in science; do not contribute to this crisis.  Tools from industry like containers can make that much easier.  Docker/Podman is my favorite, and is reasonably easy to use.  Generally these tools boil down to writing a specialized script that reproduces your environment exactly which can then be shipped to users in the form of a compressed archive.  Sometimes (especially when specialized hardware is involved) this is easier said than done.  You might need a different version of software depending on your hardware platform.  Spack is a powerful package manager that can help you solve some of these more complicated dependencies, but warrants its own post.  Together these tools give you a powerful platform to run experiments easily on diverse machines.  Tools like singularity let you run containers on HPC systems.

### Prefer parseable output, but sometimes you can’t

 See the next section on writing parsable outputs.  However, because many HPC libraries write to stdout/stderr, you can’t assume that you will have these to yourself. MPI implementations can be especially loud (for good reason) when they don’t believe that they are configured correctly.

### Validate on small cases first if possible

 Waiting on the scheduler to run your job can be painful.  If possible, have some small subset that you can verify works “correctly” before jumping to a supercomputer where your runtime environment becomes more complex and queuing times slow your ability to iterate on your experiments. Many supercomputers also charge for every execution and the costs can add up quickly. 

### Write the code to do partial writes, and resume-able in case the code crashes

There are few things more frustrating than for code to run for a few hours, crash (or timeout), and not have any results to show for it. It is often preferable to write results incrementally as your experiment is running than waiting until the end. This also often lets you use a pattern known as checkpoint restart where you resume execution at the state after your last failed/incomplete run. This makes it far easier to restart your job later to finish what’s left rather than start over from scratch. This is often as easy as partitioning the output into non overlapping regions or ids and writing the output. If this can’t be done a master process can be delegated to store the output

### Write the code to handle error conditions as gracefully as possible

Likewise thinking about the error propagation boundaries for your code. In the pseudo code above placing a mandatory error propagation boundary just outside calls  do_experiment will do what you want: isolate a fault from one experiment from another experiment allowing as many experiments to continue as possible without a crash in one experiment affecting other experiments. This can be tricky. Things like MPI have the  default behavior of terminating the world on a signal. Other things like HDF5 with many blocking function calls might not catch that other threads of execution finished in a error state and will block indefinitely. This long tail of failures to tolerate can be constructed incrementally as you encounter them.

As an aside: sigsegv or its cousins sigfpe and sigbus are often implemented as catch-able signal but the mechanisms for recovering from it in standard C/C++ fully and correctly are limited or non-existent. Even if you think you can recover correctly from these signals don’t; you probably shouldn’t and should let the entire C runtime restart instead. What is easier and arguably better is to use another program (ie bash/python scripts) to handle this particular fault boundary. 


Here is an example that tries to implement as much of this as possible:

```python
#!/usr/bin/env python
from mpi4py.futures import MPICommExecutor, as_completed
from itertools import product
from csv import DictWriter, DictReader
from time import perf_counter_ns


def do_experiment(args):
    starttime = perf_counter_ns()
    replicate, approach = args
    if replicate == 3:
        # example error
        raise RuntimeError("bad error happened here!")

    # do the actual experiment here, then put results in a dict
    # including a starttime and endtime can really help you debug things
    ex_results = {
        "result1": replicate * 2,
        "result2": replicate,
        "starttime": starttime,
        "endtime": perf_counter_ns()
    }
    return ex_results


FIELDS = ["approach", "replicate", "starttime", "endtime", "result1", "result2", "err"]
approaches = [1, 2, 3]
replicates = 5
futures = []
in_checkpoint = set()
tasks = list(product(range(replicates), approaches))
fut_to_task = {}

with MPICommExecutor() as pool:
    # only the root mpi rank enters this if-statement
    # the other processes will be workers
    if pool is not None:
        # check our results file to skip all results that are already successful
        try:
            with open("output_file.csv") as checkpoint_file:
                reader = DictReader(checkpoint_file, FIELDS)
                for row in reader:
                    if row['err'] == "":
                        in_checkpoint.add((int(row['replicate']), int(row['approach'])))
            exists = True
        except FileNotFoundError:
            exists = False
            pass

        # start all of the tasks we care about
        for task in tasks:
            if task not in in_checkpoint:
                fut = pool.submit(do_experiment, task)
                futures.append(fut)
                fut_to_task[fut] = task

        # write results as we find them
        with open("output_file.csv", "a" if exists else "w") as outfile:
            writer = DictWriter(outfile, FIELDS)
            if not exists:
                writer.writeheader()
            for fut in as_completed(futures):
                try:
                    result = fut.result()
                    task = fut_to_task[fut]
                    print("task ", task, "completed successfully")
                    result["err"] = ""
                    result["replicate"] = task[0]
                    result["approach"] = task[1]
                    writer.writerow(result)
                except Exception as ex:
                    result = {}
                    task = fut_to_task[fut]
                    print("task ", task, "failed")
                    result["err"] = str(ex)
                    result["replicate"] = task[0]
                    result["approach"] = task[1]
                    writer.writerow(result)
```

## Writing parsing code

### When parsing the results of experiments it is often helpful to do so in ways that are machine parse-able

While you almost certainly could write a domain specific language that often isn’t the best use of your time or resources. Sticking to a few well established formats can tremendously simplify the task ahead of you.

+ **CSV** is ubiquitous and easy to generate. For this reason it is usually the first thing I reach for as long as the data isn’t hierarchical or non-scalar in nature. 
+ **JSON** is usually the next step that I reach for when I need simple arrays or basic hierarchies represented in my output. There are decent JSON parsing libraries in nearly every language which makes it easy to work with. 
+ **Google’s protobuf** is also not a bad option when JSON parsing speed is a limitation and you have a stable schema. While not as common in HPC it does a decent job of representing complex scalars and moderate hierarchies in ways that can be checked against a schema for validity. 
+ **HDF5** as a structured, scalable data container. If you need to store large tensors (higher dimensional matrices) of data with hierarchical relationships, it is one of the few games in town. It also tends to have decent support in a variety of languages.
+ **SQLite** can be another highly portable output format when your data is highly relational. It is also supported on nearly every platform under the sun. 
+ **Binary files** - writing a binary flat file is a possibility when the data format is relatively simple (ie a single large array), and nearly all languages support this. However it is seldom the best format because it doesn’t communicate some subtleties like endianness and and dimensionality that formats like HDF5 provide in addition to features like compression or attributes. 
+ **Free-Form Text** can be parsed with regular expressions as tool of last resort for getting data out of your experiments. However needing a regular expression is often a suggestion that your output would benefit from greater structure and/or isolation. There are great websites that can help you rapidly prototype and validate your regular expressions for a variety of regular expression dialects. 

### When using tabular outputs like CSV use one row per experiment, one column per field

This makes it much easier to do joins and parsing of your experimental results to other tables of data much easier. If possible avoid literal new line characters or field delimitors in fields (especially error message fields) instead either 1 know how to escape them or replace them with characters without special interpretations. 

### When using tabular data include a column for errors or execution irregularities

Experimental errors happen. Having a way built in to both filter in/out and summarize these kinds or errors can save you a lot of time trying to interpret your results and issues encountered during your experiments. 

### Parsing code often doesn’t benefit as much from parallelism so don’t worry about this upfront

Serial execution is a good enough place to start. An exception to this is where your data is a large tensor in which case parallel HDF5 is your friend for scalable IO performance. 


Since the previous example used csv and wrote to a dedicated file, we don't even have to write the parsing code, we can just use `pandas.read_csv`

## Writing plotting/analysis code

### Choose a language which has mature tools for this.

less you are doing sophisticated 3D graphics where libraries like VTK or OpenGL or Vulcan are required, you can accomplish a lot more a lot faster with libraries in Python (Seaborn/Matplotlib) or Julia (Makie/ Plots.jl). C++ is not the best tool for every job.

### Separate plotting/analysis from parsing parsing the log files

 Often one of these tasks will take much longer than you’d expect. By separating these tasks, you can work with the clean data more iteration and quickly drill in on a plot that does what you want. 

### Prefer vector graphics for 2D plots

Vector graphics automatically scale to arbitrary resolution because they are described as a series of equations rather than a “map” of colors. In many plotting libraries this is as simple as choosing an eps or svg format output. 


A simple script that plots the runtime for each might look like this:

```python
import pandas as pd
import seaborn as sns
df = pd.read_csv("output_file.csv")
df['runtime'] = df['endtime'] - df['starttime']


# understand what kinds of errors occured
errs = df[df.err.notnull()]
print(errs.err.value_counts())

# filter out results with errors
success = df[df.err.isna()]

# plot the timings
sns.set(rc={"figure.figsize": (10, 7.5)})
sns.set_theme(context="talk", style="whitegrid")
fig = sns.barplot(x="approach", y="runtime", data=success)
fig.get_figure().savefig("runtime.eps")
```

+ Which of the principles in this chapter should you focus on improving in your experimental design?  Which do you do well with?
{.activity}


# Changelog

+ 2022-10-18 -- initial version
