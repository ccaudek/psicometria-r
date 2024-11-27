data {
  int<lower=1> N;
  int<lower=0> y;
}
parameters {
  real<lower=0, upper=1> p;
}
model {
  y ~ binomial(N, p); // Likelihood
  p ~ beta(1, 1); // Prior
}
generated quantities {
  int<lower=0, upper=1> p_gt_chance = p > 0.5;
}
