# Healthcare Quality and Cost Transparency

library(shiny)
library(shinydashboard)
library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(shinybusy)
library(shinyDataFilter)
library(DT)
library(fresh)

# theme

mytheme <- create_theme(
  adminlte_color(
    yellow = "#F9CF34"
  )
)

# read csv
medicare_data <- read_csv("data/danger_zone.csv", show_col_types = F) %>% 
  filter(place_of_service == "O") %>%
  group_by(across(-c(quality_category_score,
                     pi_category_score,
                     ia_category_score,
                     final_mips_score_without_cpb,
                     final_mips_score))) %>%
  mutate(quality_category_score = mean(quality_category_score, na.rm = T),
         pi_category_score = mean(pi_category_score, na.rm = T),
         ia_category_score = mean(ia_category_score, na.rm = T),
         final_mips_score_without_cpb = mean(final_mips_score_without_cpb, na.rm = T),
         final_mips_score = mean(final_mips_score, na.rm = T)) %>%
  ungroup() %>%
  distinct() %>%
  group_by(specialty, procedure_code) %>%
  mutate(procedure_cost_avg = mean(avg_submitted_charge),
         procedure_cost_std = sd(avg_submitted_charge),
         procedure_cost_range = max(avg_submitted_charge) - min(avg_submitted_charge),
         n_npis = n(),
         .after = procedure_description) %>%
  ungroup %>%
  group_by(npi, specialty) %>%
  mutate(cost_differential = weighted.mean((avg_submitted_charge - procedure_cost_avg), total_services)) %>%
  ungroup %>%
  st_as_sf(coords = c("lng", "lat"), remove = F) %>%
  transmute(City = as_factor(str_to_title(city)),
            State = as_factor(state),
            Provider = as_factor(str_remove(paste0(first_name, " ", last_name, ", ", credentials), ", NA")),
            `Medical Specialty` = as_factor(specialty),
            `Medical Procedure` = as_factor(procedure_description),
            `Medical Procedure Charge` = avg_submitted_charge,
            `Total Procedures Rendered` = total_services,
            `Average Cost Differential` = round(cost_differential),
            `MIPS Quality Score` = round(quality_category_score, 1))

# Initialize leaflet map
draw_base_map <- function() {
  
  leaflet(options = leafletOptions(minZoom = 8, 
                                   maxZoom = 18, 
                                   dragging = T, 
                                   attributionControl = F)) %>%
    addProviderTiles(provider = "CartoDB.Positron") %>%
    setView(lng = -86.7816, lat = 36.1627, zoom = 10) %>%
    setMaxBounds(lng1 = -86.7816 + 1, 
                 lat1 = 36.1627 + 1, 
                 lng2 = -86.7816 - 1, 
                 lat2 = 36.1627 - 1) %>%
    addResetMapButton()
}

update_map <- function(map, data, map_input) {
  
  data$quality_hex <- case_when(data$`MIPS Quality Score` < 50 ~ "#d73026",
                                data$`MIPS Quality Score` < 60 ~ "#f36d42",
                                data$`MIPS Quality Score` < 70 ~ "#fee08b",
                                data$`MIPS Quality Score` < 80 ~ "#a5d86a",
                                data$`MIPS Quality Score` < 90 ~ "#67bd63",
                                data$`MIPS Quality Score` <= 100 ~ "#1a984f",
                                TRUE ~ "#E5E5E5")
  
  data$affordability_hex <- case_when(data$`Average Cost Differential` > 250 ~ "#d73026",
                                      data$`Average Cost Differential` > 50 ~ "#f36d42",
                                      data$`Average Cost Differential` >= 0 ~ "#fee08b",
                                      data$`Average Cost Differential` >= -50 ~ "#a5d86a",
                                      data$`Average Cost Differential` >= -250 ~ "#67bd63",
                                      data$`Average Cost Differential` < -250 ~ "#1a984f",
                                      TRUE ~ "#E5E5E5")
  
  data$label <-
    paste0("<b>", data$Provider, " (", data$City, ", ", data$State, ")</b>",
           "<hr style='margin-top: 2px; margin-bottom: 4px'>",
           case_when(map_input == "quality_hex" ~ 
                       paste0("<b>MIPS Quality Score:</b> ", data$`MIPS Quality Score`, "<br>"),
                     map_input == "affordability_hex" ~ 
                       paste0("<b>Average Cost Differential: ", scales::dollar(data$`Average Cost Differential`), "</b>"))) %>%
    lapply(htmltools::HTML)
  
  leafletProxy(map) %>%
    clearMarkers() %>%
    addCircleMarkers(data = data,
                     group = "providers",
                     layerId = ~Provider,
                     weight = 0.5,
                     radius = 4,
                     fillColor = ~eval(parse(text = paste0(map_input))),
                     fillOpacity = 0.75,
                     color = "black",
                     label = ~label)
}

# Convert map input to column name
parse_map_input <- function(map_input) {
  case_when(
    map_input == "Quality of Care" ~ "quality_hex",
    map_input == "Affordability" ~ "affordability_hex",
  )
}