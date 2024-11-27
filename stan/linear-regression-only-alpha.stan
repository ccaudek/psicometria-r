// all data should be scaled to mean 0 and std 1:
data {
  int<lower=1> N;
  vector[N] x;
  vector[N] y;
}
parameters {
  real alpha;
  real<lower=0> sigma;
}
model {
  y ~ normal(alpha, sigma);
  alpha ~ normal(0, 2.5);
  sigma ~ cauchy(0, 2.5);
}
generated quantities {
  vector[N] log_lik;
  vector[N] y_rep;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(y[n] | alpha, sigma);
    y_rep[n] = normal_rng(alpha, sigma);
  }
}
