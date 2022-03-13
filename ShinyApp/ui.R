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
        
        # # Reset input button
        # actionBttn(
        #   inputId = "reset_input",
        #   label = "Reset Input",
        #   style = "material-flat"),
        
        # Specialty filter
        # selectInput(
        #   inputId = "specialty",
        #   label = "Provider's Specialty",
        #   choices = choices_specialty
        # ),
        
        # Procedure filter
        # selectInput(
        #   inputId = "procedure",
        #   label = "Medical Procedure",
        #   choices = choices_procedures
        # ),
        
        # Gender filter
        # selectInput(
        #   inputId = "gender",
        #   label = "Provider's Gender",
        #   choices = c('All', 'Male', 'Female')
        # ),
        
        # MIPS quality of care
        # sliderInput("mips", 
        #             label = "MIPS Score", 
        #             min = min_mips, 
        #             max = max_mips, 
        #             value = c(min_mips, max_mips)
        # ),
        
        # Procedure charge
        # sliderInput("charge", 
        #             label = "Procedure Charge($)", 
        #             min = min_charge, 
        #             max = max_charge, 
        #             value = c(min_charge, max_charge)
        # ),
        
        # State filter
        # selectInput(
        #   inputId = "state",
        #   label = "Select the State",
        #   choices = choices_state
        # ),
        
        # City filter
        # selectInput(
        #   inputId = "city",
        #   label = "Select the City",
        #   choices = choices_city
        # ),
        
        # Zipcode filter
        # selectInput(
        #   inputId = "zip_code",
        #   label = "Select the Zip Code",
        #   choices = choices_zip
        # )
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
            # downloadButton('download_customized_datatable_csv', 'CSV'),
            # downloadButton('download_customized_datatable_xlsx', 'Excel'),
            # br(),
            # br(),
            # br(),
            DTOutput('data_table')
          )
        )
      )
    )
  )
)
