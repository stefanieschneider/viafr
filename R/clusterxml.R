#' Get VIAF cluster data in viaf.xml format
#'
#' @description
#' 'viaf_get_cluster()' implements the VIAF API ''Get Data'' operation
#'
#' @param viafIDlist The VIAF identifiers of clusters to be retrieved.
#' @param cache Path for storage of downloaded viaf.xml files. This is
#' to reduce redundant calls to the VIAF server. It also enables researchers to
#' maintain snapshot records of their raw data. The default is tempdir(), which
#' is deleted at the end of the current session.
#' @return A list of file paths to the downloaded viaf.xml files.
#'
#' @details
#' Earlier versions of viafr (\url{https://github.com/stefanieschneider/viafr})
#' use json output from calls to the
#' \href{https://www.oclc.org/developer/api/oclc-apis/viaf/authority-cluster.en.html}{VIAF Authority Cluster Resource},
#' which provides data in 11 different formats including JSON, VIAF XML
#' and MARC21 XML. The
#' \href{https://www.oclc.org/developer/api/oclc-apis/viaf/authority-source.en.html}{Authority Source Resource},
#' on the other hand, only provides data in MARC21 and UNIMARC XML
#' formats. An objective of this extension to viafr is to enable access to
#' both cluster and source data.
#' VIAF authority clusters can be merged together over time
#' as additional data is received and algorithms are updated. Externally
#' maintained VIAF cluster identifiers should be checked for updates with
#' this call.
#' See
#' \href{https://www.oclc.org/developer/api/oclc-apis/viaf/authority-cluster.en.html}{Authority Cluster Resource}.
#'
#' @importFrom purrr map
#' @importFrom magrittr "%>%"
#'
#' @export
viaf_get_cluster <- function(viafidlist = NULL, cache = tempdir(), ...) {
  if (is.null(viafidlist)) {
    stop("VIAF query could not be parsed.")
  }

  if (is.list(viafidlist)) viafidlist <- unlist(viafidlist)
  assertthat::assert_that(is.vector(viafidlist))

  if (any(sapply(viafidlist, nchar) == 0)) {
    warning("At least one VIAF query is empty.")
  }

  items <- viafidlist %>%
    map(\(x) viaf_retrieve_xml(x, cache = cache))

  return(items)
}


#' Retrieve from api
#' @note Modified from rcrossref:::cr_GET and viaf_retrieve.
#'
viaf_retrieve_xml <- function(endpoint = NULL, cache = tempdir(), ...) {
  args <- list(...)

  retval <- NULL

  if (is.null(endpoint) && length(args) == 0) {
    stop("VIAF query could not be parsed.")
  }

  url <- "https://www.viaf.org/viaf/"

  if (!is.null(endpoint)) {
    url <- paste0(url, endpoint, "/viaf.xml")
  }

  cachefile <- paste0(cache, "/", endpoint, ".viaf.xml")

  if (file.exists(cachefile)) {
    retval <- cachefile
  } else {
    retval <- xml2::download_xml(url, file = cachefile, ...)
  }

  return(retval)
}
