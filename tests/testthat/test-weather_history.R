with_mock_api({
  test_that("need to provide weather variables", {
    expect_error(weather_history(c(45.46427, 9.18951),"2020-01-01","2020-01-03"),
                 "hourly or daily measure not supplied")
  })

  test_that("valid date errors",{
    expect_error(weather_history(c(52.52437, 13.41053),
                                  "yesterday",
                                  "the day before",
                                  hourly = "temperature_2m"),
                 "start and end dates must be")
    expect_error(weather_history(c(52.52437, 13.41053),
                                 "2023-03-09",
                                  100,
                                  hourly = "temperature_2m"),
                 "start and end dates must be")
  })
})
