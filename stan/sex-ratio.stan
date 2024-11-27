data {
  int<lower = 0> N;
  int<lower = 0, upper = N> y;
  int<lower = 0> alpha_prior;
  int<lower = 0> beta_prior;
}
parameters {
  real<lower=0, upper=1> theta;
}
model {
  theta ~ beta(alpha_prior, beta_prior);
  y ~ binomial(N, theta);
}
generated quantities {
  int<lower=0, upper=1> boys_gt_girls = theta > 0.5;
}
