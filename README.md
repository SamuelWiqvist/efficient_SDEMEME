# Code for the paper: "Efficient inference for stochastic differential mixed-effects models using correlated particles pseudo-marginal algorithms"

DOI: https://doi.org/10.1016/j.csda.2020.107151

NB: The code presented here is updated compared to the version we used for the CSDA article. However, the difference are minor and do not affect the main conclusions of the paper. The results in the CSDA article are computed with the code at tag csda.

### File structure

/src/SDEMEM OU process: source code for the Ornstein-Uhlenbeck SDEMEM

/src/SDEMEM tumor growth: source code for tumor growth SDEMEM

/src/SDEMEM OU neuron data: source code for the neuronal data example

/analyses: notebooks and scripts used to analyse the results for the Ornstein-Uhlenbeck SDEMEM and the neuronal data example

/lunarc: run scripts for the LUNARC cluster (http://www.lunarc.lu.se/) (used for the Ornstein-Uhlenbeck SDEMEM and the neuronal data example)

/data/SDEMEM OU: Simulation results for the Ornstein-Uhlenbeck SDEMEM (this folder is empty but the simulation results can be generated from the code)

/data/SDEMEM OU neuron data: Simulation results for the neuronal data example (this folder is empty but the simulation results can be generated from the code)

### Software

The algorithms in the paper are implemented in `Julia` (Ornstein-Uhlenbeck SDEMEM, and neuronal data example), and in `R` (for the tumor growth SDEMEM). The `Python` package  `POT: Python Optimal Transport` is used for some analysis.

### Data

The data used for for the  Ornstein-Uhlenbeck SDEMEM and the tumor growth model can be generated from the code. To access the neuronal data, please contact the authors.

###  Acknowledgements

The computations were enabled by resources provided by the Swedish National Infrastructure for Computing (SNIC) at LUNARC (http://www.lunarc.lu.se/)  partially funded by the Swedish Research Council through grant agreement no. 2018-05973.
