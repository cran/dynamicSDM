

data(sample_explan_data)

test_that("stops if wrong class for spatial.res", {
  expect_error(
    spatiotemp_resolution(
      occ.data = sample_explan_data,
      spatial.res = "3 decimal places",
      temporal.res = "year",
      month.infill = 1
    )
  )
})

test_that("stops if temporal.res does not match accepted arguments", {
  expect_error(
    spatiotemp_resolution(
      occ.data = sample_explan_data,
      temporal.res = "week",
      day.infill = 2
    )
  )
})

test_that("removes records with missing day", {
  testdata <- sample_explan_data
  n <- sample(1:nrow(testdata), 1)
  testdata[n, "day"] <- NA
  result <- spatiotemp_resolution(occ.data = testdata, temporal.res = "day")
  expect_equal(nrow(result), nrow(testdata) - 1)
})

test_that("removes records with missing month", {
  testdata <- sample_explan_data
  n <- sample(1:nrow(testdata), 1)
  testdata[n, "month"] <- NA
  result <-
    spatiotemp_resolution(occ.data = testdata, temporal.res = "month")
  expect_equal(nrow(result), nrow(testdata) - 1)
})

test_that("removes records with missing year", {
  testdata <- sample_explan_data
  n <- sample(1:nrow(testdata), 1)
  testdata[n, "year"] <- NA
  result <- spatiotemp_resolution(occ.data = testdata, temporal.res = "year")
  expect_equal(nrow(result), 329)
})

test_that("removes records with low spatial resolution", {
  testdata <- sample_explan_data
  result <- spatiotemp_resolution(occ.data = testdata, spatial.res = 3)
  expect_equal(nrow(result), 303)
})

test_that("Doesn't remove records with low spatial resolution", {
  result <- spatiotemp_resolution(occ.data = sample_explan_data, spatial.res = 0)
  expect_equal(nrow(result), nrow(sample_explan_data))
})
