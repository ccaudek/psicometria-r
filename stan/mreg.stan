data {
    int<lower=1> N;   // Numero di osservazioni
    int<lower=1> K;   // Numero di variabili indipendenti, intercetta inclusa
    vector[N] x1;     // Prima variabile indipendente
    vector[N] x2;     // Seconda variabile indipendente
    vector[N] x3;     // Seconda variabile indipendente
    // Aggiungi altri vettori se ci sono più variabili indipendenti
    vector[N] y;      // Vettore della variabile dipendente
}
parameters {
    real alpha;           // Intercetta
    real beta1;           // Coefficiente per la prima variabile indipendente
    real beta2;           // Coefficiente per la seconda variabile indipendente
    real beta3;           // Coefficiente per la terza variabile indipendente
    // Definisci altri real per ulteriori coefficienti
    real<lower=0> sigma;  // Errore del modello
}
model {
    // Prior
    alpha ~ student_t(3, 0, 2.5);
    beta1 ~ student_t(3, 0, 2.5);
    beta2 ~ student_t(3, 0, 2.5);
    beta3 ~ student_t(3, 0, 2.5);
    // Definisci prior per altri coefficienti
    sigma ~ exponential(1);

    // Likelihood
    for (n in 1:N) {
        y[n] ~ normal(alpha + beta1 * x1[n] + beta2 * x2[n] + + beta3 * x3[n], sigma);
        // Aggiungi termini per altri coefficienti se necessario
    }
}
generated quantities {
    vector[N] log_lik; // Log-likelihood per ogni osservazione
    vector[N] y_rep;  // Predizioni posteriori per ogni osservazione

    for (n in 1:N) {
        log_lik[n] = normal_lpdf(y[n] | alpha + beta1 * x1[n] + beta2 * x2[n] + + beta3 * x3[n], sigma);
        // Aggiungi termini per altri coefficienti se necessario
        y_rep[n] = normal_rng(alpha + beta1 * x1[n] + beta2 * x2[n] + beta3 * x3[n], sigma);
        // Aggiungi termini per altri coefficienti se necessario
    }
}
