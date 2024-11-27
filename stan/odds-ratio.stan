//  Comparison of two groups with Binomial
data {
  int<lower=0> N1; // number of experiments in group 1
  int<lower=0> y1; // number of events in group 1
  int<lower=0> N2; // number of experiments in group 2
  int<lower=0> y2; // number of events in group 2
}
parameters {
  real<lower=0, upper=1> theta1; // probability of event in group 1
  real<lower=0, upper=1> theta2; // probability of event in group 2
}
model {
  // model block creates the log density to be sampled
  theta1 ~ beta(2, 2); // prior
  theta2 ~ beta(2, 2); // prior
  y1 ~ binomial(N1, theta1); // observation model / likelihood
  y2 ~ binomial(N2, theta2); // observation model / likelihood
}
generated quantities {
  real oddsratio = (theta1 / (1 - theta1)) / (theta2 / (1 - theta2));
}
