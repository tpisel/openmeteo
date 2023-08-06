#' Retrieve marine conditions data from the Open-Meteo API
#'
#' @description
#'
#' `marine_forecast()` calls the Open-Meteo Marine Forecast API to obtain swell
#' and wave data for a given location. Limited historical data is also available
#' via this API.
#'
#' Refer to the API documentation at:
#' <https://open-meteo.com/en/docs/marine-weather-api>
#'
#' @details
#'
#' You will need to specify at least one variable to retrieve, such as wave
#' height, that you want data for. These variables are sampled or aggregated at
#' _hourly_ or _daily_ intervals, and can be supplied as a list to request
#' multiple variables over the same time period.
#'
#' Example _Hourly_ variables include:
#'
#' |**Variable**         |**Description**                                      |
#' |---------------------|-----------------------------------------------------|
#' |`wave_height`        |Wave height of significant mean waves                |
#' |`wind_wave_height`   |Wave height of significant wind waves                |
#' |`swell_wave_height`  |Wave height of significant swell waves               |
#' |`wind_wave_direction`|Mean direction of wind waves                         |
#' |`swell_wave_period`  |Mean period between swell waves                      |
#'
#' Example _Daily_ variables include:
#'
#' |**Variable**                   |**Description**                            |
#' |-------------------------------|-------------------------------------------|
#' |`wave_height_max`              |Maximum wave height for mean waves         |
#' |`wind_wave_direction_dominant` |Dominant wave direction of wind waves      |
#' |`swell_wave_period_max`        |Maximum wave period of swell waves         |
#'
#' Full documentation for the marine API is available at:
#' <https://open-meteo.com/en/docs/marine-weather-api>
#'
#'
#' @param location Required. The location for which data will be retrieved.
#'   Supplied as either a `c(latitude,longitude)` WGS84 coordinate pair or a
#'   place name string (with co-ordinates obtained via [geocode()]).
#' @param start,end Start and end dates in ISO 8601 (e.g. "2020-12-31"). If no
#'   dates are supplied, data for the next 7 days will be provided by default.
#' @param hourly,daily At least one required. A marine weather variable accepted
#'   by the API, or list thereof. See details below.
#' @param response_units Supply to convert response units for wave heights. This
#'   defaults to: `list(length_unit="metric") for meters. Specify "Imperial" for
#'   feet.`
#' @param timezone specify timezone for time data as a string, i.e.
#'   "australia/sydney" (defaults to "auto", the timezone local to the specified
#'   `location`).
#'
#' @return Requested marine conditions data for the given location and time, as
#'   a tidy tibble.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Obtain maximum wave heights in Nazare, Portugal, over the next week
#' marine_forecast('Nazare', daily='wave_height_max')
#' }

marine_forecast <- function(
    location,
    start = NULL,
    end = NULL,
    hourly = NULL,
    daily = NULL,
    response_units = NULL,
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

  base_url <- "https://marine-api.open-meteo.com/v1/marine"

  .query_openmeteo(
    location,
    start, end,
    hourly, daily,
    response_units,
    NULL, # no model selection for marine api
    timezone,
    base_url
  )
}
