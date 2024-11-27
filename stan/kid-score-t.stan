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
}
transformed parameters {
  real mu_1 = mu_2 + delta; 
}
model {
  y1 ~ student_t(nu, mu_1, sigma_1);
  y2 ~ student_t(nu, mu_2, sigma_2);
  // priors
  mu_2 ~ normal(80, 20);
  delta ~ normal(0, 10);
  sigma_1 ~ normal(0, 10);
  sigma_2 ~ normal(0, 10);
  nu ~ gamma(2, 0.1);
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
