
data {
  int<lower=1> N;
}
parameters {
  real mu;
  real<lower=0> sigma;
}
model {
  mu ~ normal(50, 10);
  sigma ~ exponential(1.0/10); // mean 10
}
generated quantities {
  vector[N] y_rep;
  for (i in 1:N) {
    y_rep[i] = normal_rng(mu, sigma);
  }
}

