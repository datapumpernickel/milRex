testthat::test_that('test that build returns a httr2 request',{
  req <- milRex:::sipri_build_request()
  testthat::expect_equal(class(req),'httr2_request')

  testthat::expect_true(stringr::str_detect(req$url,
                                  'https://backend.sipri.org/api/p/excel-export'))
  testthat::expect_true(stringr::str_detect(req$body$data,
                                  'regionalTotals'))
})

httptest2::with_mock_dir("test_data",simplify = F, {
  testthat::test_that("We can get data", {
    resp <- milRex:::sipri_build_request() |>
      milRex:::sipri_perform_request()
    testthat::expect_equal(class(resp),'httr2_response')
  })
})
