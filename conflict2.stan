data {
  int<lower=0> N;
  real x1[N];
  real x2[N];
  real x3[N];
  real x4[N];
  real x5[N];
  real x6[N];
  real x7[N];
  int<lower=0,upper=1> y[N];
}
parameters {
  real b0;
  real b1;
  real b2;
  real b3;
  real b4;
  real b5;
  real b6;
  real b7;
}
model {
  for (n in 1:N) 
    y[n] ~ bernoulli(inv_logit(b0 + b1*x1[n] + b2*x2[n] + b3*x3[n] + b4*x4[n] + b5*x5[n] + b6*x6[n] + b7*x7[n]));
}
