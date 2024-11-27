data {
  int<lower=1> N; // Numero di partecipanti
  array[N] int<lower=1, upper=4> y; // Risultati delle prove (valori da 1 a 4)
}
parameters {
  simplex[4] theta; // Vettore delle probabilità categoriali per le quattro emozioni
}
model {
  y ~ categorical(theta); // Likelihood: distribuzione categoriale per ciascuna prova
}
generated quantities {
  int y_pred; // Predizione per una nuova prova
  y_pred = categorical_rng(theta);
}
