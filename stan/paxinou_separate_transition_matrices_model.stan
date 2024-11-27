data {
  int<lower=1> N; // number of states
  int<lower=1> M1; // number of subjects in condition 1
  int<lower=1> M2; // number of subjects in condition 2
  int<lower=1> L; // length of each sequence
  array[M1, L] int<lower=1, upper=N> y1; // observed sequences for condition 1
  array[M2, L] int<lower=1, upper=N> y2; // observed sequences for condition 2
}
parameters {
  array[N] simplex[N] P1; // transition matrix for condition 1
  array[N] simplex[N] P2; // transition matrix for condition 2
}
model {
  // Likelihood for condition 1 using P1
  for (m in 1 : M1) {
    for (l in 2 : L) {
      y1[m, l] ~ categorical(P1[y1[m, l - 1]]);
    }
  }
  
  // Likelihood for condition 2 using P2
  for (m in 1 : M2) {
    for (l in 2 : L) {
      y2[m, l] ~ categorical(P2[y2[m, l - 1]]);
    }
  }
}
generated quantities {
  array[M1 * (L - 1) + M2 * (L - 1)] real log_lik; // combined log likelihoods for all observations
  int idx = 1; // Index for combined log likelihoods array
  
  // Compute log likelihoods for condition 1
  for (m in 1 : M1) {
    for (l in 2 : L) {
      log_lik[idx] = categorical_lpmf(y1[m, l] | P1[y1[m, l - 1]]);
      idx += 1;
    }
  }
  
  // Compute log likelihoods for condition 2
  for (m in 1 : M2) {
    for (l in 2 : L) {
      log_lik[idx] = categorical_lpmf(y2[m, l] | P2[y2[m, l - 1]]);
      idx += 1;
    }
  }
}
