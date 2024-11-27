data {
  int<lower=0> N;
  real<lower=0> alpha_prior;
  real<lower=0> beta_prior;
}
parameters {
  real<lower=0, upper=1> theta;
}
model {
  theta ~ beta(alpha_prior, beta_prior);
}
generated quantities {
  array[N] int y_sim;
  real theta_rep;
  
  for (n in 1:N)
    y_sim[n] = bernoulli_rng(theta);
  theta_rep = sum(y_sim) / (1.0 * N);
}
