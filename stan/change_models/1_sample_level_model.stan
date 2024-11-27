data {
  int<lower=1> Ntotal; //Total number of trials in the dataset (600)
  array[Ntotal] real<lower=1> trial; //Trial number
  array[Ntotal] real observed_goal; //Goal level for each trial
  array[Ntotal] real performance; //Performance for each trial
}
parameters {
  real alpha; //initialize single alpha parameter for entire sample
  real beta; //initialize single beta parameter for entire sample
  real<lower=0> sigma; //initialize single sigma parameter for entire sample and set lower bound at 0.
}
model {
  real predicted_goal; //initialize predicted goal level object to store predictions
  
  //PRIORS
  alpha ~ normal(0, 1); //set weakly informative prior on alpha
  beta ~ normal(0, 1); //set weakly informative prior on beta
  sigma ~ normal(0, 1); //set weakly informative prior on sigma
  
  //LIKELIHOOD
  //loop through all trials in the dataset performing bracketed operations on each one
  for (i in 1 : Ntotal) {
    //if the trial being considered is the first trial for that subject...
    if (trial[i] == 1) {
      //set predicted_goal to be equal to observed_goal for that trial
      predicted_goal = observed_goal[i];
    }
    //if the trial being considered is not the first trial for that subject...
    if (trial[i] > 1) {
      //increment predicted_goal according to the theory of change
      predicted_goal += alpha * (performance[i - 1] - predicted_goal) + beta;
    }
    //evaluate likelihood of observed goal given a normal distribution with mean = predicted_goal and sd = sigma
    observed_goal[i] ~ normal(predicted_goal, sigma);
  }
}
//NOTE: The generated quantities block (below) is NOT needed for the model to run. However, it can be useful for generating posterior predictives from the model. The posterior predictives from this model were presented in the "model evalutation" section of the paper.

generated quantities {
  real predicted_goal; // Initialize object to store goal level predicted by the model
  array[Ntotal] real<lower=1> sampled_goal; // Initialize object to store set of goal level samples (i.e., the posterior predictives)
  array[Ntotal] real log_lik; // Initialize array to store the log likelihood for each data point
  
  // Loop through all trials in the dataset generating predictions in the same way as above
  for (i in 1 : Ntotal) {
    if (trial[i] == 1) {
      predicted_goal = observed_goal[i];
    }
    if (trial[i] > 1) {
      predicted_goal += alpha * (performance[i - 1] - predicted_goal) + beta;
    }
    
    // Sample a goal level from the distribution of the predicted goal
    sampled_goal[i] = normal_rng(predicted_goal, sigma);
    
    // Calculate the log likelihood for the observed goal
    log_lik[i] = normal_lpdf(observed_goal[i] | predicted_goal, sigma);
  }
}
