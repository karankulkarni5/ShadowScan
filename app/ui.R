# app.R

# Install required packages if they are not already installed
list.of.packages <- c("shiny", "leaflet", "dplyr", "sf", "DT", "ggplot2", "plotly", "shinyWidgets", "readr", "rnaturalearth", "rnaturalearthdata")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if(length(new.packages)) install.packages(new.packages)

# Load libraries
library(shiny)
library(leaflet)
library(dplyr)
library(sf)
library(DT)
library(ggplot2)
library(plotly)
library(shinyWidgets)
library(readr)
library(rnaturalearth)
library(rnaturalearthdata)

# Load spatial data for world countries
world <- ne_countries(scale = "medium", returnclass = "sf")

# Simulated data for demonstration
set.seed(123)
years <- 1990:2030  # Include past and future years
countries <- world$name
data <- expand.grid(country = countries, year = years)
data$corruption_rate <- runif(nrow(data), min = 0, max = 100)
data$gdp_per_capita <- runif(nrow(data), min = 1000, max = 50000)
data$unemployment_rate <- runif(nrow(data), min = 0, max = 25)
data$education_index <- runif(nrow(data), min = 0, max = 1)
data$political_party <- sample(c("Party A", "Party B", "Party C"), nrow(data), replace = TRUE)

# UI
ui <- fluidPage(
  titlePanel("Shadowscan: Global Corruption Analysis"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("year", "Select Year:",
                  min = min(years), max = max(years),
                  value = 2020, animate = animationOptions(interval = 1000)),
      pickerInput("socioeconomic", "Select Socioeconomic Indicator:",
                  choices = c("GDP per Capita" = "gdp_per_capita",
                              "Unemployment Rate" = "unemployment_rate",
                              "Education Index" = "education_index"),
                  selected = "gdp_per_capita"),
      pickerInput("politicalParty", "Select Political Party:",
                  choices = c("Party A", "Party B", "Party C"),
                  selected = c("Party A", "Party B", "Party C"),
                  multiple = TRUE),
      actionButton("update", "Update Map")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Map View", leafletOutput("worldMap", height = 600)),
        tabPanel("Data Analysis", plotlyOutput("correlationPlot")),
        tabPanel("Predictive Modeling", plotlyOutput("predictivePlot")),
        tabPanel("Data Table", DTOutput("dataTable"))
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # Reactive expression to filter data based on inputs
  filteredData <- reactive({
    req(input$year)
    df <- data %>%
      filter(year == input$year,
             political_party %in% input$politicalParty)
    df
  })
  
  # Reactive expression for selected socioeconomic indicator
  socioIndicator <- reactive({
    req(input$socioeconomic)
    input$socioeconomic
  })
  
  # Observe event to update map
  observeEvent(input$update, {
    
    df <- filteredData()
    # Merge data with spatial data
    world_data <- left_join(world, df, by = c("name" = "country"))
    
    # Define color palette for corruption rate
    pal <- colorNumeric(
      palette = c("green", "red"),
      domain = world_data$corruption_rate,
      na.color = "gray"
    )
    
    # Render Leaflet map
    output$worldMap <- renderLeaflet({
      leaflet(world_data) %>%
        addTiles() %>%
        setView(lng = 0, lat = 20, zoom = 2) %>%
        addPolygons(
          fillColor = ~pal(corruption_rate),
          fillOpacity = 0.7,
          color = "white",
          weight = 0.5,
          popup = ~paste0(
            "<strong>Country:</strong> ", name, "<br>",
            "<strong>Corruption Rate:</strong> ", round(corruption_rate, 2), "%<br>",
            "<strong>", names(input$socioeconomic), ":</strong> ", round(get(socioIndicator()), 2), "<br>",
            "<strong>Political Party:</strong> ", political_party
          )
        ) %>%
        addLegend("bottomright", pal = pal, values = ~corruption_rate,
                  title = "Corruption Rate (%)",
                  opacity = 1)
    })
  })
  
  # Initial map rendering
  output$worldMap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = 0, lat = 20, zoom = 2)
  })
  
  # Render Correlation Plot
  output$correlationPlot <- renderPlotly({
    df <- filteredData()
    p <- ggplot(df, aes_string(x = socioIndicator(), y = "corruption_rate")) +
      geom_point(color = 'blue') +
      labs(x = names(input$socioeconomic), y = "Corruption Rate (%)") +
      theme_minimal()
    ggplotly(p)
  })
  
  # Render Predictive Plot (Placeholder)
  output$predictivePlot <- renderPlotly({
    # Placeholder for predictive analytics
    df <- data %>%
      group_by(year) %>%
      summarize(avg_corruption = mean(corruption_rate))
    
    p <- ggplot(df, aes(x = year, y = avg_corruption)) +
      geom_line(color = 'red') +
      labs(x = "Year", y = "Average Corruption Rate (%)") +
      theme_minimal()
    ggplotly(p)
  })
  
  # Render Data Table
  output$dataTable <- renderDT({
    df <- filteredData()
    datatable(df)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
