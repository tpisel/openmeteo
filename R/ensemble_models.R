#' Retrieve ensemble weather forecasts from the Open-Meteo API
#'
#' @description
#'
#' `ensemble_models()` calls the Open-Meteo Ensemble Models API to obtain
#' meteorological ensemble member forecasts for a given location. Limited
#' historical data is also available via this API.
#'
#' Refer to the API documentation at: <https://open-meteo.com/en/docs/ensemble-api>
#'
#' @details
#'
#' You will need to specify at least one variable to retrieve, such as
#' temperature, that you want data for. These variables are sampled or
#' aggregated at _hourly_ intervals, and can be supplied as a list to request
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
#' Different ensemble models can be specified, which may differ in the
#' weather variables forecasted. Models include:
#'
#' |**Model**      |**Origin** |**Resolution**                                 |
#' |---------------|-----------|-----------------------------------------------|
#' |`icon_global`  |Germany    |26 km                                          |
#' |`gfs05`        |USA        |50 km                                          |
#' |`gem_global`   |Canada     |25 km                                          |
#'
#' For all models and their available fields, refer to the full documentation
#' for the ensemble models API at: <https://open-meteo.com/en/docs/ensemble-api>
#'
#' @param location Required. The location for which data will be retrieved.
#'   Supplied as either a `c(latitude,longitude)` WGS84 coordinate pair or a
#'   place name string (with co-ordinates obtained via [geocode()]).
#' @param start,end Start and end dates in ISO 8601 (e.g. "2020-12-31"). If no
#'   dates are supplied, data for the next 7 days will be provided by default.
#' @param hourly At least one required. A weather variable accepted by the
#'   API, or list thereof. See details below.
#' @param response_units Supply to convert response units for temperature, wind
#'   speed, and precipitation, e.g.
#'   `list(temperature_unit = "fahrenheit", precipitation_unit = "inch")`. Refer
#'   to the API documentation for accepted unit names.
#' @param model Supply to specify an ensemble model for forecasted values (refer
#'   to the API documentation).
#' @param timezone specify timezone for time data as a string, i.e.
#'   "australia/sydney" (defaults to "auto", the timezone local to the specified
#'   `location`).
#'
#' @return Requested ensemble model data for the given location and time, as
#'   a tidy tibble.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Obtain temperature ensemble forecasts for Indianapolis in Imperial units
#' # over the next 7 days in Fahrenheit, with GFS
#' ensemble_models("Indianapolis",
#'   hourly = "apparent_temperature",
#'   response_units = list(temperature_unit = "fahrenheit"),
#'   model = "gfs_seamless"
#' )
#' }
ensemble_models <- function(
    location,
    start = NULL,
    end = NULL,
    hourly = NULL,
    response_units = NULL,
    model = NULL,
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

  base_url <- .lookup_open_meteo_url(fxn_name = "ensemble_models")

  .query_openmeteo(
    location,
    start, end,
    hourly, NULL, # non-set fields passed as null
    response_units,
    model,
    timezone,
    NULL, # doesn't support downscaling option
    base_url
  )
}

