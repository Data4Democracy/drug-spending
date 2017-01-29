library(shinydashboard)
library(plotly)

## -- Define header --------------------------------------------------------------------------------
header <- dashboardHeader(title = 'Medicare Part D Users and Spending, 2011-2015',
                          titleWidth = 500)

## -- Define sidebar -------------------------------------------------------------------------------
sidebar <- dashboardSidebar(
  selectInput(inputId = 'drug',
              label = 'Choose generic drug name:',
              choices = drug_costs$drugname_generic),
  sidebarMenu(menuItem("People", tabName = "people", icon = icon("user", lib = "glyphicon")),
              menuItem("Spending", tabName = "spending", icon = icon("usd", lib = "glyphicon"))))

## -- Define body ----------------------------------------------------------------------------------
body <- dashboardBody(
  tabItems(
    tabItem(tabName = 'people',
            h2("Users and Claims"),
            fluidRow(
              box(plotlyOutput("userCounts")),
              box(plotlyOutput("avgClaimsPerUser"))
            )),
    tabItem(tabName = 'spending',
            h2("Government and Individual Costs"),
            fluidRow(
              box(plotlyOutput("totalSpending")),
              box(plotlyOutput("avgCostPerUser"))
            ),
            fluidRow(
              box(plotlyOutput("oopLIS")),
              box(plotlyOutput("oopNLIS"))
            ))
  )
)

dashboardPage(header, sidebar, body,
              title = "Data for Democracy: Medicare Part D Users and Spending, 2011-2015",
              skin = "purple")
