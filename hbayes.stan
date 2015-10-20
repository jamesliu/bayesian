data {
  int<lower=0> N; // sample size
  int<lower=0> y[N]; // the number of survived seeds for each set of 8 seeds (dependent variable) 
}
parameters {
  real beta; // a coefficient of logistic regression model common across all individual seeds
  real r[N]; // individual bias (random effects), perhaps given from the number of leaves of each plant
  real<lower=0> s; // individual deviation
}
transformed parameters {
  real q[N];
  for (i in 1:N)
    q[i] <- inv_logit(beta+r[i]); // inverse logit of survival probability
}
model {
  for (i in 1:N)
    y[i] ~ binomial(8,q[i]); // logistic regression using binomial sampling
  beta~normal(0,1.0e+2); // uninformative prior of coefficient
  for (i in 1:N)
    r[i]~normal(0,s); // hierarchical prior of individual bias (random effects)
  s~uniform(0,1.0e+4); // uninformative prior for r[i]
}
