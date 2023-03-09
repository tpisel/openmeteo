with_mock_api({
  test_that("non-matching query", {
    expect_error(weather_now("sdflkjsdf"),"No matches found")
  })

  test_that("response behaviours", {
    loc <- "darwin"
    loc_x <- "sdlfkjs"
    i_units <- list(temperature_unit = "fahrenheit",
                    windspeed_unit = "mph")
    m_units <- list(temperature_unit = "celsius",
                    windspeed_unit = "kmh")
    x_units <- list(temperature_unit = "asdfsfd",
                    windspeed_unit = "asdfsd")
    w_loc <- weather_now(loc)
    w_loc_i <- weather_now(loc,response_units = i_units)
    w_loc_m <- weather_now(loc,response_units = m_units)

    expect_error(weather_now(loc,response_units = x_units),"400")
    expect_error(weather_now(loc_x),"No matches found")

    expect_true(is.numeric(w_loc$temperature))
    expect_true(is.numeric(w_loc_i$windspeed))
    expect_true(is.numeric(w_loc_m$winddirection))

    expect_equal(
      (w_loc_i$temperature - 32) * 5 / 9,
      w_loc_m$temperature,
      tolerance = .1
    )

    expect_equal(
      w_loc_i$windspeed * 1.60934,
      w_loc_m$windspeed,
      tolerance = .1
    )
  })
})
