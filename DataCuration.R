# Load necessary libraries
library(dplyr)
library(readr)

# Set your working directory
setwd("C:/Users/namit/Documents/D2P")  # Replace with your directory path

# Load the dataset
road_accidents <- read_csv("UK_Accident.csv")  # Replace with the actual dataset name

# View the structure of the dataset
str(road_accidents)

# Display the first few rows to understand the data
head(road_accidents)

# Check for missing values
colSums(is.na(road_accidents))

# Replace or drop missing values if necessary
# Replace or drop missing values for relevant columns
road_accidents <- road_accidents %>%
  filter(
    !is.na(Latitude), 
    !is.na(Longitude), 
    !is.na(Date), 
    !is.na(Road_Type), 
    !is.na(Weather_Conditions)
  )
# Data Cleaning
road_accidents_cleaned <- road_accidents %>%
  # Remove rows with missing Latitude, Longitude, Date, or Road_Type
  filter(!is.na(Latitude), !is.na(Longitude), !is.na(Date), !is.na(Road_Type)) %>%
  # Optionally remove rows with missing LSOA if it's critical
  filter(!is.na(LSOA_of_Accident_Location))

# Parse Date column to Date format
road_accidents_cleaned <- road_accidents_cleaned %>%
  mutate(
    Date = as.Date(Date, format = "%d/%m/%Y"), # Adjust format if necessary
    Year = as.numeric(format(Date, "%Y")),    # Extract Year
    Month = as.numeric(format(Date, "%m")),   # Extract Month
    Weekday = weekdays(Date)                  # Extract Day of Week
  )

# Preview cleaned data
head(road_accidents_cleaned)





