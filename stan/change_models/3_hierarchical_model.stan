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
  real alpha_mean; // Population mean parameter for the alpha distribution
  real<lower=0> alpha_sd; // Population sd parameter for the alpha distribution
  real beta_mean; // Population mean parameter for the beta distribution
  real<lower=0> beta_sd; // Population sd parameter for the beta distribution
}
model {
  vector[Ntotal] predicted_goal; // Vector to store predictions
  
  // Priors
  alpha ~ normal(alpha_mean, alpha_sd);
  beta ~ normal(beta_mean, beta_sd);
  sigma ~ normal(0, 1);
  alpha_mean ~ normal(0, 1);
  alpha_sd ~ normal(0, 1);
  beta_mean ~ normal(0, 1);
  beta_sd ~ normal(0, 1);
  
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
    
    // Calculate the log likelihood for each observation
    log_lik[i] = normal_lpdf(observed_goal[i] | predicted_goal[i], sigma);
  }
}
