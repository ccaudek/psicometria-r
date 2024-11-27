functions {
  real wiener_rng(real alpha, real tau, real beta, real delta) {
    real dt = 0.0001;
    real x = alpha * beta;
    real t = 0;
    while (x > 0 && x < alpha) {
      x += delta * dt + sqrt(dt) * normal_rng(0, 1);
      t += dt;
    }
    return t + tau;
  }
}
data {
  int<lower=1> N; // number of trials
  array[N] real<lower=0> rt; // response times
  array[N] int<lower=0, upper=1> resp; // responses (0 or 1)
}
parameters {
  real<lower=0, upper=10> v; // drift rate
  real<lower=0.1, upper=5> a; // boundary separation
  real<lower=0.001, upper=min(rt)> t; // non-decision time
  real<lower=0.1, upper=0.9> z; // starting point
}
model {
  // Priors
  v ~ normal(2, 1) T[0, 10];
  a ~ normal(1, 0.5) T[0.1, 5];
  t ~ normal(0.3, 0.1) T[0.001, min(rt)];
  z ~ beta(5, 5);
  
  // Likelihood
  for (i in 1 : N) {
    if (rt[i] > t) {
      if (resp[i] == 1) {
        target += wiener_lpdf(rt[i] | a, t, z, v);
      } else {
        target += wiener_lpdf(rt[i] | a, t, 1 - z, -v);
      }
    } else {
      target += -1e10; // Strongly penalize impossible RTs
    }
  }
}
generated quantities {
  array[N] real log_lik;
  array[N] real y_pred;
  for (i in 1 : N) {
    if (rt[i] > t) {
      if (resp[i] == 1) {
        log_lik[i] = wiener_lpdf(rt[i] | a, t, z, v);
        y_pred[i] = wiener_rng(a, t, z, v);
      } else {
        log_lik[i] = wiener_lpdf(rt[i] | a, t, 1 - z, -v);
        y_pred[i] = wiener_rng(a, t, 1 - z, -v);
      }
    } else {
      log_lik[i] = -1e10;
      y_pred[i] = t; // Set to non-decision time for impossible RTs
    }
  }
}
