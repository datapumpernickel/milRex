
mr_process_response <- function(resp, footnotes){
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

  data <- mr_process_constant_usd(file_path, footnotes)

  unlink(tools::R_user_dir("milRex", which = "data"), recursive = TRUE)
  return(data)
}



mr_process_constant_usd <- function(file_path, footnotes){
  Country <-  content <- content2 <- country <- head <- value <- year <- NULL

  sheet_name <- 'Constant (2022) US$'
  sheet <- readxl::read_xlsx(file_path,
                             sheet = sheet_name,
                             skip = 5) |>
    tidyr::pivot_longer(cols = -c(Country, 2:3),
                        names_to = "year",
                        values_to = "value") |>
    janitor::clean_names() |>
    dplyr::select(country, notes, year, value) |>
    dplyr::mutate(year = as.numeric(year),
                  missing = dplyr::case_when(
                    value == "..."~"data unavailable",
                    value == "xxx"~"country did not exist or was independent"),
                  value = as.numeric(value)) |>
    dplyr::filter(!(is.na(value) & is.na(missing)))

  notes <- sheet |> dplyr::pull(notes) |> unique()

  if(footnotes){
    sheet <- sheet |>
      dplyr::left_join(mr_get_footnotes(file_path, notes ))

  } else {
    sheet <- sheet |>
      dplyr::distinct(country, year, value, missing) |>
      dplyr::mutate(unit = readxl::read_xlsx(file_path,
                                             sheet = sheet_name,
                                             col_names = FALSE) |>
                      dplyr::pull(1) |>
                      head(1))
  }
  return(sheet)

}


mr_process_current_usd <- function(file_path, footnotes){
  Country <-  content <- content2 <- country <- head <- value <- year <- NULL

  sheet_name <- 'Current US$'
  sheet <- readxl::read_xlsx(file_path,
                             sheet = sheet_name,
                             skip = 5) |>
    tidyr::pivot_longer(cols = -c(Country, 2:3),
                        names_to = "year",
                        values_to = "value") |>
    janitor::clean_names() |>
    dplyr::select(country, notes, year, value) |>
    dplyr::mutate(year = as.numeric(year),
                  missing = dplyr::case_when(
                    value == "..."~"data unavailable",
                    value == "xxx"~"country did not exist or was independent"),
                  value = as.numeric(value)) |>
    dplyr::filter(!(is.na(value) & is.na(missing)))

  notes <- sheet |> dplyr::pull(notes) |> unique()

  if(footnotes){
    sheet <- sheet |>
      dplyr::left_join(mr_get_footnotes(file_path, notes ))

  } else {
    sheet <- sheet |>
      dplyr::distinct(country, year, value, missing) |>
      dplyr::mutate(unit = readxl::read_xlsx(file_path,
                                             sheet = sheet_name,
                                             col_names = FALSE) |>
                      dplyr::pull(1) |>
                      head(1))
  }
  return(sheet)

}
