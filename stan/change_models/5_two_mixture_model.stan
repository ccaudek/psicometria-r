data {
  int Ntotal;                   //Total number of trials in the dataset (600)
  real trial[Ntotal];           //Trial number
  real observed_goal[Ntotal];   //Goal level for each trial
  real performance[Ntotal];     //Performance for each trial
  int Nsubj;                    //Number of subjects
  int subject[Ntotal];          //Subject number
}

parameters {
  real alpha[2];                //initialize unique alpha parameter for each of the two mixtures
  ordered[2] beta;              //initialize unique beta parameter for each of the two mixtures. Here, beta is initialized as an ordered vector. When using a mixture model, usually one parameter needs to be implemented as an ordered vector to make the chains non-exchangable (see Stan user guide for details).
  real<lower=0> sigma;          //initialize single sigma parameter for entire sample and set lower bound to 0.
  real<lower=0,upper=1> mix_weight[Nsubj]; //initialize a unique mixture weight parameter for each subject, setting the lower bounds to 0 and the upper bounds to 1.
}

model {
  real predicted_goal[2];          //initialize predicted goal level object to store predictions for each mixture

  //PRIORS
  alpha ~ normal(0,1);          //set weakly informative prior on alpha
  beta ~ normal(0,1);           //set weakly informative prior on beta
  sigma ~ normal(0,1);          //set weakly informative prior on sigma
  //Note: The fact that we have not specified a prior on the mixture weights parameters means that Stan will apply the default uniform prior to these parameters.

  //LIKELIHOOD
  //loop through all trials in the dataset performing bracketed operations on each one
  for(i in 1:Ntotal){
    //if the trial being considered is the first trial for that subject...
    if(trial[i]==1){
      //for each mixture, set predicted_goal to be equal to observed_goal for that trial
      predicted_goal[1] = observed_goal[i];
      predicted_goal[2] = observed_goal[i];
    }
    if(trial[i]>1){
      //for each mixture, increment predicted_goal according to the theory of change, using parameters relevant to that mixture.
      predicted_goal[1] += alpha[1]*(performance[i-1]-predicted_goal[1]) + beta[1];
      predicted_goal[2] += alpha[2]*(performance[i-1]-predicted_goal[2]) + beta[2];
    }

    //calculate the likelihood of observed goal given a mixture of two normal distributions, and incrememnt log density directly (see Stan user guide for details on log probability increment statement)
    target += log_mix(mix_weight[subject[i]],
                        normal_lpdf(observed_goal[i] | predicted_goal[1], sigma),
                        normal_lpdf(observed_goal[i] | predicted_goal[2], sigma));
  }
}

//NOTE: The generated quantities block (below) is NOT needed for the model to run. However, it can be useful for generating posterior predictives from the model. The posterior predictives from this model were presented in the "model evalutation" section of the paper.

generated quantities {
  real predicted_goal[2];        //initialize object to store goal level predicted by the model for each mixture
  real sampled_goal[Ntotal];     //initialize object to store set of goal level samples (i.e., the posterior predictives)

  //loop through all trials in the dataset generating predictions in the same way as above
  for(i in 1:Ntotal){
    if(trial[i]==1){
      predicted_goal[1] = observed_goal[i];
      predicted_goal[2] = observed_goal[i];
    }
    if(trial[i]>1){
      predicted_goal[1] += alpha[1]*(performance[i-1]-predicted_goal[1]) + beta[1];
      predicted_goal[2] += alpha[2]*(performance[i-1]-predicted_goal[2]) + beta[2];
    }

    //instead of evaluating the likelihood of the observed goal, we sample a goal level from the distribution of the predicted goal. This distribution is mixture of two normals. Each mixture has a mean equal to the predicted goal for that mixture and an sd of sigma. The sampled goal level is a weighted sum of the samples from each mixture, where the weight applied to the sample from mixture 1 is the mixture weight for the relevant subject, and the weight applied to the sample from mixture 2 is one minus the mixture weight for the relevant subject.

    sampled_goal[i] = mix_weight[subject[i]]*normal_rng(predicted_goal[1],sigma) +
                              (1-mix_weight[subject[i]])*normal_rng(predicted_goal[2],sigma);



  }
}

