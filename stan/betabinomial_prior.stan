data {
  int<lower=0> N;             // Numero di osservazioni
  real<lower=0> alpha_prior;  // Parametro alpha del prior Beta
  real<lower=0> beta_prior;   // Parametro beta del prior Beta
}
generated quantities {
  real<lower=0, upper=1> theta_prior;    // Valore estratto da Beta(alpha_prior, beta_prior)
  array[N] int<lower=0, upper=1> y_sim;  // Osservazioni simulate
  
  theta_prior = beta_rng(alpha_prior, beta_prior); // Generazione di theta
  for (n in 1:N) {
    y_sim[n] = bernoulli_rng(theta_prior); // Simulazione dei successi
  }
}
