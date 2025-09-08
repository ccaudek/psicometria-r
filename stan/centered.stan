data {
  int<lower=0> N;
  vector[N] y;
  real mu;
  real<lower=0> tau;
  real<lower=0> sigma;
}
parameters {
  real theta;
}
model {
  theta ~ normal(mu, tau);    // prior (centered)
  y ~ normal(theta, sigma);   // likelihood
}
generated quantities {
  // utile per controlli o confronti
  real y_rep = normal_rng(theta, sigma);
}
