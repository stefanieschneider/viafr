require(magrittr)
require(stringr)

get_name_types <- function() {
  name_types <- tibble::tibble(
    name = c(
      "Corporate Names", "Geographic Names", "Personal Names",
      "Uniform Title Works", "Uniform Title Expressions"
    )
  ) %>%
  dplyr::mutate(
    id = str_remove_all(tolower(name), "\\s|s$|names$")
  )

  return(name_types)
}

name_types <- get_name_types()
usethis::use_data(name_types, overwrite = TRUE)
