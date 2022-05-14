### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# ╔═╡ 044c0c96-d355-11ec-25de-37d5f5e9e12c
md"""
# Julia intro for Pythonistas

Julia is a relatively young language.
Its initial release was in 2012, and its first stable release (version 1.0) was in 2018.
In comparison, Python was first released in 1991.

Julia was created at MIT in USA because of the "sorry state of scientific programming" in the early 2010s.
The authors sought to address several fundamental issues in existing languages that hindered their use in science and engineering; in paricular issues in the static languages C and C++, and the dynamic languages Python, Perl, Ruby, Matlab and R.

In this notebook, I highlight some important consequences of the design differences between Python and Julia.
The two languages have way too many differences for the notebook to show examples of them all.
The relative strengths and weaknesses that will be highlighted is:

* Weakness: The slow and laggy start-up latency of Julia
* Strength: The speed of Julia code
* Strength: Ease of reproducibility and installation of Julia code
* Strength: Type system
* Strength: Multiprocessing
"""

# ╔═╡ 683d19e4-adc0-4173-bf3c-ddf2048b34aa
md"""
## Weakness: Latency

You've already noticed the latency - it's hard to miss.
Unlike interpreted languages like Python, R and Perl, Julia is _compiled_.
Yet, it is also completely _dynamic and interactive_. How is this possible?

Similar to the Python package Numba, Julia is Just In Time (JIT) compiled.
This means that when you execute a Julia function, the compiler will first compile the function into RAM, then execute the compiled function.

The compiled functions can be freely and dynamically overwritten, shadowed or extended, in which case the compiler will detect the changes, and re-compile the code before it is run the next time.

This way of working means that when starting up, Julia is laggy and unresponsive while it is compiling your code. When you start it up, it needs to first compile the Julia code used by your code editor, by the Julia REPL itself, or in the case for this notebook, the code used by the Pluto notebook system and all its dependencies. This causes latency of many seconds.
"""

# ╔═╡ 458562b3-083b-48fe-89dc-f956dbb486fe
md"""
#### Exercise: Measure latency
For this, we'll use the terminal.
Open your terminal and navigate to the directory of this exercise.

Open and inspect the file `latency_test_1.jl`.
Note the syntax is quite similar to Python, though with some minor differences:
* In Python, modules are defined by the files they are in. In Julia, modules are explcitly created with the `module` keyword, allowing modules accross multiple files, or multiple modules in one file.
* `using MyPackage` in Julia is similar to `from MyPackage import *` in Python
* `print` in Julia does not add a newline automatically like in Python, but `println` does, so that is used instead.
* The curly brackets `{ }` in e.g. `LongRNA{2}` designates _type parameters_ of generic types (where Python uses square brackets `[ ]`). Don't worry about it for now.

Try to guess what the program will do from reading it.

Then execute it from command line with the shell command:

```bash
$ time julia --project=. latency_test_1.jl
```

Note how long it takes - around 0.8 seconds on my computer - possibly longer if this is the very first time you launch Julia. Nearly 100% of this time is spent compiling the various functions from `FASTX` and `BioSequences` used.

It can get much worse. The standard plotting package `Plots` is huge compared the `FASTX` and `BioSequences`, and is infamous for its long compile times.

Do the same for the file `latency_test_2.jl`: Open and look at it, predict what it will create, then run it from command line:

```bash
$ time julia --project=. latency_test_2.jl
```

... yeah.

The good news is that as long as the Julia process remains alive, the compiled code remains in RAM. This means that if you run the code multiple times, it only needs to compile the _first_ time. Let's try that:

From the same directory, open an interactive Julia REPL:

```bash
$ julia
```

Now load in the code from the file:

```julia-repl
julia> include("latency_test_2.jl")
```

You see the same ~10 second delay again. BUT, now try to rerun the code and time it from the REPL:

```julia-repl
julia> @time LatencyTest2.create_plots(randn(1_000_000))
```

Do this a few times. It should be about 100x faster than the first time.

Keeping the REPL open, try modifying the file, e.g. by plotting something else. Then reload the file from the REPL with `include("latency_test_2.jl")`, and re-time running the function. What you will see is that only a small bit of the code needs to be recompiled, since most of the underlying plotting code is already compiled. As a result, there should be little latency.
"""

# ╔═╡ 1f7ced75-cee2-42a6-82f1-4e870e65b423
md"""
## Strength: Speed
This is probably the major advantage of Julia over Python.

Whenever you are running Python code, you are actually running much more C code than Python code. Not only are the core computational code of e.g. Numpy and PyTorch written in C, all of Python are also written in C for speed reasons. In contrast, most of Julia is written in Julia.

Julia is around 100-1000 times faster than Python, and around 1-1.5 times slower than C. Hence the speed advantage over Python depends on how much of the "Python" computation that happens inside C code.
"""

# ╔═╡ a71fc3ae-469f-4059-b2fc-06c200463a86
md"""
#### Exercise: Kmer counting performance

The two files `kmers.jl` and `kmers.py` do the same thing in Julia and Python, respectively. Read one (or both) of the files and figure out what they do.

Time Julia the following ways:
* From command line (including startup latency): `time julia --project=. kmers.jl`
* From REPL (discarding latency): `julia> include("kmers.jl")`, then `julia> @time Kmers.count_matrix(Kmers.data, Kmers.matrix);`

Time Python, e.g. from command line or using `iPython`.

* How many times faster is Julia than Python for this task when including or discounting startup latency, respectively?
"""

# ╔═╡ d1d99486-0273-4b5e-a79e-2141f63397d8
md"""
#### Exercise: Learn from source code

Both Python and Julia's base library include hash sets, called `set` in Python and `Set` in Julia. For this exercise, let's learn how a hash set is implemented in the two languages by reading the source code.

__Julia__

For Julia, you can obtain the source file name and line number where a function is defined, by using the `@which` macro in front of a function call:
```julia-repl
julia> @which Set(1)
Set(itr) in Base at set.jl:23
```

Alternatively, you can use the similar macros `@edit` or `@less` to use an editor or pager, respectively, to open up the source file, then you can look around the file to find what you're looking for.

Julia data types (structs) are defined with the keyword `struct`, i.e. a type `Foo` is defined with:

```julia
struct Foo
	# some content here
end
```

* Use `@edit` or `@less` to find the definition `struct Set` in Julia. What is "inside" the struct definition? What does this tell you about how a `Set` is implemented?

__Python__

The Python `set` is defined in this file: https://github.com/python/cpython/blob/main/Objects/setobject.c

Because Python is too slow to implement any performance-sensitive algorithm or data structure in pure Python, this is written entirely in C. Good luck.
"""

# ╔═╡ bc2918d9-b67e-48da-8220-d7cd24abb334
md"""
## Strength: Reproducibility and packages
Python is from the 90's, in a simpler time before everyone had high-speed Internet.
For this reason, downloading, uploading and installing third-party packages was added of an afterthought, and not built into the language. As a consequence, there are _many_ different package and environment managers like Conda, pip, pipenv, pyenv, poetry, PyPM and virtualenv.

Julia is from the 2010's, where package management is seen as a basic property of a programming language. Hence, it comes with a package manager, which
* Is ubiquitously used for all Julia software making installation easy
* Consistently uses _semantic versioning_ for easy dependency management.
* Has built-in enviroments
* Has support for locally stored or company-internal package management.
"""

# ╔═╡ e0a41812-064f-45a4-b681-bfd287cde692
md"""
#### Exercise: Create new Julia project
This shows how to create a new project (i.e. environment) that enables full reproducibility.

* Open a new Julia REPL. Hit the square bracket close (`]`) key to enter _package management mode_, and type "`generate MyProject`", then hit enter.

A new directory called `MyProject` is now created.

* While still in the Julia REPL, type semicolon (`;`) to enter the built-in _shell mode_, then navigate to the new directory "`shell> cd MyProject`".

* Activate the new project by entering _package mode_ (backspace to go back to Julia mode, then hit `]`), then type "`activate .`" - notice the dot for "the project in this directory".

* Add some dependencies to your project to typing in `add BioSequences, BioSymbols` in package mode.

Exit Julia and explore the files in the directory `MyProject`. It should have the following structure:
```
.
├── Manifest.toml
├── Project.toml
└── src
   └── MyProject.jl
```

First look at `src/MyProject.jl`. This is just a template for the source code.

__Project.toml__

Then look at `Project.toml`. This file contains all relevant metadata for the package. It should contain:
* The project name
* Project UUID - this is the identifier of the project so you can have multiple, different projects with the same name without issues
* Project author (I think this is retrieved from `git`)
* Project version
* A section with dependencies - their name and UUID.

More information like version compatibility, test-specific dependencies etc can be put in the Project.toml file,, but let's leave it on the table for now.

__Manifest.toml__

Skim the `Manifest.toml` file. This file is automatically generated by the package manager. It contains the fully-specified and resolved package with all transitive dependencies. This file can be used to automatically _exactly_ reconstruct a specific environment e.g. for scientific reproducibility.

__Play around__

In package mode, type `help` and look at the options. Try playing around with the package manager in your new environment.
"""

# ╔═╡ 4f90b4b6-6f45-4c84-89c5-ef89ae548c33
md"""
## Strength: Type system

A _type_ is an abstract concept that programmers use to distinguish different kinds of data. For example, the difference in Python between a string and an integer is that the string has the type `str` and the integer has type `int`.

Python used to not really have a _type system_, i.e. a systematic and rigorous way of talking about different types and how they relate. However, after 10+ years of criticism, [a type system was introduced](https://docs.python.org/3/library/typing.html) in 2015 (Python 3.5), which is still being expanded and rolled out slowly in current Python releases.

The Python type system is awesome and a great improvement of the language. However, since the Python interpreter _itself_ has no concept of a type system, the system is artificially bolted on as a separate package, not integrated into the interpreter. For example, you can easily write code that violates the type system, and the interpreter wouldn't have a clue.

In contrast, Julia's compiler uses the type system heavily, so it is an integrated and natural part of the language.

Type systems (both Python's and Julia's) are inherently complex and heavy with technical terms and jargon. Instead of going into a deep dive which would be a 2 week course, let me show some concrete examples of the Julia type system in use:
"""

# ╔═╡ a43340c8-087f-4220-8bc7-b9fc229909bd
md"""
#### Exercise: Multiple dispatch

_Dispatch_ refers to the ability to have multiple definitions of the same function that applies to different types. I.e. in Python `a + b` means different things depending on if `a` is a `list`, a `str`, a `float` or an `int`.

Different versions of functions are called `methods`. In Python, dispatch is (nearly) always controlled by the _first_ argument to a function call (i.e. _single dispatch_), and works via _dunder methods_, that is, methods that begin and end with double underscore, like `__add__`, `__mul__` or `__hash__`. In my **entirely** unbiased opinion, It's a mess.

In Julia, _multiple dispatch_ allows you to write multiple functions for different types.

For example, suppose we want to, for some object `X`, have the ability to create a _default object_ of the same type - but we don't know beforehand for what types we might need to do this. This is extremely awkward (perhaps even impossible?) in Python due to how its dispatch works. However, in Julia, we can easily define 4 methods for the same function
"""

# ╔═╡ 2c58bddd-adf6-42fa-a141-9b7a735b4b47
begin 
	default(x::Number) = zero(x)
	default(::Vector{T}) where T = Vector{T}()
	default(::Char) = 'X'
	default(::Type{T}) where {T <: AbstractString} = T("")
end

# ╔═╡ 4b50510f-2ebb-4429-8ffe-51fd2ad91b7c
(
	default(1.0),
	default('A'),
	default([1, 2, 3])
)

# ╔═╡ 9bfdb192-ccff-4175-ae16-11fd1638fde0
md"""
Try to define a new `default` method for the type `Int`. It should return `0`. 
"""

# ╔═╡ fcaeef3f-06a7-45ed-a8d2-c295864a1fa9
md"""
#### Exercise: Static analysis

One major advantage of type systems is that they allow computer programs to detect _type errors_ in your code _before_ you run it. Python's `PyLance` system is pretty decent - but it only works _sometimes_ for some code bases. I.e. you can't use it for any of _your_ code, unless you added type annotations yourself, or for any projects where any of your dependencies did not add type annotations. And if you mess up your type annotations, since the Python interpreter is clueless about types, you're on your own.

In contrast, the Julia type checker `JET` is integrated into Julia's compiler, so it sees what the compiler sees. For that reason, it works for all code that is statically analyzable at all.

For this exercise, statically analyse the Julia and Python codes in `kmers.jl` and `kmers.py`.

__Julia__

* Launch Julia in this project: `$julia --project=.`
* Load `JET`: `julia> using JET`
* Statically analyse the top function call: `julia> @report_call mode=:sound Kmers.count_matrix(Kmers.data, Kmers.matrix)`

An output of `No errors detected` means that the compiler can guarantee that there will be no type errors at runtime.

__Python__

In order to provide type checking, you need to annotate all the top-level data and functions in the script using Python's type syntax. Be careful not to get it wrong, because the interpreter can't help you.

If you _also_ want the code to be generic, you need to match each argument with the [abstract base classes](https://docs.python.org/3/library/collections.abc.html) that correctly cover the methods of the object in the function called.

You don't have the time to do this today, but it's left as an exercise for the reader.
"""

# ╔═╡ d578a599-9f0d-4acb-aa4d-313074a12a80
md"""
## Strength: Multithreading

Python has a [global interpreter lock (GIL)](https://en.wikipedia.org/wiki/Global_interpreter_lock) which prevents race conditions when calling multithreaded code, allowing the interpreter to be reasonably "fast". On the flip side, the GIL means it is impossible to write multithreaded Python. For parallelism, you need to rely on C libraries, or multiprocessing.

This was not really an issue in the 90's when PCs only had a single CPU core. But it's a big problem nowadays. Python developers have tried removing the GIL for years, but so far has gotten nowhere.

Since it's from the 2010's, Julia was built with multithreading in mind.

#### Exercise: Add multithreading to an existing program
Make a new function `sum_vectors_multithreaded` by copy-pasting the function `sum_vectors_singlethreaded`, then put `Threads.@threads` in front of the for-loop in the function. Then time it like is already done with the single threaded one below.
"""

# ╔═╡ b786af58-9925-481d-a202-c4cef10527c8
# Just do some computations
function compute_vector(v)
	s = 0.0
	for i in v
		s += i / (isqrt(abs(i)) + log(abs(i)))
	end
	s
end;

# ╔═╡ aa0240f3-e1c4-4b98-a16e-3d3de52119f6
function sum_vectors_singlethreaded(vectors)
	s = 0.0
	for i in vectors
		s += compute_vector(i)
	end
	s
end;

# ╔═╡ 24e4ad19-1681-4df7-8725-217da110454a
data = [rand(Int32, 2_000_000) for i in 1:8];

# ╔═╡ 00bc8f70-7ebe-464a-b229-86d11bf7041b
@time sum_vectors_singlethreaded(data)

# ╔═╡ d41fc671-3809-48f2-aad6-e1353aef695f
md"""
## Misc - what wasn't said.

There are many more differences between Python and Julia than covered here. There are a few more that deserves a mention though.

#### Other weaknesses of Julia
* Since Julia requires a JIT compiler to run, it also consumes around 150 MB memory just to run any script. This, combined with its latency makes it completely unsuitable for _deployment_ in e.g. a standalone app, or for a small background task. This limitation is being worked on, but it may take multiple years before Julia can create quick scrips without latency.

* Compared to Python, Julia is far more _immature_. This means major projects have fewer developers and have existed for a shorter time. As a consequence, the documentation for major projects is often of worse quality, and there are more bugs in the Julia ecosystem as there are fewer people to discover and fix them. There are also less likely to exist a Julia package for your specific needs compared to Python

#### Other strengths of Julia
* Unlike for Python, Julia is ubiqutiously documented using a single framework, namely `Documenter`. For this reason, documentation is much more prevalent in Julia than in Python.
* Julia can represent and process its own code like the Lisp language. This enables _metaprogramming_, introspection and macros. For example, you can easily create a program which tracks its own source code and reacts if it is being modified.

#### Materials
* [What's bad about Julia](https://viralinstruction.com/posts/badjulia/) - a more comprehensive look at all the disadvantages of Julia
* [The unreasonable effectiveness of multiple dispatch (video)](https://www.youtube.com/watch?v=kc9HwsxE1OY) - a video on why Julia's dispatch model enables code reuse
* Visit the [JuliaLang Slack workspace](https://julialang.org/slack/) or the [Discourse forum](discourse.julialang.org/).
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[deps]
"""

# ╔═╡ Cell order:
# ╠═044c0c96-d355-11ec-25de-37d5f5e9e12c
# ╟─683d19e4-adc0-4173-bf3c-ddf2048b34aa
# ╟─458562b3-083b-48fe-89dc-f956dbb486fe
# ╟─1f7ced75-cee2-42a6-82f1-4e870e65b423
# ╟─a71fc3ae-469f-4059-b2fc-06c200463a86
# ╟─d1d99486-0273-4b5e-a79e-2141f63397d8
# ╟─bc2918d9-b67e-48da-8220-d7cd24abb334
# ╟─e0a41812-064f-45a4-b681-bfd287cde692
# ╟─4f90b4b6-6f45-4c84-89c5-ef89ae548c33
# ╟─a43340c8-087f-4220-8bc7-b9fc229909bd
# ╠═2c58bddd-adf6-42fa-a141-9b7a735b4b47
# ╠═4b50510f-2ebb-4429-8ffe-51fd2ad91b7c
# ╠═9bfdb192-ccff-4175-ae16-11fd1638fde0
# ╟─fcaeef3f-06a7-45ed-a8d2-c295864a1fa9
# ╟─d578a599-9f0d-4acb-aa4d-313074a12a80
# ╠═b786af58-9925-481d-a202-c4cef10527c8
# ╠═aa0240f3-e1c4-4b98-a16e-3d3de52119f6
# ╠═24e4ad19-1681-4df7-8725-217da110454a
# ╠═00bc8f70-7ebe-464a-b229-86d11bf7041b
# ╟─d41fc671-3809-48f2-aad6-e1353aef695f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
