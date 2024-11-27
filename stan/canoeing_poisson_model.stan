data {
  int<lower=0> N; // Number of trials
  array[N] int<lower=0> y; // Number of errors in each trial (could be 0 or 1)
}
parameters {
  real<lower=0> lambda; // Rate parameter for the Poisson distribution
}
model {
  // Weak prior on lambda
  lambda ~ normal(0, 10);
  
  // Likelihood: Poisson distribution
  y ~ poisson(lambda);
}
generated quantities {
  vector[N] log_lik; // Log-likelihood for each observation
  for (n in 1 : N) {
    log_lik[n] = poisson_lpmf(y[n] | lambda);
  }
}
