#' Search VIAF records
#'
#' Search VIAF records where the authority includes the given terms.
#'
#' @param query The search query (or queries) to get data for.
#' @param ... Optional VIAF API query parameters.
#' @return A named list of tibbles with data items.
#'
#' @note An internet connection is required. The MARC 21 field
#' definitions are used.
#'
#' @examples
#' \donttest{viaf_search(c("Rembrandt", "Jane Austen"))}
#'
#' @importFrom purrr map set_names
#' @importFrom magrittr "%>%"
#'
#' @rdname search
#' @export
viaf_search <- function(query = NULL, ...) {
  if (is.null(query)) {
    stop("VIAF query could not be parsed.")
  }

  if (is.list(query)) query <- unlist(query)
  assertthat::assert_that(is.vector(query))

  endpoint <- "search"

  items <- map(query, viaf_retrieve_query, endpoint = endpoint,
      ...) %>% map(get_search) %>% set_names(query)

  return(items)
}

#' @importFrom dplyr rename select
#' @importFrom magrittr "%>%"
#' @importFrom purrr map_chr
#' @importFrom rlang .data
get_search <- function(x) {
  if (!is.null(x)) {
    response <- x$searchRetrieveResponse
    n_records <- response$numberOfRecords
  } else {
    n_records <- 0 # acts as a surrogate
  }

  if (as.integer(n_records) == 0) {
    return(
      tibble(
        viaf_id = NA, source_ids = list(),
        name_type = NA, text = list()
      )
    )
  }

  x <- response$records$record$recordData
  source_ids <- x$sources$source

  if (is.data.frame(source_ids)) {
    source_ids <- purrr::transpose(source_ids)
  }

  metadata <- tibble::as_tibble(x) %>%
    rename(viaf_id = "viafID", name_type = "nameType") %>%
    mutate(
      source_ids = map(!!source_ids, get_source_ids),
      text = map(split(x, 1:nrow(x)), get_text)
    )

  metadata <- get_name_type(metadata) %>%
    select(
      .data$viaf_id, .data$source_ids,
      .data$name_type, .data$text
    )

  return(metadata)
}
