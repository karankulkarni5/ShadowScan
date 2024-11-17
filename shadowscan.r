library(shiny)
library(leaflet)
library(shinyWidgets)
library(DT)

ui <- fluidPage(
  titlePanel("Shadowscan: Global Corruption Analysis"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("year", "Select Year:",
                  min = 2000, max = 2030,
                  value = 2020, animate = TRUE),
      pickerInput("socioeconomic", "Select Socioeconomic Indicators:",
                  choices = c("GDP per Capita", "Unemployment Rate", "Education Index"),
                  multiple = TRUE),
      pickerInput("politicalParty", "Select Political Party:",
                  choices = c("Party A", "Party B", "Party C"),
                  multiple = TRUE)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Map View", leafletOutput("worldMap")),
        tabPanel("Data Analysis", plotOutput("correlationPlot")),
        tabPanel("Predictive Modeling", plotOutput("predictivePlot")),
        tabPanel("Data Table", DTOutput("dataTable"))
      )
    )
  )
)
