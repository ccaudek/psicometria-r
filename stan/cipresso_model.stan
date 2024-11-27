data {
  int<lower=1> N; // number of transitions
  array[N] int states; // sequence of observed states
}
parameters {
  array[4] simplex[4] trans_matrix; // 4x4 transition matrix with simplex constraints
}
model {
  // Prior distribution for the transition matrix (Dirichlet prior)
  for (i in 1 : 4) 
    trans_matrix[i] ~ dirichlet(rep_vector(1.0, 4));
  
  // Likelihood of the observed data
  for (n in 1 : (N - 1)) 
    states[n + 1] ~ categorical(trans_matrix[states[n]]);
}
generated quantities {
  array[N - 1] real log_lik; // array per la log likelihood
  array[N] int<lower=1, upper=4> y_rep; // dati simulati per posterior predictive checks
  
  // Calcolo della log likelihood per ogni osservazione
  for (n in 1 : (N - 1)) {
    log_lik[n] = categorical_lpmf(states[n + 1] | trans_matrix[states[n]]);
  }
  
  // Generazione di dati simulati per posterior predictive checks
  y_rep[1] = states[1]; // il primo stato simulato è lo stesso dello stato osservato
  for (n in 1 : (N - 1)) {
    y_rep[n + 1] = categorical_rng(trans_matrix[y_rep[n]]);
  }
}
