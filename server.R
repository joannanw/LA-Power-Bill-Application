# Developing Data Products Course Project
# By Joanna Widjaja
# L.A. City Power Usage & Bill Predictor

library(shiny)
library(rCharts)
require(data.table)
library(dplyr)
library(tidyr)
library(DT)

source("process_data.R")
city <- sort(unique(finData$City))
rate <- 0.117

shinyServer(
  function(input, output) {
    
    output$city <- renderUI({
      selectInput(inputId = "cityId", label = "Select City", choices = as.list(city))
    })
   
    output$rate <- renderUI({
      textInput(inputId = "rateId", label = "Electricity Rate (Cents per kWh)", value = rate)
    })
    
#     output$chart <- renderChart({
#       city <- input$cityId
#       data <- groupByCity(finData, input$cityId, as.numeric(input$rateId))
#       p1 <- nPlot(`Avg Power Use` ~ Month, data = data, type = "bar")
# #       p1$layer(`Avg Power Use` ~ Month, 
# #                data = data, type = 'bar', size = list(const = 3))
#       p1$addParams(height = 300, dom = 'chart1', 
#                    title = "")
# #       p1$guides(x = list(title = "Month", ticks = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")))
# #       p1$guides(y = list(title = "in kWh", max = 18))
#       return(p1)
#     })
    
    
    output$table <- renderTable({
      if(is.null(input$cityId)) return ()
      
      data <- groupByCity(finData, input$cityId, as.numeric(input$rateId))
      
    })
    
    output$totalBill <- renderText({
      data <- getTotalBill(finData, input$cityId, as.numeric(input$rateId))
    })
  }
)

