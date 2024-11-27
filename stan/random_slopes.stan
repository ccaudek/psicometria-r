data {
  int<lower=0> N;                  // Number of data points
  vector[N] rt;                    // Reading time
  vector[N] so;                    // Predictor, constrained between -1 and 1
  int<lower=0> J;                  // Number of subjects
  int<lower=0> K;                  // Number of items
  array[N] int<lower=0, upper=J> subj;
  array[N] int<lower=0, upper=K> item;
}
parameters {
  vector[2] beta;                  // Fixed intercept and slope
  real<lower=0> sigma_e;           // Error standard deviation
  matrix[2,J] u;                   // Subject intercepts and slopes
  vector<lower=0>[2] sigma_u;      // Subject standard deviations
  matrix[2,K] w;                   // Item intercepts and slopes
  vector<lower=0>[2] sigma_w;      // Item standard deviations
}
model {
  // Priors
  for (j in 1:J) {
    u[1,j] ~ normal(0, sigma_u[1]); // Prior for subject intercepts
    u[2,j] ~ normal(0, sigma_u[2]); // Prior for subject slopes
  }
  
  for (k in 1:K) {
    w[1,k] ~ normal(0, sigma_w[1]); // Prior for item intercepts
    w[2,k] ~ normal(0, sigma_w[2]); // Prior for item slopes
  }
  
  // Likelihood
  for (i in 1:N) {
    real mu = beta[1] + u[1, subj[i]] + w[1, item[i]]
              + (beta[2] + u[2, subj[i]] + w[2, item[i]]) * so[i];
    rt[i] ~ lognormal(mu, sigma_e);
  }
}

