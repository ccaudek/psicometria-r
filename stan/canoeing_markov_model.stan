data {
  int<lower=0> N; // Number of trials
  array[N] int<lower=0, upper=1> y; // Sequence of errors (0 = correct, 1 = error)
}
parameters {
  real<lower=0, upper=1> p_error_given_error; // Probability of error given previous error
  real<lower=0, upper=1> p_error_given_correct; // Probability of error given previous correct
  real<lower=0, upper=1> p_initial_error; // Initial probability of error
}
model {
  // Implicit weak priors on parameters
  
  // Likelihood for the first trial
  y[1] ~ bernoulli(p_initial_error);
  
  // Likelihood for the rest of the trials
  for (n in 2 : N) {
    if (y[n - 1] == 1) {
      y[n] ~ bernoulli(p_error_given_error);
    } else {
      y[n] ~ bernoulli(p_error_given_correct);
    }
  }
}
generated quantities {
  vector[N] log_lik; // Log-likelihood for each observation
  log_lik[1] = bernoulli_lpmf(y[1] | p_initial_error);
  for (n in 2 : N) {
    if (y[n - 1] == 1) {
      log_lik[n] = bernoulli_lpmf(y[n] | p_error_given_error);
    } else {
      log_lik[n] = bernoulli_lpmf(y[n] | p_error_given_correct);
    }
  }
}
