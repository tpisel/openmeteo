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
    downscaling,
    base_url,
    current = NULL) {
  coordinates <- .coords_generic(location)

  # base queries
  queries <- list(
    latitude = coordinates[1],
    longitude = coordinates[2],
    start_date = start,
    end_date = end,
    timezone = timezone
  )

  # add units/hourly/daily/current/model as supplied
  queries <- c(queries, response_units)
  if (!is.null(hourly)) {
    queries$hourly <- paste(hourly, collapse = ",")
  }
  if (!is.null(daily)) {
    queries$daily <- paste(daily, collapse = ",")
  }
  if (!is.null(current)) {
    queries$current <- paste(current, collapse = ",")
  }
  if (!is.null(model)) {
    if (length(model) != 1) {
      stop("Please specify only one model per query.") # may support later
    }
    queries$models <- paste(model, collapse = ",")
  }

  ## handle downscaling switch for climate forecast
  if(!is.null(downscaling))queries[["disable_bias_correction"]] <- paste(!downscaling, collapse = ",")

  api_key <- Sys.getenv("OPENMETEO_API_KEY", unset = NA_character_)

  if (!is.na(api_key) && nzchar(api_key)) {
    queries$apikey <- api_key
  }

  # request (decode necessary as API treats ',' differently to '%2C')
  pl <- httr::GET(utils::URLdecode(httr::modify_url(base_url, query = queries)))
  .response_OK(pl)

  # parse response
  pl_parsed <- httr::content(pl, as = "parsed")

  tz <- pl_parsed$timezone
  dtformat <- "%Y-%m-%dT%H:%M"
  export_both <- (!is.null(hourly) & !is.null(daily))

  # parse current data (single record). Returned alongside hourly/daily as a
  # named list element when those are also requested; otherwise returned bare.
  current_tibble <- NULL
  if (!is.null(pl_parsed$current)) {
    current_tibble <-
      pl_parsed$current |>
      .nestedlist_as_tibble() |>
      dplyr::rename_with(~ paste0("current_", .x), .cols = -tidyr::any_of(c("time", "interval"))) |>
      dplyr::mutate(datetime = as.POSIXct(time, format = dtformat, tz = tz)) |>
      dplyr::relocate(datetime, .before = time) |>
      dplyr::select(-time)

    if (is.null(hourly) && is.null(daily)) {
      return(current_tibble)
    }
  }

  # parse hourly data
  if (!is.null(pl_parsed$hourly)) {
    hourly_tibble <-
      pl_parsed$hourly |>
      .nestedlist_as_tibble() |>
      dplyr::rename_with(~ paste0("hourly_", .x), .cols = -time) |>
      dplyr::mutate(datetime = as.POSIXct(time, format = dtformat, tz = tz)) |>
      dplyr::relocate(datetime, .before = time) |>
      dplyr::select(-time)

    if (!export_both && is.null(current_tibble)) {
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

    if (!export_both && is.null(current_tibble)) {
      return(daily_tibble)
    }
  }

  # if current was requested alongside hourly/daily, return a named list
  if (!is.null(current_tibble)) {
    out <- list(current = current_tibble)
    if (!is.null(pl_parsed$hourly)) out$hourly <- hourly_tibble
    if (!is.null(pl_parsed$daily))  out$daily  <- daily_tibble
    return(out)
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

# Geocoding API returns a heterogeneous list of records (e.g. some have a
# `postcodes` vector, some only have admin1, etc.). Convert one record at a
# time, wrapping multi-element fields as list-columns so as_tibble_row accepts
# them, then bind. Equivalent to what tibblify::tibblify() produced before we
# removed that dependency.
.geocoding_results_as_tibble <- function(results) {
  rows <- lapply(results, function(r) {
    wrapped <- lapply(r, function(v) {
      if (length(v) > 1 || is.list(v)) list(v) else v
    })
    tibble::as_tibble_row(wrapped, .name_repair = "minimal")
  })
  dplyr::bind_rows(rows)
}


# lookup API endpoint for a function, switching to customer URL if API key is set
.lookup_open_meteo_url <- local({
  urls <- list(
    air_quality = c(
      noncommercial = "https://air-quality-api.open-meteo.com/v1/air-quality",
      commercial = "https://customer-air-quality-api.open-meteo.com/v1/air-quality"
    ),
    climate_forecast = c(
      noncommercial = "https://climate-api.open-meteo.com/v1/climate",
      commercial = "https://customer-climate-api.open-meteo.com/v1/climate"
    ),
    ensemble_models = c(
      noncommercial = "https://ensemble-api.open-meteo.com/v1/ensemble",
      commercial = "https://customer-ensemble-api.open-meteo.com/v1/ensemble"
    ),
    geocode = c(
      noncommercial = "https://geocoding-api.open-meteo.com/v1/search",
      commercial = "https://customer-geocoding-api.open-meteo.com/v1/search"
    ),
    marine_forecast = c(
      noncommercial = "https://marine-api.open-meteo.com/v1/marine",
      commercial = "https://customer-marine-api.open-meteo.com/v1/marine"
    ),
    river_discharge = c(
      noncommercial = "https://flood-api.open-meteo.com/v1/flood",
      commercial = "https://customer-flood-api.open-meteo.com/v1/flood"
    ),
    weather_forecast = c(
      noncommercial = "https://api.open-meteo.com/v1/forecast",
      commercial = "https://customer-api.open-meteo.com/v1/forecast"
    ),
    weather_history = c(
      noncommercial = "https://archive-api.open-meteo.com/v1/archive",
      commercial = "https://customer-archive-api.open-meteo.com/v1/archive"
    ),
    weather_now = c(
      noncommercial = "https://api.open-meteo.com/v1/forecast",
      commercial = "https://customer-api.open-meteo.com/v1/forecast"
    )
  )

  function(fxn_name) {
    if (!is.character(fxn_name) || length(fxn_name) != 1L || is.na(fxn_name)) {
      stop("'fxn_name' must be a single non-missing character value.", call. = FALSE)
    }

    if (!fxn_name %in% names(urls)) {
      stop(
        sprintf("'fxn_name' must be one of: %s", paste(names(urls), collapse = ", ")),
        call. = FALSE
      )
    }

    url_type <- if (isTRUE(nzchar(Sys.getenv("OPENMETEO_API_KEY")))) {
      "commercial"
    } else {
      "noncommercial"
    }

    unname(urls[[fxn_name]][[url_type]])
  }
})
