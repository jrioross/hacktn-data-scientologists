# Healthcare Quality and Cost Transparency

library(shiny)
library(shinydashboard)
library(tidyverse)
library(sf)
library(leaflet)



# read csv
medicare <- read_csv("data/danger_zone.csv")

# labels for legends and titles
choices_specialty <- c("All", medicare %>%
                         pull(specialty) %>%
                         unique() %>%
                         sort())

choices_procedures <- c("All",medicare %>%
                          pull(procedure_description) %>%
                          unique() %>%
                          sort())

choices_state <- c("United States", medicare %>%
                     pull(state) %>%
                     unique() %>%
                     sort())

choices_city <- c("All", medicare %>%
                    pull(city) %>%
                    unique() %>%
                    sort())

choices_zip <- c("All", medicare %>%
                   pull(zip) %>%
                   unique() %>%
                   sort())

# Range of slider range
min_charge <- round(min(medicare$avg_submitted_charge),2)
max_charge <- round(max(medicare$avg_submitted_charge),2)
min_mips <- min(medicare$quality_category_score, na.rm = TRUE)
max_mips <- max(medicare$quality_category_score, na.rm = TRUE)

# Initial view
initial_lat = 39.8283
initial_lng = -98.5795
initial_zoom = 4



