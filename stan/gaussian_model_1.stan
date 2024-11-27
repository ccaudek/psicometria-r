data {
    int<lower=1> N;
    vector[N] y;
}
parameters {
    real mu;
    real<lower=0> sigma;
}
model {
  y ~ normal(mu, sigma);
  sigma ~ normal(0, 15);
  mu ~ normal(29, 10);
}
