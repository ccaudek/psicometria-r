data {
  int<lower=0> N; // number of trials
  array[N] int<lower=0, upper=1> y; // accuracy (0 or 1)
  array[N] int<lower=0, upper=1> condition; // 1 if high learning, 0 if low learning
}
parameters {
  real<lower=0, upper=1> theta_initial; // initial accuracy
  real<lower=0, upper=1> learning_rate; // learning rate
  real<lower=0, upper=1> decay_rate; // decay rate
}
model {
  // Priors
  theta_initial ~ beta(2, 2);
  learning_rate ~ beta(2, 2);
  decay_rate ~ beta(2, 2);
  
  for (n in 2 : N) {
    real p = condition[n]
             * fmin(fmax((1 - decay_rate) * theta_initial
                         + learning_rate * (1 - y[n - 1]), 0),
                    1)
             + (1 - condition[n]) * theta_initial;
    y[n] ~ bernoulli(p);
  }
}
generated quantities {
  array[N] int<lower=0, upper=1> y_rep;
  array[N] real log_lik;
  
  y_rep[1] = bernoulli_rng(theta_initial); // First trial based on initial theta
  log_lik[1] = bernoulli_lpmf(y[1] | theta_initial);
  
  for (n in 2 : N) {
    real p = condition[n]
             * fmin(fmax((1 - decay_rate) * theta_initial
                         + learning_rate * (1 - y[n - 1]), 0),
                    1)
             + (1 - condition[n]) * theta_initial;
    
    y_rep[n] = bernoulli_rng(p);
    log_lik[n] = bernoulli_lpmf(y[n] | p);
    
    // Optional diagnostic print statement
    print("n: ", n, " p: ", p, " y_rep[n]: ", y_rep[n]);
  }
}
