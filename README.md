# 2018-NHTS-Data-Challenge

Working space for NHTS Data Challenge.

## Organization

-  `src`: Any R scripts (`*.R` and `*.Rmd`) and result files (`*.html`).

  - `bootstrap.*`: Comparison of weighted m-out-of-n bootstrap and delete-a-group jackknife resampling. 
  
  - `Cramer_s_V.*`: Correlation bwtween `USES_TNC` and demographic features.
  
  - `BNN.*`: Bayesian Belief Network of `USES_TNC` and demographic features.
  
  - `BNN-with-Missing.*`: Missing value imputation and missing pattern encoding in BNN.
  
  - `Semantic-Analysis.*`: Hierarchical n-gram model of transportation transformation.
  
- `data`: Derived variable configuration.

- `result`: Markov chain of transportation transformation obtained by partial-pooling model.

## Install

This project depends on [R](https://cran.r-project.org/). You will need to install several R packages for this project:

```r
# R pipeline of NHTS data
if(!require(summarizeNHTS)){
install.packages('devtools')
devtools::install_github('Westat-Transportation/summarizeNHTS')
require(summarizeNHTS)
}
# List of other packages this project depends on
packages <- c("dplyr","survey","vcd","knitr","bnlearn","Rgraphviz","missForest")
if(!require(packages)){
install.packages(packages)
require(packages)
}
```

## Method

- Resampling Fitting
  
  This work is inspired by the idea of function fitting. Firstly, I chosed a ratio as hyperparameter (in this project, the ratio is 0.1), then I used weighted m-out-of-n bootstrapping to mimic jackkifing, which achieved very close results in estimation and corresponding standard error of marginal and conditional probability (some results are shown in `src/bootstrape.html`). I also compared them in more complicated calculation, like Cramer's V, and I applied this bootstrapping strategy in Bayesian Belief Network. Since bootstrapping is known to be consistent in more cases and some modern model/algorithm, such as BNN, is more or less based on it, this work broadens and deepens our exploration of survey data. 

- Bayesian Belief Network with Missing Pattern: 
  
  BNN could be a useful tool for encoding correlation patterns among TNC usage and demographic features (education level, gender, race, age level and health condition). In order to make the most of data, I firstly applied Random Forrest in nonparametic imputation, and then I generated new boolean variables to encode missing pattern. Finally, I put them all in BNN learning. It turned out that some correlation would be overestimated if simply removing entris with missing value, and education level and age level seem to be reliable strong features.

- Hierarchical Semantic Model: 
  
  This work is inspired by n-gram model in NLP. I used a demographic feature (education level) to build hierarchical models for transportation transformation, and it turned out that partial-pooling model outperformed fully-pooling/non-hierarchical model and no-pooling model.

## Results

## Build

knit `src/*.Rmd`
