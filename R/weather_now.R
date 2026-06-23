#' Retrieve Current Weather from the Open-Meteo API
#'
#' @description
#'
#' `weather_now()` calls the Open-Meteo weather API for the most recently
#' recorded weather conditions a given location. Location is provided either as
#' string or `c(latitude,longitude)`.
#'
#' @inheritParams weather_forecast
#'
#' @return Current weather conditions: temperature, windspeed, wind direction
#'   and weathercode.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # current weather in Montreal
#' weather_now("Montreal")
#'
#' # current weather at the North Pole in Imperial units
#' weather_now(c(90, 0),
#'   response_units = list(
#'     temperature_unit = "fahrenheit",
#'     windspeed_unit = "mph"
#'   )
#' )
#' }
weather_now <- function(
    location,
    response_units = NULL,
    timezone = "auto") {
  coordinates <- .coords_generic(location)
  base_url <- .lookup_open_meteo_url(fxn_name = "weather_now")

  # base queries
  queries <- list(
    latitude = coordinates[1],
    longitude = coordinates[2],
    current_weather = TRUE,
    timezone = timezone
  )

  # add units as supplied
  queries <- c(queries, response_units)

  api_key <- Sys.getenv("OPENMETEO_API_KEY", unset = NA_character_)

  if (!is.na(api_key) && nzchar(api_key)) {
    queries$apikey <- api_key
  }

  # request (decode necessary as API treats ',' differently to '%2C')
  pl <- httr::GET(utils::URLdecode(httr::modify_url(base_url, query = queries)))
  .response_OK(pl)

  # parse response
  pl_parsed <- httr::content(pl, as = "parsed")

  # parse response data

  tz <- pl_parsed$timezone

  current_tibble <-
    pl_parsed$current_weather |>
    .nestedlist_as_tibble() |>
    dplyr::mutate(time = as.POSIXct(time,
      format = "%Y-%m-%dT%H:%M",
      tz = tz
    )) |>
    dplyr::relocate(datetime = time)

  current_tibble
}
