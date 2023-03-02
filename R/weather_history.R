#' Retrieve Historical Weather Data from the Open-Meteo Forecasting API
#'
#' @description
#'
#' `weather_history()` calls the Open-Meteo Historical Weather API for a given
#' location. Location provided either as string or `c(latitude,longitude)`.
#' Start and end dates must be provided.
#'
#' Full API documentation is available at: <https://open-meteo.com/en/docs/historical-weather-api>.
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
#' weather_forecast("London",hourly="temperature_2m")
#'

weather_history <- function(
    location,
    start,
    end,
    hourly = NULL,
    daily = NULL,
    response_units = NULL,
    model = NULL,
    timezone = "auto"
){

  # validation
  if(is.null(hourly) && is.null(daily)) stop("hourly or daily measure not supplied")
  if(!.is.date(start)) stop("start and end dates must be in ISO-1806 format")
  if(!.is.date(end)) stop("start and end dates must be in ISO-1806 format")

  base_url <- "https://archive-api.open-meteo.com/v1/archive"
  coordinates <- .coords_generic(location)

  # base queries
  queries <- list(
    latitude = coordinates[1],
    longitude = coordinates[2],
    start_date = start,
    end_date = end,
    timezone = timezone
  )

  # add units/hourly/daily/model as supplied
  queries <- c(queries,response_units)
  if(!is.null(hourly)) {queries$hourly <- paste(hourly, collapse = ",")}
  if(!is.null(daily)) {queries$daily <- paste(daily, collapse = ",")}
  if(!is.null(model)) {queries$model <- paste(model, collapse = ",")}

  # request (decode necessary as API treats ',' differently to '%2C')
  pl <- httr::GET(utils::URLdecode(httr::modify_url(base_url, query = queries)))

  # parse response
  pl_parsed <- httr::content(pl, as = "parsed")

  tz <- pl_parsed$timezone

  export_both <- (!is.null(hourly)&!is.null(daily))

  # parse hourly data
  if(!is.null(pl_parsed$hourly)) {
    hourly_tibble <-
      pl_parsed$hourly |>
      .nestedlist_as_tibble() |>
      dplyr::rename_with( ~ paste0("hourly_", .x)) |>
      dplyr::mutate(datetime = as.POSIXct(hourly_time, format = "%Y-%m-%dT%H:%M", tz = tz)) |>
      dplyr::relocate(datetime, .before = hourly_time) |>
      dplyr::select(-hourly_time)

    if(!export_both) return(hourly_tibble)
  }

  # process daily data
  if(!is.null(pl_parsed$daily)) {
    daily_tibble <-
      pl_parsed$daily |>
      .nestedlist_as_tibble() |>
      dplyr::rename_with( ~ paste0("daily_", .x)) |>
      dplyr::mutate(date = as.Date(daily_time, tz = tz)) |>
      dplyr::relocate(date, .before = daily_time) |>
      dplyr::select(-daily_time)

    if(!export_both) return(daily_tibble)
  }

  # combine both hourly and daily if requested
  if(export_both) {
    d <-
      daily_tibble |>
      dplyr::mutate(date = as.character(date))

    h <-
      hourly_tibble |>
      dplyr::mutate(date = as.character(datetime)) |>
      dplyr::select(-datetime)

    dh <-
      dplyr::full_join(d, h, by = "date") |>
      tidyr::separate(col = "date", sep = " ", fill = "right", into = c("date","time")) |>
      dplyr::mutate(date = as.Date(date, tz = tz))

    return(dh)
  }
}




