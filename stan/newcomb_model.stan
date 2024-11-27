data {
  int<lower=0> N; // Number of observations
  vector[N] y; // Outcome variable
}
parameters {
  real alpha; // Intercept
  real<lower=0> sigma; // Standard deviation of the errors
}
model {
  // Prior for the intercept
  alpha ~ normal(27, 20);
  
  // Likelihood
  y ~ normal(alpha, sigma);
}
generated quantities {
  vector[N] y_rep; // Replicated data
  
  for (n in 1 : N) {
    y_rep[n] = normal_rng(alpha, sigma);
  }
}
