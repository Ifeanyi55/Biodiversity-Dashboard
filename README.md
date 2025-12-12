# **Biodiversity Dashboard Project**

## Project Description

An interactive dashboard that visualizes the biodiversity data from Poland.

## Key Features

- An interactive map
- An interactive plot
- An interactive table
- A dropdown menu for dynamically visualizing data

## Technologies Used
- R
- R/Shiny
- Bs4Dash
- Leaflet, for building an interactive map
- Highcharter, for building an interactive plot
- Reactable, for building an interactive table
- Miller, for filtering a large dataset
- CSS, for moderate dashboard styling

## Dataset

This project required the use of a 20GB dataset. The dataset covered the whole world, but focus was on data from Poland. Therefore, the 20GB dataset had to be filtered down to results from Poland.
You can achieve that using [miller](https://miller.readthedocs.io/en/6.13.0/), a command line tool that can be used to filter the data down to only results from Poland before it is loaded into the R session. 
You can accomplish that by running the following simple command in your command line: `mlr --csv filter '$country == "Poland"' occurence.csv > poland.csv`.

## Deployment

The application was deployed on [Hugging Face](https://huggingface.co/) space using the docker file below:

```
FROM rocker/shiny-verse:latest

WORKDIR /code

# Install required system libraries
RUN apt-get update && apt-get install -y \
    libglpk40 \
    && rm -rf /var/lib/apt/lists/*

# Install stable packages from CRAN
RUN install2.r --error \
    shiny \
    bs4Dash \
    leaflet \
    leaflet.extras \
    highcharter \
    reactable \
    reactablefmtr \
    data.table \
    dplyr \
    lubridate \
    box \
    viridis 
    

# Install development packages from GitHub
RUN installGithub.r \
    rstudio/bslib \
    rstudio/httpuv

COPY . .

CMD ["R", "--quiet", "-e", "shiny::runApp(host='0.0.0.0', port=7860)"]

```
You can access the web version of the application [here](https://biodiversity-dashboard.netlify.app/)
