#' Retrieve climate change forecasts from the Open-Meteo API
#'
#' @description
#'
#' `climate_forecast()` calls the Open-Meteo Climate Change Forecast API to
#' obtain long-range weather projections from a range of climate models.
#'
#' Refer to the API documentation at:
#' <https://open-meteo.com/en/docs/climate-api>
#'
#' @details
#'
#' You will need to specify at least one weather variable, such as temperature,
#' that you want projected forecasts for. The models currently only provide
#' weather data aggregated at _daily_ intervals. Multiple variables can be
#' supplied as a list.
#'
#' Example daily climate forecast variables include:
#'
#' |**Variable**        |**Description**                                       |
#' |--------------------|------------------------------------------------------|
#' |`temperature_2m_max`|Maximum daily air temperature at 2 meters above ground|
#' |`precipitation_sum` |Sum of rain, showers, and snow over the preceding day |
#' |`windspeed_10m_max` |Maximum daily wind speed at 10 meters above ground    |
#'
#' Different climate change models can be specified, which may differ in the
#' weather variables predicted. Models include:
#'
#' |**Model**      |**Origin** |**Resolution**                                 |
#' |---------------|-----------|-----------------------------------------------|
#' |`EC_Earth3P_HR`|Europe     |29 km                                          |
#' |`FGOALS_f3_H`  |China      |28 km                                          |
#' |`MRI_AGCM3_2_S`|Japan      |20 km                                          |
#'
#' For all models and their available fields, refer to the full documentation
#' for the climate API at: <https://open-meteo.com/en/docs/climate-api>
#'
#'
#' @param location Required. The location for which data will be retrieved.
#'   Supplied as either a `c(latitude,longitude)` WGS84 coordinate pair or a
#'   place name string (with co-ordinates obtained via [geocode()]).
#' @param start,end Required. Future start and end dates in ISO 8601 (e.g.
#'   "2020-12-31").
#' @param daily Required. A weather variable accepted by the API, or list
#'   thereof. See details below.
#' @param response_units Supply to convert temperature, windspeed, or
#'   precipitation units. This defaults to: `list(temperature_unit = "celsius",`
#'   `windspeed_unit = "kmh", precipitation_unit = "mm")`
#' @param model Supply to specify a climate model for forecasted values (refer
#'   to the API documentation).
#' @param timezone specify timezone for time data as a string, i.e.
#'   "australia/sydney" (defaults to "auto", the timezone local to the specified
#'   `location`).
#'
#' @return Requested climate forecast data for the given location and time
#'   period, as a tidy tibble.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Obtain projected precipitation for the North Pole in 2050
#' climate_forecast(c(90, 0),
#'   '2050-06-01', '2050-07-01',
#'   daily = "precipitation_sum"
#'   )
#'
#' # Obtain projected temperatures for Madrid in 2050 in Fahrenheit, with ESMI1
#' climate_forecast("Madrid",
#'   '2050-06-01', '2050-07-01',
#'   daily = 'temperature_2m_max',
#'   model = 'MPI_ESM1_2_XR',
#'   response_units = list(temperature_unit = "fahrenheit")
#'   )
#' }
climate_forecast <- function(
    location,
    start,
    end,
    daily = NULL,
    response_units = NULL,
    model = NULL,
    timezone = "auto") {
  # validation
  if (is.null(daily)) {
    stop("daily weather variables not supplied")
  }
  if (!is.null(start) && !.is.date(start)) {
    stop("start and end dates must be in ISO-1806 format")
  }
  if (!is.null(end) && !.is.date(end)) {
    stop("start and end dates must be in ISO-1806 format")
  }

  base_url <- "https://climate-api.open-meteo.com/v1/climate"

  .query_openmeteo(
    location,
    start, end,
    NULL, daily, # no hourly variables for climate forecasts
    response_units,
    model,
    timezone,
    base_url
  )
}
