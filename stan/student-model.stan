data {
    int<lower=1> N;  // Numero totale di prove
    vector[N] y;  // Punteggio in ciascuna prova
}
transformed data {
    real y_mean = mean(y);  // Media dei dati osservati
    real y_sd = sd(y);  // Deviazione standard dei dati osservati
}
parameters {
    real mu_raw;  // Parametro latente standardizzato per mu
    real<lower=0> sigma_raw;  // Parametro latente standardizzato per sigma
    real<lower=1> nu;  // Gradi di libertà per la distribuzione t di Student
}
transformed parameters {
    real mu;  // Media sulla scala originale
    real<lower=0> sigma;  // Deviazione standard sulla scala originale
    mu = y_mean + y_sd * mu_raw;
    sigma = y_sd * sigma_raw;
}
model {
    // Distribuzioni a priori non centrate
    mu_raw ~ normal(0, 1);
    sigma_raw ~ normal(0, 1);
    nu ~ exponential(1.0 / 30.0);  // Prior esponenziale per i gradi di libertà
    // Verosimiglianza
    y ~ student_t(nu, mu, sigma);
}
generated quantities {
    vector[N] y_rep;
    for (n in 1:N) {
        y_rep[n] = student_t_rng(nu, mu, sigma);
    }
}
