data {
  int<lower=0> N1; // Numero di osservazioni nel gruppo 1
  int<lower=0> N2; // Numero di osservazioni nel gruppo 2
  vector[N1] y1; // Dati del gruppo 1
  vector[N2] y2; // Dati del gruppo 2
}
parameters {
  real mu1; // Media del gruppo 1
  real delta; // Differenza tra le medie
  real<lower=0> sigma; // Deviazione standard comune
  real<lower=0> nu; // Gradi di libertà per la distribuzione t
}
transformed parameters {
  real mu2; // Media del gruppo 2
  mu2 = mu1 + delta;
}
model {
  // Priori
  mu1 ~ normal(0, 5);
  delta ~ normal(0, 2); // Priore su delta
  sigma ~ cauchy(0, 5);
  nu ~ gamma(2, 0.1); // Priore sulla t-student
  
  // Verosimiglianza
  y1 ~ student_t(nu, mu1, sigma);
  y2 ~ student_t(nu, mu2, sigma);
}
generated quantities {
  real diff; // Differenza tra le medie (alias di delta per chiarezza)
  diff = delta;
}
