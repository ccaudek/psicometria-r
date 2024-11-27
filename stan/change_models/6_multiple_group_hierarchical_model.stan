//Note: This model was not presented in the paper.

data {
  int Ntotal;                   //Total number of trials in the dataset (600)
  real trial[Ntotal];           //Trial number
  real observed_goal[Ntotal];   //Goal level for each trial
  real performance[Ntotal];     //Performance for each trial
  int condition[Ntotal];        //Condition (1=Approach, 2=Avoidance)
  int Nsubj;                    //Number of subjects
  int subject[Ntotal];          //Subject number
  int subj_cond[Nsubj];         //An array with a single element for each subject containing the condition for each one
}  
 
parameters {
  real alpha[Nsubj];            //initialize unique alpha parameter for each subject
  real beta[Nsubj];             //initialize unique beta parameter for each subject
  real<lower=0> sigma;          //initialize single sigma parameter for entire sample and set lower bound to 0.
  real alpha_mean[2];              //initialize condition mean parameter for the alpha distribution for each condition
  real<lower=0>  alpha_sd[2];      //initialize condition sd parameter for the alpha distribution for each condition and set lower bound to 0.
  real beta_mean[2];               //initialize condition mean parameter for the beta distribution for each condition
  real<lower=0>  beta_sd[2];       //initialize condition sd parameter for the beta distribution for each condition and set lower bound to 0.
}

model {
 real predicted_goal;          //initialize predicted goal level object to store predictions
  
  //PRIORS
  //In this model, we have to loop through subjects setting the priors individually. This is because the subject priors do not all come from the same distribution, so we use indexing to map the subject onto the appropriate group level distribution.
  for(subj in 1:Nsubj){
    alpha[subj] ~ normal(alpha_mean[subj_cond[subj]],alpha_sd[subj_cond[subj]]);  //set hierarchical prior on alpha
    beta[subj] ~ normal(beta_mean[subj_cond[subj]],beta_sd[subj_cond[subj]]);     //set hierarchical prior on beta
  }
  sigma ~ normal(0,1);                  //set weekly informative prior on sigma
  alpha_mean  ~ normal(0,1);            //set weekly informative prior on mean of alpha
  alpha_sd  ~ normal(0,1);              //set weekly informative prior on sd of alpha
  beta_mean  ~ normal(0,1);             //set weekly informative prior on mean of beta
  beta_sd  ~ normal(0,1);               //set weekly informative prior on sd of beta
  
  //LIKELIHOOD
  //loop through all trials in the dataset performing bracketed operations on each one
  for(i in 1:Ntotal){
    //if the trial being considered is the first trial for that subject...
    if(trial[i]==1){
      //set predicted_goal to be equal to observed_goal for that trial
      predicted_goal = observed_goal[i];
    }
    //if the trial being considered is not the first trial for that subject...
    if(trial[i]>1){
      //increment predicted_goal according to the theory of change, using parameters associated with the individual subject
      predicted_goal += alpha[subject[i]]*(performance[i-1]-predicted_goal) + beta[subject[i]];
    }
    //evaluate likelihood of observed goal given a normal distribution with mean = predicted_goal and sd = sigma
    observed_goal[i] ~ normal(predicted_goal,sigma);
  }
}