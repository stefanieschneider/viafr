#' Data frame (tibble) from VIAF cluster xml
#'
#' @description
#' 'viafxml2df()' reads xml downloaded from viaf.org, transforms it to an
#' xml, and from that xml produces
#' a tibble. This function draws on Dominic Bordelon's
#' read_marcxml() function in
#' \href{https://github.com/dojobo/marc21r}{__marc21r__}.
#'
#' @rdname viafxml2df
#' @usage viafxml2df(x, xslt=NULL, ...)
#' @param x Loaded viaf.xml document.
#' @param xslt Loaded xslt stylesheet
#' @param intercache Directory in which to story intermediate xml
#' output from transform.
#'
#' @import dplyr
#' @import purrr
#' @import stringr
#' @import tidyr
#' @import xml2
#' @import xslt
#' @importFrom tibble tibble
#' @importFrom magrittr "%>%"
#' @importFrom lubridate ymd_hms now
#'
#' @return The target tibble.
#' @export
viafxml2df <- function(x, xslt = NULL, intercache = tempdir(), ...) {
  vv <- as.character(utils::packageVersion("viafr"))
  pt <- as.character(lubridate::now("UTC"))
  dataxml <- xslt::xml_xslt(x, xslt, params = list(viafrversion = vv, now = pt))
  rootname <- xml2::xml_name(xml2::xml_root(dataxml))
  if (file.exists(intercache)) {
    vid <- xml2::xml_attr(xml2::xml_root(dataxml), attr = "viafid")
    wpath <- file.path(intercache, paste0(vid, ".", rootname, ".xml", sep = ""))
    xml2::write_xml(dataxml, wpath, options = "format", encoding = "UTF-8")
  }

  ## this gets the tibble out of the intermediary xml
  chlds <- xml2::xml_find_all(xml2::xml_root(dataxml), "row")
  labs <- trimws(xml2::xml_name(xml2::xml_children(chlds[1])))
  colclasses <- xml2::xml_attr(xml2::xml_children(chlds[1]), "class")

  df <- read.table(text = "", colClasses = colclasses, col.names = labs)
  len <- length(chlds)
  for (i in 1:len) {
    cells <- xml2::xml_children(chlds[i])
    nocells <- length(cells)

    dv <- read.table(text = "", colClasses = colclasses, col.names = labs)
    for (j in 1:nocells) {
      dv[1, j] <- switch(colclasses[j],
          character = as.character(xml2::xml_text(cells[j])), # nolint
          Date = lubridate::ymd(xml2::xml_contents(cells[j]),truncated = 2, quiet = TRUE), # nolint
          POSIXct = lubridate::ymd_hms(xml2::xml_contents(cells[j]), quiet = TRUE), # nolint
          factor = as.character(xml2::xml_text(cells[j])),
          logical = as.logical(xml2::xml_text(cells[j])),
          integer = as.integer(xml2::xml_text(cells[j])))
    }
    df <- rbind(df, dv)
  }
  result <- dplyr::tibble(df)

  return(result)
}