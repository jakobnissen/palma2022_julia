# Short introduction to Julia for Pythonistas
This is material for a short (~2 hour) introduction to Julia, intended for scientists who already code in Python.
It highlights the most important core strenghts and weaknesses of Julia compared to Python.

## How to get started - MacOS or Linux
* Clone this repository
* Install Julia:
  - Recommended: Run `curl -fsSL https://install.julialang.org | sh`
  - Alternative: Follow instructions on www.julialang.org.
* In the shell, enter the directory of this git repository.
* Launch Julia in the current environment: `julia --project=.`
* Download and install dependencies: Run `import Pkg; Pkg.instantiate(); Pkg.precompile()`.
* Run `import Pluto; Pluto.run()` to launch Pluto.
* Use the Pluto UI to open the `notebook.jl` file in this directory.

## How to get started - Windows
* Clone this repository
* Install Julia from the Windows store, and launch Julia.
* Type `;` to enter shell mode, then navigate to the directory of this git repository.
* Type backspace to get back to Julia mode, then `]` to enter Package mode.
* In pkg mode, run `activate .` (notice the trailing dot!) to activate this environment
* In pkg mode, run `instantiate` to download dependencies
* In pkg mode, run `precompile` to precompile dependencies
* Type backspace to get back to Julia mode
* Run `import Pluto; Pluto.run()` to launch Pluto.
* Use the Pluto UI to open the `notebook.jl` file in this directory.
