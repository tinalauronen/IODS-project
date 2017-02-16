# RStudio Excercise 4: Data wrangling
# Tina Lauronen
# 16.2.2017

## Reading the data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

## Exploring the datasets
str(hd)
dim(hd) # 195 obs., 8 var.
summary(hd)

str(gii)
dim(gii) #195 obs., 10 var.
summary(gii)

## Renaming the variables
library(plyr)
names(hd)
names(hd)[1] <- "HDI_rank" 
names(hd)[2] <- "Country" 
names(hd)[3] <- "HDI" 
names(hd)[4] <- "Life_e" 
names(hd)[5] <- "Educ_e" 
names(hd)[6] <- "Educ_mean" 
names(hd)[7] <- "GNI"  
names(hd)[8] <- "GNI_HDI"
names(hd)
str(hd)

names(gii)
names(gii)[1] = "GII_rank"
names(gii)[2] = "Country"
names(gii)[3] = "GII"
names(gii)[4] = "MM_ratio"
names(gii)[5] = "Ad_birth_rate"
names(gii)[6] = "Rep_parl"
names(gii)[7] = "Educ_sec_F"
names(gii)[8] = "Educ_sec_M"
names(gii)[9] = "Labour_F"
names(gii)[10] = "Labour_M"
names(gii)

## Creating two new variables
### Ratio of female and male populations with secondary education
gii$Educ_sec_FM_ratio <- (gii$Educ_sec_F / gii$Educ_sec_M)

### Ratio of female and male populations participating labour
gii$Labour_FM_ratio <- (gii$Labour_F / gii$Labour_M)

### Checking the data
str(gii)

## Joining the two datasets
human <- inner_join(hd, gii, by = "Country")

names(human)
str(human)
dim(human)

write_csv(human, "/Users/tlaurone/GitHub/tinalauronen/IODS-project/data/human.csv")
