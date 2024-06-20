httptest2::with_mock_dir("test_data",simplify = F, {
  testthat::test_that("We can get data from top level function", {
    testthat::expect_no_error(resp <- milRex::sipri_get_data(indicator = "constantUSD",
                                                          verbose = TRUE))
    testthat::expect_true(all(names(resp) %in% c("sheet",
                                                 "country",
                                                 "year","value",
                                                 "missing")))
  })
  testthat::test_that("We can get footnotes", {
    testthat::expect_no_error(
      resp <- milRex::sipri_get_data(indicator = "constantUSD",
                                                          verbose = TRUE,
                                                          footnotes = TRUE))
    testthat::expect_true(all(names(resp) %in% c("sheet",
                                                 "country",
                                                 "year","value",
                                                 "missing","footnote")))

})
})


testthat::test_that("Valid indicators are needed", {
  testthat::expect_error(resp <- milRex::sipri_get_data(indicator = "test"))
})
testthat::test_that("Valid verbose arguments are needed", {
  testthat::expect_error(resp <- milRex::sipri_get_data(verbose = "test"))
})

testthat::test_that("Valid footnote arguments are needed", {
  testthat::expect_error(resp <- milRex::sipri_get_data(footnotes = "test"))
})

testthat::test_that("Valid cache arguments are needed", {
  testthat::expect_error(resp <- milRex::sipri_get_data(cache = "test"))
})


