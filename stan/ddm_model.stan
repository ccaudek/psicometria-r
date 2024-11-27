data {
  int<lower=1> N; // number of trials
  array[N] real<lower=0> RT; // response times
  array[N] int<lower=0, upper=1> accuracy; // accuracy (0 or 1)
}
parameters {
  real<lower=0> v; // drift rate
  real<lower=0> a; // boundary separation
  real<lower=0> t; // non-decision time
  real<lower=0, upper=1> z; // starting point (a priori bias)
}
model {
  // Priors
  v ~ normal(2, 1);
  a ~ normal(1, 0.5);
  t ~ normal(0.3, 0.1);
  z ~ beta(5, 5);
  
  // Likelihood
  for (n in 1 : N) {
    real prob;
    real rt_shifted = RT[n] - t;
    
    if (rt_shifted <= 0) {
      target += -1e10; // Avoid negative RTs
    } else {
      prob = z + (1 - 2 * z) * (1 / (1 + exp(-2 * v * a * rt_shifted)));
      if (accuracy[n] == 1) {
        target += log(prob);
      } else {
        target += log1m(prob);
      }
      target += -0.5 * log(rt_shifted)
                - 0.5 * square(v * rt_shifted - a / 2) / rt_shifted;
    }
  }
}
generated quantities {
  array[N] real log_lik;
  for (n in 1 : N) {
    real prob;
    real rt_shifted = RT[n] - t;
    
    if (rt_shifted <= 0) {
      log_lik[n] = -1e10;
    } else {
      prob = z + (1 - 2 * z) * (1 / (1 + exp(-2 * v * a * rt_shifted)));
      if (accuracy[n] == 1) {
        log_lik[n] = log(prob);
      } else {
        log_lik[n] = log1m(prob);
      }
      log_lik[n] += -0.5 * log(rt_shifted)
                    - 0.5 * square(v * rt_shifted - a / 2) / rt_shifted;
    }
  }
}
