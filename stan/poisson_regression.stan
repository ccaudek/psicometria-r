data {
  int<lower=0> N;  // Numero di osservazioni
  array[N] int<lower=0> y;  // Dati di conteggio (frequenze)
  vector[N] x;  // Variabile predittore (anni, già standardizzata)
}

parameters {
  real alpha;  // Intercetta
  real beta;  // Pendenza
}

model {
  // Priors debolmente informativi
  alpha ~ normal(0, 10);
  beta ~ normal(0, 10);

  // Modello di regressione di Poisson
  y ~ poisson_log(alpha + beta * x);
}

generated quantities {
  array[N] int<lower=0> y_pred = poisson_log_rng(alpha + beta * x);
}
