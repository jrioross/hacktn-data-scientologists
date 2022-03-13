# Healthcare Quality and Cost Transparency

# Define server logic required to draw a histogram
shinyServer(function(session, input, output) {
  
  
  # Render leaflet map
  output$map <- renderLeaflet({
    draw_base_map()
  })
  
  data_filter <- callModule(
    shiny_data_filter,
    "medicare_data_filter",
    data = medicare_data,
    verbose = F)
  
  observeEvent(
    eventExpr = data_filter(),
    handlerExpr = update_map("map", data_filter(), parse_map_input(input$map_input))
  )
  
  observeEvent(
    eventExpr = input$map_input,
    handlerExpr = update_map("map", data_filter(), parse_map_input(input$map_input))
  )


  output$list_providers<- renderDataTable(
    as_tibble(medicare_data) %>%
      select(Provider, City, State, `Medical Specialty`, `Medical Procedure`, `MIPS Quality Score`, `Medical Procedure`, `Cost Differential`),
    options = list(
      pageLength=5, scrollX='900px')
  )
  
    
  
  
  # observe({
    # filtered_data <- data_filter()
  
  # observe({
  #   leafletProxy("map") %>%
  #     addCircleMarkers(data = data_filter(),
  #                      group = "providers",
  #                      weight = 0.5,
  #                      radius = 2,
  #                      fillColor = "red",
  #                      fillOpacity = 0.75,
  #                      color = "white")
  # })
  # 
  # Reset Input Button
  # observeEvent(input$reset_input, {
  #   
  #   updateSelectInput(session, "specialty", choices = choices_specialty)
  #   updateSelectInput(session, "procedure", choices = choices_procedures)
  #   updateSelectInput(session, "gender", choices = c('All', 'Male', 'Female'))
  #   updateSliderInput(session, "charge",value = c(min_pop,max_pop))
  #   updateSelectInput(session, "state",choices = choices_state)
  #   updateSelectInput(session, "city", choices = choices_city)
  #   updateSelectInput(session, "zip_code", choices = choices_zip)
  # })
  
  

  
  
  
  # # Update City based on State
  # updateSelectInput(session, "city",
  #                   choices = data_filtered[data_filtered$Rndrng_Prvdr_State_Abrvtn == input$state_rank,]$Rndrng_Prvdr_City %>% unique() %>% sort()
  # )
  
  # MAP TAB-------------------------------------------------------------------------------
  
  # Initial Leaflet map
  # initial_map <- leaflet() %>%
  #   addProviderTiles(provider = "CartoDB.Positron") %>%
  #   setView(lng = -86.7816, lat = 36.1627, zoom = 12) %>%
  #   addCircleMarkers(data = medicare,
  #                    weight = 0.5,
  #                    radius = 2,
  #                    fillColor = "red",
  #                    fillOpacity = 0.75,
  #                    color = "white")
  # 
  # output$map <- renderLeaflet({
  #   initial_map
  # })
  
  
  
  
  
  
})
