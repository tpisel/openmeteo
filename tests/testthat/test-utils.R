test_that("co-ords validate", {
  expect_true(.is_coords(c(90,180)))
  expect_true(.is_coords(c(-90,0)))
  expect_true(.is_coords(c(0,0)))
  expect_true(.is_coords(c(0L,0L)))
  expect_false(.is_coords(c(180,0)))
  expect_false(.is_coords(c(0,-90)))
  expect_false(.is_coords("coords"))
  expect_false(.is_coords(12))
  expect_false(.is_coords(c(1,2,3)))
  expect_false(.is_coords(list(1,2)))
})

test_that("return co-ords from string", {
  expect_equal(.coords_generic(c(90,180)),c(90,180))
  expect_equal(.coords_generic("Darwin"),c(-12.46113, 130.84184))
  expect_error(.coords_generic("sdflksdjflsdkjf"),"No matches found")
  expect_error(.coords_generic(c(-10,-10)),"location not provided as co-ordinate pair or string")
})

test_that("ISO 8601 validation", {
  expect_true(.is.date("2010-12-18"))
  expect_false(.is.date("12182010"))
  expect_false(.is.date("12-18-10"))
  expect_false(.is.date("12/18/10"))
  expect_false(.is.date(1231231))
})
