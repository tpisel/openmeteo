structure(list(
  url = "https://api.open-meteo.com/v1/forecast?latitude=45.46427&longitude=9.18951&timezone=auto&hourly=lksdfj",
  status_code = 400L, headers = structure(list(
    date = "Mon, 07 Aug 2023 13:18:07 GMT",
    `content-type` = "application/json; charset=utf-8", `content-length` = "125",
    `content-encoding` = "deflate"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 400L, version = "HTTP/2",
    headers = structure(list(
      date = "Mon, 07 Aug 2023 13:18:07 GMT",
      `content-type` = "application/json; charset=utf-8",
      `content-length` = "125", `content-encoding` = "deflate"
    ), class = c(
      "insensitive",
      "list"
    ))
  )), cookies = structure(list(
    domain = logical(0),
    flag = logical(0), path = logical(0), secure = logical(0),
    expiration = structure(numeric(0), class = c(
      "POSIXct",
      "POSIXt"
    )), name = logical(0), value = logical(0)
  ), row.names = integer(0), class = "data.frame"),
  content = charToRaw("{\"reason\":\"Cannot initialize SurfaceAndPressureVariable<ForecastSurfaceVariable, ForecastPressureVariable> from invalid String value lksdfj for key \",\"error\":true}"),
  date = structure(1691414287, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 0.001383,
    connect = 0.366638, pretransfer = 1.066002, starttransfer = 1.348552,
    total = 1.348674
  )
), class = "response")
