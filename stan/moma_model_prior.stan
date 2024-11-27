data {
  int<lower=0> N;
  int<lower=0, upper=N> y;
  int<lower=0> alpha_prior;
  int<lower=0> beta_prior;
  int<lower=0, upper=1> compute_likelihood; // Flag to control likelihood inclusion
}
parameters {
  real<lower=0, upper=1> theta;
}
model {
  theta ~ beta(alpha_prior, beta_prior); // Prior for theta
  
  if (compute_likelihood == 1) {
    y ~ binomial(N, theta); // Likelihood is only included if compute_likelihood == 1
  }
}
generated quantities {
  int<lower=0, upper=N> y_rep;
  int<lower=0, upper=1> theta_gt_025 = theta > 0.25; // Indicator if theta > 0.25
  y_rep = binomial_rng(N, theta); // Simulated data for posterior predictive check
}
