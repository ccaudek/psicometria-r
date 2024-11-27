data {
  int<lower=0> N; // numero di osservazioni per ogni gruppo
  real<lower=0> mu; // parametro mu per la distribuzione Gamma
  real<lower=0> sigma; // parametro sigma per la distribuzione Gamma
  array[N] int<lower=0> y_white; // dati osservati per il gruppo caucasico
  array[N] int<lower=0> y_non_white; // dati osservati per il gruppo non caucasico
}
parameters {
  real<lower=0> rate_white; // parametro rate per la distribuzione Poisson per il gruppo caucasico
  real<lower=0> rate_non_white; // parametro rate per la distribuzione Poisson per il gruppo non caucasico
}
model {
  // Priori
  rate_white ~ gamma(mu ^ 2 / sigma ^ 2, mu / sigma ^ 2);
  rate_non_white ~ gamma(mu ^ 2 / sigma ^ 2, mu / sigma ^ 2);
  
  // Likelihood
  y_white ~ poisson(rate_white);
  y_non_white ~ poisson(rate_non_white);
}
generated quantities {
  real diff_rate = rate_non_white - rate_white; // differenza tra le frequenze attese
}
