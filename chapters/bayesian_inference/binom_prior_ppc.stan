
data {
  int<lower=1> N;           // numero di studenti fittizi
  int<lower=1> n_items;     // numero di item per studente
}
parameters {
  real alpha;               // intercetta in logit
}
model {
  alpha ~ normal(0, 1.5);   // prior weakly-informative
  // Nessuna likelihood: solo prior
}
generated quantities {
  vector[N] p;              // probabilità individuali
  array[N] int y_rep;       // punteggi simulati
  for (i in 1:N) {
    p[i] = inv_logit(alpha);            // da logit a probabilità
    y_rep[i] = binomial_rng(n_items, p[i]);
  }
}

