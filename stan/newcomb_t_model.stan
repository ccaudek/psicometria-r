data {
  int<lower=0> N; // Number of observations
  vector[N] y; // Outcome variable
}
parameters {
  real alpha; // Intercept
  real<lower=0> sigma; // Standard deviation of the errors
  real<lower=1> nu; // Degrees of freedom for the Student's t-distribution
}
model {
  // Prior for the intercept
  alpha ~ normal(27, 20);
  
  // Prior for degrees of freedom
  nu ~ gamma(2, 0.1); // Weakly informative prior for nu, adjust as needed
  
  // Likelihood using Student's t-distribution
  y ~ student_t(nu, alpha, sigma);
}
generated quantities {
  vector[N] y_rep; // Replicated data
  
  for (n in 1 : N) {
    y_rep[n] = student_t_rng(nu, alpha, sigma);
  }
}
