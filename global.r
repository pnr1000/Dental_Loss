library(readr)
library(dplyr)
library(shiny)
library(ggplot2)
library(plotly)
library(metricsgraphics)
#library(plyr)

#setwd("/Users/Phoebe/Desktop/R Scripts")
teeth <- read_csv("Dental.csv")
teeth <- tbl_df(teeth)

#putting the business type column into readable values
x <- table(teeth$`Business Type`)
lut <- c("L" = "Life", "P" = "Property/Casualty", "X" = "Health")
teeth$Business <- lut[teeth$`Business Type`]


#subsetting the regions
y <- table(teeth$Domicile)
lut <- c("ME" = "NewEngland","NH" = "NewEngland","MA" = "NewEngland", 
         "CT" = "NewEngland","VT" = "NewEngland","RI" = "NewEngland", 
         "NY" = "Atlantic", "NJ" = "Atlantic", "PR" = "Atlantic", 
         "PA" = "Midatlantic", "MD" = "Midatlantic", "DE" = "Midatlantic", 
         "DC" = "Midatlantic", "WV" = "Midatlantic", "VA" = "Midatlantic", 
         "KY" = "Southeast", "TN" = "Southeast", "MS" = "Southeast", 
         "AL" = "Southeast", "GA" = "Southeast", "FL" = "Southeast", 
         "SC" = "Southeast", "NC" = "Southeast", "OH" = "Greatlakes", 
         "MI" = "Greatlakes", "IN" = "Greatlakes", "IL" = "Greatlakes", 
         "WI" = "Greatlakes", "MN" = "Greatlakes", "TX" = "Southcentral", 
         "LA" = "Southcentral", "AR" = "Southcentral", "OK" = "Southcentral", 
         "NM" = "Southcentral", "NE" = "Greatplains", "KS" = "Greatplains", 
         "IA" = "Greatplains", "MO" = "Greatplains","ND" = "Rockys", 
         "SD" = "Rockys", "MT" = "Rockys", "WY" = "Rockys", "UT" = "Rockys", 
         "CO" = "Rockys", "NV" = "Pacific", "HI" = "Pacific", "AZ" = "Pacific", 
         "CA" = "Pacific", "GU" = "Pacific", "WA" = "Pacificnw", "ID" = "Pacificnw", 
         "OR" = "Pacificnw", "AK" = "Pacificnw")
teeth$Region <- lut[teeth$Domicile]

#converting columns with large values into smaller values for better visualizations
teeth$Premiums <- teeth$Premiums/1000000
teeth$Payments <- teeth$Payments/1000000
teeth$Members <- teeth$Members/1000000
teeth$MM <- teeth$`Member Months`/1000000

#changing a long column name to a shorter, more managable name
teeth$Avg <- teeth$`Average Amount of Premiums per Member per Month`

teeth <- tbl_df(teeth)