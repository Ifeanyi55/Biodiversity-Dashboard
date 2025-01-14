# import specific functions from relevant libraries
box::use(leaflet[
  leaflet,
  providers,
  addTiles,
  addProviderTiles,
  addPolygons,
  addLegend,
  addControl,
  setView,
  addCircleMarkers,
  colorBin,
  colorNumeric,
  markerClusterOptions,
  labelOptions
])
box::use(leaflet.extras[
  addFullscreenControl,
  addSearchFeatures,
  searchFeaturesOptions
])
box::use(dplyr[filter])
box::use(viridis)


#* @param df data frame containing map coordinates
#* @param vernacular the vernacular names of the animals
#* @param locality regions in Poland
# write map function
mapData <- function(df, vernacular) {
  # set default values if arguments are NULL or empty
  if (is.null(vernacular)) {
    vernacular <- "Mandarin Duck"
  } else {
    vernacular
  }

  # filter the data based on vernacular and locality
  filtered_df <- df |>
    filter(vernacularName == vernacular)


  # ensure there is data to display
  if (nrow(filtered_df) == 0) {
    leaflet() |>
      addTiles() |>
      addPopups(lng = 0, lat = 0, popup = "No data available for the selected filters")
  }


  # create a color palette for markers
  pal <- colorNumeric(palette = "Paired", domain = filtered_df$individualCount)

  # create the tooltip labels
  labels <- paste0(
    "<b>Vernacular Name: </b>", filtered_df$vernacularName, "<br>",
    "<b>Individual Count: </b>", filtered_df$individualCount, "<br>",
    "<b>Locality: </b>", filtered_df$locality
  ) |> lapply(htmltools::HTML)

  # create the map
  leaflet(filtered_df) |>
    addTiles() |>
    addProviderTiles(providers$CartoDB.Positron) |>
    addCircleMarkers(
      lng = ~longitudeDecimal,
      lat = ~latitudeDecimal,
      color = ~ pal(individualCount),
      fillColor = ~ pal(individualCount),
      fillOpacity = 0.7,
      label = labels,
      labelOptions = labelOptions(
        style = list("font-weight" = "normal", padding = "3px 8px"),
        textsize = "15px",
        direction = "auto"
      )
    ) |>
    addLegend(
      pal = pal,
      values = ~individualCount,
      title = "Individual Count",
      position = "bottomright"
    )
}
