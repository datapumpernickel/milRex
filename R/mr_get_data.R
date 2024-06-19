
#' Get data from SIPRI Milex database
#'
#' @param indicator The type of data to download.
#' @param verbose Whether to be verbose.
#' @param footnotes Whether to join footnotes to the results table.
#' @param cache Whether to cache response from SIPRI and processed data.
#'
#' @return A tibble.
#' @export
mr_get_data <- function(indicator = "constantUSD",
                        verbose = FALSE,
                        footnotes = FALSE,
                        cache = TRUE){

  rlang::check_required(indicator)
  rlang::check_required(cache)
  rlang::check_required(verbose)
  rlang::check_required(footnotes)

  rlang::arg_match(
    indicator,
    values = c(
      "regionalTotals",
      "currencyFY",
      "currencyCY",
      "constantUSD",
      "currentUSD",
      "shareOfGDP",
      "perCapita",
      "shareGovt",
      "all"
    ),
    multiple = TRUE
  )

  req <- mr_build_request(verbose)

  if(cache){
    resp <- mr_perform_request_cached(req)
    data <- mr_process_response_cached(resp, footnotes,indicator,verbose)

  } else {
    resp <- mr_perform_request(req)
    data <- mr_process_response(resp, footnotes,indicator,verbose)
  }

  return(data)

}
