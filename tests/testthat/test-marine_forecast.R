with_mock_api({
  test_that("marine forecast query returns correctly",{
    result = marine_forecast('sydney',
                              '2023-01-01', '2023-01-02',
                              hourly = c('wave_height', 'wave_direction'),
                              daily = 'wave_height_max',
                              response_units = list(length_unit = 'imperial'))

    expect_true(dim(result)[1]>=40)
    expect_true(dim(result)[2]==5)
  })
  test_that("need to provide hourly or daily variables", {
    expect_error(
      marine_forecast(
        c(-45.46427, -9.18951),
        "2030-01-01",
        "2030-01-03"
      ),
      "hourly or daily measure not supplied"
    )
  })
  test_that("date formatting",{
    expect_error(
      marine_forecast('nice',
                       'tomorrow',222,
                       daily = 'wave_height_max',
                       response_units = list(temperature_unit = 'fahrenheit',
                                             precipitation_unit = 'inch')),
      "start and end dates must be in ISO-1806 format"
    )
    expect_error(
      marine_forecast('nice',
                       '2023-02-01',222,
                       daily = 'wave_height_max',
                       response_units = list(temperature_unit = 'fahrenheit',
                                             precipitation_unit = 'inch')),
      "start and end dates must be in ISO-1806 format"
    )
  })
})
