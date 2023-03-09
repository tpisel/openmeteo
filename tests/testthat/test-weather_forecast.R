with_mock_api({
  test_that("need to provide weather variables", {
    expect_error(weather_forecast(c(52.52437, 13.41053)), "hourly or daily measure not supplied")
  })

  test_that("valid date errors",{
    expect_error(weather_forecast(c(52.52437, 13.41053),
                                  "yesterday",
                                  "the day before",
                                  hourly = "temperature_2m"),
                 "start and end dates must be")
    expect_error(weather_forecast(c(52.52437, 13.41053),
                                  "2023-03-09",
                                  100,
                                  hourly = "temperature_2m"),
                 "start and end dates must be")
  })
})
