data {
  int<lower=0> N1; // Number of participants in group 1 (intervention)
  int<lower=0> N2; // Number of participants in group 2 (control)
  array[N1] real y1; // Test scores for group 1
  array[N2] real y2; // Test scores for group 2
}
parameters {
  real mu1; // Mean test score for group 1
  real mu2; // Mean test score for group 2
  real<lower=0> sigma_y; // Standard deviation of test scores
  real<lower=0> sigma_theta; // Standard deviation of baseline cognitive ability
  array[N1 + N2] real theta; // Baseline cognitive abilities for all participants
}
model {
  // Priors
  mu1 ~ normal(0, 10);
  mu2 ~ normal(0, 10);
  sigma_y ~ normal(0, 5);
  sigma_theta ~ normal(0, 5);
  
  for (j in 1 : (N1 + N2)) {
    theta[j] ~ normal(0, sigma_theta); // Random effects for baseline abilities
  }
  
  // Likelihood
  for (j in 1 : N1) {
    y1[j] ~ normal(mu1 + theta[j], sigma_y);
  }
  
  for (j in 1 : N2) {
    y2[j] ~ normal(mu2 + theta[N1 + j], sigma_y);
  }
}
generated quantities {
  real delta = mu1 - mu2; // Difference in means
}
