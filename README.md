# Traffic Accident Analysis System

## Overview
The Traffic Accident Analysis System is a data-driven application designed to analyze road traffic accidents. It provides both diagnostic and descriptive insights and predictive capabilities. The system enables users to explore accident data through interactive heatmaps and perform predictive analysis to estimate risk levels for specific routes.

## Features

### Diagnostic and Descriptive Analysis
- **Interactive Heatmaps:** Visualize accident hotspots dynamically based on filters like year range and map bounds.
- **Charts and Insights:** Display statistics for accidents categorized by road type, weather conditions, and light conditions.
- **Dynamic Filtering:** Focus on specific geographic regions by adjusting the map view.

### Predictive Analysis
- **Route Risk Assessment:** Predicts accident risk for custom-selected routes based on accident data and a machine learning model.
- **Interactive Route Selection:** Users can click on the map to specify start and end points for risk prediction.
- **Visual Representation:** Highlights high-risk accident zones along the selected route.

## Project Structure
The project is structured as follows:

```
project-root/
├── data/
│   ├── road_accidents_cleaned.csv       # Full dataset used for descriptive analysis
│   ├── road_accidents_shorter.csv       # Reduced dataset (2012-2014) for performance optimization
├── predictive/
│   ├── helpers.R                        # Helper functions for data preprocessing
│   ├── ml_predictions.R                 # Machine learning model and prediction functions
│   ├── ml_model.json                    # Trained ML model for risk prediction
├── www/
│   ├── styles.css                       # Custom CSS for UI styling
├── app.R                                # Combined Shiny application
├── server.R                             # Server-side logic for descriptive analysis
├── server_predictive.R                  # Server-side logic for predictive analysis
├── ui.R                                 # UI definitions for the application
├── README.md                            # Project documentation
```

## Getting Started

### Prerequisites
1. **R and RStudio:** Install the latest version of R and RStudio.
2. **R Packages:**
   Install the required packages using the following command:
   ```R
   install.packages(c("shiny", "leaflet", "plotly", "dplyr", "lubridate", "htmlwidgets", "shinyjs", "leaflet.extras", "jsonlite", "geosphere"))
   ```

### Running the Application
1. Clone the repository or download the project files.
2. Set your working directory to the project root in RStudio.
3. Run the app using:
   ```R
   shiny::runApp()
   ```

### Configuring the Data
- The application reads data from `road_accidents_cleaned.csv` for descriptive analysis and `road_accidents_shorter.csv` for predictive analysis.
- To replace these datasets, ensure new files have the same structure and column names.

## Detailed Features

### Diagnostic and Descriptive Analysis
#### Heatmap
- Displays accident density as a heatmap.
- Dynamically adjusts based on map zoom level, year range, and visible bounds.
- Color gradient represents accident intensity.

#### Charts
- **Accidents by Road Type:** Bar chart showing the distribution of accidents based on road types.
- **Weather Conditions:** Bar chart showing accident counts for different weather conditions.
- **Light Conditions:** Pie chart displaying accident distribution under various lighting conditions.

#### File Configuration
- The main dataset used is `road_accidents_cleaned.csv`. Ensure this file is formatted with the following columns:
  - `Date`: Date of the accident
  - `Longitude`, `Latitude`: Geographic coordinates
  - `Road_Type`: Type of road where the accident occurred
  - `Weather_Conditions`: Weather during the accident
  - `Light_Conditions`: Lighting at the time of the accident

### Predictive Analysis
#### Route Risk Assessment
- Users select two points on the map to define a route.
- The application fetches the route and calculates accident risk using the `ml_model.json` file.
- Outputs a percentage risk score and highlights high-risk zones along the route.

#### File Configuration
- The reduced dataset `road_accidents_shorter.csv` (2012-2014) is used for performance.
- The machine learning model (`ml_model.json`) predicts accident risk based on aggregated data.

#### Technical Details
- **Features Used in Prediction:**
  - `Latitude`, `Longitude`
  - `Number_of_Casualties`
  - `Day_of_Week`
  - `Weather_Conditions`
  - `Time_Slot`
- **Model:** XGBoost model trained on historical accident data.

## Debugging and Logs
- Diagnostic messages are printed in the R console for debugging.
- Common errors include:
  - Missing data files: Ensure datasets are present in the `data/` directory.
  - Invalid inputs: Check for incorrect file formatting or missing columns.

## Future Improvements
1. **Real-time Data Integration:** Include live traffic and weather data for dynamic risk prediction.
2. **User Authentication:** Secure access to the application for sensitive data.
3. **Scalability:** Optimize code for handling larger datasets.
4. **Enhanced Visuals:** Improve UI and interactivity for a better user experience.

## Contributors
Namit Garg
Karan Kulkarni
