library(testthat)
library(highcharter)
library(dplyr)

# import plotData() function
source("Plot.R")

# dummy data for testing function
test_data <- data.frame(
  locality = c("Poland - Bug","Poland - Podlaskie","Poland - Warszawa"),
  vernacularName = c("Small Skipper", "Large Skipper", "Mandarin Duck"),
  individualCount = c(10,5,9),
  longitudeDecimal = c(19.1, 19.5,19.2),
  latitudeDecimal = c(52.1, 52.5,52.2),
  eventDate = c("2015-03-11","2014-06-16","2016-05-08")
)

# test that plot function will always return a highcharter plot
test_that("plot function creates a highcharter plot",{
  # test when vernacular is NULL
  vernacular_null <- plotData(df = test_data,vernacular = NULL)
  expect_true(inherits(vernacular_null,"highcharter"))
  
  # test with filtered vernacular name
  filtered_vernacular <- plotData(df = test_data,vernacular = "Small Skipper")
  expect_true(inherits(filtered_vernacular,"highcharter"))
})
