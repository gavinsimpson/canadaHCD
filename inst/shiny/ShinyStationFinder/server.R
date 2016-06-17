## Adapted from http://shiny.rstudio.com/gallery/basic-datatable.html


library(shiny)

# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- canadaHCD:::station_data
    if (input$prov != "All") {
      data <- data[data$Province == input$prov,]
    }
    data
  }))
  
})
