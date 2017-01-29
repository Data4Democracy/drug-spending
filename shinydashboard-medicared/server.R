library(shinydashboard)
library(ggplot2)
library(plotly)

shinyServer(
  function(input, output, session){

  # observe({
    # drug <- input$drug # generic drug name
    # brand <- input$brand # selected drug brands

    ## Use only data for selected generic
    dataset <- reactive({
      drug_costs[drug_costs$drugname_generic == input$drug,]
    })

    # updateSelectInput(session, "brand",
    #                   choices = unique(dataset$drugname_brand),
    #                   selected = unique(dataset$drugname_brand)
    # ) # update the Select input$brand options

    # if(!is.null(brand)){
    #   dataset <- dataset[dataset$drugname_brand %in% brand,]
    # } # allows first selection to show all drugs in that drug. TODO still need to do the same when switching drugs

    ## User counts
    output$userCounts <- renderPlotly({
      g <- ggplot(dataset(), aes(x = year, y = user_count, color = drugname_brand)) +
        geom_point() +
        geom_line() +
        theme(legend.position = 'none') +
        labs(x = 'Year', y = 'Number of Users')

      ggplotly(g)
    })

    ## Average number of claims per user
    output$avgClaimsPerUser <- renderPlotly({
      g <- ggplot(dataset(),
                  aes(x = year, y = (claim_count / user_count), color = as.factor(drugname_brand))) +
        geom_point() +
        geom_line() +
        labs(color = 'Drug brands', x = 'Year', y ='Average Claims Per User')

      ggplotly(g)
    })

    ## Total spending
    output$totalSpending <- renderPlotly({
      g <- ggplot(dataset(), aes(x = year, y = total_spending, color = as.factor(drugname_brand))) +
        geom_point() +
        geom_line() +
        theme(legend.position = 'none') +
        labs(x = 'Year', y = 'Total spending')
      ggplotly(g)
    })

    ## Average spending per user
    output$avgCostPerUser <- renderPlotly({
      g <- ggplot(dataset(),
                  aes(x = year, y = total_spending_per_user, color = as.factor(drugname_brand))) +
        geom_point() +
        geom_line() +
        theme(legend.position = 'none') +
        labs(x = 'Year', y = 'Average Medicare Cost Per User')
      ggplotly(g)
    })

    ## Average out of pocket cost, low-income users
    output$oopLIS <- renderPlotly({
      g <- ggplot(dataset(),
                  aes(x = year, y = out_of_pocket_avg_lowincome, color = as.factor(drugname_brand))) +
        geom_point() +
        geom_line() +
        theme(legend.position = 'none') +
        labs(x = 'Year', y = 'Average Out of Pocket Cost', title = 'Low-Income Subsidy Recipients')
      ggplotly(g)
    })

    ## Average out of pocket cost, non-low-income
    output$oopNLIS <- renderPlotly({
      g <- ggplot(dataset(),
                  aes(x = year,
                      y = out_of_pocket_avg_non_lowincome,
                      color = as.factor(drugname_brand))) +
        geom_point() +
        geom_line() +
        theme(legend.position = 'none') +
        labs(x = 'Year', y = 'Average Out of Pocket Cost', title = "Non-LIS Recipients")
      ggplotly(g)
    })
  })
