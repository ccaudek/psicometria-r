data {
  int<lower=1> N; // numero di osservazioni
  array[N] int<lower=1, upper=4> states; // sequenza degli stati osservati
}
parameters {
  simplex[4] state_probs; // vettore delle probabilità di ciascuno stato
}
model {
  // Distribuzione a priori uniforme per le probabilità degli stati (Dirichlet(1))
  state_probs ~ dirichlet(rep_vector(1.0, 4));
  
  // Verosimiglianza dei dati osservati trattati come indipendenti
  for (n in 1 : N) 
    states[n] ~ categorical(state_probs);
}
generated quantities {
  array[N] real log_lik; // array per la log likelihood
  array[N] int<lower=1, upper=4> y_rep; // dati simulati per posterior predictive checks
  
  // Calcolo della log likelihood per ogni osservazione
  for (n in 1 : N) {
    log_lik[n] = categorical_lpmf(states[n] | state_probs);
  }
  
  // Generazione di dati simulati per posterior predictive checks
  for (n in 1 : N) {
    y_rep[n] = categorical_rng(state_probs);
  }
}
