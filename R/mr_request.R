#' Build a request for SIPRI data
#'
#' Constructs an HTTP request for the SIPRI data export.
#'
#' @param verbose Logical. If `TRUE`, enables verbose output for the request.
#' @return An `httr2` request object configured with the specified parameters.
#' @keywords internal
mr_build_request <- function(verbose){

  req <- httr2::request("https://backend.sipri.org/api/p/excel-export") |>
    httr2::req_headers("Content-Type" = "application/json")|>
    httr2::req_body_raw(req_body)

  if(verbose){
    req <- req |>
      httr2::req_verbose()
  }

  return(req)
}

#' Perform a request and retrieve response
#'
#' Executes an HTTP request and retrieves the response.
#'
#' @param req An `httr2` request object created by `mr_build_request`.
#' @return An `httr2` response object containing the server's response.
#' @keywords internal
mr_perform_request<- function(req){
  resp <- httr2::req_perform(req)

  return(resp)
}
