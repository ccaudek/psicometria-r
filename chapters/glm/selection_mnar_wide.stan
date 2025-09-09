
data {
  int<lower=0> N_obs;
  int<lower=0> N_mis;
  int<lower=0> N_total;
  array[N_obs] real y_obs;
  array[N_total] int<lower=0,upper=1> R;
}
parameters {
  real mu;
  real<lower=0> sigma;
  array[N_mis] real y_mis;
  real alpha;
  real beta;
}
model {
  // Priors: outcome fortemente ancorato (scala z), beta ampia
  mu    ~ normal(0, 0.2);
  sigma ~ normal(1, 0.1) T[0,];
  alpha ~ normal(0, 2);
  beta  ~ normal(0, 2);

  // Outcome
  y_obs ~ normal(mu, sigma);
  y_mis ~ normal(mu, sigma);

  // Selection con indicizzazione corretta
  {
    int i_obs = 1;
    int i_mis = 1;
    for (n in 1:N_total) {
      real y_n = (R[n] == 1) ? y_obs[i_obs] : y_mis[i_mis];
      R[n] ~ bernoulli_logit(alpha + beta * y_n);
      if (R[n] == 1) i_obs += 1; else i_mis += 1;
    }
  }
}
generated quantities {
  real y_mean = mu;
  real y_sd   = sigma;
}

