# openmeteo
_An Open Meteo SDK for R_

<!-- badges: start -->
[![R-CMD-check](https://github.com/tpisel/openmeteo/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tpisel/openmeteo/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`openmeteo` provides functions for accessing the Open-Meteo
weather API, enabling the desired weather data or forecasts to be retrieved
in a tidy data format. An API key is _not_ required to access the
Open-Meteo API.

Install with: `install.packages("openmeteo")`

Open-Meteo provides several API endpoints through the following functions:

**Core Weather APIs**
 - [weather_forecast()] - retrieve weather forecasts for a location
 - [weather_history()] - retrieve historical weather observations for a
 location
 - [weather_now()] - simple function to return current weather for a
 location
 - [weather_variables()] - retrieve a shortlist of valid forecast or
 historical weather variables provided

**Other APIs**
 - [geocode()] - return the co-ordinates and other data for a location name
 - [climate_forecast()] - return long-range climate modelling for a location
 - [river_discharge()] - return flow volumes for the nearest river
 - [marine_forecast()] - return ocean conditions data for a location
 - [air_quality()] - return air quality data for a location


Please review the API documentation at [Open-Meteo.com](https://open-meteo.com/) for
details regarding the data available, its types, units, and other caveats
and considerations.




