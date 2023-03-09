test_that("return non-empty variables sublists", {
  skip_on_cran()
  v <- weather_variables()
  expect_true(length(v$hourly_forecast_vars) > 1)
  expect_true(length(v$daily_forecast_vars) > 1)
  expect_true(length(v$hourly_history_vars) > 1)
  expect_true(length(v$daily_history_vars) > 1)
})
