test_that("need to provide weather variables", {
  expect_error(weather_forecast("London"),"hourly or daily measure not supplied")
})
