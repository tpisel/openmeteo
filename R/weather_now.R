#' Retrieve Current Weather from the Open-Meteo API
#'
#' @description
#'
#' `weather_now()` calls the Open-Meteo Weather API to return current weather
#' for a given location. Location provided either as string or `c(latitude,longitude)`.
#'
#' Full API documentation is available at: <https://open-meteo.com/en/docs>.
#'
#' @param location `c(latitude,longitude)` WGS84 coordinate pair or a place name (via a fuzzy search using [geocode()])
#' @param response_units convert temperature, windspeed, or precipitation units, defaulting to:
#' `c(temperature_unit = "celsius", windspeed_unit = "kmh", precipitation_unit = "mm")`
#' @param timezone specify timezone of data (defaults to the timezone local to the specified `location`)
#'
#' @return Current weather conditions: temperature, windspeed, winddirection and weathercode
#'
#' @export
#'
#' @examples
#'
#' # obtain temperature forecasts for London's next 7 days
#' weather_forecast("London",hourly="temperature_2m")
#'


# this is the same as the other one but you have

weather_now <- function(
  location,
  response_units = NULL,
  timezone = "auto"
) {

  coordinates <- .coords_generic(location)
  base_url <- "https://api.open-meteo.com/v1/forecast"

  # base queries
  queries <- list(
    latitude = coordinates[1],
    longitude = coordinates[2],
    current_weather = TRUE,
    timezone = timezone
  )

  # add units as supplied
  queries <- c(queries,response_units)

  # request (decode necessary as API treats ',' differently to '%2C')
  pl <- httr::GET(utils::URLdecode(httr::modify_url(base_url, query = queries)))

  # parse response
  pl_parsed <- httr::content(pl, as = "parsed")

  # parse response data

  tz <- pl_parsed$timezone

  current_tibble <-
    pl_parsed$current_weather |>
    .nestedlist_as_tibble() |>
    dplyr::mutate(time = as.POSIXct(time, format = "%Y-%m-%dT%H:%M", tz = tz)) |>
    dplyr::relocate(datetime = time)

  current_tibble

}








