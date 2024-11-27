data {
  int<lower=0> N;
  real<lower=0> alpha_prior;
  real<lower=0> beta_prior;
}
parameters {
  real<lower=0, upper=1> theta;
}
model {
  // Definizione del priore Beta
  theta ~ beta(alpha_prior, beta_prior);
}
generated quantities {
  // Generazione della distribuzione predittiva a priori
  array[N] int<lower=0, upper=1> y_sim;
  for (n in 1 : N) {
    y_sim[n] = bernoulli_rng(theta);
  }
}
