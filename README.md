# Learning the topology of a Bayesian network from a database of cases using the K2 algorithm

<p align="center">
<b>Group members</b> // Francesco Pio Barone, Gianmarco Nagaro Quiroz, Daniele Ninni
</p>

This is our final project for *Advanced Statistics for Physics Analysis*. In this work, we implement the K2 algorithm and test its performance in learning the topology of a Bayesian network starting from a database of cases. Moreover, we code the algorithm inside the **bnstruct** R package.

## Bayesian networks

A **Bayesian network** (also known as a **belief network**) is a probabilistic graphical model that represents a set of variables and their conditional dependencies via a directed acyclic graph (DAG).

Such DAGs consist of:

- $\color{red}{\text{nodes}}$ $\leftrightarrow$ variables in the Bayesian sense (observable quantities, latent variables, unknown parameters or hypotheses)
    - unconnected nodes $\leftrightarrow$ conditionally independent variables
    - each node $\leftrightarrow$ probability function (INPUT: a particular set of values for the node's parent variables, OUTPUT: probability of the variable represented by the node)
- $\color{blue}{\text{edges}}$ $\leftrightarrow$ conditional dependencies

Given a database of records, it is interesting to construct a Bayesian network which can provide insights into the probabilistic dependencies existing among the variables in the database itself.
Such network can be further used to predict the future behaviour of the system thus modeled.

## Topology learning

In the simplest case, a Bayesian network has a small number of nodes and therefore can be specified manually by an expert.
Even in the case of a large number of nodes, an expert could be able to assess the network structure, if his knowledge of the system is sufficient.
In general, it is crucial to learn the network topology following a data-driven approach.

Automatically learning the graph structure of a Bayesian network is a challenge pursued within machine learning.
For instance, $\color{green}{\text{score-based}}$ algorithms use optimization-based search according to:

- a scoring function
- a search strategy

Such score-based algorithms focus on the DAG as a whole and approach the topology learning task as an optimization problem:

1) each candidate DAG is assigned a score which represents a statistical measurement of how well the DAG itself mirrors the dependence structure of the data
2) the output DAG is the one corresponding to the highest score

## K2 algorithm

The K2 algorithm is a score-based algorithm introduced by G. F. Cooper and E. Herskovits in 1992.
It allows to learn the topology of a Bayesian network, i.e. to find the most probable belief network structure, given a database of cases.

The algorithm holds on the following assumptions:

- there is an ordering on the domain variables
- a priori, all structures are considered equally likely

The algorithm is based on the use of a greedy-search method. In particular, for each node:

1) it begins by making the assumption that the current node has no parents
2) it adds incrementally that parent whose addition most increases the probability of the resulting structure
3) when the addition of no single parent can increase the probability, it stops adding parents to the current node and moves on to the next node

***

## Bibliography

- M. Scutari and J. B. Denis, *Bayesian Networks*, CRC Press, 2022, Taylor and Francis Group
- G. F. Cooper and E. Herskovits, *A Bayesian Method for the Induction of Probabilistic Networks from Data*, Machine Learning 9, (1992) 309
- C. Ruiz, *Illustration of the K2 Algorithm for learning Bayes Net Structures* [web.cs.wpi.edu](http://web.cs.wpi.edu/~cs539/s11/Projects/k2_algorithm.pdf)
- A. Franzin et al., *bnstruct: an R package for Bayesian Network structure learning in the presence of missing data*, Bioinformatics 33(8) (2017) 1250
- F. Sambo and A. Franzin, *bnstruct: an R package for Bayesian Network Structure Learning with missing data*, December 12, 2016

***

<h5 align="center">Advanced Statistics for Physics Analysis<br>University of Padua, A.Y. 2021/22</h5>

<p align="center">
  <img src="https://user-images.githubusercontent.com/62724611/166108149-7629a341-bbca-4a3e-8195-67f469a0cc08.png" alt="" height="70"/>
</p>