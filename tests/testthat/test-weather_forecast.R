with_mock_api({
  test_that("need to provide weather variables", {
    expect_error(weather_forecast(c(52.52437, 13.41053)), "hourly or daily measure not supplied")
  })
})
