## Installing MASS package, acces to it, data "Boston"
install.packages("MASS")
library(MASS)
install.packages("corrplot")
library(corrplot)
install.packages("tidyverse")
library(tidyverse)
library(ggplot2)
data("Boston")

## Exploring the dataset
str(Boston)
dim(Boston)

## Graphical overview
pairs(Boston)
hist(Boston$crim)

## Summary
summary(Boston)

## Correlations
cor_matrix <- cor(Boston)
corrplot(cor_matrix, method = "circle", type = "upper", cl.pos = "b", tl.pos = "d", tl.cex = 0.6 )

## Scaling
boston_scaled <- scale(Boston)
summary(boston_scaled)
boston_scaled <- as.data.frame(boston_scaled)

## Categorical variable: crime rate (quantiles)
scaled_crim <- boston_scaled$crim #saving the variable
summary(scaled_crim) #checking...
bins <- quantile(scaled_crim) #create a quantile vector of crim
bins
crime <- cut(scaled_crim, breaks = bins, include.lowest = TRUE, #create categorical variable
             label = c("low", "med_low", "med_high", "high"))
table(crime)
boston_scaled <- dplyr::select(boston_scaled, -crim) #remove original crim
boston_scaled <- data.frame(boston_scaled, crime) #add the new categorical crime

## Dividing the set to train and test sets 80/20
n <- nrow(boston_scaled) #number of rows in Boston dataset
ind <- sample(n, size = n * 0.8) # choose randomly 80% of them
train <- boston_scaled[ind,] #create training set
test <- boston_scaled[-ind,] #create testing set
correct_classes <- test$crime #save correct classes from test data
test <- dplyr::select(test, -crime) #remove crime from test data

## LDA on the train set, LDA (bi)plot
lda.fit <- lda(crime ~ ., data = train) #LDA analysis
lda.fit #print

#the function
lda.arrows <- function(x, myscale = 1, arrow_heads = 0.1, color = "red", tex = 0.75, choises = c(1,2)){
    heads <- coef(x)
    arrows(x0 = 0, y0 = 0,
           x1 = myscale * heads[,choises[1]],
           y1 = myscale * heads[,choises[2]], col = color, length = arrow_heads)
    text(myscale * heads[,choises], labels = row.names(heads),
         cex = tex, col = color, pos = 3)
}

lda.arrows

classes <- as.numeric(train$crime) #target classes as numeric

# plotting the results
plot(lda.fit, dimen = 2)
plot(lda.fit, dimen = 2, col = classes, pch = classes)

lda.arrows(lda.fit, myscale = 1)

## Predicting the classes + crosstabulation

lda.pred <- predict(lda.fit, newdata = test)
table(correct = correct_classes, predicted = lda.pred$class)


## K-MEANS
#reload dataset
data(Boston)
#standardize the set
stand_boston <- scale(Boston)
summary(stand_boston)
#calculate the distances between the observations
dist_eu <- dist(stand_boston)
summary(dist_eu)
#k-means algorithm
km <- kmeans(dist_eu, centers = 4)
pairs(Boston, col = km$cluster)
#WCSS
set.seed(123)
k_max <- 10
twcss <- sapply(1:k_max, function(k){kmeans(dist_eu, k)$tot.withinss})
plot(1:k_max, twcss, type = "b")

km <- kmeans(dist_eu, centers = 2)
pairs(Boston, col = km$cluster)


