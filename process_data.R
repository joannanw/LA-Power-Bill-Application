# Developing Data Products Course Project
# By Joanna Widjaja
# L.A. City Power Usage & Bill Predictor

library(shiny)
library(rCharts)
require(data.table)
library(dplyr)
library(tidyr)
library(DT)

# Read power data
data <- fread("./data/Water_and_Electric_Usage_from_2005_-_2013.csv")
data$`Zip Code` <- substr(data$`Zip Code`,1,5)
# Take only power data
data <- data[,-4, with = FALSE]
# Process Year and Month
data$`Text Date` <- substr(data$`Text Date`,5,8)
data$`Value Date` <- substr(data$`Value Date`,1,3)
# Rename column
setnames(data, old = names(data), new = c("Year", "Month", "Zipcode", "Power Use"))

# Read zipcode and city data
zipcode <- fread("./data/free-zipcode-database-Primary.csv")
# Take only zipcode, city, and state
zipcode <- zipcode[,.(Zipcode, City, State)]
# Match zipcode to city 
finData <- merge(x = data, y = zipcode, by = "Zipcode")
# Set Month to 1 - 12
finData$Month <- sapply(finData$Month, switch, Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6, Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12)

# Helper functions

#' Aggregate dataset by year
#' 
#' @param dt data.table
#' @param city
#' @return result data.table

#Find average group by city
groupByCity <- function(dt, city, rate) {
  result <- (dt %>% filter(City == city) %>% gather(variable, value, -Zipcode, -Year, -Month, -State, -City)
            %>% group_by(City, Month) %>% summarise(`Avg Power Use` = mean(value, na.rm = TRUE))
            %>% mutate(Bill = `Avg Power Use` * rate) %>% arrange(Month))
  result$Month <- format(result$Month, nsmall = 0)
  return(result)
}


getTotalBill <- function(dt, city, rate){
  result <- (dt %>% filter(City == city) %>% gather(variable, value, -Zipcode, -Year, -Month, -State, -City)
             %>% group_by(City, Month) %>% summarise(`Avg Power Use` = mean(value, na.rm = TRUE))
             %>% mutate(Bill = `Avg Power Use` * rate) %>% arrange(Month))
  totalBill <- format(sum(result$Bill), nsmall = 2)
  return(totalBill)
}


#' Plot graph of power usage by Month
#' 
#' @param dt data.table
#' @param dom
#' @param xAxisLabel month
#' @param yAxisLabel power usage
#' @return plot
# 
# plotDataByCity <- function(dt, dom = "UsageByMonth", 
#                                 xAxisLabel = "Month",
#                                 yAxisLabel = "in kWh") {
#   
#   plotDataByCityAvg <- nPlot(
#     avg.value ~ Month,
#     data = dt,
#     type = "multiBarChart",
#     dom = dom, width = 650
#   )
#   plotDataByCityAvg$chart(margin = list(left = 100))
#   plotDataByCityAvg$chart(color = c('orange', 'blue', 'green'))
#   plotDataByCityAvg$yAxis(axisLabel = yAxisLabel, width = 80)
#   plotDataByCityAvg$xAxis(axisLabel = xAxisLabel, width = 70)
#   plotDataByCityAvg
  
  
  
  
# }

# ggplot(result, aes(Month, avg.value)) + geom_bar(stat = "identity") + scale_x_discrete(limits=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))

