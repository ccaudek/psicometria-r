
data {
  int<lower=1> N;           // numero di studenti simulati
  int<lower=1> n_items;     // numero di item per studente
}
parameters {
  real alpha;               // intercetta in scala logit
}
model {
  alpha ~ normal(0, 1.5);   // prior debolmente informativa
  // Nessuna verosimiglianza specificata: modello basato solo sulle prior
}
generated quantities {
  vector[N] p;              // probabilità individuali di successo
  array[N] int y_rep;       // punteggi simulati (dati replicati)
  for (i in 1:N) {
    p[i] = inv_logit(alpha);            // trasformazione da logit a probabilità
    y_rep[i] = binomial_rng(n_items, p[i]); // simulazione dei punteggi binomiali
  }
}

