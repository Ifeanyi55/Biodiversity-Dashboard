# import specific functions from relevant libraries
box::use(highcharter[
  highchart,
  hcaes,
  hc_title,
  hc_xAxis,
  hc_yAxis,
  hc_tooltip
])

box::use(dplyr[filter])

#* @param df the data frame containing the data
#* @param vernacular the vernacular names of the animals
#* @param locality regions in Poland
plotData <- function(df, vernacular) {
  # set default values if arguments are NULL or empty
  if (is.null(vernacular) || vernacular == "") {
    vernacular <- "Mandarin Duck"
  } else {
    vernacular
  }

  # dynamically filter data frame
  filtered_df <- df |>
    filter(vernacularName == vernacular)

  # ensure there is data to display
  if (nrow(filtered_df) == 0) {
    highchart() |>
      hc_title(text = "No data available for the selected filters")
  }

  # return plot
  filtered_df |>
    hchart(
      type = "scatter",
      hcaes(
        x = eventDate,
        y = individualCount
      ),
      marker = list(radius = 20)
    ) |>
    hc_title(text = "Biodiversity in Poland") |>
    hc_xAxis(title = list(text = "Event Date")) |>
    hc_yAxis(title = list(text = "Individual Count")) |>
    hc_tooltip(
      pointFormat = "Date: {point.x:%Y-%m-%d}<br>Individual Count: {point.y:.2f}"
    )
}
