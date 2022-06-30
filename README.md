# Short introduction to Julia for Pythonistas
This is material for a short (~2 hour) introduction to Julia, intended for scientists who already code in Python.
It highlights the most important core strenghts and weaknesses of Julia compared to Python.

It assumes familiarity with the shell, and a Bash-like shell available.

## How to get started
* Install Julia:
  - MacOS/Linux recommended: Run `curl -fsSL https://install.julialang.org | sh`
  - Windows recommended: Install from Windows Store.
  - Alternative for all platforms: Follow instructions on www.julialang.org.
* Clone this repository
* In the shell, enter the directory of this git repository.
* Launch Julia in the the environment of this repository: `julia --project=.`
* Download and install dependencies: Run `import Pkg; Pkg.instantiate(); Pkg.precompile()`.
* Run `import Pluto; Pluto.run()` to launch Pluto.
* Use the Pluto UI to open the `notebook.jl` file in this directory.
