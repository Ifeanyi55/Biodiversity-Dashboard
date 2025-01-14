library(shiny)
library(bs4Dash)
library(leaflet)
library(highcharter)
library(reactable)
library(reactablefmtr)
library(data.table)
library(dplyr)
library(lubridate)


# load map function
source("Map.R")

# load plot function
source("Plot.R")

# load table function
source("Table.R")

# load dataset
bio_poland <- fread("poland.csv")

# filter dataset and select relevant columns
poland_bio <- bio_poland |>
  filter(vernacularName != "") |>
  select(
    vernacularName,
    longitudeDecimal,
    latitudeDecimal,
    individualCount,
    eventDate,
    locality
  ) |>
  mutate(eventDate = as_date(eventDate))


# add blanks to vector of choices so that the widget loads blank
choices2 <- unique(poland_bio$vernacularName)


# create dashboard brand
dash_title <- dashboardBrand(
  title = "Biodiversity in Poland",
  color = "primary",
  href = "https://www.gbif.org/occurrence/search?q=Poland&country=PL",
  image = "bird_2.jpg"
)

# define UI
ui <- dashboardPage(
  title = "Biodiversity",
  scrollToTop = T,
  help = NULL,
  dark = NULL,
  header = dashboardHeader(title = dash_title),
  sidebar = dashboardSidebar(disable = T),
  footer = dashboardFooter(left = "Source: Global Biodiversity Informational Facility"),
  body = dashboardBody(
    tags$style(HTML("
    .box {
      border: 2px solid #007bff !important;
      box-shadow: none !important;
    }
  ")),
    fluidRow(
      column(
        12,
        selectizeInput("vernacular",
          label = strong("Vernacular Name"),
          choices = choices2,
          selected = "Mandarin Duck",
          width = "100%"
        )
      )
    ),
    fluidRow(
      box(
        class = "box",
        title = "Map of Observations",
        width = 12,
        status = "primary",
        solidHeader = T,
        leafletOutput("map_plot"), elevation = 4
      )
    ),
    fluidRow(
      box(
        class = "box",
        title = "Plot of Observation Over time",
        status = "primary",
        solidHeader = T,
        highchartOutput("chart"), elevation = 4
      ),
      box(
        class = "box",
        title = "Observation Data",
        status = "primary",
        solidHeader = T,
        reactableOutput("table", height = 400),
        elevation = 4
      )
    )
  ),
  fullscreen = T
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  # make input values reactive and return the defaults if both input values are NULL
  input_vernacular <- reactive({
    input$vernacular %||% "Mandarin Duck"
  })


  # render map
  output$map_plot <- renderLeaflet({
    req(poland_bio)
    tryCatch(
      {
        mapData(
          df = poland_bio,
          vernacular = input_vernacular()
        )
      },
      error = function(e) {
        leaflet() |>
          addTiles() |>
          addPopups(lng = 0, lat = 0, popup = "No data available for the selected filters")
      }
    )
  })

  # render chart
  output$chart <- renderHighchart({
    req(poland_bio)
    tryCatch(
      {
        plotData(
          df = poland_bio,
          vernacular = input_vernacular()
        )
      },
      error = function(e) {
        highchart() |>
          hc_title(text = "No data available for the selected filters")
      }
    )
  })

  # render table
  output$table <- renderReactable({
    req(poland_bio)
    tryCatch(
      {
        tableFunction(
          df = poland_bio,
          vernacular = input_vernacular()
        )
      },
      error = function(e) {
        reactable(data.frame(
          Message = "No data available for the selected filters"
        ))
      }
    )
  })
}

# Run the application
shinyApp(ui = ui, server = server)
