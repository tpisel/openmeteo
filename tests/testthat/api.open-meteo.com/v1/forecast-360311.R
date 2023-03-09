structure(list(
  url = "https://api.open-meteo.com/v1/forecast?latitude=-12.46113&longitude=130.84184&current_weather=TRUE&timezone=Australia/Darwin&temperature_unit=asdfsfd&windspeed_unit=asdfsd",
  status_code = 400L, headers = structure(list(
    date = "Thu, 09 Mar 2023 03:31:04 GMT",
    `content-type` = "application/json; charset=utf-8", `content-length` = "102",
    `content-encoding` = "deflate"
  ), class = c(
    "insensitive",
    "list"
  )), all_headers = list(list(
    status = 400L, version = "HTTP/2",
    headers = structure(list(
      date = "Thu, 09 Mar 2023 03:31:04 GMT",
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
  content = charToRaw("{\"error\":true,\"reason\":\"Cannot initialize TemperatureUnit from invalid String value asdfsfd for key temperature_unit\"}"),
  date = structure(1678332664, class = c("POSIXct", "POSIXt"), tzone = "GMT"), times = c(
    redirect = 0, namelookup = 3.6e-05,
    connect = 3.6e-05, pretransfer = 0.000168, starttransfer = 0.526832,
    total = 0.526935
  )
), class = "response")
