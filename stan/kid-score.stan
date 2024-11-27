data {
  int<lower=0> N1;  // number of observations (group 1)
  int<lower=0> N2;  // number of observations (group 2)
  vector[N1] y1;  // response times (group 1)
  vector[N2] y2;  // response times (group 2)
}

parameters {
  real mu_1;  // mean of group 1
  real mu_2;  // mean of group 2
  real<lower=0> sigma_1;  // standard deviation of group 1
  real<lower=0> sigma_2;  // standard deviation of group 2
}

transformed parameters {
  real delta;  // difference in means
  real cohen_d;  // Cohen's d effect size
  delta = mu_1 - mu_2;
  cohen_d = delta / sqrt((sigma_1^2 + sigma_2^2) / 2);
}

model {
  // Priors
  mu_1 ~ normal(80, 20);  // Prior for mean of group 1
  mu_2 ~ normal(80, 20);  // Prior for mean of group 2
  sigma_1 ~ normal(0, 10);  // Prior for standard deviation of group 1
  sigma_2 ~ normal(0, 10);  // Prior for standard deviation of group 2

  // Likelihood
  y1 ~ normal(mu_1, sigma_1);
  y2 ~ normal(mu_2, sigma_2);
}

generated quantities {
  vector[N1] y1_rep;  // replicated data for group 1
  vector[N2] y2_rep;  // replicated data for group 2
  for (i in 1:N1) {
    y1_rep[i] = normal_rng(mu_1, sigma_1);
  }
  for (i in 1:N2) {
    y2_rep[i] = normal_rng(mu_2, sigma_2);
  }
}
