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
  sigma ~ normal(0, 20);
  mu ~ normal(181, 30);
}
