data {
  int<lower=1> N;                       // numero di prove
  int<lower=0, upper=N> y;              // successi osservati
  real<lower=0> alpha_prior;            // Beta prior: alpha
  real<lower=0> beta_prior;             // Beta prior: beta
}
parameters {
  real<lower=0, upper=1> theta;         // probabilità di successo
}
model {
  // Prior
  theta ~ beta(alpha_prior, beta_prior);
  // Likelihood
  y ~ binomial(N, theta);
}
generated quantities {
  // Replica del dato per pp_check
  int y_rep = binomial_rng(N, theta);

  // Log-likelihood del dato osservato (per LOO/WAIC)
  real log_lik = binomial_lpmf(y | N, theta);
}
