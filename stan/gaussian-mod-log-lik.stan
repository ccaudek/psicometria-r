data {
  int<lower=0> N;
  vector[N] y;
}
parameters {
  real mu;
  real<lower=0> sigma;
}
model {
  // Priors
  mu ~ normal(5, 2);         // Prior for mu, centered around the known mean with some uncertainty
  sigma ~ normal(0, 2);      // Half-normal prior for sigma (implying positive values)
  
  // Likelihood
  y ~ normal(mu, sigma);
}
generated quantities {
  vector[N] log_lik;
  for (n in 1:N)
    log_lik[n] = normal_lpdf(y[n] | mu, sigma);
}
