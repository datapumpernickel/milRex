
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

  if(!rlang::is_bool(verbose)){
    rlang::abort(message = "verbose must be a logical value")
  }
  if(!rlang::is_bool(cache)){
    rlang::abort(message = "cache must be a logical value")
  }
  if(!rlang::is_bool(footnotes)){
    rlang::abort(message = "footnotes must be a logical value")
  }

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

  req <- mr_build_request()

  if(cache){
    resp <- mr_perform_request_cached(req)
    data <- mr_process_response_cached(resp, footnotes,indicator,verbose)

  } else {
    resp <- mr_perform_request(req)
    data <- mr_process_response(resp, footnotes,indicator,verbose)
  }

  return(data)

}
