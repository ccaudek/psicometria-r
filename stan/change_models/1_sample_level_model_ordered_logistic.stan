data {
  int<lower=1> Ntotal; // Total number of trials in the dataset (600)
  array[Ntotal] int<lower=1> trial; // Trial number
  array[Ntotal] real observed_goal; // Goal level for each trial
  array[Ntotal] real performance; // Performance for each trial
}
parameters {
  real alpha; // Single alpha parameter for entire sample
  real beta; // Single beta parameter for entire sample
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
                          + alpha
                            * (performance[i - 1] - predicted_goal[i - 1])
                          + beta;
    }
  }
  
  observed_goal ~ normal(predicted_goal, sigma);
}
generated quantities {
  array[Ntotal] real sampled_goal;
  array[Ntotal] real log_lik;
  real predicted_goal;
  
  for (i in 1 : Ntotal) {
    if (trial[i] == 1) {
      predicted_goal = observed_goal[i];
    } else {
      predicted_goal += alpha * (performance[i - 1] - predicted_goal) + beta;
    }
    print("i: ", i, " predicted_goal: ", predicted_goal, " sigma: ", sigma);
    sampled_goal[i] = normal_rng(predicted_goal, sigma);
    log_lik[i] = normal_lpdf(observed_goal[i] | predicted_goal, sigma);
  }
}
