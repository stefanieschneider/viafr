require(magrittr)
require(stringr)

get_authorities <- function() {
  cli <- crul::HttpClient$new(url = "http://viaf.org/")

  result <- cli$get()

  if (result$status_code == 200L) {
    search_string <- "viafpartners=\\[\\{(.*)\\}\\]"

    result <- result$parse("UTF-8") %>%
      str_remove_all("\\r|\\n|\\t") %>%
      str_replace_all("\\s+", " ") %>%
      str_match(search_string)

    data <- paste0("{ ", result[2], "}") %>%
      str_remove_all(", \"children(.*?)\\]")

    names <- str_match_all(data, "\"name\": (.*?),") %>%
      .[[1]] %>% .[, 2] %>% str_remove_all("\"")

    schemes <- str_match_all(data, "\"flag\": (.*?),") %>%
      .[[1]] %>% .[, 2] %>% str_remove_all("\"|.png")

    return(tibble::tibble(name = names, scheme = schemes))
  }
}

get_name_types <- function() {
  name_types <- tibble::tibble(name = c(
    "Corporate Names", "Geographic Names", "Personal Names",
    "Uniform Title Works", "Uniform Title Expressions")
  ) %>%
  mutate(id = tolower(str_remove_all(x, " ")))

  return(name_types)
}

authorities <- get_authorities()
usethis::use_data(authorities, overwrite = TRUE)

name_types <- get_name_types()
usethis::use_data(name_types, overwrite = TRUE)
