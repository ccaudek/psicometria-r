data {
  int<lower=0> N;
  vector[N] x;
  vector[N] y;
}
parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}
model {
  alpha ~ normal(48.8, 0.5);
  beta ~ normal(0, 0.2);
  y ~ normal(alpha + beta * x, sigma);
}
