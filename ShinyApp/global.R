# Healthcare Quality and Cost Transparency

library(shiny)
library(shinydashboard)
library(tidyverse)
library(sf)
library(leaflet)



# read csv
medicare <- read_csv("data/Medicare_Physician_Other_Practitioners_by_Provider_and_Service_2019.csv")

# labels for legends and titles
choices_specialty <- c("All", medicare %>%
                         pull(Rndrng_Prvdr_Type) %>%
                         unique() %>%
                         sort())

choices_procedures <- c("All",medicare %>%
                          pull(HCPCS_Desc) %>%
                          unique() %>%
                          sort())

choices_state <- c("United States", medicare %>%
                     pull(Rndrng_Prvdr_State_Abrvtn) %>%
                     unique() %>%
                     sort())

choices_city <- c("All", medicare %>%
                     pull(Rndrng_Prvdr_City) %>%
                     unique() %>%
                     sort())

choices_zip <- c("All", medicare %>%
                     pull(Rndrng_Prvdr_Zip5) %>%
                     unique() %>%
                     sort())

# Range of slider range
min_charge <- min(medicare$Avg_Sbmtd_Chrg)
max_charge <- max(medicare$Avg_Sbmtd_Chrg)
