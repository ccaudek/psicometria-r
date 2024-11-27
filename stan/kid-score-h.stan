data {
  int<lower=0> N1;  // number of observations (group 1)
  int<lower=0> N2;  // number of observations (group 2)
  vector[N1] y1;  // response time (group 1)
  vector[N2] y2;  // response time (group 2)
}

parameters {
  real mu_2;  // mean of group 2
  real delta;  // difference in means
  real<lower=0> sigma_1;  // scale parameter for group 1
  real<lower=0> sigma_2;  // scale parameter for group 2
  real<lower=1> nu;  // degrees of freedom of student's t distribution

  // Hyperparameters
  real mu_2_prior_location;
  real<lower=0> mu_2_prior_scale;
  real delta_prior_location;
  real<lower=0> delta_prior_scale;
  real<lower=0> sigma_prior_scale;
}

transformed parameters {
  real mu_1 = mu_2 + delta; 
}

model {
  // Hyperpriors
  mu_2_prior_location ~ normal(80, 20);
  mu_2_prior_scale ~ normal(10, 5);
  delta_prior_location ~ normal(0, 10);
  delta_prior_scale ~ normal(5, 2);
  sigma_prior_scale ~ normal(5, 2);
  
  // Priors
  mu_2 ~ normal(mu_2_prior_location, mu_2_prior_scale);
  delta ~ normal(delta_prior_location, delta_prior_scale);
  sigma_1 ~ normal(sigma_prior_scale, 10);
  sigma_2 ~ normal(sigma_prior_scale, 10);
  nu ~ gamma(2, 0.1);
  
  // Likelihood
  y1 ~ student_t(nu, mu_1, sigma_1);
  y2 ~ student_t(nu, mu_2, sigma_2);
}

generated quantities {
  vector[N1] y1rep;
  vector[N2] y2rep;
  real pooled_sd = sqrt((sigma_1^2 + sigma_2^2) / 2);
  real cohen_d = delta / pooled_sd;
  
  for (i in 1:N1) {
    y1rep[i] = student_t_rng(nu, mu_1, sigma_1);
  }
  for (i in 1:N2) {
    y2rep[i] = student_t_rng(nu, mu_2, sigma_2);
  }
}
