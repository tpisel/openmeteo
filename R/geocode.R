#' Retrieve data from the Open-Meteo geocoding API
#'
#' @description
#'
#' Call the Open-Meteo Geocoding API to retrieve co-ordinates and other
#' information for a given place name. The closest n matching records can be
#' requested.
#'
#' Geocoding API documentation is available at
#' <https://open-meteo.com/en/docs/geocoding-api>.
#'
#' @param location_name Required. The location name to search for via fuzzy
#'   matching.
#' @param n_results The number of matching locations provided in response,
#'   sorted by relevance (default 1, up to 100).
#' @param language Desired response language for place names (lower-cased
#'   two-letter string, i.e. "en" for _London_,"fr" for _Londres_).
#' @param silent If `FALSE`, the top match will be printed to the console, to
#'   aid in confirming the match is correct when used within other functions.
#'
#' @return Details for each matching location (latitude, longitude, elevation,
#'   population, timezone, and administrative areas)
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # obtain co-ordinates of Sydney
#' gc <- geocode("Sydney")
#' sydney_coords <- c(gc$latitude, gc$longitude)
#'
#' # elevation of Kathmandu
#' geocode("kathmandu")$elevation
#'
#' # 10 places named 'Paris'
#' geocode("paris",10)
#'}
#'
geocode <- function(location_name,
                    n_results = 1,
                    language = "en",
                    silent = TRUE) {
  if (!is.character(location_name)) stop("location_name must be string")
  if (!is.numeric(n_results)) stop("n_results must be integer/numeric")

  base_url <- httr::parse_url("https://geocoding-api.open-meteo.com/v1/search")

  queries <- list(
    name = location_name,
    count = n_results,
    language = language
  )

  pl <- httr::GET(httr::modify_url(base_url, query = queries))
  .response_OK(pl)

  if (is.null(httr::content(pl, as = "parsed")$results)) {
    stop("No matches found")
  }

  out <- tibblify::tibblify(httr::content(pl, as = "parsed")$results)

  if (!silent) {
    l <- dplyr::slice_head(out)
    m <- paste0("`geocode()` has matched \"",location_name,"\" to:\n",
                l$name," ","in ",l$admin1,", ",l$country,"\n",
                "Population: ",l$population,"\n",
                "Co-ordinates: c(",l$latitude,", ",l$longitude,")\n\n")
    cat(m)
  }

  out
}
