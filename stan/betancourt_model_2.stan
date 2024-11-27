data {
  int<lower=1> N_subjects; // Numero di soggetti
  array[N_subjects] real<lower=0> reaction_times; // Tempi di reazione osservati per ciascun soggetto
}
parameters {
  real<lower=0> lambda_global; // Parametro globale lambda
  real<lower=0> sigma_lambda; // Deviazione standard delle differenze individuali
  array[N_subjects] real<lower=0> lambda_individual; // Parametri lambda individuali per ciascun soggetto
}
model {
  // Prior su lambda_global e sigma_lambda
  lambda_global ~ normal(1, 1);
  sigma_lambda ~ normal(0, 1);
  
  // I lambda individuali sono distribuiti attorno a lambda_global
  lambda_individual ~ normal(lambda_global, sigma_lambda);
  
  // Likelihood: distribuzione esponenziale per i tempi di reazione
  reaction_times ~ exponential(lambda_individual);
}
