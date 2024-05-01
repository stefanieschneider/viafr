#' Get data tibbles from VIAF cluster
#'
#' @description Get tibbles from VIAF cluster using xml/xslt methods.
#'
#' @rdname cluster_data
#' @param viafids A list of VIAF IDs to be retrieved
#' @param xslt The xslt stylesheet in character format.
#' @param t A tibble that contains summaries. If the columns of t are
#' identical to the columns retrieved in this function, the retrieved
#' rows are added to t. If not, a warning is given and t returned without
#' new rows. If t is NULL, a new tibble is returned with the columns
#' from the transformed viaf.xml.
#' @param cache A folder for storing download viaf.xml files and avoiding
#' unnecessary internet calls. The default is tempdir(), which is not
#' permanent. Researchers may want to substute a permanent folder to
#' maintain a snapshot of their data.
#' @param intercache A folder for storing the intermediate xml files produced
#' by the xslt transform. The intermediary files
#' @param redirectlog Path to csv file. The viaf api redirects superceded ids.
#' This parameter provides for logging these redirects.
#' @return If t is a tibble, a new row is added and the tibble returned.
#' If t is NULL, a new tibble is created and returned.
#' @import xml2
#' @import xslt
#' @importFrom purrr map
#' @importFrom tibble tibble
#' @importFrom dplyr filter
#' @importFrom magrittr "%>%"
#' @importFrom lubridate ymd_hms now
#' @export
cluster_data <- function(viafids = NULL,
  xslt = NULL,
  t = NULL,
  cache = tempdir(),
  intercache = tempdir(),
  redirectlog = file.path(tempdir(), "redirects.csv"),
  ...
) {
  style <- xml2::read_xml(xslt)

  viafs <- viafr::viaf_get_cluster(viafidlist = viafids, cache = cache)

  tmpt <- viafs %>%
    map(\(x) xml2::read_xml(x)) %>%
    map(\(x) viafr::viafxml2df(x, xslt = style, intercache = intercache))  %>%
    dplyr::bind_rows()

  vs <- tmpt %>% dplyr::select(viafID) %>% unique()

  qrs <- tibble::tibble(query = viafids, redirect = vs$viafID)
  vars <- as.character(colnames(qrs))
  redirects <- qrs %>% dplyr::filter(.data[[vars[[1]]]] != .data[[vars[[2]]]])

  if (length(redirects) > 0) {
    if (file.exists(redirectlog)) {
      redirects[1, ] %>%
        write.table(file = redirectlog, col.names = FALSE,
                    append = TRUE, row.names = FALSE, sep = ",")
    } else if (file.exists(dirname(redirectlog))) {
      redirects[1, ] %>%
        write.table(file = redirectlog, row.names = FALSE, sep = ",")
    } else {
      redirects[1, ] %>% print(n = Inf)
    }
  }

  if (tibble::is_tibble(t)) {
    tmpt <- t %>% dplyr::bind_rows(tmpt)
  }

  return(tmpt)
}

#' @description `cluster_summary` gets summary data, one row per viafID.
#'
#' @rdname cluster_data
#' @seealso
#' \link{vc_summary}
#' @export
cluster_summary <- function(viafids = NULL,
  t = NULL,
  cache = tempdir(),
  intercache = tempdir(),
  redirectlog = file.path(tempdir(), "redirects.csv"),
  ...
) {
  style <- viafr::vc_summary

  tmpt <- cluster_data(viafids = viafids, xslt = style, t = t, cache = cache,
                       intercache = intercache, redirectlog = redirectlog)

  return(tmpt)
}

#' @description `cluster_sources` gets the sources with source ids.
#'
#' @rdname cluster_data
#' @seealso
#' \link{vc_sources}
#' @export
cluster_sources <- function(viafids = NULL,
  t = NULL,
  cache = tempdir(),
  intercache = tempdir(),
  redirectlog = file.path(tempdir(), "redirects.csv"),
  ...
) {
  style <- viafr::vc_sources

  tmpt <- cluster_data(viafids = viafids, xslt = style, t = t, cache = cache,
                       intercache = intercache, redirectlog = redirectlog)

  return(tmpt)
}

#' @description `cluster_authorship`
#'
#' @seealso
#' \link{vc_authorship}
#' @rdname cluster_data
#' @export
cluster_authorship <- function(viafids = NULL,
  t = NULL,
  cache = tempdir(),
  intercache = tempdir(),
  redirectlog = file.path(tempdir(), "redirects.csv"),
  ...
) {
  style <- viafr::vc_authorship

  tmpt <- cluster_data(viafids = viafids, xslt = style, t = t, cache = cache,
                       intercache = intercache, redirectlog = redirectlog)

  return(tmpt)
}

#' @description `cluster_covers`
#'
#' @rdname cluster_data
#' @seealso
#' \link{vc_covers}
#' @export
cluster_covers <- function(viafids = NULL,
  t = NULL,
  cache = tempdir(),
  intercache = tempdir(),
  redirectlog = file.path(tempdir(), "redirects.csv"),
  ...
) {
  style <- viafr::vc_covers

  tmpt <- cluster_data(viafids = viafids, xslt = style, t = t, cache = cache,
                       intercache = intercache, redirectlog = redirectlog)

  return(tmpt)
}

#' @description `cluster_ISBNs`
#'
#' @rdname cluster_data
#' @seealso
#' \link{vc_ISBNs}
#' @export
cluster_ISBNs <- function(viafids = NULL,
  t = NULL,
  cache = tempdir(),
  intercache = tempdir(),
  redirectlog = file.path(tempdir(), "redirects.csv"),
  ...
) {
  style <- viafr::vc_ISBNs

  tmpt <- cluster_data(viafids = viafids, xslt = style, t = t, cache = cache,
                       intercache = intercache, redirectlog = redirectlog)

  return(tmpt)
}

#' @description `cluster_jointcorps`
#'
#' @rdname cluster_data
#' @seealso
#' \link{vc_jointcorps}
#' @export
cluster_jointcorps <- function(viafids = NULL,
  t = NULL,
  cache = tempdir(),
  intercache = tempdir(),
  redirectlog = file.path(tempdir(), "redirects.csv"),
  ...
) {
  style <- viafr::vc_jointcorps

  tmpt <- cluster_data(viafids = viafids, xslt = style, t = t, cache = cache,
                       intercache = intercache, redirectlog = redirectlog)

  return(tmpt)
}

#' @description `cluster_jointpersons`
#'
#' @rdname cluster_data
#' @seealso
#' \link{vc_jointpersons}
#' @export
cluster_jointpersons <- function(viafids = NULL,
  t = NULL,
  cache = tempdir(),
  intercache = tempdir(),
  redirectlog = file.path(tempdir(), "redirects.csv"),
  ...
) {
  style <- viafr::vc_jointpersons

  tmpt <- cluster_data(viafids = viafids, xslt = style, t = t, cache = cache,
                       intercache = intercache, redirectlog = redirectlog)

  return(tmpt)
}

#' @description `cluster_links`
#'
#' @rdname cluster_data
#' @seealso
#' \link{vc_viaflinks}
#' @export
cluster_links <- function(viafids = NULL,
  t = NULL,
  cache = tempdir(),
  intercache = tempdir(),
  redirectlog = file.path(tempdir(), "redirects.csv"),
  ...
) {
  style <- viafr::vc_viaflinks

  tmpt <- cluster_data(viafids = viafids, xslt = style, t = t, cache = cache,
                       intercache = intercache, redirectlog = redirectlog)

  return(tmpt)
}

#' @description `cluster_names`
#'
#' @rdname cluster_data
#' @seealso
#' \link{vc_names}
#' @export
cluster_names <- function(viafids = NULL,
  t = NULL,
  cache = tempdir(),
  intercache = tempdir(),
  redirectlog = file.path(tempdir(), "redirects.csv"),
  ...
) {
  style <- viafr::vc_names

  tmpt <- cluster_data(viafids = viafids, xslt = style, t = t, cache = cache,
                       intercache = intercache, redirectlog = redirectlog)

  return(tmpt)
}

#' @description `cluster_titles`
#'
#' @rdname cluster_data
#' @seealso
#' \link{vc_titles}
#' @export
cluster_titles <- function(viafids = NULL,
  t = NULL,
  cache = tempdir(),
  intercache = tempdir(),
  redirectlog = file.path(tempdir(), "redirects.csv"),
  ...
) {
  style <- viafr::vc_titles

  tmpt <- cluster_data(viafids = viafids, xslt = style, t = t, cache = cache,
                       intercache = intercache, redirectlog = redirectlog)

  return(tmpt)
}

