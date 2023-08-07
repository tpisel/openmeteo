structure(list(
  url = "https://api.open-meteo.com/v1/forecast?latitude=-12.46113&longitude=130.84184&current_weather=TRUE&timezone=auto&temperature_unit=asdfsfd&windspeed_unit=asdfsd",
  status_code = 400L, headers = structure(list(
    date = "Mon, 07 Aug 2023 13:16:10 GMT",
    `content-type` = "application/json; charset=utf-8", `content-length` = "102",
    `content-encoding` = "deflate"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 400L, version = "HTTP/2",
    headers = structure(list(
      date = "Mon, 07 Aug 2023 13:16:10 GMT",
      `content-type` = "application/json; charset=utf-8",
      `content-length` = "102", `content-encoding` = "deflate"
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
  content = charToRaw("{\"reason\":\"Cannot initialize TemperatureUnit from invalid String value asdfsfd for key temperature_unit\",\"error\":true}"),
  date = structure(1691414170, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 3.6e-05,
    connect = 3.6e-05, pretransfer = 0.000138, starttransfer = 0.284841,
    total = 0.284907
  )
), class = "response")
