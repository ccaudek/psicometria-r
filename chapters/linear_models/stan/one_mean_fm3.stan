
data {
  int<lower=1> N;
  vector[N] y;
}
parameters {
  real mu;
  real<lower=0> sigma;
}
model {
  // Priors equivalenti a brms:
  mu    ~ normal(181, 30);
  sigma ~ normal(0, 20); // con <lower=0> diventa automaticamente Half-Normal(0,20)

  // Likelihood
  y ~ normal(mu, sigma);
}
generated quantities {
  vector[N] y_rep;
  for (n in 1:N) y_rep[n] = normal_rng(mu, sigma);
}

