data {
  int<lower=0> N; // numero di osservazioni
  vector[N] x; // pesi (differenze dalla media)
  vector[N] y; // altezze
}
parameters {
  real alpha_tilde; // parametro ausiliario per l'intercetta
  real beta_tilde; // parametro ausiliario per il coefficiente di regressione
  real<lower=0> sigma; // deviazione standard dell'errore
}
transformed parameters {
  real alpha; // intercetta
  real beta; // coefficiente di regressione
  
  // Trasformazioni per ottenere i parametri nella scala dei dati grezzi
  alpha = 154 + 10 * alpha_tilde;
  beta = 0 + 5 * beta_tilde;
}
model {
  // Priors standardizzati per i parametri ausiliari
  alpha_tilde ~ normal(0, 1); // prior standardizzato per alpha_tilde
  beta_tilde ~ normal(0, 1); // prior standardizzato per beta_tilde
  sigma ~ cauchy(0, 5); // prior per la deviazione standard
  
  // Likelihood sulla scala dei dati grezzi
  y ~ normal(alpha + beta * x, sigma);
}
