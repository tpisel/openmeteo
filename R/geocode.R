#' Retrieve Data from the Open-Meteo Geocoding API
#'
#' @description
#'
#' `geocode()` calls the Open-Meteo Geocoding API. API documentation is
#' available at <https://open-meteo.com/en/docs/geocoding-api>
#'
#' @param location_string location name to search for via fuzzy matching
#' @param n_results number of locations provided in response (up to 100)
#' @param language response language (lower-cased two-letter string)
#'
#' @return details for each location (latitude, longitude, elevation ...)
#'
#' @export
#'
#' @examples
#' \dontrun{
#' dt <- geocode("Sydney")
#' sydney_coords <- c(dt$latitude, dt$longitude)
#' }
geocode <- function(location_string, n_results = 1, language = "en") {
  if (!is.character(location_string)) stop("location_string must be string")
  if (!is.numeric(n_results)) stop("n_results must be integer/numeric")

  base_url <- httr::parse_url("https://geocoding-api.open-meteo.com/v1/search")

  queries <- list(
    name = location_string,
    count = n_results,
    language = language
  )

  pl <- httr::GET(httr::modify_url(base_url, query = queries))

  if (pl$status != 200) stop(paste("API returned status code", pl$status))
  if (is.null(content(pl, as = "parsed")$results)) stop("No matches found")

  tibblify(content(pl, as = "parsed")$results)
}
