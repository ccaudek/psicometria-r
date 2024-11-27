data {
  int<lower=1> N; // Number of observations
  int<lower=1> M; // Number of hidden states
  int<lower=1> K; // Number of observation categories
  array[N] int<lower=1, upper=K> y; // Observations, coded as integers 1:K
}
parameters {
  simplex[M] pi; // Initial state probabilities
  array[M] simplex[M] A; // Transition matrix for hidden states
  array[M] simplex[K] B; // Emission matrix for observation categories
}
model {
  // Priors
  pi ~ dirichlet(rep_vector(1.0, M));
  for (m in 1 : M) {
    A[m] ~ dirichlet(rep_vector(1.0, M));
    B[m] ~ dirichlet(rep_vector(1.0, K));
  }
  
  // Forward algorithm for likelihood
  {
    array[N, M] real log_alpha;
    for (m in 1 : M) 
      log_alpha[1, m] = log(pi[m]) + categorical_lpmf(y[1] | B[m]);
    
    for (n in 2 : N) {
      for (m in 1 : M) {
        real acc = negative_infinity();
        for (k in 1 : M) 
          acc = log_sum_exp(acc, log_alpha[n - 1, k] + log(A[k, m]));
        log_alpha[n, m] = acc + categorical_lpmf(y[n] | B[m]);
      }
    }
    target += log_sum_exp(log_alpha[N]);
  }
}
