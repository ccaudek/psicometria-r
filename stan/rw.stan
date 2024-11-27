data {
  int<lower=1> N; // number of observations
  int<lower=1> J; // number of individuals
  array[N] int<lower=0, upper=1> accepted; // binary outcome
  array[N] int<lower=1, upper=J> individual; // individual ID
  vector<lower=0, upper=1>[N] pa; // initial probabilities or associative strengths
}
parameters {
  real<lower=0> sigmai; // standard deviation for individual effects
  vector[J] eps; // individual effects
  real<lower=0, upper=1> alpha; // learning rate
  real<lower=0, upper=1> v; // mixing parameter
}
model {
  sigmai ~ exponential(1);
  eps ~ normal(0, sigmai);
  alpha ~ beta(1, 1);
  v ~ uniform(0, 1);
  
  vector[N] V; // associative strengths
  V[1] = pa[1]; // initialize the first trial
  
  for (n in 2 : N) {
    // Update associative strength using RW model
    V[n] = V[n - 1] + alpha * (accepted[n - 1] - V[n - 1]);
  }
  
  for (n in 1 : N) {
    real p = inv_logit(eps[individual[n]]) * v + (1 - v) * V[n];
    accepted[n] ~ bernoulli(p);
  }
}
