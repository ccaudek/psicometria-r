data {
  int<lower=1> N;                // Number of data points
  vector[N] rt;                  // Reading time
  vector[N] so;                  // Predictor, constrained between -1 and 1
}
parameters {
  vector[2] beta;                // Intercept and slope
  real<lower=0> sigma_e;         // Error standard deviation
}
model {
  vector[N] mu;

  // Define the model for mu using vectorized operations
  mu = beta[1] + beta[2] * so;

  // Vectorized likelihood
  rt ~ lognormal(mu, sigma_e);
}
