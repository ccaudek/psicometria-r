data {
  int<lower=1> N; // numero totale di osservazioni 
  vector[N] y; // variabile di risposta
  vector[N] x; // variabile predittore
}
parameters {
  real alpha; // intercetta
  real beta; // coefficiente angolare
  real<lower=0> sigma; // deviazione standard residua
}
model {
  // distribuzioni a priori
  alpha ~ normal(0, 5.0);
  beta ~ normal(0, 2.5);
  sigma ~ cauchy(0, 5.0);
  // verosimiglianza
  y ~ normal(alpha + beta * x, sigma);
}
