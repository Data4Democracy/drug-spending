library(shinydashboard)
library(ggplot2)
library(scales)
library(plotly)

shinyServer(
  function(input, output, session){

    output$people_headline <- renderText({
      if(input$drug == ''){
        "Users and Claims"
      } else{
        paste("Users and Claims,", input$drug)
      }
    })
    output$spending_headline <- renderText({
      if(input$drug == ''){
        "Government and Individual Costs"
      } else{
        paste("Government and Individual Costs,", input$drug)
      }
    })

    ## Use only data for selected generic
    dataset <- reactive({
      # validate(
      #   need(input$drug != "", "Please select a drug from the dropdown menu.")
      # )
      drug_costs[drug_costs$drugname_generic == input$drug,]
    })
    dataset_overall <- reactive({
      # validate(
      #   need(input$drug != "", "")
      # )
      drug_costs_overall[drug_costs_overall$drugname_generic == input$drug,]
    })
    oopdata <- reactive({
      # validate(
      #   need(input$drug != "", "")
      # )
      oop_costs[oop_costs$drugname_generic == input$drug,]
    })

    ## User counts
    output$userCounts <- renderPlotly({

      g <- ggplot(dataset(), aes(x = year, y = user_count, color = drugname_brand)) +
        ## Attempt at monochromatic color scale... not great because lines that overlap look like
        ## a darker version of same color and are misleading
        # geom_point(aes(colour = generic_num), shape = 1, alpha = 0.5) +
        # geom_line(aes(colour = generic_num), size = 0.5, alpha = 0.5) +
        # scale_colour_gradient(low = "#3F297F", high = "#AC9ED5") +
        geom_point(shape = 1, alpha = 0.5) +
        geom_line(size = 0.5, alpha = 0.5) +
        geom_point(data = dataset_overall(), shape = 19, alpha = 0.5, colour = 'black') +
        geom_line(data = dataset_overall(), size = 1, alpha = 0.5, colour = 'black') +
        scale_x_continuous(name = '') +
        scale_y_continuous(name = '', labels = comma) +
        theme_minimal() +
        theme(legend.position = 'none',
              panel.grid.major.y = element_line(color = 'grey95'),
              plot.title = element_text(hjust = 0))

      ggplotly(g)
    })

    ## Average number of claims per user
    output$avgClaimsPerUser <- renderPlotly({
      g <- ggplot(dataset(),
                  aes(x = year, y = (claim_count / user_count), color = drugname_brand)) +
        geom_point(shape = 1, alpha = 0.5) +
        geom_line(size = 0.5, alpha = 0.5) +
        geom_point(data = dataset_overall(), shape = 19, alpha = 0.5, colour = 'black') +
        geom_line(data = dataset_overall(), size = 1, alpha = 0.5, colour = 'black') +
        scale_x_continuous(name = '') +
        scale_y_continuous(name = '', labels = comma) +
        theme_minimal() +
        theme(legend.position = 'none',
              panel.grid.major.y = element_line(color = 'grey95'))

      ggplotly(g)
    })

    ## Total spending
    output$totalSpending <- renderPlotly({
      g <- ggplot(dataset(), aes(x = year, y = total_spending, color = drugname_brand)) +
        geom_point(shape = 1, alpha = 0.5) +
        geom_line(size = 0.5, alpha = 0.5) +
        geom_point(data = dataset_overall(), shape = 19, alpha = 0.5, colour = 'black') +
        geom_line(data = dataset_overall(), size = 1, alpha = 0.5, colour = 'black') +
        scale_x_continuous(name = '') +
        scale_y_continuous(name = '', labels = comma) +
        theme_minimal() +
        theme(legend.position = 'none',
              panel.grid.major.y = element_line(color = 'grey95'))

      ggplotly(g, tooltip = c('x', 'y', 'colour'))
    })

    ## Average spending per user
    output$avgCostPerUser <- renderPlotly({
      g <- ggplot(dataset(),
                  aes(x = year, y = total_spending_per_user, color = drugname_brand)) +
        geom_point(shape = 1, alpha = 0.5) +
        geom_line(size = 0.5, alpha = 0.5) +
        geom_point(data = dataset_overall(), shape = 19, alpha = 0.5, colour = 'black') +
        geom_line(data = dataset_overall(), size = 1, alpha = 0.5, colour = 'black') +
        scale_x_continuous(name = '') +
        scale_y_continuous(name = '', labels = comma) +
        theme_minimal() +
        theme(legend.position = 'none',
              panel.grid.major.y = element_line(color = 'grey95'))
      ggplotly(g)
    })

    ## Average out of pocket cost, faceted by LIS vs non-LIS
    output$oop <- renderPlotly({
      g <- ggplot(data = oopdata(), aes(x = year, y = oop_avg, colour = drugname_brand)) +
        facet_wrap(~ lis_status, nrow = 1) +
        geom_point(shape = 1, alpha = 0.5) +
        geom_line(size = 0.5, alpha = 0.5) +
        scale_x_continuous(name = '') +
        scale_y_continuous(name = '', labels = comma) +
        theme_minimal() +
        theme(legend.position = 'none',
              panel.grid.major.y = element_line(color = 'grey95'))

      ggplotly(g)
    })
  })
