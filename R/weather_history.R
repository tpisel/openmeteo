#' Retrieve historical weather data from the Open-Meteo API
#'
#' @description
#'
#' `weather_history()` calls the Open-Meteo Historical Weather API to obtain
#' weather data for a given location and historical time period.
#'
#' @details
#'
#' You will need to specify at least one weather variable, such as temperature,
#' that you want historical data for. These variables have been sampled or
#' aggregated at _hourly_ or _daily_ intervals, and can be supplied as a list to
#' request multiple variables over the same time period.
#'
#' Example _Hourly_ historical weather variables include:
#'
#' |**Variable**    |**Description**                                           |
#' |----------------|----------------------------------------------------------|
#' |`temperature_2m`|Air temperature at 2 meters above ground                  |
#' |`precipitation` |Sum of rain, showers, and snow over the preceding hour    |
#' |`windspeed_10m` |Wind speed at 10 meters above ground                      |
#' |`cloudcover`    |Total cloud cover as an area fraction                     |
#' |`pressure_msl`  |Atmospheric air pressure at mean sea level                |
#'
#' Example _Daily_ historical weather variables include:
#'
#' |**Variable**        |**Description**                                       |
#' |--------------------|------------------------------------------------------|
#' |`temperature_2m_max`|Maximum daily air temperature at 2 meters above ground|
#' |`precipitation_sum` |Sum of rain, showers, and snow over the preceding day |
#' |`windspeed_10m_max` |Maximum daily wind speed at 10 meters above ground    |
#'
#' Full documentation for the historical weather API is available at:
#' <https://open-meteo.com/en/docs/historical-weather-api>
#'
#' You can also call [weather_variables()] to retrieve an (incomplete) shortlist
#' of valid hourly and daily weather variables.
#'
#' @inheritParams weather_forecast
#'
#' @param start,end Required. Start and end dates in ISO 8601 (e.g.
#'   "2020-12-31").
#' @param model Supply to specify a model for re-analysis.
#'
#' @return Specified weather forecast data for the given location and time
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # obtain cloud cover history for London over 2020
#' weather_history("London",
#'   start = "2020-01-01",
#'   end = "2021-12-31",
#'   hourly = "cloudcover"
#' )
#'
#' # compare a week ago's predicted precipitation with actual values, for Kyiv
#' dt <- Sys.Date() - 7
#' predicted <- weather_forecast("kyiv",
#'   start = dt, end = dt,
#'   daily = "precipitation_sum"
#' )
#' actual <- weather_history("kyiv",
#'   start = dt, end = dt,
#'   daily = "precipitation_sum"
#' )
#' }
weather_history <- function(
    location,
    start,
    end,
    hourly = NULL,
    daily = NULL,
    response_units = NULL,
    model = NULL,
    timezone = "auto") {
  # validation
  if (is.null(hourly) && is.null(daily)) {
    stop("hourly or daily measure not supplied")
  }
  if (!.is.date(start)) {
    stop("start and end dates must be in ISO-1806 format")
  }
  if (!.is.date(end)) {
    stop("start and end dates must be in ISO-1806 format")
  }

  base_url <- "https://archive-api.open-meteo.com/v1/archive"

  .query_openmeteo(
    location,
    start, end,
    hourly, daily,
    response_units,
    model,
    timezone,
    base_url
  )
}
