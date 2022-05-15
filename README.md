# How to get started
* Install Julia:
  - Recommended: Run `curl -fsSL https://install.julialang.org | sh`
  - Alternative: Follow instructions on www.julialang.org.
* In the shell, enter the directory of this git repository.
* Launch Julia: `julia --project=.`
* Download and install dependencies: Run `import Pkg; Pkg.instantiate(); Pkg.precompile()`.
* Run `import Pluto; Pluto.run()` to launch Pluto.
* Use the Pluto UI to open the `notebook.jl` file in this directory.
