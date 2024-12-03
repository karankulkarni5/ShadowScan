server <- function(input, output, session) {
  # Load cleaned dataset
  road_accidents_cleaned <- read.csv("road_accidents_cleaned.csv")
  road_accidents_cleaned$Date <- as.Date(road_accidents_cleaned$Date)
  
  # Filtered dataset for the heatmap based on time slider
  filtered_data <- reactive({
    road_accidents_cleaned %>%
      filter(Date >= as.Date(input$time_range[1]) & Date <= as.Date(input$time_range[2]))
  })
  
  # Render the heatmap
  output$heatmap <- renderLeaflet({
    leaflet() %>%
      setView(lng = -1.5, lat = 54.5, zoom = 6) %>%  # Center over the UK
      addProviderTiles(providers$CartoDB.Positron) %>%
      addHeatmap(
        lng = ~Longitude,
        lat = ~Latitude,
        intensity = ~Number_of_Casualties,
        blur = 20,
        max = 0.05,
        radius = 15,
        data = filtered_data()
      )
  })
  
  # Enable region selection on the map
  observeEvent(input$heatmap_shape_click, {
    click <- input$heatmap_shape_click
    selected_region <- filtered_data() %>%
      filter(Longitude == click$lng & Latitude == click$lat)  # Adjust region selection logic if needed
    output$selected_region <- renderPrint({ selected_region })
    
    # Diagnostic analytics
    output$reason_table <- renderTable({
      selected_region %>%
        count(Road_Type) %>%
        arrange(desc(n))
    })
    
    output$severity_distribution <- renderPlot({
      ggplot(selected_region, aes(x = factor(Accident_Severity, labels = c("Slight", "Serious", "Fatal")))) +
        geom_bar(fill = "steelblue") +
        labs(
          title = "Accident Severity Distribution",
          x = "Severity",
          y = "Count"
        ) +
        theme_minimal()
    })
    
    output$weekday_collisions <- renderPlot({
      ggplot(selected_region, aes(x = Weekday)) +
        geom_bar(fill = "coral") +
        labs(
          title = "Collisions by Weekday",
          x = "Weekday",
          y = "Count"
        ) +
        theme_minimal()
    })
    
    output$weather_light_conditions <- renderTable({
      selected_region %>%
        count(Weather_Conditions, Light_Conditions) %>%
        arrange(desc(n))
    })
  })
}
