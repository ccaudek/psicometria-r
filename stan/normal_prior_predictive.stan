data {
  int<lower=0> N;                 // n. osservazioni (non usato in prior predictive)
  vector[N] y;                    // dati (ignorati)
  real mu0;                       // media a priori
  real<lower=0> tau0;             // sd a priori
  real<lower=0> sigma;            // sd nota
}
generated quantities {
  real mu_prior;                  // estrazione dal prior
  mu_prior = normal_rng(mu0, tau0);

  // Una replica completa di dimensione N (se N=0, restituisce vettore vuoto senza errori)
  vector[N] y_rep;
  for (n in 1:N) {
    y_rep[n] = normal_rng(mu_prior, sigma);
  }
}

