with_mock_api({
  test_that("need to provide weather variables", {
    expect_error(
      weather_history(
        c(45.46427, 9.18951),
        "2020-01-01",
        "2020-01-03"
      ),
      "hourly or daily measure not supplied"
    )
  })
  test_that("date formatting",{
    expect_error(
      weather_history('chicago',
                       'tomorrow',222,
                       daily = c('temperature_2m_max', 'precipitation_sum'),
                       response_units = list(temperature_unit = 'fahrenheit',
                                             precipitation_unit = 'inch')),
      "start and end dates must be in ISO-1806 format"
    )
    expect_error(
      weather_history('chicago',
                       '2022-02-01',222,
                       daily = c('temperature_2m_max', 'precipitation_sum'),
                       response_units = list(temperature_unit = 'fahrenheit',
                                             precipitation_unit = 'inch')),
      "start and end dates must be in ISO-1806 format"
    )
  })
})
