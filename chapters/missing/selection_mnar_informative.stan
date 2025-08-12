
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
transformed parameters {
  array[N_total] real y_all;
  for (n in 1:N_obs)   y_all[n] = y_obs[n];
  for (n in 1:N_mis)   y_all[N_obs + n] = y_mis[n];
}
model {
  // Priors ancoranti su outcome (scala nota) + informativa su beta
  mu    ~ normal(0, 0.3);
  sigma ~ normal(1, 0.2) T[0,];
  alpha ~ normal(0, 1);
  beta  ~ normal(-1.5, 0.5);

  // Outcome
  y_obs ~ normal(mu, sigma);
  y_mis ~ normal(mu, sigma);

  // Selection
  for (n in 1:N_total)
    R[n] ~ bernoulli_logit(alpha + beta * y_all[n]);
}
generated quantities {
  real y_mean = mu;
  real y_sd   = sigma;
}

