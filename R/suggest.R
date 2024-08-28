#' Suggest VIAF records
#'
#' Suggest VIAF records based on given terms passed in a query.
#'
#' @param query The search query (or queries) to get data for.
#' @param ... Optional VIAF API query parameters.
#' @return A named list of tibbles with data items.
#'
#' @note An internet connection is required.
#'
#' @examples
#' \donttest{viaf_suggest(c("rembrandt", "austen"))}
#'
#' @importFrom purrr map set_names
#' @importFrom magrittr "%>%"
#'
#' @rdname suggest
#' @export
viaf_suggest <- function(query = NULL, ...) {
  if (is.null(query)) {
    stop("VIAF query could not be parsed.")
  }

  if (is.list(query)) query <- unlist(query)
  assertthat::assert_that(is.vector(query))

  if (any(sapply(query, nchar) == 0)) {
    warning("At least one VIAF query is empty.")
  }

  endpoint <- "AutoSuggest"

  items <- map(
      query,
      viaf_retrieve_query,
      endpoint = endpoint,
      ...
    ) %>%
    map(get_suggest) %>%
    set_names(query)

  return(items)
}

#' @importFrom tidyr unnest drop_na
#' @importFrom purrr transpose map
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
#' @import dplyr tibble
get_suggest <- function(x) {
  if (is.null(x$result)) {
    return(
      tibble(
        viaf_id = NA,
        source_ids = list(),
        name_type = NA,
        text = NA,
        score = NA
      )
    )
  }

  authorities <- get("authorities")

  metadata <- as_tibble(x$result) %>%
    rename(
      viaf_id = "viafid",
      text = "term",
      name_type = "nametype"
    )

  if (ncol(metadata) > 6) {
    metadata <- metadata %>%
      mutate(
        source_ids = map(
          # columns that every record exhibits
          transpose(select(., -c(
            "text",
            "displayForm",
            "name_type",
            "viaf_id",
            "score",
            "recordID"
          ))),
          ~ enframe(.) %>%
            unnest(cols = names(.)) %>%
            drop_na() %>%  # drop totally empty columns
            rename(id = "value", scheme = "name") %>%
            mutate(scheme = toupper(scheme)) %>%
            left_join(authorities, by = "scheme") %>%
            select(id, scheme, name)
        )
      )
  } else {
    metadata <- mutate(metadata, source_ids = list(NULL))
  }

  metadata <- get_name_type(metadata) %>%
    select(
      "viaf_id",
      "source_ids",
      "name_type",
      "text",
      "score"
    )

  return(normalize(ungroup(metadata)))
}
