
data {
  int<lower=1> N;
  vector[N] y;
  int<lower=1> K;
}
parameters {
  real alpha;
  vector[K] beta;
  real<lower=0> sigma;
}
model {
  // priors (debolmente informativi)
  alpha ~ normal(0, 50);
  beta  ~ normal(0, 0.5);
  sigma ~ exponential(0.1); // mean 10

  for (n in (K+1):N) {
    real mu = alpha;
    for (k in 1:K) mu += beta[k] * y[n-k];
    y[n] ~ normal(mu, sigma);
  }
}
generated quantities {
  vector[N] log_lik;
  vector[N] mu;
  vector[N] y_rep;

  // inizializza
  for (n in 1:N) {
    log_lik[n] = negative_infinity();
    mu[n]      = y[n];       // placeholder per i primi K
    y_rep[n]   = y[n];       // idem
  }

  for (n in (K+1):N) {
    real m = alpha;
    for (k in 1:K) m += beta[k] * y[n-k];
    mu[n] = m;
    log_lik[n] = normal_lpdf(y[n] | m, sigma);
    y_rep[n] = normal_rng(m, sigma);
  }
}

