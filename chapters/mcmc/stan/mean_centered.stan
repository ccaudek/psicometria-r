
data {
  int<lower=1> N;
  vector[N] y;
  real<lower=0> sigma;
  real mu0;
  real<lower=0> tau;
}
parameters {
  real mu;
}
model {
  mu ~ normal(mu0, tau);
  y  ~ normal(mu, sigma);
}
generated quantities {
  vector[N] y_rep;
  vector[N] log_lik;
  for (n in 1:N) {
    y_rep[n] = normal_rng(mu, sigma);
    log_lik[n] = normal_lpdf(y[n] | mu, sigma);
  }
}

