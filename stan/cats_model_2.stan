data {
  int N;
  array[N] int adopted; // 1/0 indicator (adopted = 1, only adopted cats considered)
  array[N] int days; // days until event (adoption)
  array[N] int color; // 1 = black, 2 = other
}
parameters {
  vector<lower=0, upper=1>[2] p; // Probabilità di adozione per ciascun colore
}
model {
  p ~ beta(1, 10); // Prior sulla probabilità di adozione
  
  for (i in 1 : N) {
    if (adopted[i] == 1) {
      // Consideriamo solo i gatti adottati
      real P = p[color[i]]; // Probabilità di adozione per il colore del gatto
      target += log((1 - P) ^ (days[i] - 1) * P); // Verosimiglianza per l'adozione
    }
  }
}
