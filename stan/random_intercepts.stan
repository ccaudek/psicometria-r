data {
  int<lower=0> N;                  // Number of data points
  vector[N] rt;                    // Reading time
  vector[N] so;                    // Predictor, constrained between -1 and 1
  int<lower=0> J;                  // Number of subjects
  int<lower=0> K;                  // Number of items
  array[N] int<lower=0, upper=J> subj;
  array[N] int<lower=0, upper=K> item;
}
parameters {
  vector[2] beta;                  // Fixed intercept and slope
  vector[J] u;                     // Subject intercepts
  vector[K] w;                     // Item intercepts
  real<lower=0> sigma_e;           // Error standard deviation
  real<lower=0> sigma_u;           // Subject standard deviation
  real<lower=0> sigma_w;           // Item standard deviation
}
model {
  vector[N] mu;

  // Priors
  beta ~ normal(0, 5);             // Assuming a weakly informative prior for beta
  u ~ normal(0, sigma_u);
  w ~ normal(0, sigma_w);
  sigma_e ~ exponential(1);
  sigma_u ~ exponential(1);
  sigma_w ~ exponential(1);

  // Likelihood
  mu = beta[1] + beta[2] * so + u[subj] + w[item];  // Vectorized computation of mu
  rt ~ lognormal(mu, sigma_e);
}
