with_mock_api({
  test_that("climate forecast query returns correctly",{
    result = climate_forecast(c(0,0),
                     '2030-01-01', '2030-02-01',
                     daily = c('temperature_2m_max', 'precipitation_sum'),
                     model = 'FGOALS_f3_H',
                     response_units = list(temperature_unit = 'fahrenheit',
                                           precipitation_unit = 'inch'))

    expect_true(dim(result)[1]>=30)
    expect_true(dim(result)[2]==3)
  })
  test_that("need to provide hourly variables", {
    expect_error(
      climate_forecast(
        c(-45.46427, -9.18951),
        "2030-01-01",
        "2030-01-03"
      ),
      "daily weather variables not supplied"
    )
  })
  test_that("date formatting",{
    expect_error(
      climate_forecast('chicago',
                       'tomorrow',222,
                       daily = c('temperature_2m_max', 'precipitation_sum'),
                       model = 'FGOALS_f3_H',
                       response_units = list(temperature_unit = 'fahrenheit',
                                             precipitation_unit = 'inch')),
    "start and end dates must be in ISO-1806 format"
    )
    expect_error(
      climate_forecast('chicago',
                       '2023-02-01',222,
                       daily = c('temperature_2m_max', 'precipitation_sum'),
                       model = 'FGOALS_f3_H',
                       response_units = list(temperature_unit = 'fahrenheit',
                                             precipitation_unit = 'inch')),
      "start and end dates must be in ISO-1806 format"
    )
  })
})
