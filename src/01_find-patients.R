library(tidyverse)
library(edwr)

dir_raw <- "data/raw"

# run MBO query
#   * Patients - by Visit Type
#       Admit Date: 7/1/17 - 9/30/17
#       Visit Type: Inpatient;Observation

patients <- read_data(dir_raw, "patients", FALSE) %>%
    as.patients()

mbo_id <- concat_encounters(patients$millennium.id)

# run MBO query
#   * Location History
