#' @importFrom utf8 utf8_normalize
normalize <- function(x) {
  result <- purrr::set_names(x, utf8_normalize(colnames(x))) %>%
    dplyr::mutate_if(is.character, list(~ utf8_normalize(.)))

  return(result)
}

#' @note modified from rcrossref:::rcrossref_ua
#' @importFrom utils packageVersion
viaf_ua <- function() {
  versions <- c(
    paste0("r-curl/", packageVersion("curl")),
    paste0("crul/", packageVersion("crul")),
    paste0("viafr/", packageVersion("viafr"))
  )

  return(paste0(versions, collapse = " "))
}

#' @note modified from rcrossref:::cr_GET
viaf_retrieve <- function(endpoint = NULL, ...) {
  args <- list(...)

  if (is.null(endpoint) && length(args) == 0) {
    stop("VIAF query could not be parsed.")
  }

  url <- "http://www.viaf.org/viaf/"

  if (!is.null(endpoint)) {
    url <- paste0(url, endpoint)
  }

  cli <- crul::HttpClient$new(
    url = url,
    headers = list(
      `User-Agent` = viaf_ua(),
      `X-USER-AGENT` = viaf_ua(),
      Accept = "application/json"
    )
  )

  args$httpAccept <- "application/json"

  result <- cli$get(query = args)
  return_value <- NULL

  if (result$status_code == 200L) {
    return_value <- tryCatch({
      jsonlite::fromJSON(result$parse("UTF-8"))
    }, error = function(e) return(return_value))
  }

  if (is.null(return_value)) {
    warning(
      sprintf("Query to %s failed with status code %s.",
        result$url, result$status_code), call. = FALSE
    )
  }

  return(return_value)
}

viaf_retrieve_query <- function(query, endpoint, ...) {
  args <- list(...); args$query <- query
  do.call(viaf_retrieve, c(endpoint, args))
}

#' @importFrom dplyr rename mutate left_join
#' @importFrom purrr map_chr pluck
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
get_source_ids <- function(x) {
  result <- tibble::as_tibble(x) %>%
    rename(id = "@nsid", scheme = "#text") %>%
    mutate(
      id = map_chr(
        .data$id, ~ stringr::str_remove_all(., "^\\.|.*/")
      ),
      scheme = map_chr(
        .data$scheme, ~ strsplit(., "\\|") %>% pluck(1, 1)
      )
    ) %>%
    left_join(get("authorities"), by = "scheme")

  return(result)
}

#' @importFrom dplyr mutate left_join pull
#' @importFrom rlang .data
get_name_type <- function(x) {
  if (length(unlist(x)) == 1) {
    x <- tibble::tibble(name_type = x)
  }

  result <- mutate(
      x, name_type = tolower(.data$name_type) %>%
        stringr::str_remove_all("\\s")
    ) %>%
    left_join(
      get("name_types"), by = c("name_type" = "id")
    ) %>%
    mutate(name_type = .data$name)

  return(result)
}

#' @importFrom stringr str_subset
find_field <- function(x, name, exclude = NULL) {
  x <- unlist(x); names(x) <- paste0(".", names(x))
  field <- str_subset(names(x), paste0(".*\\.", name))

  if (!is.null(exclude)) {
    assertthat::assert_that(is.vector(exclude))

    exclude <- paste(paste0("\\.", exclude), collapse = "|")
    field <- str_subset(field, exclude, negate = TRUE)
  }

  field <- purrr::map(field, ~ x[.])

  return(unlist(field, recursive = FALSE))
}

#' @importFrom dplyr group_by ungroup summarise one_of
#' @importFrom stringr str_subset str_detect
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
get_text <- function(x) {
  x <- find_field(x, name = "subfield", "x500")

  result <- tibble::tibble(
      code = str_subset(names(x), "@code.*$"),
      text = str_subset(names(x), "#text.*$")
    ) %>%
    mutate(
      id = cumsum(str_detect(.data$code, "code(?:1)?$")),
      code = x[.data$code], text = x[.data$text]
    ) %>%
    group_by(.data$id, .data$code) %>%
    summarise(
      text = paste(.data$text, collapse = ", ")
    ) %>%
    ungroup() %>% normalize() %>% group_by(.data$id) %>%
    tidyr::spread(.data$code, .data$text)

  # reorder columns first by letter, then by number
  id <- str_detect(colnames(result), "^[0-9]")

  result <- select(result, one_of(
    c(colnames(result)[!id], colnames(result)[id])
  ))

  return(result)
}
