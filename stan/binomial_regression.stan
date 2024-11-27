data {
  int<lower=0> sample_size;  // Numero totale di osservazioni
  vector[sample_size] x;     // Variabile indipendente
  array[sample_size] int<lower=0> y;  // Successi per ogni tentativo
  int<lower=0> n;           // Numero di tentativi per osservazione
}
parameters {
  real beta0;  // Intercetta
  real beta1;  // Pendenza
}
transformed parameters {
  vector[sample_size] eta = beta0 + beta1 * x;  // Modello lineare
  vector[sample_size] p = inv_logit(eta);       // Probabilità di successo
}
model {
  // Priori
  beta0 ~ normal(0, 1);
  beta1 ~ normal(0, 1);

  // Likelihood
  y ~ binomial(n, p);
}
