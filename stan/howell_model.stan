data {
  int<lower=0> N; // numero di osservazioni
  vector[N] x; // pesi (differenze dalla media)
  vector[N] y; // altezze
}
parameters {
  real alpha; // intercetta
  real beta; // coefficiente di regressione
  real<lower=0> sigma; // deviazione standard dell'errore
}
model {
  // Priors
  alpha ~ normal(154, 10); // prior per l'intercetta
  beta ~ normal(0, 5); // prior per il coefficiente di regressione
  sigma ~ cauchy(0, 5); // prior per la deviazione standard
  
  // Likelihood
  y ~ normal(alpha + beta * x, sigma);
}
