with_mock_api({
test_that("flood api query returns correctly",{
  result = river_discharge('brisbane',
                       '2023-01-01', '2023-01-02',
                       daily = 'river_discharge')

  expect_true(dim(result)[1]==2)
  expect_true(dim(result)[2]==2)
})
test_that("need to provide hourly variables", {
  expect_error(
    river_discharge(
      c(-45.46427, -9.18951),
      "2030-01-01",
      "2030-01-03"
    ),
    "daily measure not supplied"
  )
})
})
