#' Retrieve Weather Forecasts from the Open-Meteo Forecasting API
#'
#' @description
#'
#' `weather_forecast()` calls the Open-Meteo Weather Forecast API for a given
#' location. Location provided either as string or `c(latitude,longitude)`. The
#' next 7 days will be provided if start and end days are not specified.
#' Full API documentation is available at: <https://open-meteo.com/en/docs>.
#' You can also call [weather_variables()] to retrieve a shortlist of valid hourly
#' and daily weather variables.
#'
#' @param location `c(latitude,longitude)` WGS84 coordinate pair or a place name (via a fuzzy search using [geocode()])
#' @param start start date in ISO 8601 (e.g. "2020-12-30")
#' @param end end date in ISO 8601 (e.g. "2021-01-30")
#' @param hourly an hourly weather variable provided by the API, or list thereof
#' @param daily a daily weather variable provided by the API, or list thereof
#' @param response_units convert temperature, windspeed, or precipitation units, defaulting to:
#' `c(temperature_unit = "celsius", windspeed_unit = "kmh", precipitation_unit = "mm")`
#' @param model specify a model (or list of models) for forecasted values
#' (defaults to autoselection of best model)
#' @param timezone specify timezone of data (defaults to the timezone local to the specified `location`)
#'
#' @return specified weather forecast data for the given location and time
#'
#' @export
#'
#' @examples
#'
#' # obtain temperature forecasts for London's next 7 days
#' weather_forecast("London", hourly = "temperature_2m")
#'
weather_forecast <- function(
    location,
    start = NULL,
    end = NULL,
    hourly = NULL,
    daily = NULL,
    response_units = NULL,
    model = NULL,
    timezone = "auto") {
  # validation
  if (is.null(hourly) && is.null(daily)) stop("hourly or daily measure not supplied")
  if (!is.null(start)) if (!.is.date(start)) stop("start and end dates must be in ISO-1806 format")
  if (!is.null(end)) if (!.is.date(end)) stop("start and end dates must be in ISO-1806 format")

  base_url <- "https://api.open-meteo.com/v1/forecast"

  .query_openmeteo(location, start, end, hourly, daily, response_units, model, timezone, base_url)
}
