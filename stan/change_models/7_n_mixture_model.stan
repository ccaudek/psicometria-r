data {
  int Ntotal;                   //Total number of trials in the dataset (600)
  real trial[Ntotal];           //Trial number
  real observed_goal[Ntotal];   //Goal level for each trial
  real performance[Ntotal];     //Performance for each trial
  int Nsubj;                    //Number of subjects
  int subject[Ntotal];          //Subject number
  int Nmix;                     //Number of mixtures
}    
 
parameters {
  real alpha[Nmix];                //initialize unique alpha parameter for each mixture
  ordered[Nmix] beta;              //initialize unique beta parameter for each mixture. Here, beta is initialized as an ordered vector. When using a mixture model, usually one parameter needs to be implemented as an ordered vector to make the chains non-exchangable (see Stan user guide for details).
  real<lower=0> sigma;          //initialize single sigma parameter for entire sample and set lower bound to 0.
  simplex[Nmix] mix_weight[Nsubj]; //initialize a unique mixture weight parameter for each subject, setting the lower bounds to 0 and the upper bounds to 1. When there are more than two mixtures, a unique weight is needed for each mixture, and all the weights must sum to one. This can be implemneted using the 'simplex' object type in stan. A simplex is a vector of weights which all sum to 1. Here we specify an array of simplexes. Each element in the array contains a simplex with an element for each mixture. The number of simplexes in the array is equal to the number of subjects.
}

model {
  real predicted_goal[Nmix];          //initialize predicted goal level object to store predictions for each mixture
  
  //PRIORS
  alpha ~ normal(0,1);          //set weekly informative prior on alpha
  beta ~ normal(0,1);           //set weekly informative prior on beta
  sigma ~ normal(0,1);          //set weekly informative prior on sigma
  //Note: The fact that we have not specified a prior on the mixture weights parameters means that Stan will apply the default uniform prior to these parameters. 
  
  //LIKELIHOOD
  //loop through all trials in the dataset performing bracketed operations on each one
  for(i in 1:Ntotal){
    //initialize object to store weighted logged likelihood of observed goal for each mixture
    real lps[Nmix];
    for(k in 1:Nmix){
      //if the trial being considered is the first trial for that subject...
      if(trial[i]==1){
        //for each mixture, set predicted_goal to be equal to observed_goal for that trial
        predicted_goal[k] = observed_goal[i];
      }
      if(trial[i]>1){
        //for each mixture, increment predicted_goal according to the theory of change, using parameters relevant to that mixture.
        predicted_goal[k] += alpha[k]*(performance[i-1]-predicted_goal[k]) + beta[k];
      }
      //calculated weighted log likelihood of observed goal under mixture being considered
      lps[k] = log(mix_weight[subject[i],k]) + normal_lpdf(observed_goal[i] | predicted_goal[k], sigma);
    }
     //sum weighted log likelihoods to get the logged likelihood of observation given combination of mixtures
    target += log_sum_exp(lps);
  }
}