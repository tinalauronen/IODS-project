## Tina Lauronen
## 2.2.2017
## RStudio excercise 2, analysis

## Reading the data from my local folder and checking it's ok
read.table("/Users/tlaurone/GitHub/tinalauronen/IODS-project/data/learning2014.txt", sep = "\t", header = TRUE)
dim(new_learning2014)
str(new_learning2014)

## Checking the descriptive statistics from the data
summary(new_learning2014)

## Drawing a scatter plots according to age and gender
plot(new_learning2014$Attitude, new_learning2014$Age, col=new_learning2014$gender, title("Figure 1: Attitude according to age and gender"))
plot(new_learning2014$Points, new_learning2014$Age, col=new_learning2014$gender, title("Figure 2: Exam points according to age and gender"))
plot(new_learning2014$deep, new_learning2014$Age, col=new_learning2014$gender, title("Figure 3: Deep learning according to age and gender"))
plot(new_learning2014$stra, new_learning2014$Age, col=new_learning2014$gender, title("Figure 4: Strategic learning according to age and gender"))
plot(new_learning2014$surf, new_learning2014$Age, col=new_learning2014$gender, title("Figure 5: Surface learning according to age and gender"))

library(ggplot2)
library(GGally)

## Regression model
qplot(Attitude, Points, data = new_learning2014) + geom_smooth(method = "lm")
rg_model <- lm(Points ~ Attitude + deep + stra, data = new_learning2014)
summary(rg_model)

## Leaving only the statistically significant variables
rg_model2 <- lm(Points ~ Attitude, data = new_learning2014)
summary(rg_model2)

## Diagnostic plots: 1, 2 and 5
plot(rg_model2, which = 1)
plot(rg_model2, which = 2)
plot(rg_model2, which = 5)
