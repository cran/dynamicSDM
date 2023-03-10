data("sample_explan_data")

sample_explan_data2 <- dplyr::sample_n(sample_explan_data, 100)
colnames(sample_explan_data2)

test_that("stops if no occ.data provided", {
  expect_error(spatiotemp_autocorr(varname = "Temperaturemean", temporal.level = "DOY"))
})

test_that("stops if method not accepted", {
  expect_error(
    spatiotemp_autocorr(
      occ.data = sample_explan_data2,
      varname = "eight_sum_prec"   ,
      temporal.level = "decadal"
    )
  )
})

test_that("day method output list object", {
  results <- spatiotemp_autocorr(occ.data = sample_explan_data2,
                        varname = "eight_sum_prec",
                        temporal.level = "day")
  expect_equal(class(results), "list")
})

test_that("day temporal.level outputs length(2) in each list", {
  results <- spatiotemp_autocorr(occ.data = sample_explan_data2,
                        varname = "eight_sum_prec",
                        temporal.level = "day")
  expect_equal(length(results[[1]]), 2)
})

test_that("year temporal.level works with multiple variables", {
  varnames <- c("eight_sum_prec", "year_sum_prec")
  results <- spatiotemp_autocorr(occ.data = sample_explan_data2,
                        varname = varnames,
                        temporal.level = "year")
  expect_equal(length(results), length(varnames))
})

test_that("month temporal.level works with multiple variables", {
  varnames <- c("eight_sum_prec", "year_sum_prec")
  results <- spatiotemp_autocorr(occ.data = sample_explan_data2,
                        varname = varnames,
                        temporal.level = "month")
  expect_equal(length(results), length(varnames))
})
