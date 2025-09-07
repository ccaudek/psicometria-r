
data {
  int<lower=1> N;                      // numero di osservazioni
  int<lower=2> J;                      // numero di gruppi (qui: 2)
  vector[N] y;                         // esito standardizzato
  array[N] int<lower=1, upper=J> g;    // indice di gruppo
}
parameters {
  vector[J] mu;                        // medie per gruppo
  vector<lower=0>[J] sigma;            // sd specifica di gruppo
}
model {
  // Priors debolmente informative
  mu    ~ normal(0, 1.5);
  sigma ~ exponential(1);

  // Likelihood con sd per gruppo
  for (i in 1:N)
    y[i] ~ normal(mu[g[i]], sigma[g[i]]);
}
generated quantities {
  vector[N] log_lik;                   // per PSIS-LOO
  vector[N] y_rep;                     // posterior predictive checks
  real diff_mu;                        // mu[2] - mu[1], Mindfulness - Controllo
  real diff_sigma;                     // sigma[2] - sigma[1]

  for (i in 1:N) {
    log_lik[i] = normal_lpdf(y[i] | mu[g[i]], sigma[g[i]]);
    y_rep[i]   = normal_rng(mu[g[i]], sigma[g[i]]);
  }

  diff_mu    = mu[2]    - mu[1];
  diff_sigma = sigma[2] - sigma[1];
}

