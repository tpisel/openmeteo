#' Retrieve weather forecasts from the Open-Meteo API
#'
#' @description
#'
#' `weather_forecast()` calls the Open-Meteo Weather Forecast API to obtain
#' meteorological forecasts for a given location.
#'
#' Refer to the API documentation at: <https://open-meteo.com/en/docs>
#'
#' @details
#'
#' You will need to specify at least one weather variable, such as temperature,
#' that you want forecasted data for. These variables are sampled or aggregated
#' at _hourly_ or _daily_ intervals, and can be supplied as a list to request
#' multiple variables over the same time period.
#'
#' Example _Hourly_ forecast variables include:
#'
#' |**Variable**    |**Description**                                           |
#' |----------------|----------------------------------------------------------|
#' |`temperature_2m`|Air temperature at 2 meters above ground                  |
#' |`precipitation` |Sum of rain, showers, and snow over the preceding hour    |
#' |`windspeed_10m` |Wind speed at 10 meters above ground                      |
#' |`cloudcover`    |Total cloud cover as an area fraction                     |
#' |`pressure_msl`  |Atmospheric air pressure at mean sea level                |
#'
#' Example _Daily_ forecast variables include:
#'
#' |**Variable**        |**Description**                                       |
#' |--------------------|------------------------------------------------------|
#' |`temperature_2m_max`|Maximum daily air temperature at 2 meters above ground|
#' |`precipitation_sum` |Sum of rain, showers, and snow over the preceding day |
#' |`windspeed_10m_max` |Maximum daily wind speed at 10 meters above ground    |
#'
#' Full documentation for the forecast API is available at:
#' <https://open-meteo.com/en/docs>
#'
#' You can also call [weather_variables()] to retrieve an (incomplete) shortlist
#' of valid hourly and daily weather variables.
#'
#' @param location Required. The location for which data will be retrieved.
#'   Supplied as either a `c(latitude,longitude)` WGS84 coordinate pair or a
#'   place name string (with co-ordinates obtained via [geocode()]).
#' @param start,end Start and end dates in ISO 8601 (e.g. "2020-12-31"). If no
#'   dates are supplied, data for the next 7 days will be provided by
#'   default.
#' @param hourly,daily At least one required. A weather variable accepted by the
#'   API, or list thereof. See details below.
#' @param response_units Supply to convert temperature, windspeed, or
#'   precipitation units. This defaults to: `list(temperature_unit = "celsius",`
#'   `windspeed_unit = "kmh", precipitation_unit = "mm")`
#' @param model Supply to specify a model for forecasted
#'   values (defaults to autoselection of best model).
#' @param timezone specify timezone for time data as a string, i.e.
#'   "australia/sydney" (defaults to "auto", the timezone local to the specified
#'   `location`).
#'
#' @return Requested weather forecast data for the given location and time, as a
#'   tidy tibble.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # obtain temperature forecasts for the South Pole's next 7 days
#' weather_forecast(c(-90, 0), hourly = "temperature_2m")
#'
#' # obtain temperature and precipitation forecasts for NYC in Imperial units
#' weather_forecast("nyc",
#'   hourly = c("temperature_2m", "precipitation"),
#'   response_units = list(
#'     temperature_unit = "fahrenheit",
#'     precipitation_unit = "inch"
#'   )
#' )
#'
#' # will it rain tomorrow in Jakarta?
#' tomorrow <- Sys.Date() + 1
#' weather_forecast("jakarta", tomorrow, tomorrow, daily = "precipitation_sum")
#' }
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
  if (is.null(hourly) && is.null(daily)) {
    stop("hourly or daily measure not supplied")
  }
  if (!is.null(start) && !.is.date(start)) {
    stop("start and end dates must be in ISO-1806 format")
  }
  if (!is.null(end) && !.is.date(end)) {
    stop("start and end dates must be in ISO-1806 format")
  }

  base_url <- "https://api.open-meteo.com/v1/forecast"

  .query_openmeteo(
    location,
    start, end,
    hourly, daily,
    response_units,
    model,
    timezone,
    NULL, # doesn't support downscaling option
    base_url
  )
}
