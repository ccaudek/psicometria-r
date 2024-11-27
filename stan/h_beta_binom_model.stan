data {
  int<lower=0> N;  // Number of participants
  array[N] int<lower=0> y;  // Number of successes for each participant
  array[N] int<lower=0> n_trials;  // Number of trials for each participant
}

parameters {
  real<lower=0> alpha;  // Alpha parameter for the Beta distribution
  real<lower=0> beta;   // Beta parameter for the Beta distribution
  array[N] real<lower=0, upper=1> p;  // Success probability for each participant
}

model {
  // Priors
  alpha ~ gamma(8, 2);
  beta ~ gamma(27, 5);
  
  // Each participant's success probability follows a Beta distribution
  p ~ beta(alpha, beta);
  
  // Likelihood of the observed data
  for (i in 1:N) {
    y[i] ~ binomial(n_trials[i], p[i]);
  }
}

generated quantities {
  real overall_p = alpha / (alpha + beta);  // Calculate the mean success probability
}
