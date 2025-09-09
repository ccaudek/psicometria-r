
data {
  int<lower=0> N_obs;             // Numero di osservazioni
  int<lower=0> N_mis;             // Numero di valori mancanti
  array[N_obs] real y_obs;        // Valori osservati
}
parameters {
  real mu;                        // Media della distribuzione
  real<lower=0> sigma;            // Deviazione standard
  array[N_mis] real y_mis;        // Valori mancanti (stimati)
}
model {
  // Priors
  mu    ~ normal(0, 1);
  sigma ~ normal(1, 0.5);
  
  // Likelihood per dati osservati
  y_obs ~ normal(mu, sigma);
  
  // Likelihood per dati mancanti (uguale agli osservati)
  y_mis ~ normal(mu, sigma);
}
generated quantities {
  real y_mean = mu;               // Stima della media
  real y_sd   = sigma;             // Stima della deviazione standard
}

