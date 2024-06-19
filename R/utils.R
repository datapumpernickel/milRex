

mr_build_request <- function(verbose){
  data = "{\"regionalTotals\":true,\"currencyFY\":true,\"currencyCY\":true,\"constantUSD\":true,\"currentUSD\":true,\"shareOfGDP\":true,\"perCapita\":true,\"shareGovt\":true,\"regionDataDetails\":false,\"getLiveData\":false,\"yearFrom\":null,\"yearTo\":null,\"yearList\":[1949,2023],\"countryList\":[\"Afghanistan\",\"Albania\",\"Algeria\",\"Angola\",\"Argentina\",\"Armenia\",\"Australia\",\"Austria\",\"Azerbaijan\",\"Bahrain\",\"Bangladesh\",\"Belarus\",\"Belgium\",\"Belize\",\"Benin\",\"Bolivia\",\"Bosnia and Herzegovina\",\"Botswana\",\"Brazil\",\"Brunei\",\"Bulgaria\",\"Burkina Faso\",\"Burundi\",\"Cambodia\",\"Cameroon\",\"Canada\",\"Cape Verde\",\"Central African Republic\",\"Chad\",\"Chile\",\"China\",\"Colombia\",\"Congo, DR\",\"Congo, Republic\",\"Costa Rica\",\"Cote d'Ivoire\",\"Croatia\",\"Cuba\",\"Cyprus\",\"Czechia\",\"Czechoslovakia\",\"Denmark\",\"Djibouti\",\"Dominican Republic\",\"Ecuador\",\"Egypt\",\"El Salvador\",\"Equatorial Guinea\",\"Eritrea\",\"Estonia\",\"Eswatini\",\"Ethiopia\",\"European Union\",\"Fiji\",\"Finland\",\"France\",\"Gabon\",\"Gambia, The\",\"Georgia\",\"German Democratic Republic\",\"Germany\",\"Ghana\",\"Greece\",\"Guatemala\",\"Guinea\",\"Guinea-Bissau\",\"Guyana\",\"Haiti\",\"Honduras\",\"Hungary\",\"Iceland\",\"India\",\"Indonesia\",\"Iran\",\"Iraq\",\"Ireland\",\"Israel\",\"Italy\",\"Jamaica\",\"Japan\",\"Jordan\",\"Kazakhstan\",\"Kenya\",\"Korea, North\",\"Korea, South\",\"Kosovo\",\"Kuwait\",\"Kyrgyz Republic\",\"Laos\",\"Latvia\",\"Lebanon\",\"Lesotho\",\"Liberia\",\"Libya\",\"Lithuania\",\"Luxembourg\",\"Madagascar\",\"Malawi\",\"Malaysia\",\"Mali\",\"Malta\",\"Mauritania\",\"Mauritius\",\"Mexico\",\"Moldova\",\"Mongolia\",\"Montenegro\",\"Morocco\",\"Mozambique\",\"Myanmar\",\"Namibia\",\"Nepal\",\"Netherlands\",\"New Zealand\",\"Nicaragua\",\"Niger\",\"Nigeria\",\"North Macedonia\",\"Norway\",\"Oman\",\"Pakistan\",\"Panama\",\"Papua New Guinea\",\"Paraguay\",\"Peru\",\"Philippines\",\"Poland\",\"Portugal\",\"Qatar\",\"Romania\",\"Russia\",\"Rwanda\",\"Saudi Arabia\",\"Senegal\",\"Serbia\",\"Seychelles\",\"Sierra Leone\",\"Singapore\",\"Slovakia\",\"Slovenia\",\"Somalia\",\"South Africa\",\"South Sudan\",\"Spain\",\"Sri Lanka\",\"Sudan\",\"Sweden\",\"Switzerland\",\"Syria\",\"Taiwan\",\"Tajikistan\",\"Tanzania\",\"Thailand\",\"Timor Leste\",\"Togo\",\"Trinidad and Tobago\",\"Tunisia\",\"Turkmenistan\",\"Türkiye\",\"USSR\",\"Uganda\",\"Ukraine\",\"United Arab Emirates\",\"United Kingdom\",\"United States of America\",\"Uruguay\",\"Uzbekistan\",\"Venezuela\",\"Viet Nam\",\"Yemen\",\"Yemen, North\",\"Yugoslavia\",\"Zambia\",\"Zimbabwe\"]}"

  req <- httr2::request("https://backend.sipri.org/api/p/excel-export") |>
    httr2::req_headers("Content-Type" = "application/json")|>
    httr2::req_body_raw(data)

  if(verbose){
    req <- req |>
      httr2::req_verbose()
  }

 return(req)
}

mr_perform_request<- function(req){
  resp <- httr2::req_perform(req)

  return(resp)
}

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


mr_get_footnotes <- function(file_path, notes){
  content <- content2 <- NULL
  footnotes <- readxl::read_xlsx(file_path,
                             sheet = 'Footnotes') |>
    dplyr::select(footnotes = 1, content = 2, content2 = 3) |>
    dplyr::mutate(content = dplyr::if_else(is.na(content),
                                           content2,
                                           content)) |>
    dplyr::mutate(footnotes = stringr::str_remove(footnotes,"\\.0")) |>
    dplyr::filter(!is.na(footnotes))

  notes <- notes[!is.na(notes)]

  footnotes <- notes |> purrr::map_dfr(
    function(x){
      footnotes_num <- stringr::str_extract(x,"[0-9]+")
      footnotes_alpha <- stringr::str_remove_all(x,"[0-9]") |>
        stringr::str_split_1(pattern = "")

      all_notes <- c(footnotes_num, footnotes_alpha)

      footnote_string <- footnotes |>
        dplyr::filter(footnotes %in% all_notes) |>
        dplyr::summarise(notes = x,
                         footnote = paste0(stringr::str_c(footnotes,": ",content), collapse = "; "))

      return(footnote_string)
    }
  )

  return(footnotes)
}
