## IODS RStudio excercise 3: Logistic regression
## Data wrangling: https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION
## 9.2.2017 
## Tina Lauronen

# Reading two datasets and checking the structure and dimensions

por <- read.csv("/Users/tlaurone/GitHub/tinalauronen/IODS-project/student/student-por.csv", sep = ";", header = TRUE)
str(por)
dim(por)

mat <- read.csv("/Users/tlaurone/GitHub/tinalauronen/IODS-project/student/student-mat.csv", sep = ";", header = TRUE)
str(mat)
dim(mat)

# Acces dplyr library
library(dplyr)

# Selecting the variables for joining two datasets
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

# Joining to datasets to create set "por-mat"
por_mat <- inner_join(por, mat, by = join_by, suffix = c(".por", ".mat"))
str(por_mat)
dim(por_mat)

# Creating a data frame with only joined variables
alc <- select(por_mat, one_of(join_by))

# Naming the columns not joined
notjoined_columns <- colnames(por)[!colnames(por) %in% join_by]
notjoined_columns

# Combinig the duplicated answers with for loop and if-else structure
for(column_name in notjoined_columns) { # defining the loop
  two_columns <- select(por_mat, starts_with(column_name)) # selecting columns with the same name
  first_column <- select(two_columns, 1)[[1]] # selecting the first column
  
  if(is.numeric(first_column)) { # if the first column is numeric...
    alc[column_name] <- round(rowMeans(two_columns)) # ...we take avergae...
  } else { # ...and if it is not numeric...
    alc[column_name] <- first_column # ...we select the first of the columns
  }
}

colnames(alc)

# acces ggplot2
library(ggplot2)

# Creating a new variable "alc_use" measuring alcohol consumption by taking average of two variable
# alc_use is average of daily and weekly alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# Creating new dichotomous variable "high_use". High_use is true if alc_use > 2
alc <- mutate(alc, high_use = (alc_use > 2))

# Checking the data set works correctly: 35 variables and 382 observations
glimpse(alc)
write.csv(alc, "/Users/tlaurone/GitHub/tinalauronen/IODS-project/data/alc.csv")
