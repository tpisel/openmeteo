with_mock_api({
  test_that("API queries correctly", {
    loc1 <- c(-12.46113, -130.84184)
    loc2 <- "Brasilia"
    d1 <- "2022-12-29"
    d2 <- "2023-01-08"
    forecast <- weather_forecast(loc1, d1, d2, daily = "temperature_2m_max")
    history <- weather_history(loc2, d1, d2, daily = "temperature_2m_max")
    hist_hourly <- weather_history(loc1, d1, d1, hourly = "temperature_2m")
    hist_both <- weather_history(loc2, d1, d1,
      hourly = "temperature_2m",
      daily = "temperature_2m_max"
    )
    fore_model <- weather_forecast(loc2,
      hourly = "temperature_2m",
      model = "gem_global"
    )

    expect_true(dim(history)[1] > 10)
    expect_true(dim(history)[2] == 2)
    expect_true(dim(forecast)[1] > 10)
    expect_true(dim(forecast)[2] == 2)
    expect_true(dim(hist_hourly)[1] > 10)
    expect_true(dim(hist_hourly)[2] == 2)
    expect_true(dim(hist_both)[1] > 10)
    expect_true(dim(hist_both)[2] == 4)
    expect_true(dim(fore_model)[1] > 10)
    expect_true(dim(fore_model)[2] == 2)
  })

  test_that("invalid api queries", {
    expect_error(weather_forecast("paris"), "hourly or daily")
    expect_error(weather_forecast("milan", hourly = "lksdfj"), "invalid variable")
    expect_error(
      weather_forecast("berlin",
        hourly = "temperature_2m",
        model = c("icon_global", "gem_global")
      ),
      "one model"
    )
  })

  test_that("co-ords validate", {
    expect_true(.is_coords(c(90, 180)))
    expect_true(.is_coords(c(-90, 0)))
    expect_true(.is_coords(c(-90, -180)))
    expect_true(.is_coords(c(0, 0)))
    expect_true(.is_coords(c(0L, 0L)))
    expect_false(.is_coords(c(180, 0)))
    expect_true(.is_coords(c(0, -90)))
    expect_false(.is_coords("coords"))
    expect_false(.is_coords(12))
    expect_false(.is_coords(c(1, 2, 3)))
    expect_false(.is_coords(list(1, 2)))
  })

  test_that("return co-ords from string", {
    expect_equal(.coords_generic(c(90, 180)), c(90, 180))
    expect_equal(.coords_generic("Darwin"), c(-12.5, 131.0), tolerance=0.1)
    expect_error(.coords_generic("sdflksdjflsdkjf"), "No matches found")
    expect_error(
      .coords_generic(c(-10, 200)),
      "location not provided as co-ordinate pair or string"
    )
  })

  test_that("ISO 8601 validation", {
    expect_true(.is.date("2010-12-18"))
    expect_false(.is.date("12182010"))
    expect_false(.is.date("12-18-10"))
    expect_false(.is.date("12/18/10"))
    expect_true(.is.date(as.Date("2010-12-18")))
    expect_true(.is.date("2023-03-09"))
  })
})
