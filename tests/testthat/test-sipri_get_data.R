httptest2::with_mock_dir("test_data", simplify = F, {
  testthat::test_that("We can get data from top level function", {
    testthat::expect_no_error(resp <-
                                milRex::sipri_get_data(indicator = "constantUSD",
                                                       verbose = TRUE))
    testthat::expect_true(all(
      names(resp) %in% c("sheet",
                         "country","iso3c",
                         "year", "value",
                         "missing")
    ))
  })
  testthat::test_that("We can get footnotes", {
    testthat::expect_no_error(
      resp <- milRex::sipri_get_data(
        indicator = "constantUSD",
        verbose = TRUE,
        footnotes = TRUE
      )
    )
    testthat::expect_true(all(
      names(resp) %in% c("sheet",
                         "country","iso3c",
                         "year", "value",
                         "missing", "footnote")
    ))

  })
  testthat::test_that("All expected data is included", {
    testthat::expect_no_error(
      resp <- milRex::sipri_get_data(
        indicator = "constantUSD",
        verbose = TRUE,
        footnotes = TRUE
      )
    )

    testthat::expect_true(length(unique(resp$country)) == 174)
    testthat::expect_true(all(!is.na(unique(resp$year))))
    testthat::expect_true(all(unique(resp$year) %in% as.character(1949:2023)))



  })
  testthat::test_that("We can get the expected column names", {
    for (indicator in xlsx_config$indicator) {
      print(indicator)
      resp <- milRex::sipri_get_data(indicator = indicator,
                                     verbose = TRUE)
      testthat::expect_true(all(c("sheet",
                                                   "year", "value",
                                                   "missing") %in% names(resp) ))

    }
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


