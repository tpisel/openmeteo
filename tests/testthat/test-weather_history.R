with_mock_api({
  test_that("need to provide weather variables", {
    skip_on_cran()
    expect_error(weather_history(c(45.46427, 9.18951),
                                 "2020-01-01",
                                 "2020-01-03"),
                 "hourly or daily measure not supplied")
  })
})
