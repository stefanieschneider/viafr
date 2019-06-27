#' Get Data for VIAF Identifier(s)
#'
#' Get authority cluster data based on supplied VIAF identifier(s).
#'
#' @param query The VIAF identifier(s) to get data for.
#' @param ... Optional VIAF API query parameters.
#' @return A tibble with data items.
#'
#' @note An internet connection is required. The MARC 21 field
#' definitions are used.
#'
#' @examples
#' \donttest{viaf_get(c("64013650", "102333412"))}
#'
#' @importFrom purrr map
#' @importFrom magrittr "%>%"
#'
#' @rdname get
#' @export
viaf_get <- function(query = NULL, ...) {
  if (is.null(query)) {
    stop("VIAF query could not be parsed.")
  }

  if (is.list(query)) query <- unlist(query)
  assertthat::assert_that(is.vector(query))

  items <- map(query, viaf_retrieve, ...) %>%
    map(get_identifier) %>% dplyr::bind_rows()

  return(items)
}

#' @importFrom tibble tibble
#' @importFrom magrittr "%>%"
get_identifier <- function(x) {
  if (is.null(x)) {
    return(
      tibble(
        viaf_id = NA, source_ids = list(),
        name_type = NA, text = list()
      )
    )
  }

  metadata <- tibble(
    viaf_id = x$viafID, source_ids = list(
      get_source_ids(x$sources$source)
    ),

    name_type = get_name_type(x$nameType)[[1]],
    text = list(get_text(x))
  )

  return(metadata)
}
