# Healthcare Quality and Cost Transparency

# Define UI for application 
shinyUI(

  dashboardPage(
    
    dashboardHeader(
      title = "HEALTHI",
      titleWidth = 300
    ),
    
    dashboardSidebar(
      width = 300,
      
      sidebarMenu(
        id ="tabs",
        
        menuItem(
          "Map",
          tabName = "map",
          icon = icon("map-marked-alt")
        ),
        menuItem(
          "Table",
          tabName = "table",
          icon = icon('table')
        ),
        
        selectInput(
          inputId = "map_input",
          label = "Compare Provdiers By:",
          choices = c("Affordability", "Quality of Care")
        ),
        
        shiny_data_filter_ui("medicare_data_filter")
      )
    ),
    
    dashboardBody(
      
      # add_busy_spinner(spin = "fading-circle"),
      
      tabItems(
        
        # Map tab
        tabItem(
          tabName = "map",
          tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"), # increase the height of the map
          leafletOutput("map", width = "100%", height = "100%")
        ),
        
        # Table tab
        tabItem(
          tabName = "table",
          
          box(
            title = "List of Providers",
            width = 12,
            downloadButton('download_customized_datatable_csv', 'CSV'),
            downloadButton('download_customized_datatable_xlsx', 'Excel'),
            br(),
            br(),
            DTOutput('data_table')
          )
        )
      )
    )
  )
)
