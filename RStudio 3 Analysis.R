## IODS RStudio Exercise 3
## Tina Lauronen
## 9.2.2017

# Reading the joined student alcohol consumption data from my local folder
alc <- read.csv("/Users/tlaurone/GitHub/tinalauronen/IODS-project/data/alc.csv")
alc
str(alc)

# Print the variable names
colnames(alc)

# Install and acces to libraries
install.packages("tidyr")
install.packages("gmodels")
library(tidyr); library(dplyr); library(ggplot2); library(gmodels)

# Exploring the variables
summary(alc)
qplot(sex, data = alc, color = high_use)
qplot(Medu, data = alc, color = high_use, main = "Figure 1: Mother's education")
qplot(goout, data = alc, color = high_use, main = "Figure 2: Going out with friends")
qplot(romantic, data = alc, color = high_use, main = "Figure 3: Having romantic relationship")

# Crosstabulation
CrossTable(alc$high_use, alc$sex, prop.r = TRUE, prop.c = TRUE, prop.t = FALSE, prop.chisq = FALSE, chisq = TRUE)
help("CrossTable")
help("barplot")

# Regression model
r_model <- glm(high_use ~ sex + Medu + goout + romantic, data = alc, family = "binomial")
summary.glm(r_model)
OR <- coef(r_model) %>% exp
CI <- confint(r_model) %>% exp
cbind(OR, CI)

## Prediction
r_m <- glm(high_use ~ sex + goout, data = alc, family = "binomial")
probabilities <- predict(r_m, type = "response")
alc <- mutate(alc, probability = probabilities)
alc <- mutate(alc, prediction = (probability > 0.5))

## Table
table(high_use = alc$high_use, prediction = alc$prediction)

## Plot
g <- ggplot(alc, aes(x = probability, y = high_use, col = prediction))
g + geom_point()

## Training error: making the function
loss_func <- function(class, prob) {
  n_wrong <- abs(class - prob) > 0.5
  mean(n_wrong)
}

# Calling the function
loss_func(class = alc$high_use, prob = alc$probability)

## K-fold cross-validation
install.packages("boot")
library(boot)
cv <- cv.glm(data = alc, cost = loss_func, glmfit = r_m, K = 10)
cv$delta[1]
