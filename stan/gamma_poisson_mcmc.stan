data {
  int<lower=0> N; // numero di osservazioni
  array[N] int<lower=0> y; // dati osservati
  real<lower=0> alpha_prior; // parametro alpha della priori Gamma
  real<lower=0> beta_prior; // parametro beta della priori Gamma
}
parameters {
  real<lower=0> lambda; // parametro di interesse
}
model {
  // Priori
  lambda ~ gamma(alpha_prior, beta_prior);
  
  // Verosimiglianza
  y ~ poisson(lambda);
}
generated quantities {
  real alpha_post = alpha_prior + sum(y);
  real beta_post = beta_prior + N;
}
