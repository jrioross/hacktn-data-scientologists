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

  # output$list_providers<- renderDataTable(
  #   as_tibble(medicare_data) %>%
  #     select(Provider, City, State, `Medical Specialty`, `Medical Procedure`, `MIPS Quality Score`, `Medical Procedure`, `Cost Differential`),
  #   options = list(
  #     pageLength=5, scrollX='900px')
  # )
  
  observeEvent(input$map_marker_click, { 
    
    
    showModal(modalDialog(
      plotOutput("common_procedures"),
      title = input$map_marker_click[1],
      fade = F,
      size = "l",
      easyClose = T,
      footer = tagList(
        actionButton("medical_bill", "Submit Medical Bill"),
        actionButton("review", "Write Review")
      )
    ))
  })
  
  output$common_procedures <- renderPlot({
    medicare_data %>%
      filter(Provider == "Rupa Grummon, MSN NP-C") %>% 
      arrange(desc(`Total Procedures Rendered`)) %>% 
      head() %>%
      ggplot(aes(y = `Medical Procedure`, 
                 x = `Medical Procedure Charge`, 
                 fill = `Medical Procedure`)) +
      geom_col(position = 'stack') +
      labs(title = "5 Most Common Procedures Rendered by Provider", y = "") +
      theme_minimal() +
      theme(legend.position = "none") +
      scale_x_continuous(labels = scales::dollar)
  })
  
  output$data_table <- renderDT(
    server = T, {
      datatable(
        data = data_filter(),
        style = 'bootstrap',
        rownames = F,
        selection = "none",
        extensions = c("Buttons"),
        options = list(
          pageLength = 10,
          lengthMenu = c(10, 25, 50, 100),
          autoWidth = T,
          scrollX = T,
          dom = 'lrtip',
          buttons = list(
            list(
              extend = 'collection',
              buttons = c('columnsToggle'),
              text = 'Columns'
            )
          ),
          columnDefs = list(list(visible = F, targets=c(9)))
        )
      ) %>%
        formatCurrency(columns = c("Medical Procedure Charge", "Average Cost Differential"),
                       digits = 0)
    })

  
})
