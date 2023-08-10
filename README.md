# openmeteo
_An Open Meteo SDK for R_

<!-- badges: start -->
[![R-CMD-check](https://github.com/tpisel/openmeteo/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tpisel/openmeteo/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`openmeteo` provides functions for accessing the [Open-Meteo
weather API](https://open-meteo.com/), enabling the desired weather data or forecasts to be retrieved
in a tidy data format. An API key is _not_ required to access the
Open-Meteo API.

Install and load with: `install.packages("openmeteo") library(openmeteo)`  
Getting current weather for a location is as easy as: `weather_now('tokyo')`  
Explore the documentation with `?openmeteo`

Open-Meteo provides several API endpoints through the following functions:

**Core Weather APIs**
 - `weather_forecast()` - retrieve weather forecasts for a location
 - `weather_history()` - retrieve historical weather observations for a
 location
 - `weather_now()` - simple function to return current weather for a
 location
 - `weather_variables()` - retrieve a shortlist of valid forecast or
 historical weather variables provided

**Other APIs**
 - `geocode()` - return the co-ordinates and other data for a location name
 - `climate_forecast()` - return long-range climate modelling for a location
 - `river_discharge()` - return flow volumes for the nearest river
 - `marine_forecast()` - return ocean conditions data for a location
 - `air_quality()` - return air quality data for a location


Please review the API documentation at [Open-Meteo.com](https://open-meteo.com/) for
details regarding the data available, its types, units, and other caveats
and considerations. `openmeteo` is hosted on [CRAN](https://cran.r-project.org/web/packages/openmeteo/index.html) where it has a rendered [reference manual](https://cran.r-project.org/web/packages/openmeteo/openmeteo.pdf).

Please feel free to raise any issues / pull requests if your use case is not supported.




