data {
  int<lower=0> Nb;  // # obs in RCT treatment B
  int<lower=0> Nh;  // # obs in historical control data
  vector[Nb] yb;    // vector of tx=B data
  vector[Nh] yh;    // vector of historical data
  real<lower=0> sigma;  // standard deviation of prior for bias
}
parameters {
  real mua;  // unknown mean for tx=A
  real mub;  // unknown mean for tx=B
  real bias; // unknown bias
}
transformed parameters {
  real delta;
  delta = mua - mub;
}
model {
  yb   ~ normal(mub, 1.0);
  yh   ~ normal(mua + bias, 1.0);
  bias ~ normal(0., sigma);
}

