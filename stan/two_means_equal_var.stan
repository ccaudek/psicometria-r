
data {
  int<lower=1> N;                      // numero di osservazioni
  int<lower=2> J;                      // numero di gruppi (qui: 2)
  vector[N] y;                         // esito standardizzato
  array[N] int<lower=1, upper=J> g;    // indice di gruppo per ogni osservazione
}
parameters {
  vector[J] mu;                        // medie dei due gruppi
  real<lower=0> sigma;                 // deviazione standard comune
}
model {
  // Priors debolmente informative, coerenti con y standardizzata
  mu    ~ normal(0, 1.5);
  sigma ~ exponential(1);

  // Likelihood: ogni y appartiene al suo gruppo g[i]
  for (i in 1:N)
    y[i] ~ normal(mu[g[i]], sigma);
}
generated quantities {
  vector[N] log_lik;                   // log-verosimiglianze per PSIS-LOO
  vector[N] y_rep;                     // repliche per posterior predictive checks
  real diff_mu;                        // differenza tra le medie (Gruppo 2 - Gruppo 1)

  // calcolo log_lik e repliche
  for (i in 1:N) {
    log_lik[i] = normal_lpdf(y[i] | mu[g[i]], sigma);
    y_rep[i]   = normal_rng(mu[g[i]], sigma);
  }

  // differenza di interesse sostantivo:
  // attenzione: per coerenza didattica, assumiamo g=1 -> Controllo, g=2 -> Mindfulness
  diff_mu = mu[2] - mu[1];
}

