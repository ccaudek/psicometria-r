data {
  int<lower=1> nTrials; // numero di tentativi
  array[nTrials] int<lower=1, upper=2> choice; // scelte effettuate (1 o 2)
  array[nTrials] real<lower=0, upper=1> reward; // ricompense ricevute (0 o 1)
}
transformed data {
  vector[2] initV; // valori iniziali per V
  initV = rep_vector(0.5, 2); // inizializzati a 0.5
}
parameters {
  real<lower=0, upper=1> alpha; // tasso di apprendimento
  real<lower=0> theta; // temperatura
}
model {
  vector[2] v; // valori attesi
  real delta; // errore di previsione
  
  // Priori
  alpha ~ beta(1, 1); // prior uniforme su [0, 1]
  theta ~ normal(0, 10); // prior normale con media 0 e deviazione standard 10
  
  v = initV;
  
  for (t in 1 : nTrials) {
    // Calcolo delle probabilità di scelta usando la funzione softmax con limitazione
    vector[2] logits;
    logits = theta * v;
    logits = fmin(logits, 20); // Limita i valori massimi per evitare overflow
    logits = fmax(logits, -20); // Limita i valori minimi per evitare underflow
    
    choice[t] ~ categorical_logit(logits);
    
    // Errore di previsione
    delta = reward[t] - v[choice[t]];
    
    // Aggiornamento dei valori attesi (apprendimento)
    v[choice[t]] = v[choice[t]] + alpha * delta;
  }
}
