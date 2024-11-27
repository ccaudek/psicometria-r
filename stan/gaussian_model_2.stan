data {
  int<lower=0> N;            // number of observations
  vector[N] y;               // observed data
  real mu_prior;             // prior mean for mu
  real<lower=0> sigma_prior; // prior standard deviation for mu
  real<lower=0> sigma;       // known standard deviation of y
}
parameters {
  real mu;                   // parameter of interest
}
model {
  mu ~ normal(mu_prior, sigma_prior); // prior
  y ~ normal(mu, sigma);              // likelihood
}
generated quantities {
  array[N] real y_rep;
  for (n in 1:N) {
    y_rep[n] = normal_rng(mu, sigma);
  }
}
