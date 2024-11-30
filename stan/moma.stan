data {
  int<lower=0> N;           // Numero totale di prove
  int<lower=0> y;           // Numero di successi osservati
  real<lower=0> alpha_prior; // Parametro alpha della distribuzione Beta a priori
  real<lower=0> beta_prior;  // Parametro beta della distribuzione Beta a priori
}

parameters {
  real<lower=0, upper=1> theta; // Probabilità di successo
}

model {
  // Distribuzione a priori Beta
  theta ~ beta(alpha_prior, beta_prior);
  
  // Likelihood binomiale
  y ~ binomial(N, theta);
}

generated quantities {
  real log_lik; // Log-verosimiglianza
  log_lik = binomial_lpmf(y | N, theta);
}
