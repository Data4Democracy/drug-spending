
library(shiny)
library(ggplot2)

GPLOT_WIDTH <- 400

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    dataset <- reactive({
        drug_costs[drug_costs$drugname_generic == input$drug, ]
        
    })
   
    output$plot1 <- renderPlot({
        
        # make user count plot
        g <- ggplot(dataset(), aes_string(x=dataset()$year, y=dataset()$user_count, color = as.factor(dataset()$drugname_brand)))
        g <- g + geom_point() + geom_line() + theme(legend.position = "none") + labs(x = "Year", y = "No. Users")
        
        print(g)
    })
  
    output$plot2 <- renderPlot({
        
        # make claim/user plot
        g <- ggplot(dataset(), aes_string(x=dataset()$year, y=dataset()$claim_count/dataset()$user_count, color = as.factor(dataset()$drugname_brand)))
        g <- g + geom_point() + geom_line() + labs(color = 'Drug brands', x = "Year", y ="avg Claim/User")
        
        print(g)
    })
    
    output$plot3 <- renderPlot({
        
        # make total spending plot
        #ggplot obj
        g <- ggplot(dataset(), aes_string(x=dataset()$year, y=dataset()$total_spending, color = as.factor(dataset()$drugname_brand)))
        #plot features
        g <- g + geom_point() + goem_line() + theme(legend.position = "none") + labs(x = "Year", y = "Total spending")
        
        print(g)
        #print plot
        
        
    })
    

})
