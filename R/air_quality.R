#' Retrieve air quality data from the Open-Meteo API
#'
#' @description
#'
#' `air_quality()` calls the Open-Meteo Air Quality API to obtain pollutant,
#' pollen, and particulate data. Historical and forecasted data is available.
#'
#' Refer to the API documentation at:
#' <https://open-meteo.com/en/docs/air-quality-api>
#'
#' @details
#'
#' You will need to specify at least one air quality variable, such as PM10 or
#' Carbon Monoxide, that you want forecasted data for. These variables are
#' sampled or aggregated at _hourly_ intervals, and can be supplied as a list to
#' request multiple variables over the same time period.
#'
#' Example hourly air quality variables include:
#'
#' |**Variable**     |**Description**                                          |
#' |-----------------|---------------------------------------------------------|
#' |`pm10`           |Particulate matter with diameter smaller than 10 µm      |
#' |`carbon_monoxide`|Concentration in μg/m³ 10m above surface                 |
#' |`european_aqi`   |European Air Quality Index                               |
#' |`us_aqi`         |United States Air Quality Index                          |
#' |`dust`           |Saharan dust particles 10m above ground                  |
#'
#' Full documentation for the forecast API is available at:
#' <https://open-meteo.com/en/docs/air-quality-api>
#'
#' @param location Required. The location for which data will be retrieved.
#'   Supplied as either a `c(latitude,longitude)` WGS84 coordinate pair or a
#'   place name string (with co-ordinates obtained via [geocode()]).
#' @param start,end Start and end dates in ISO 8601 (e.g. "2020-12-31"). If no
#'   dates are supplied, data for the next 5 days will be provided by default.
#' @param hourly Required. An air quality variable accepted by the
#'   API, or list thereof. See details below.
#' @param timezone specify timezone for time data as a string, i.e.
#'   "australia/sydney" (defaults to "auto", the timezone local to the specified
#'   `location`).
#'
#' @return Requested air quality data for the given location and time, as a
#'   tidy tibble.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # obtain Carbon Monoxide levels for Beijing over the next 5 days
#' air_quality("Beijing", hourly = "carbon_monoxide")
#' }
air_quality <- function(
    location,
    start = NULL,
    end = NULL,
    hourly = NULL,
    timezone = "auto") {
  # validation
  if (is.null(hourly)) {
    stop("hourly measure not supplied")
  }
  if (!is.null(start) && !.is.date(start)) {
    stop("start and end dates must be in ISO-1806 format")
  }
  if (!is.null(end) && !.is.date(end)) {
    stop("start and end dates must be in ISO-1806 format")
  }

  base_url <- "https://air-quality-api.open-meteo.com/v1/air-quality"

  .query_openmeteo(
    location,
    start, end,
    hourly, NULL, # non-set fields passed as null
    NULL,
    NULL,
    timezone,
    base_url
  )
}
