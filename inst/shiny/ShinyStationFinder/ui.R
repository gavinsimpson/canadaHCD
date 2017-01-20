## Adapted from http://shiny.rstudio.com/gallery/basic-datatable.html

library(shiny)
library(canadaHCD)

if(exists("customtable")) {
  dataui <- customtable
} else {
  dataui <- canadaHCD:::station_data
}

# Define the overall UI
shinyUI(
  fluidPage(
    titlePanel("canadaHCD data inventory"),
    
    # Create a new Row in the UI for selectInputs
    fluidRow(
      column(4,
             selectInput("prov",
                         "Province:",
                         c("All",
                           unique(as.character(dataui$Province))))
    ),
    # Create a new row for the table.
    fluidRow(
      DT::dataTableOutput("table")
    )
  )
)
)