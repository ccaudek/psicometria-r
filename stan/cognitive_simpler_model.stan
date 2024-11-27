data {
  int<lower=0> N; // number of trials
  array[N] int<lower=0, upper=1> y; // accuracy (0 or 1)
  array[N] int<lower=0, upper=1> condition; // 1 if high learning, 0 if low learning
}
parameters {
  real<lower=0, upper=1> theta_high; // accuracy in condition 1
  real<lower=0, upper=1> theta_low; // accuracy in condition 0
}
model {
  // Priors
  theta_high ~ beta(2, 2);
  theta_low ~ beta(2, 2);
  
  for (n in 1 : N) {
    real p = condition[n] * theta_high + (1 - condition[n]) * theta_low;
    y[n] ~ bernoulli(p);
  }
}
generated quantities {
  array[N] int<lower=0, upper=1> y_rep;
  array[N] real log_lik;
  
  for (n in 1 : N) {
    real p = condition[n] * theta_high + (1 - condition[n]) * theta_low;
    y_rep[n] = bernoulli_rng(p);
    log_lik[n] = bernoulli_lpmf(y[n] | p);
  }
}
