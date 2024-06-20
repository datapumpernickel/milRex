#' Extract and format footnotes from an Excel file
#'
#' Reads footnotes from a specified Excel file and formats them according to the provided notes.
#'
#' @param file_path A character string specifying the path to the Excel file containing footnotes.
#' @param notes A character vector of notes to extract and format.
#' @return A data frame with two columns: `notes`, containing the original notes, and `footnote`, containing the formatted footnotes.
#' @keywords internal
sipri_get_footnotes <- function(file_path, notes){
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
