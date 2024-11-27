// Thompson model
data {
  int<lower=1> N; // number of observations
  int<lower=1> J; // number of individuals
  array[N] int<lower=0, upper=1> accepted; // binary outcome
  array[N] int<lower=1, upper=J> individual; // individual ID
  vector<lower=0, upper=1>[N] pa; // probability from Thompson sampling
}
parameters {
  real<lower=0> sigmai; // standard deviation for individual effects
  vector[J] eps; // individual effects
  real<lower=0, upper=1> v; // mixing parameter
}
model {
  sigmai ~ exponential(1);
  eps ~ normal(0, sigmai);
  v ~ uniform(0, 1);
  
  for (n in 1 : N) {
    real p = inv_logit(eps[individual[n]]) * v + (1 - v) * pa[n];
    accepted[n] ~ bernoulli(p);
  }
}
