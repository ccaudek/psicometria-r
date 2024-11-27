data {
  int<lower=0> Ntotal; // Total number of trials in the dataset (600)
  array[Ntotal] int<lower=1> trial; // Trial number
  array[Ntotal] real observed_goal; // Goal level for each trial
  array[Ntotal] real performance; // Performance for each trial
  int<lower=1> Nsubj; // Number of subjects
  array[Ntotal] int<lower=1, upper=Nsubj> subject; // Subject number
}
parameters {
  vector[Nsubj] alpha; // Unique alpha parameter for each subject
  vector[Nsubj] beta; // Unique beta parameter for each subject
  real<lower=0> sigma; // Single sigma parameter for entire sample
}
model {
  vector[Ntotal] predicted_goal; // Vector to store predictions
  
  // Priors
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
  sigma ~ normal(0, 1);
  
  // Likelihood
  for (i in 1 : Ntotal) {
    if (trial[i] == 1) {
      predicted_goal[i] = observed_goal[i];
    } else {
      predicted_goal[i] = predicted_goal[i - 1]
                          + alpha[subject[i]]
                            * (performance[i - 1] - predicted_goal[i - 1])
                          + beta[subject[i]];
    }
  }
  
  observed_goal ~ normal(predicted_goal, sigma);
}
generated quantities {
  vector[Ntotal] predicted_goal;
  array[Ntotal] real sampled_goal;
  array[Ntotal] real log_lik;
  
  for (i in 1 : Ntotal) {
    if (trial[i] == 1) {
      predicted_goal[i] = observed_goal[i];
    } else {
      predicted_goal[i] = predicted_goal[i - 1]
                          + alpha[subject[i]]
                            * (performance[i - 1] - predicted_goal[i - 1])
                          + beta[subject[i]];
    }
    
    sampled_goal[i] = normal_rng(predicted_goal[i], sigma);
    log_lik[i] = normal_lpdf(observed_goal[i] | predicted_goal[i], sigma);
  }
}
