library(shiny)


shinyUI(fluidPage(
  
  titlePanel("Drug Costs"),
  
  fluidRow(
      column(4,
            selectInput('drug', 'pick generic name', drug_costs$drugname_generic                        ),
            submitButton('Apply Changes')),
      column(8, 
             selectInput('brand', 'Select brands', choices = NULL, selected = NULL, multiple = TRUE, width = '100%'))
  ) # row for selecting user options
  ,
  
  fluidRow(
      column(4, plotOutput("plot1")),
      column(8, plotOutput("plot2"))
  ) # first row of plots (second column is wider to allow for the legend to fit)
  ,
  
  fluidRow(
      column(4, plotOutput("plot3")),
      column(4, plotOutput("plot4"))
  ) # second row of plots
  ,
  
  fluidRow(
      column(4, plotOutput("plot5")),
      column(4, plotOutput("plot6"))
  ) # third row of plots
      
  
))

