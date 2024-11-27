data {
  int<lower=0> N; // Numero di osservazioni (tempi di reazione) per il soggetto
  array[N] real<lower=0> reaction_times; // Tempi di reazione osservati
}
parameters {
  real<lower=0> lambda; // Parametro lambda della distribuzione esponenziale (tasso)
}
model {
  // Prior debolmente informativo su lambda
  lambda ~ normal(1, 1);
  
  // Likelihood: distribuzione esponenziale per i tempi di reazione
  reaction_times ~ exponential(lambda);
}
