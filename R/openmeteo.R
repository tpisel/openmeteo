#' @title openmeteo: retrieve weather data from the Open-Meteo API
#'
#' @description `openmeteo` provides functions for accessing the Open-Meteo
#'   weather API, enabling the desired weather data or forecasts to be retrieved
#'   in a tidy data format. An API key is _not_ required to access the
#'   Open-Meteo API.
#'
#'   Open-Meteo provides several API endpoints. This package
#'   currently enables access to the _Weather Forecast API_, the _Historical
#'   Weather API_, and the _Geocoding API_ through the following functions:
#'
#'   - [weather_forecast()] - retrieve weather forecasts for a location
#'   - [weather_history()] - retrieve historical weather observations for a
#'   location
#'   - [weather_now()] - simple function to return current weather for a
#'   location
#'   - [geocode()] - return the co-ordinates and other data for a location name
#'   - [weather_variables()] - retrieve a shortlist of valid forecast or
#'   historical weather variables provided
#'
#'   Please review the API documentation at <https://open-meteo.com/> for
#'   details regarding the data available, its types, units, and other caveats
#'   and considerations.
#'
#' @docType package
#' @name openmeteo
NULL
#>  NULL
