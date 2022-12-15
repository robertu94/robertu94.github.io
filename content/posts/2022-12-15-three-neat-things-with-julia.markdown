---
title: Three Neat Things I Did With Julia
date: "2022-12-15"
tags:
- programming
- julia
---

In the past, I've [written pretty glowingly about Julia]({{< ref
 2019-03-21-julia-could-there-be-one.markdown >}}). It's been a few years
since I first used Julia in 2019, and it hasn't completely replaced Python for
me. However, I wanted to share a few neat projects that I've done using it
which would have been much more painful without it, and share what I think now
about what I wrote in 2019.

# Implementing a Statistical Metric on the GPU

Being able to access heterogenous compute is important to be able to make the
most of the availible hardware. Doing so almost always requiring jumping to
another (often device specific) language to implmenet a mix of kenrels and
high-level reductions. While Julia doesn't allow you to completely get away
from device specific code for more than simple cases ([for
now](https://juliagpu.github.io/KernelAbstractions.jl/stable/)), it does give
you an easy way to mix high level reductions and low-level kernels to run on
the GPU.

This code computes a metric that I call the quantized entropy which highlights
each of Julia's capabilities here:

1. We can easily define a kernel -- even one that uses more advanced kernel
   features like atomics
2. Writing reductions -- even reductions that aren't provided upstream -- is
   really easy
3. Many operations (i.e. BLAS/LaPACK operations) just work and are applied on
   the GPU just by casting to a device array type.

This code is pretty concise 40 lines of code.  I implemented another metric
that uses Multi-GPU capabilies that 36 lines of code and leveraged linear
algebra capabilities of the native device libraries which is remarkably consise.

```julia
using CUDA
function quantize_kernel(cu_data, global_bins, N::Int64, dmin::Float32, abs::Float32)
  global_idx = threadIdx().x + blockDim().x * (blockIdx().x -1)
  if global_idx <= N
    bin_idx = trunc(Int32,(cu_data[global_idx] - dmin)/abs) + 1
    @inbounds CUDA.@atomic global_bins[bin_idx] += 1
  end
  return
end
function extreem(x:: Tuple{T,T}, y:: T)::Tuple{T,T} where{T}
  (min_x, max_x) = x;
  return (min(min_x, y), max(max_x, y))
end
function extreem(x:: T, y:: Tuple{T,T})::Tuple{T,T} where{T}
  (min_y, max_y) = y;
  return (min(x, min_y), max(x, max_y))
end
function extreem(x:: Tuple{T,T}, y:: Tuple{T,T})::Tuple{T,T} where{T}
  (min_x, max_x) = x;
  (min_y, max_y) = y;
  return (min(min_x, min_y), max(max_x, max_y))
end
GPUArrays.neutral_element(::typeof(extreem), T) = (floatmax(T), floatmin(T))
function cuda_qentropy(data; abs=1e-4)
  cu_data = CuArray(data);
  N = length(cu_data)
  (dmin,dmax) = reduce(extreem, cu_data; init=(floatmax(eltype(data)),floatmin(eltype(data))))
  bin_counts = round(Int64,(dmax-dmin)/abs) + 1
  bins = CUDA.zeros(Int32, bin_counts)
  n_threads=32
  n_blocks=trunc(Int,(N + n_threads+1) / n_threads)
  @cuda threads=n_threads blocks=n_blocks quantize_kernel(cu_data, bins, N, dmin, abs)
  -mapreduce(+, bins; init=0.0) do bin
    if bin != 0
      prop = convert(Float64,bin)/N;
      prop * log2(prop)
    else
      0.0
    end
  end
end
```

# Implmenting an Interactive Visualization of Slices of 3D Data.

Understanding how data is structured is much easier with interactive tools, but
depending on what structure you are looking for, there aren't always pre-built tools
that will help you understand that strucuture.  I've consistently been frustrated with
the apparent inconsistencies of tools like `matplotlib`, and I was impressed with what
I could build in just a few lines of code.

This code highlights

1. How to apply layouts and multiple figure types with ease
2. How to easily make them interactive via reactive programming.
3. How to incorperate keyboard interactivity

This is 36 lines of code creates an interactive visualization that shows both a
histogram and heatmap of slices of 3d data that can be updated with either a slider
or with keyboard commands.

```julia
using GLMakie
function vis_explorer(args::SliceExploreArguments)
    data = Array{args.type}(undef, args.dims...)
    read!(args.filename, data)
    n_slices = args.dims[end]
    min,max = extrema(data)
    fig = Figure()
    s = Slider(fig[2,1:2], range=1:1:n_slices, startvalue=round(Int,args.dims[end]/2))
    slice = lift(s.value) do v
        data[:,:, v]
    end
    slice_vec = lift(s.value) do v
        vec(data[:,:, v])
    end
    hist_title = lift(s.value) do v
        "Histogram slice $v"
    end
    img_title = lift(s.value) do v
        "SliceView slice $v"
    end
    hist_ax = Axis(fig[1,1], title=hist_title, limits=((min,max), nothing))
    hist!(hist_ax, slice_vec)
    img_ax = Axis(fig[1,2], title=img_title)
    hm = heatmap!(img_ax, slice)
    Colorbar(fig[:,end+1], hm)

    on(events(fig).keyboardbutton) do event
    if event.action == Keyboard.press || event.action == Keyboard.repeat
            if event.key == Keyboard.k
                set_close_to!(s, s.value[]+1)
            elseif event.key == Keyboard.j
                set_close_to!(s, s.value[]-1)
            end
        end
    end
    fig
end
```

# Implementing a Distributed Experiment

Writing experiments that spans several nodes is the bread and butter of writing
code in HPC. While it is possible to use libraries such as `mpi4py` or
`libdistributed` to write experiments that run on any nodes, Julia provides a
set of libraries that make this nearly effortless, and many of them are part of
the standard library.

In this code you can see:

1. A distributed for loop where communications between nodes were serialized
   and abstracted away
2. The ability to distribute libraries and data to all nodes with the
   `@everwhere` macro
3. A simple way to store complex metrics to standard formats like CSV even when
   not all experiments return the same keys

And all of this comes in a mere 36 lines of code.

```julia
using Distributed
using Base.Iterators
addprocs(6)

template = Array{Float32}(undef, 500, 500, 100)
read!(expanduser("~/git/datasets/hurricane/100x500x500/CLOUDf48.bin.f32"), template)

# broadcast libraries and data to workers
@everywhere using Pressio
@everywhere input_data = $template
@everywhere library = pressio()

configurations = collect((product(["sz", "zfp"], exp10.(range(-1, -6, length=6)))))
results = @sync @distributed vcat for (comp_id, abs) in configurations
    try
        comp = compressor(library, comp_id)
        options = Dict{String,Any}(
            "pressio:abs" => abs,
            "pressio:metric" => "size",
        )
        set_options(comp, options)
        compress(comp, input_data)
        result = get_metrics_results(comp)
        result["error"] = missing
    catch e
        result = Dict{String, Any}()
        result["error"] = e
    end
    result["comp_id"] = comp_id
    result["abs"] = abs
    [result]
end

using DataFrames, Tables, CSV
CSV.write("/tmp/results.csv", Tables.dictcolumntable(results),
          transform=((col, val) -> something(val, missing)))
```

# What Are My Thoughts Since 2019?

I largely stand by my 2019 review.  The good things about Julia are still good,
and if not have gotten better. While, I still find the matlabisms annoying, I
eventually learned enougth of them to be productive. However, the package
ecosystem has matured substantially in just 2 years with libraries especially
in the areas of language interpop, accllerated computing, and mathmatical
computing are now among best in class, but other areas still are lacking. I
even think discoverablity has improved with podcasts (although mostly on
hiatus) like Talk Julia and the Julia Bloggers and Julia Conn online pressenece
improving knowledge of what is being developed in the Julia community. However
discoverablity of what function to use could still be improved, but has gotten
better with things like LanguageServer.jl.

However, I think 3 things are still largely keeping me from using it more:

1. Reliance on specific Python or C++ libraries.  If a project is 90% relying
   on a library in some other langauge (i.e. Tensorflow/PyTorch, libfabric) it
   sometimes makes sense to just use that language.  Finding Julia based
   alternatives takes time, and isn't always worth the effort
2. Lack of knowledge among my colleagues.  A big part of my work is sharing my
   code with others, and many of my coleagues don't use Julia.
3. Although for some packages, it has gotten way better, some packages still have
   really long pre-compile times (i.e. time to first plot).

Hope this helps!
