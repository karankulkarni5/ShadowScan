ui <- fluidPage(
  # Include the custom CSS
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  
  # Title
  div(
    class = "title-bar",
    h1("UK Road Accident Analysis")
  ),
  
  # Main layout
  div(
    class = "main-container",
    leafletOutput("heatmap", height = "600px"),
    
    div(
      class = "sidebar",
      sliderInput(
        "time_range", 
        "Select Time Range:", 
        min = as.Date("2005-01-01"), 
        max = as.Date("2014-12-31"), 
        value = c(as.Date("2005-01-01"), as.Date("2014-12-31"))
      )
    ),
    
    div(
      class = "info-panel",
      h3("Analytics"),
      tableOutput("reason_table"),
      plotOutput("severity_distribution"),
      plotOutput("weekday_collisions"),
      tableOutput("weather_light_conditions")
    )
  )
)
