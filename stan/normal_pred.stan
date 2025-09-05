data {
  int<lower=0> N;          // numero di osservazioni
  vector[N] y;             // dati osservati
  real mu0;                // media a priori
  real<lower=0> tau0;      // dev.st. a priori
  real<lower=0> sigma;     // dev.st. nota
  int<lower=0,upper=1> prior_only; // se 1: ignora i dati
}
parameters {
  real mu;                 // media sconosciuta
}
model {
  mu ~ normal(mu0, tau0);
  if (prior_only == 0) {
    y ~ normal(mu, sigma);
  }
}
generated quantities {
  vector[N] y_rep;                // UNA REPLICA COMPLETA per draw
  for (n in 1:N) {
    y_rep[n] = normal_rng(mu, sigma);
  }
}

