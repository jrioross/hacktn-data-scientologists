# Healthcare Quality and Cost Transparency

# Define server logic required to draw a histogram
shinyServer(function(session, input, output) {
  
  # Reset Input Button
  observeEvent(input$reset_input, {
    
    updateSelectInput(session, "specialty", choices = choices_specialty)
    updateSelectInput(session, "procedure", choices = choices_procedures)
    updateSelectInput(session, "gender", choices = c('All', 'Male', 'Female'))
    updateSliderInput(session, "charge",value = c(min_pop,max_pop))
    updateSelectInput(session, "state",choices = choices_state)
    updateSelectInput(session, "city", choices = choices_city)
    updateSelectInput(session, "zip_code", choices = choices_zip)
  })
  
  # # Update City based on State
  # updateSelectInput(session, "city",
  #                   choices = data_filtered[data_filtered$Rndrng_Prvdr_State_Abrvtn == input$state_rank,]$Rndrng_Prvdr_City %>% unique() %>% sort()
  # )
})
