#' Get data from SIPRI Military Expenditure (Milex) Database
#'
#' The `sipri_get_data` function retrieves military expenditure data from the
#' SIPRI Milex database. It provides multiple indicators including constant USD,
#' current USD, share of GDP, and more. You can also join footnotes to the
#' results and enable caching for faster queries.
#'
#' @param indicator Character vector. The type of data to download. Must be one of:
#'   "constantUSD", "currentUSD", "shareOfGDP", "shareGovt", "regionalTotals",
#'   "currencyFY", "currencyCY", "perCapita", or "all".
#'   Default is "constantUSD".
#' @param verbose Logical. If TRUE, prints additional details about the query
#' process. Default is FALSE.
#' @param footnotes Logical. If TRUE, joins footnotes to the result table.
#' Default is FALSE.
#' @param cache Logical. If TRUE, caches the response and processed
#' data to avoid re-querying. Default is TRUE.
#'
#' @return A tibble containing the requested data.
#'
#' @examples
#' \dontrun{
#' # Retrieve military expenditure data in constant 2022 USD
#' milex_data <- sipri_get_data(indicator = "constantUSD",
#'     verbose = TRUE,
#'     footnotes = TRUE)
#'
#' # Retrieve regional totals without caching
#' regional_totals <- sipri_get_data(indicator = "regionalTotals", cache = FALSE)
#' }
#'
#' @export
sipri_get_data <- function(indicator = "constantUSD",
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

  req <- sipri_build_request(verbose)

  if(cache){
    resp <- sipri_perform_request_cached(req)
    data <- sipri_process_response_cached(resp, footnotes,indicator,verbose)

  } else {
    resp <- sipri_perform_request(req)
    data <- sipri_process_response(resp, footnotes,indicator,verbose)
  }

  return(data)

}
