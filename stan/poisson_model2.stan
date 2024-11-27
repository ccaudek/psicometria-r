data {
  int<lower=0> N; // numero di osservazioni
  real<lower=0> mu; // parametro mu per la distribuzione Gamma
  real<lower=0> sigma; // parametro sigma per la distribuzione Gamma
  array[N] int<lower=0> y; // dati osservati  
}
parameters {
  real<lower=0> rate; // parametro rate per la distribuzione Poisson
}
model {
  // Priori
  rate ~ gamma(mu ^ 2 / sigma ^ 2, mu / sigma ^ 2);
  
  // Likelihood
  y ~ poisson(rate);
}
