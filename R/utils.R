# handle the quasiquoted dplyr columns being picked up in the check()
utils::globalVariables(c("time", "datetime"))

# query the api
.query_openmeteo <- function(
    location,
    start,
    end,
    hourly,
    daily,
    response_units,
    model,
    timezone,
    base_url) {
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
  queries <- c(queries, response_units)
  if (!is.null(hourly)) {
    queries$hourly <- paste(hourly, collapse = ",")
  }
  if (!is.null(daily)) {
    queries$daily <- paste(daily, collapse = ",")
  }
  if (!is.null(model)) {
    if (length(model) != 1) {
      stop("Please specify only one model per query.") # may support later
    }
    queries$model <- paste(model, collapse = ",")
  }

  # request (decode necessary as API treats ',' differently to '%2C')
  pl <- httr::GET(utils::URLdecode(httr::modify_url(base_url, query = queries)))
  .response_OK(pl)

  # parse response
  pl_parsed <- httr::content(pl, as = "parsed")

  tz <- pl_parsed$timezone
  dtformat <- "%Y-%m-%dT%H:%M"
  export_both <- (!is.null(hourly) & !is.null(daily))

  # parse hourly data
  if (!is.null(pl_parsed$hourly)) {
    hourly_tibble <-
      pl_parsed$hourly |>
      .nestedlist_as_tibble() |>
      dplyr::rename_with(~ paste0("hourly_", .x), .cols = -time) |>
      dplyr::mutate(datetime = as.POSIXct(time, format = dtformat, tz = tz)) |>
      dplyr::relocate(datetime, .before = time) |>
      dplyr::select(-time)

    if (!export_both) {
      return(hourly_tibble)
    }
  }

  # process daily data
  if (!is.null(pl_parsed$daily)) {
    daily_tibble <-
      pl_parsed$daily |>
      .nestedlist_as_tibble() |>
      dplyr::rename_with(~ paste0("daily_", .x), .cols = -time) |>
      dplyr::mutate(date = as.Date(time, tz = tz)) |>
      dplyr::relocate(date, .before = time) |>
      dplyr::select(-time)

    if (!export_both) {
      return(daily_tibble)
    }
  }

  # combine both hourly and daily if requested
  if (export_both) {
    d <-
      daily_tibble |>
      dplyr::mutate(date = as.character(date))

    h <-
      hourly_tibble |>
      dplyr::mutate(date = as.character(datetime)) |>
      dplyr::select(-datetime)

    dh <-
      dplyr::full_join(d, h, by = "date") |>
      tidyr::separate(
        col = "date",
        sep = " ",
        fill = "right",
        into = c("date", "time")
      ) |>
      dplyr::mutate(date = as.Date(date, tz = tz))

    return(dh)
  }
}


# check if x is of type c(lat,long)
.is_coords <- function(x) {
  if (length(x) == 2 && is.numeric(x)) {
    abs(x[1]) <= 90 && abs(x[2]) <= 180 && abs(x[2]) >= 0
  } else {
    FALSE
  }
}

# generic helper to return co-ords from co-ords or string, or error out
.coords_generic <- function(x) {
  if (.is_coords(x)) {
    return(x)
  } else if (is.character(x)) {
    dt <- geocode(x, silent = FALSE)
    return(c(dt$latitude, dt$longitude))
  } else {
    stop("location not provided as co-ordinate pair or string")
  }
}


# validate date reads as ISO 8601 (e.g. "2020-12-30")
.is.date <- function(d) {
  tryCatch(!is.na(as.Date(d, format = "%Y-%m-%d")),
    error = function(e) {
      FALSE
    }
  )
}

# error helper to surface API feedback if possible
.response_OK <- function(pl) {
  if (pl$status != 200) {
    error <- paste("API returned status code", pl$status)
    try(if (httr::content(pl)$error) {
      error <- paste0(error, "\nReason from API : ", httr::content(pl)$reason)
    })
    if (grepl("Cannot initialize ", error, fixed = TRUE)) {
      error <- paste0(
        error, "\nNote : an invalid variable (e.g. hourly, daily,",
        " units) was likely requested, check the API docs"
      )
    }
    stop(error)
  }
  TRUE
}


# turn the list-of-lists received into a tibble
.nestedlist_as_tibble <- function(nl) {
  nl |>
    tibble::as_tibble() |>
    tidyr::unnest(cols = tidyr::everything())
}
