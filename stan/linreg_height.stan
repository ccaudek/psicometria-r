data {
  int<lower=1> N;
  vector[N] x;
  vector[N] y;
}
parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
}
model {
  y ~ normal(alpha + beta * (x- mean(x)), sigma);
  alpha ~ normal(181, 30);
  beta ~ normal(-2, 2);
  sigma ~ normal(0, 20);
}
generated quantities {
  array[N] real y_rep = normal_rng(alpha + beta * x, sigma);
}
