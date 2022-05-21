# Short introduction to Julia for Pythonistas
This is material for a short (~2 hour) introduction to Julia, intended for scientists who already code in Python.
It highlights the most important core strenghts and weaknesses of Julia compared to Python.

It assumes familiarity with the shell, and a Bash-like shell available.

## How to get started
* Clone this repository
* Install Julia:
  - Recommended: Run `curl -fsSL https://install.julialang.org | sh`
  - Alternative: Follow instructions on www.julialang.org.
  - Windows: Install from Windows Store.
* In the shell, enter the directory of this git repository.
* Launch Julia in the current environment: `julia --project=.`
* Download and install dependencies: Run `import Pkg; Pkg.instantiate(); Pkg.precompile()`.
* Run `import Pluto; Pluto.run()` to launch Pluto.
* Use the Pluto UI to open the `notebook.jl` file in this directory.
