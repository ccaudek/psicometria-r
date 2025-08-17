
data {
  int<lower=1> N;
  vector[N] x;
}
parameters {
  real alpha;
  real beta;
}
model {
  alpha ~ normal(0, 1);
  beta  ~ normal(0, 1);
}
generated quantities {
  vector[N] p;
  array[N] int y_rep;
  for (i in 1:N) {
    p[i] = inv_logit(alpha + beta * x[i]);
    y_rep[i] = bernoulli_rng(p[i]);
  }
}

