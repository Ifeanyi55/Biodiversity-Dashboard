library(testthat)
library(leaflet)
library(dplyr)

# import mapData() function
source("Map.R")

# dummy data for testing function
test_data <- data.frame(
  locality = c("Poland - Bug","Poland - Podlaskie"),
  vernacularName = c("Small Skipper", "Large Skipper"),
  individualCount = c(10,5),
  longitudeDecimal = c(19.1, 19.5),
  latitudeDecimal = c(52.1, 52.5)
)

# test that function will always return a leaflet map
test_that("map function creates leaflet map",{
  
  # test when vernacular is NULL
  vernacular_null <- mapData(df = test_data,vernacular = NULL)
  expect_true(inherits(vernacular_null,"leaflet"))
  
  # test with filtered vernacular name
  filtered_vernacular <- mapData(df = test_data,vernacular = "Small Skipper")
  expect_true(inherits(filtered_vernacular,"leaflet"))
  
  # check that filter worked
  filtered_vernacular_df <- test_data |> filter(vernacularName == "Small Skipper")
  expect_equal(nrow(filtered_vernacular_df),1)
})


