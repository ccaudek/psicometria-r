data {
  int<lower=1> N_subjects;        // Numero di soggetti
  array[N_subjects] real<lower=0> reaction_times; // Tempi di reazione per ciascun soggetto
  array[N_subjects] real<lower=0> task_difficulty; // Difficoltà del compito per ciascun soggetto
  array[N_subjects] real ability;                 // Abilità individuale per ciascun soggetto
}

parameters {
  real<lower=0> lambda_global;    // Parametro globale lambda
  real<lower=0> beta_difficulty;  // Effetto della difficoltà del compito
}

transformed parameters {
  array[N_subjects] real<lower=0> lambda_individual; // Parametri lambda individuali

  // Il parametro lambda individuale dipende dalla difficoltà del compito e dall'abilità
  for (i in 1:N_subjects) {
    lambda_individual[i] = lambda_global + beta_difficulty * task_difficulty[i] - ability[i];
  }
}

model {
  // Priori
  lambda_global ~ normal(1, 1);
  beta_difficulty ~ normal(0, 1);

  // Likelihood
  reaction_times ~ exponential(lambda_individual);
}
