############ PH 250C: Missing Data
############ Patrick Bradshaw
############ 15 April 2017

require("blm")
require("geepack")
require("mi")
library("R2jags")
library("coda")


########## DATA GENERATION
set.seed(111404)
##### Generate exposure/covariate variables
N <- 1500 # Number of observations
### Normally distributed confounder
Z <- rbinom(N,1,.5) # Binomial, p=0.5
### Binomial exposure, dependent on Z:
# px <- expit(-.5 + 2*Z)
px <- .5
X <- rbinom(N,1,px)
table(X)
### Binary outcome
py <- expit(-1 + X - Z)
Y <- rbinom(N,1,py)

# Generate missingness indicator (missing at random)
p.miss <- expit(-1 + .5*Z - 5*Y)
R <- rbinom(N,1,1-p.miss) # Generate indicator of observed =1
table(R)

X.miss <- X
X.miss[R==0] <- NA # If not observed set to missing (NA)

########## ANALYSIS

##### "True" analysis
summary(glm(Y~X+Z, family = binomial(link="logit")))

##### Complete-case analysis
summary(glm(Y~X.miss+Z, family = binomial(link="logit")))

##### Inverse probability weighting
model.r <- glm(R~Z+Y, family=binomial) # Model for observed/missing
phat.r <- predict(model.r, type="response") # Predicted probability of observed
w <- 1/phat.r # Weight according to probability of being observed
w[R==0] <- 1 # Replace weight on unobserved obs.
id <- 1:length(Y)

data.cc <- na.omit(as.data.frame(cbind(Y,X.miss,Z,w,id)))

summary(geeglm(Y ~ X.miss + Z, family=binomial(link="logit"), weights = w, id=id, 
               data=data.cc, std.err='san.se', corstr="exchangeable"))

##### Multiple Imputation
# Make a data frame with all variables for missing data analysis
data.all <- as.data.frame(cbind(Y,X.miss,Z,w,id))

to.drop <- names(data.all) %in% c("w","id")
mdf <- missing_data.frame(data.all[!to.drop])
show(mdf)
summary(mdf)

imputations <- mi(mdf, n.iter=50, n.chains=20)
round(mipply(imputations, mean, to.matrix = TRUE), 3)
Rhats(imputations)

analysis <- pool(Y~X.miss+Z, data=imputations, family=binomial)
summary(analysis)

##### Bayesian Modeling of Missing Data

### Bayesian logistic regression
logistic.model <- function() {
  # SAMPLING DISTRIBUTION
  for (i in 1:N) {
    logit(p[i]) <- b[1] + b[2]*X[i] + b[3]*Z[i];
    Y[i] ~ dbin(p[i],1);  
    
    # DISTRIBUTION ON COVARIATE WITH MISSING DATA:
    logit(p.x[i]) <- a[1] + a[2]*Z[i];
    X[i] ~ dbin(p.x[i],1);
  }
  
  # PRIORS ON BETAS
  b[1:N.y] ~ dmnorm(mu.b[1:N.y],tau.b[1:N.y,1:N.y]) # multivariate normal prior

  # PRIORS ON ALPHAS
  a[1:N.x] ~ dmnorm(mu.a[1:N.x],tau.a[1:N.x,1:N.x]) # multivariate normal prior
  
  # # Calculate ORs:
  # for (l in 1:N.y) {
  #   OR[l] <- exp(b[l]);
  # }
}

N <- length(Y) # Number of observations
N.y <- 3 # Number of slope parameters in model for Y
N.x <- 2 # Number of slope parameters in model for X (variable with missingness)

# Data, parameter list and starting values
mu.b <- rep(0,N.y)
tau.b <- diag(0.001,N.y)

mu.a <- rep(0,N.x)
tau.a <- diag(0.001, N.x)

data.logistic <- list("N", "N.y", "N.x", "Y", "X", "Z", "mu.b", "tau.b", "mu.a", "tau.a")
parameters.logistic <-c("b","a") # Parameters to keep track of
inits.logistic <- function() {list (b= rep(0,N.y, a=rep(0,N.x)))}

set.seed(114011)
logistic.sim<-jags(data=data.logistic,inits=inits.logistic,parameters.logistic,n.iter=100000,
                   n.burn=50000, model.file=logistic.model, n.thin=5, n.chains = 3)

print(logistic.sim,2)

logistic.mcmc <- as.mcmc(logistic.sim)

plot(logistic.mcmc)
autocorr.diag(logistic.mcmc)
autocorr.plot(logistic.mcmc[1]) # ACF for chain 1
autocorr.plot(logistic.mcmc[2]) # ACF for chain 2
autocorr.plot(logistic.mcmc[3]) # ACF for chain 3

geweke.diag(logistic.mcmc)
