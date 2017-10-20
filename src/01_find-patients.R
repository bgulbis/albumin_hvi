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

locations <- read_data(dir_raw, "location", FALSE) %>%
    as.locations()

hvi_pts <- locations %>%
    filter(unit.name %in% c("HH CCU", "HH CVICU", "HH HFIC")) %>%
    distinct(millennium.id)

mbo_hvi <- concat_encounters(hvi_pts$millennium.id)

# run MBO query
#   * Medications - Inpatient - All

meds <- read_data(dir_raw, "meds-inpt", FALSE) %>%
    as.meds_inpt()

albumin <- meds %>%
    filter(med == "albumin human") %>%
    mutate(order_id = order.parent.id) %>%
    mutate_at("order_id", funs(na_if(., 0L))) %>%
    mutate_at("order_id", funs(coalesce(., order.id)))

mbo_order <- concat_encounters(albumin$order_id)

# run MBO query
#   * Orders - Actions - by Order Id
#   * Orders Meds - Details - by Order Id
