library(testthat)
library(reactable)
library(reactablefmtr)
library(dplyr)

# import tableFunction() function
source("Table.R")

# dummy data for testing function
test_data <- data.frame(
  locality = c("Poland - Bug","Poland - Podlaskie"),
  vernacularName = c("Small Skipper", "Large Skipper"),
  individualCount = c(10,5),
  longitudeDecimal = c(19.1, 19.5),
  latitudeDecimal = c(52.1, 52.5),
  eventDate = c("2015-03-11","2014-06-16")
)

# test that function will always return a reactable table
test_that("table function creates reactable table",{
  
  # test when vernacular is NULL
  vernacular_null <- tableFunction(df = test_data,vernacular = NULL)
  expect_true(inherits(vernacular_null,"reactable"))
  
  # test with filtered vernacular name
  filtered_vernacular <- tableFunction(df = test_data,vernacular = "Small Skipper")
  expect_true(inherits(filtered_vernacular,"reactable"))
  
  # check that filter worked
  filtered_vernacular_df <- test_data |> filter(vernacularName == "Small Skipper")
  expect_equal(nrow(filtered_vernacular_df),1)
})


