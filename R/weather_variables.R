#' Retrieve a List of Weather Variables Accepted by the Open-Meteo Forecasting API
#'
#' @description
#'
#' `weather_variables()` retrieves a list of  hourly and daily variables accepted
#' by [weather_forecast()] and [weather_history()], such as temperature and precipitation.
#'
#' Refer to the following documentation for the forecast and history API
#' endpoints for detailed descriptions, units, and caveats.
#'
#' Forecast: <https://open-meteo.com/en/docs>
#' Historical: <https://open-meteo.com/en/docs/historical-weather-api>
#'
#' @return a list of weather variables
#'
#' @export
#'
#' @examples
#'
#' weather_variables()
#'


weather_variables <- function() {
  base_url <- "https://raw.githubusercontent.com/open-meteo/open-meteo/main/"

  forecast_url <- paste0(base_url, "openapi.yml")
  forecast_params <- .retrieve_om_schema(forecast_url)$paths$`/v1/forecast`$get$parameters

  history_url <- paste0(base_url, "openapi_historical_weather_api.yml")
  history_params <- .retrieve_om_schema(history_url)$paths$`/v1/archive`$get$parameters

  list(
    hourly_forecast_vars = .vars_from_schema(forecast_params, "hourly"),
    daily_forecast_vars  = .vars_from_schema(forecast_params, "daily"),
    hourly_history_vars  = .vars_from_schema(history_params, "hourly"),
    daily_history_vars   = .vars_from_schema(history_params, "daily")
  )
}

# retrieves openai yaml from URL as an R object
.retrieve_om_schema <- function(url) {
  pl <- httr::GET(url)
  .response_OK(pl)

  yaml::yaml.load(httr::content(pl))
}

.vars_from_schema <- function(params, name) {
  for (i in params) {
    if(i$name == name) {
      return(i$schema$items$enum)
    }
  }
  stop("Unable to find variables from parsed YAML params")
}




