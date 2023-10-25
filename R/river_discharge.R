#' Retrieve river discharge data from the Open-Meteo API
#'
#' @description
#'
#' `river_discharge()` calls the Open-Meteo Global Flood API to obtain simulated
#' river discharge from the nearest river. Data obtained from the Global Flood
#' Awareness System (GloFAS). Forecasts and historical data is available.
#'
#' Refer to the API documentation at: <https://open-meteo.com/en/docs/flood-api>
#'
#'
#' @details
#'
#' You will need to specify at least one river discharge variable to retrieve
#' data for. These variables are sampled or aggregated at daily intervals, and
#' can be supplied as a list to request multiple variables over the same time
#' period.
#'
#' Example daily forecast variables include:
#'
#' |**Variable**            |**Description**                                   |
#' |------------------------|--------------------------------------------------|
#' |`river_discharge`       |Daily river discharge rate in m³/s                |
#' |`river_discharge_median`|Median over ensemble members (forecasts only)     |
#' |`river_discharge_max`   |Maximum over ensemble members (forecasts only)    |
#'
#' Full documentation for the forecast API is available at:
#' <https://open-meteo.com/en/docs/flood-api>
#'
#' @param location Required. The location for which data will be retrieved.
#'   Supplied as either a `c(latitude,longitude)` WGS84 coordinate pair or a
#'   place name string (with co-ordinates obtained via [geocode()]).
#' @param start,end Start and end dates in ISO 8601 (e.g. "2020-12-31"). If no
#'   dates are supplied, data for the next 3 months will be provided by default.
#' @param daily Required. A weather variable accepted by the API, or list
#'   thereof. See details below.
#' @param model Supply to specify a model for forecasted values (defaults to
#'   latest GloFAS model).
#'
#' @return Requested river discharge data (m³/s) for the given location and time
#'   period, as a tidy tibble.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # obtain historical flood data for Brisbane
#' river_discharge("Brisbane",
#'   "2022-01-01", "2022-02-01",
#'   daily = "river_discharge"
#' )
#' }
river_discharge <- function(
    location,
    start = NULL,
    end = NULL,
    daily = NULL,
    model = NULL) {
  # validation
  if (is.null(daily)) {
    stop("daily measure not supplied")
  }
  if (!is.null(start) && !.is.date(start)) {
    stop("start and end dates must be in ISO-1806 format")
  }
  if (!is.null(end) && !.is.date(end)) {
    stop("start and end dates must be in ISO-1806 format")
  }

  base_url <- "https://flood-api.open-meteo.com/v1/flood"

  .query_openmeteo(
    location,
    start, end,
    NULL, daily,
    NULL,
    model,
    NULL, # doesn't support timezone
    NULL, # doesn't support downscaling option
    base_url
  )
}
