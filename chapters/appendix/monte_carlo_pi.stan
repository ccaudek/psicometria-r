
generated quantities {
  real x = uniform_rng(0, 1);
  real y = uniform_rng(0, 1);
  int inside = x^2 + y^2 <= 1;
  real pi_estimate = 4 * inside;
}

