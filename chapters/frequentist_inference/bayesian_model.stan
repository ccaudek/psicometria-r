data {
  int<lower=1> N;        // Numero di osservazioni
  vector[N] Y;           // Dati osservati
}
parameters {
  real mu;               // Media della popolazione
  real<lower=0> sigma;   // Deviazione standard della popolazione
}
model {
  mu ~ normal(0, 200);               // Prior debole per mu
  sigma ~ normal(0, 100) T[0, ];     // Prior HalfNormal per sigma
  Y ~ normal(mu, sigma);             // Likelihood
}
