data {
  int<lower=0> N; // number of observations
  real mu_prior; // prior mean for mu
  real<lower=0> sigma_prior; // prior standard deviation for mu
  real<lower=0> sigma_prior_mean; // prior mean for sigma
  real<lower=0> sigma_prior_sd; // prior standard deviation for sigma
}
generated quantities {
  real mu = normal_rng(mu_prior, sigma_prior); // prior draw for mu
  real<lower=0> sigma = normal_rng(sigma_prior_mean, sigma_prior_sd); // prior draw for sigma
  array[N] real y_rep;
  for (n in 1 : N) {
    y_rep[n] = normal_rng(mu, sigma);
  }
}
