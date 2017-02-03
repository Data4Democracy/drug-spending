library(shinydashboard)
library(plotly)

## -- Define header --------------------------------------------------------------------------------
header <- dashboardHeader(title = 'Medicare Part D Users and Spending, 2011-2015',
                          titleWidth = 500)

## -- Define sidebar -------------------------------------------------------------------------------
sidebar <- dashboardSidebar(
  selectInput(inputId = 'drug',
              label = 'Choose generic drug name:',
              choices = sort(unique(drug_costs$drugname_generic)),
              selectize = FALSE),
  sidebarMenu(menuItem("People", tabName = "people", icon = icon("user", lib = "glyphicon")),
              menuItem("Spending", tabName = "spending", icon = icon("usd", lib = "glyphicon"))))

## -- Define body ----------------------------------------------------------------------------------
body <- dashboardBody(
  tabItems(
    tabItem(tabName = 'people',
            h2(textOutput("people_headline")),
            p("Black lines represent overall values for the selected generic; colored lines represent values for individual brands."),
            p("As one example, a black line would represent the total for all formulations of metformin HCL; one colored line on the same chart represents only Glucophage XR."),
            fluidRow(
              box(
                h3("Total Number of Users by Year"),
                plotlyOutput("userCounts")
                ),
              box(
                h3("Average Claims Per User by Year"),
                plotlyOutput("avgClaimsPerUser")
                )
            )),
    tabItem(tabName = 'spending',
            h2(textOutput("spending_headline")),
            p("Black lines represent overall values for the selected generic; colored lines represent values for individual brands."),
            p("As one example, a black line would represent the total for all formulations of metformin HCL; one colored line on the same chart represents only Glucophage XR."),
            fluidRow(
              box(
                h3("Total Spending by Year, US Dollars"),
                plotlyOutput("totalSpending")
                ),
              box(
                h3("Average Cost Per User by Year, US Dollars"),
                plotlyOutput("avgCostPerUser")
                )
            ),
            fluidRow(
              box(
                h3("Average Out of Pocket Cost Per User by Year, US Dollars"),
                plotlyOutput("oop"), width = 12)
            ),
            p("Because out-of-pocket costs are specific to individual brands, no overall out-of-pocket cost for a single generic is provided.")
            )
  )
)

dashboardPage(header, sidebar, body,
              title = "Data for Democracy: Medicare Part D Users and Spending, 2011-2015",
              skin = "purple")
