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
  sidebarLayout(
    sidebarPanel(
        selectInput('drug', 'pick generic name', drug_costs$drugname_generic),
        selectInput('x', 'pick x variable', names(drug_costs)),
        selectInput('y', 'pick y variable', names(drug_costs)),
        submitButton('Apply Changes')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("plot")
    )
  )
))
