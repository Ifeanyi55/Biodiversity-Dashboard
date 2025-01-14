library(reactablefmtr)

# import specific functions from relevant libraries
box::use(reactable[reactable, colDef])
box::use(dplyr[filter])


#* @param df the data frame containing the data
#* @param vernacular the vernacular names of the animals
#* @param locality regions in Poland
tableFunction <- function(df, vernacular) {
  # set default values if arguments are NULL or empty
  if (is.null(vernacular) || vernacular == "") {
    vernacular <- "Mandarin Duck"
  } else {
    vernacular
  }

  # filter the data based on vernacular and locality
  filtered_df <- df |>
    filter(vernacularName == vernacular)


  # ensure there is data to display
  if (nrow(filtered_df) == 0) {
    reactable(data.frame(
      Message = "No data available for the selected filters"
    ))
  }

  # return table
  reactable(
    filtered_df,
    filterable = TRUE,
    searchable = TRUE,
    striped = TRUE,
    highlight = TRUE,
    bordered = TRUE,
    compact = TRUE,
    defaultPageSize = 10,
    columns = list(
      vernacularName = colDef(name = "Common Name"),
      longitudeDecimal = colDef(name = "Longitude"),
      latitudeDecimal = colDef(name = "Latitude"),
      individualCount = colDef(name = "Count"),
      eventDate = colDef(name = "Date"),
      locality = colDef(name = "Location")
    ),
    theme = reactableTheme(
      highlightColor = "#627cfc",
      borderColor = "#1239fe",
      borderWidth = 2
    )
  )
}
