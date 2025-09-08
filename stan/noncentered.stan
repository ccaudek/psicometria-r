data {
  int<lower=0> N;
  vector[N] y;
  real mu;
  real<lower=0> tau;
  real<lower=0> sigma;
}
parameters {
  real z;
}
transformed parameters {
  real theta = mu + tau * z;
}
model {
  z ~ normal(0, 1);           // prior (non-centered)
  y ~ normal(theta, sigma);   // likelihood
}
generated quantities {
  real y_rep = normal_rng(theta, sigma);
}
