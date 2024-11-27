data {
  int<lower=0> N; // number of observations
  vector[N] y; // observed data
  real mu_prior; // prior mean for mu
  real<lower=0> sigma_prior; // prior standard deviation for mu
  real<lower=0> sigma_prior_mean; // prior mean for sigma
  real<lower=0> sigma_prior_sd; // prior standard deviation for sigma
}
parameters {
  real mu; // parameter of interest
  real<lower=0> sigma; // parameter for the standard deviation
}
model {
  mu ~ normal(mu_prior, sigma_prior); // prior for mu
  sigma ~ normal(sigma_prior_mean, sigma_prior_sd); // prior for sigma
  y ~ normal(mu, sigma); // likelihood
}
generated quantities {
  array[N] real y_rep;
  for (n in 1 : N) {
    y_rep[n] = normal_rng(mu, sigma);
  }
}
