# Developing Data Products Course Project
# By Joanna Widjaja
# L.A. City Power Usage & Bill Predictor

library(shiny)
library(rCharts)
require(data.table)
library(dplyr)
library(tidyr)
library(DT)

shinyUI(fluidPage(
  # Application title
  titlePanel("L.A. City Electricity Usage & Bill Generator"),
  
  sidebarLayout(
    sidebarPanel( 
      uiOutput("city"),
      uiOutput("rate")
    ),
    mainPanel(
      h1("About"),
      p("This application takes in historical data (2005 - 2013) from L.A. City Electricity Usage. The data is used to estimate average power consumption by City. In addition, users are able to input electricity rate and use this information to generate a monthly bill for a given year. This information helps users estimate their annual power consumption and power bill so that they can budget accordingly."),
      # br(),
#       h3("Graph of Monthly Average Electricity Usage"),
#       showOutput("chart", "polycharts"),
      h3("Table of Annual Electricity Usage and Bill"),
      tableOutput("table"),
      p("Total Annual Bill ($):"), 
      textOutput("totalBill"),
      br()
    )
  )
))