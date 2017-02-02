## Tina Lauronen
## 1.2.2017
## RStudio exercise 2, Data wrangling

## Data read and named learning2014
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header = TRUE)

## Data consists of 184 rows (observations) and 
# 60 columns (variables)
dim(learning2014)

## The structure of the data
str(learning2014)

## Acces the dplyr library
library(dplyr)

## Combinig the questions related to learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D07","D14","D22","D30")
surface_questions <-c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

## Selecting the columns for "deep" and taking average
deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$deep <- rowMeans(deep_columns)

## Selecting the columns for "surf" and taking average
surface_columns <- select(learning2014, one_of(surface_questions))
learning2014$surf <- rowMeans(surface_columns)

## Selecting the columns for "stra" and taking average
strategic_columns <- select(learning2014, one_of(strategic_questions))
learning2014$stra <- rowMeans(strategic_columns)

## Selecting the variables to dataset
keep_columns <- c("gender", "Age", "Attitude", "deep", "stra", "surf", "Points")
new_learning2014 <- select(learning2014, one_of(keep_columns))

## Removing the observations with 0 points
new_learning2014 <- filter(new_learning2014, Points > 0)

## Testing
new_learning2014
dim(new_learning2014)
str(new_learning2014)

## Saving the dataset
write.table(new_learning2014, "learning2014.txt", sep = "\t")

## Reading the set again
read.table("/Users/tlaurone/GitHub/tinalauronen/IODS-project/data/learning2014.txt", sep = "\t", header = TRUE)

str(new_learning2014)
dim(new_learning2014)
head(new_learning2014)
