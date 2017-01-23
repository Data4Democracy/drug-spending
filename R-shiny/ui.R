#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Drug Costs"),
  
  # Sidebar with selections for the data
  fluidRow(
      column(4,
            selectInput('drug', 'pick generic name', drug_costs$drugname_generic                        ),
            submitButton('Apply Changes')),
      column(8, 
             selectInput('brand', 'Select brands', choices = NULL, selected = NULL, multiple = TRUE, width = '100%'))
  ),
  
  fluidRow(
      column(4, plotOutput("plot1")),
      column(8, plotOutput("plot2"))
  ),
  
  fluidRow(
      column(4, plotOutput("plot3")),
      column(4, plotOutput("plot4"))
      ),
  
  fluidRow(
      column(4, plotOutput("plot5")),
      column(4, plotOutput("plot6"))
  )
      
  
))

