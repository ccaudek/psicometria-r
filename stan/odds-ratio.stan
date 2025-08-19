
data {
  int<lower=0> N1;  int<lower=0> y1;
  int<lower=0> N2;  int<lower=0> y2;
}
parameters {
  real<lower=0, upper=1> theta1;
  real<lower=0, upper=1> theta2;
}
model {
  // Priors (debolmente informativi)
  theta1 ~ beta(2, 2);
  theta2 ~ beta(2, 2);

  // Likelihood
  y1 ~ binomial(N1, theta1);
  y2 ~ binomial(N2, theta2);
}
generated quantities {
  real log_or  = logit(theta1) - logit(theta2);
  real oddsratio = exp(log_or);
}

