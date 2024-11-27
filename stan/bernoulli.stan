data {
  int<lower=0> N;
  array[N] int<lower=0, upper=1> y;
  int<lower=0> alpha_prior;
  int<lower=0> beta_prior;
}
parameters {
  real<lower=0, upper=1> theta;
}
model {
  theta ~ beta(alpha_prior, beta_prior);
  y ~ bernoulli(theta);
}
generated quantities {
  array[N] int y_sim;
  real<lower=0, upper=1> theta_rep;
  for (n in 1:N)
    y_sim[n] = bernoulli_rng(theta);
  theta_rep = sum(y) / N;
}
