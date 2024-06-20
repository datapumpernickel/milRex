httptest2::with_mock_dir("test_data", simplify = F, {
  testthat::test_that("The directory is cleaned afterwards",{
    resp <- sipri_build_request() |>
      sipri_perform_request() |>
      sipri_process_response(footnotes = FALSE,
                             indicator = "regionalTotals",
                             verbose = F)
    testthat::expect_false(tools::R_user_dir("milRex", which = "data") |>
                             dir.exists())
  })
  testthat::test_that("The directory is cleaned afterwards",{
    resp <- sipri_build_request() |>
      sipri_perform_request() |>
      sipri_process_response(footnotes = FALSE,
                             indicator = "constantUSD",
                             verbose = F)
    testthat::expect_false(tools::R_user_dir("milRex", which = "data") |>
                             dir.exists())
  })

})
