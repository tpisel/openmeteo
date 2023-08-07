with_mock_api({
test_that("air quality query returns correctly",{
  result = air_quality('beijing',
                            '2023-01-01', '2023-01-02',
                            hourly = 'carbon_monoxide')

  expect_true(dim(result)[1]>=30)
  expect_true(dim(result)[2]==2)
})
test_that("need to provide hourly variables", {
  expect_error(
    air_quality(
      c(-45.46427, -9.18951),
      "2030-01-01",
      "2030-01-03"
    ),
    "hourly measure not supplied"
  )
})
test_that("date formatting",{
  expect_error(
    air_quality('chicago',
                     'tomorrow',222,
                     hourly = 'dust'),
    "start and end dates must be in ISO-1806 format"
  )
  expect_error(
    air_quality('chicago',
                '2023-02-01',222,
                hourly = 'dust'),
    "start and end dates must be in ISO-1806 format"
  )
})
})
