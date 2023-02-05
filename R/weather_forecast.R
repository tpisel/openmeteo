#' Retrieve Weather Forecasts from the Open-Meteo Forecasting API
#'
#' @description
#'
#' `weather_forecast()` calls the Open-Meteo Weather Forecast API for a given
#' location. Location provided either as string or `c(latitude,longitude)`
#' API documentation is available at <https://open-meteo.com/en/docs>
#'
#'
#'
#' @param location a `c(latitude,longitude)` pair or place name (via [geolocate()])
#' @param start start date in ISO 8601 (e.g. "2020-12-30")
#' @param end end date in ISO 8601 (e.g. "2021-01-30")
#' @param hourly an hourly weather variable provided by the API, or list thereof
#' @param daily a daily weather variable provided by the API, or list thereof
#' @param response_units convert temperature, windspeed, or precipitation units:
#' `c(temperature_unit = "celsius", windspeed_unit = "kmh", precipitation_unit = "mm")`
#' @param models specify a model for forecasted values
#' (defaults to autoselection of best model)
#' @param timezone specify timezone of data (defaults to local to location)
#'
#' @return details for each location (latitude, longitude, elevation ...)
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' }

weather_forecast <- function(
  location,
  start,
  end,
  hourly = NULL,
  daily = NULL,
  response_units = default_units,
  models = "auto",
  timezone = NULL
  ){

  if(is.null(hourly) & is.null(daily)) stop("hourly or daily measure not supplied")
  if(!(.is.date(start) & .is.date(end))) stop("start and end dates must be in ISO-1806 format")

  coordinates <- .coords_generic(location)
  base_url <- "https://api.open-meteo.com/v1/forecast"

  queries <- list(
    latitude = coordinates[1],
    longitude = coordinates[2],
  )


}





