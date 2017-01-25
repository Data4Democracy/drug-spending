
library(shiny)
library(ggplot2)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    observe({
    drug <- input$drug # generic drug name
    brand <- input$brand # selected drug brands 
    
    dataset <- drug_costs[drug_costs$drugname_generic == drug,] # select from drug_costs based on generic drug selection
    
    updateSelectInput(session, "brand",
                      choices = unique(dataset$drugname_brand),
                      selected = unique(dataset$drugname_brand)
    ) # update the Select input$brand options
    
    if(!is.null(brand)){
       dataset <- dataset[dataset$drugname_brand %in% brand,]
    } # allows first selection to show all drugs in that drug. TODO still need to do the same when switching drugs
    
        output$plot1 <- renderPlot({
            
            # make user count plot
            g <- ggplot(dataset, aes_string(x=dataset$year, y=dataset$user_count, color = as.factor(dataset$drugname_brand)))
            g <- g + geom_point() + geom_line() + theme(legend.position = 'none') + labs(x = 'Year', y = 'No. Users')
            
            print(g)
        })
    
        output$plot2 <- renderPlot({
            
            # make claim/user plot
            g <- ggplot(dataset, aes_string(x=dataset$year, y=dataset$claim_count/dataset$user_count, color = as.factor(dataset$drugname_brand)))
            g <- g + geom_point() + geom_line() + labs(color = 'Drug brands', x = 'Year', y ='avg Claim/User')
            
            print(g)
        })
        
        output$plot3 <- renderPlot({
            
            # make total spending plot
            g <- ggplot(dataset, aes_string(x=dataset$year, y=dataset$total_spending, color = as.factor(dataset$drugname_brand)))
            g <- g + geom_point() + geom_line() + theme(legend.position = 'none') + labs(x = 'Year', y = 'Total spending')
            print(g)
        })
        
        #make output$plot4
        output$plot4 <- renderPlot({
            #Avg spending/user
            g <- ggplot(dataset, aes_string(x = dataset$year, y= dataset$total_spending_per_user, color = as.factor(dataset$drugname_brand)))
            g <- g + geom_point() + geom_line() + theme(legend.position = 'none') + labs(x = 'Year', y = 'Total spending/User')
            print(g)
        })
        
        #make output$plot5
        output$plot5 <- renderPlot({
            #Avg out of pocket per lowincome user
            g <- ggplot(dataset, aes_string(x = dataset$year, y = dataset$out_of_pocket_avg_lowincome, color = as.factor(dataset$drugname_brand)))
            g <- g + geom_point() + geom_line() +  theme(legend.position = 'none') + labs(x = 'Year', y = 'Avg Out of Pocket Cost', title = 'Low Income')
            print(g)
        })
    
        #make output$plot6
        output$plot6 <- renderPlot({
            #Avg out of pocket per non lowincome user
            g <- ggplot(dataset, aes_string(x = dataset$year, y = dataset$out_of_pocket_avg_non_lowincome,
                                              color = as.factor(dataset$drugname_brand)))
            g <- g + geom_point() + geom_line() + theme(legend.position = 'none') + labs(x = 'Year', y = 'Avg Out of Pocket Cost', title = "Non-Low Income")
            print(g)
        })
    })
})
