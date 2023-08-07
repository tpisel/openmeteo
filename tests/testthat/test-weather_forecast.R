with_mock_api({
  test_that("need to provide weather variables", {
    expect_error(weather_forecast(c(52.52437, 13.41053)),
                 "hourly or daily measure not supplied")
  })
  test_that("date formatting",{
    expect_error(
      weather_forecast('chicago',
                       'tomorrow',222,
                       daily = c('temperature_2m_max', 'precipitation_sum'),
                       response_units = list(temperature_unit = 'fahrenheit',
                                             precipitation_unit = 'inch')),
      "start and end dates must be in ISO-1806 format"
    )
    expect_error(
      weather_forecast('chicago',
                       '2023-02-01',222,
                       daily = c('temperature_2m_max', 'precipitation_sum'),
                       response_units = list(temperature_unit = 'fahrenheit',
                                             precipitation_unit = 'inch')),
      "start and end dates must be in ISO-1806 format"
    )
  })
})
