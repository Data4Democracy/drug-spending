
library(shiny)
library(ggplot2)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    dataset <- reactive({
        drug_costs[drug_costs$drugname_generic == input$drug, ]
        
    })
   
    output$plot <- renderPlot({
        
        g <- ggplot(dataset(), aes_string(x=input$x, y=input$y, color = as.factor(dataset()$drugname_brand)))
        g <- g + geom_point() + geom_smooth(method = lm)
        
        print(g)
  })
  
})
