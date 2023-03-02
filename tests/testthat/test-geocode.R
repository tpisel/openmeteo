test_that("single known call returns correct co-ordinates", {
  co <- geocode("sydney")
  expect_equal(c(co$latitude, co$longitude), c(-33.86785, 151.20732))
})

test_that("multiple calls return correctly", {
  co <- geocode("paris", 2)
  ex <- c("France", "United States")
  expect_equal(co$country, ex)
})

test_that("non-string inputs return an error", {
  expect_error(geocode(1, 2))
  expect_error(geocode("sydney", "two"))
})

test_that("nonsense inputs return no matches", {
  expect_error(geocode("sdlkfsjsdf"), "No matches found")
})
