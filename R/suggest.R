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

  endpoint <- "AutoSuggest"

  items <- map(query, viaf_retrieve_query, endpoint = endpoint,
      ...) %>% map(get_suggest) %>% set_names(query)

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
        viaf_id = NA, source_ids = list(),
        name_type = NA, text = NA, score = NA
      )
    )
  }

  authorities <- get("authorities")

  metadata <- as_tibble(x$result) %>%
    rename(
      viaf_id = "viafid", text = "term",
      name_type = "nametype"
    ) %>%
    mutate(
      source_ids = map(
        # columns that every record exhibits
        transpose(select(., -c(
          .data$text, .data$displayForm, .data$name_type,
          .data$viaf_id, .data$score, .data$recordID
        ))),
        ~ enframe(.) %>% unnest() %>% drop_na() %>%
          rename(id = "value", scheme = "name") %>%
          mutate(scheme = toupper(.data$scheme)) %>%
          left_join(authorities, by = "scheme") %>%
          select(.data$id, .data$scheme, .data$name)
      )
    )

  metadata <- get_name_type(metadata) %>%
    select(
      .data$viaf_id, .data$source_ids,
      .data$name_type, .data$text, .data$score
    )

  return(normalize(ungroup(metadata)))
}
