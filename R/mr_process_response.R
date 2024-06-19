
mr_process_response <- function(resp, footnotes, indicator,verbose){
  .env <- NULL
  content <- resp |>
    httr2::resp_body_json() |>
    purrr::pluck('Value')

  decoded <- base64enc::base64decode(content)

  file_path <- tools::R_user_dir("milRex",
                                 which = "data") |>
    file.path("data.xlsx")

  dir.create(
    tools::R_user_dir("milRex", which = "data"),
    showWarnings = FALSE,
    recursive = TRUE
  )

  writeBin(decoded, con = file_path, useBytes = TRUE)

  if(!indicator %in% 'all') {
    data_to_be_extracted <- xlsx_config |>
      dplyr::filter(indicator %in% .env$indicator)
  } else {
    data_to_be_extracted <- xlsx_config
  }


  suppressWarnings({
    suppressMessages({
      data <- purrr::pmap_dfr(
        data_to_be_extracted,
        mr_process_xlsx,
        file_path = file_path,
        footnotes = footnotes,
        .progress = verbose
      ) |>
        dplyr::select(dplyr::any_of(c("sheet",
                               "country",
                               "region",
                               "year",
                               "value",
                               "missing",
                               "footnote")))
    })
  })


  unlink(tools::R_user_dir("milRex", which = "data"), recursive = TRUE)
  return(data)
}


mr_process_xlsx <- function(file_path, footnotes, indicator,sheet_name, unit, skip){
  Country <-  content <- content2 <- country <- NULL
  head <- value <- year <- region <- NULL



  if(indicator %in% 'regionalTotals'){
    sheet <- readxl::read_xlsx(file_path,
                               sheet = sheet_name,
                               skip = skip,
                               col_type = "text") |>
      tidyr::pivot_longer(cols = tidyselect::contains(as.character(1900:2050)),
                          names_to = "year",
                          values_to = "value") |>
      janitor::clean_names() |>
      dplyr::select(dplyr::any_of(c("region", "notes", "year", "value"))) |>
      dplyr::mutate(year = year |>
                      stringr::str_remove("\\.0"),
                    missing = dplyr::case_when(
                      value == "..."~"data unavailable",
                      value == "xxx"~"country did not exist or was independent"),
                    value = as.numeric(value)) |>
      dplyr::filter(!(is.na(value) & is.na(missing))) |>
      dplyr::distinct(region, year, value, missing) |>
      dplyr::mutate(unit = unit, sheet = sheet_name) |>
      dplyr::mutate(unit = readxl::read_xlsx(file_path,
                                             sheet = sheet_name) |>
                      dplyr::pull(1) |>
                      dplyr::nth(unique(unit)))
  } else {
    sheet <- readxl::read_xlsx(file_path,
                               sheet = sheet_name,
                               skip = skip) |>
      tidyr::pivot_longer(cols = tidyselect::contains(as.character(1900:2050)),
                          names_to = "year",
                          values_to = "value") |>
      janitor::clean_names() |>
      dplyr::select(country, notes, year, value) |>
      dplyr::mutate(year = year |>
                      stringr::str_remove("\\.0"),
                    missing = dplyr::case_when(
        value == "..."~"data unavailable",
        value == "xxx"~"country did not exist or was independent"),
        value = as.numeric(value)) |>
      dplyr::filter(!(is.na(value) & is.na(missing)))

    notes <- sheet |> dplyr::pull(notes) |> unique()

    if(footnotes){
      sheet <- sheet |>
        dplyr::left_join(mr_get_footnotes(file_path, notes))
    }

    sheet <- sheet |>
      dplyr::distinct(country, year, value, missing,
                      .keep_all = TRUE) |>
      dplyr::mutate(unit = unit, sheet = sheet_name) |>
      dplyr::mutate(unit = readxl::read_xlsx(file_path,
                                             sheet = sheet_name) |>
                      dplyr::pull(1) |>
                      dplyr::nth(unique(unit)))
  }



  return(sheet)

}


