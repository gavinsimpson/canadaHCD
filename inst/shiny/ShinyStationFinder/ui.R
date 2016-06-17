## Adapted from http://shiny.rstudio.com/gallery/basic-datatable.html

library(shiny)

# Load the ggplot2 package which provides
# the 'mpg' dataset.
library(canadaHCD)

# Define the overall UI
shinyUI(
  fluidPage(
    titlePanel("canadaHRM data inventory"),
    
    # Create a new Row in the UI for selectInputs
    fluidRow(
      column(4,
             selectInput("prov",
                         "Province:",
                         c("All",
                           unique(as.character(canadaHCD:::station_data$Province))))
    ),
    # Create a new row for the table.
    fluidRow(
      DT::dataTableOutput("table")
    )
  )
)
)