#' Data frame (tibble) from VIAF cluster xml
#'
#' @description
#' 'viafxml2df()' reads xml downloaded from viaf.org, transforms it to an
#' xml, and from that xml produces
#' a tibble. This function draws on Dominic Bordelon's
#' read_marcxml() function in
#' \href{https://github.com/dojobo/marc21r}{__marc21r__}.
#'
#' @usage viafxml2df(x, xslt=NULL, ...)
#' @param x Loaded viaf.xml document.
#' @param xslt Loaded xslt stylesheet
#' @param intercache Directory in which to store intermediate xml
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
#' @importFrom lubridate ymd_hms now ymd
#'
#' @return The target tibble.
#' @export
viafxml2df <- function(x, # nolint
      xslt = NULL, # nolint
      params = list(), # nolint
      intercache = tempdir(), # nolint
      ...) { # nolint
  ps <- params
  if (length(ps) == 0) {
    vv <- as.character(utils::packageVersion("viafr"))
    pt <- as.character(lubridate::now("UTC"))
    ps <- list(viafrversion = vv, now = pt)
  }
  dataxml <- xslt::xml_xslt(x, xslt, params = ps)
  rootname <- xml2::xml_name(xml2::xml_root(dataxml))
  if (file.exists(intercache)) {
    vid <- xml2::xml_attr(xml2::xml_root(dataxml), attr = "viafid")
    wpath <- file.path(intercache, paste0(vid, ".", rootname, ".xml", sep = ""))
    xml2::write_xml(dataxml, wpath, options = "format", encoding = "UTF-8")
  }

  ## this gets the tibble out of the intermediary xml
  chlds <- xml2::xml_find_all(xml2::xml_root(dataxml), "row")
  if (length(chlds) == 0) return(NULL)

  labs <- trimws(xml2::xml_name(xml2::xml_children(chlds[1])))
  colclasses <- xml2::xml_attr(xml2::xml_children(chlds[1]), "ct")

  df <- read.table(text = "", colClasses = colclasses, col.names = labs)
  len <- length(chlds)
  for (i in 1:len) {
    cells <- xml2::xml_children(chlds[i])
    nocells <- length(cells)

    dv <- read.table(text = "", colClasses = colclasses, col.names = labs)
    for (j in 1:nocells) {
      cellcontents <- xml2::xml_contents(cells[j])
      tryCatch(
        {
          if (xml2::xml_has_attr(cells[j], "postnm") &
                xml2::xml_attr(cells[j], "postnm") == "TRUE") {
            cellcontents <- viaf_normalize(as.character(cellcontents),
                source = as.character(xml2::xml_attr(cells[j], "src"))) # nolint
          }
        },
        error = function(cond) {
          message(paste("Error: viafxml2df normalization ", i, " Cell ", j))
          message(paste("Content: ", xml2::xml_text(cells[j])))
          message(conditionMessage(cond))
        },
        warning = function(cond) {
          message(paste("Warning: viafxml2df normalization ", i, " Cell ", j))
          message(paste("Content: ", xml2::xml_text(cells[j])))
          message(conditionMessage(cond))
        }
      )
      tryCatch(
        {
          dv[1, j] <- switch(colclasses[j],
              "character" = as.character(cellcontents), # nolint
              "Date" = lubridate::ymd(xml2::xml_text(cells[j]),truncated = 2, quiet = TRUE), # nolint
              "POSIXct" = lubridate::ymd_hms(xml2::xml_text(cells[j]), quiet = TRUE), # nolint
              "factor" = as.factor(xml2::xml_text(cells[j])),
              "logical" = as.logical(xml2::xml_text(cells[j])),
              "integer" = as.integer(xml2::xml_text(cells[j])))
        },
        error = function(cond) {
          message(paste("Error: viafxml2df Record ", i, " Cell ", j))
          message(paste("Content: ", xml2::xml_text(cells[j])))
          message(conditionMessage(cond))
        },
        warning = function(cond) {
          message(paste("Warning: viafxml2df Record ", i, " Cell ", j))
          message(paste("Content: ", xml2::xml_text(cells[j])))
          message(paste("Content: ", as.character(xml2::xml_text(cells[j]))))
          message(conditionMessage(cond))
        }
      )
    }
    df <- rbind(df, dv)
  }
  result <- dplyr::tibble(df)

  return(result)
}

#' @import stringr
#'
viaf_normalize <- function(string, source = "ALL") {
  normstring <- stringr::str_to_lower(string)
  if (source == "NDL" || source == "NII") {
    normstring <- stringr::str_replace_all(normstring, "[・]", " ")
    normstring <- stringr::str_replace_all(normstring, "[ガ]", "カ")
    normstring <- stringr::str_replace_all(normstring, "[ギ]", "キ")
    normstring <- stringr::str_replace_all(normstring, "[グ]", "ク")
    normstring <- stringr::str_replace_all(normstring, "[ゲ]", "ケ")
    normstring <- stringr::str_replace_all(normstring, "[ゴ]", "コ")
    normstring <- stringr::str_replace_all(normstring, "[ザ]", "サ")
    normstring <- stringr::str_replace_all(normstring, "[ジ]", "シ")
    normstring <- stringr::str_replace_all(normstring, "[ズ]", "ス")
    normstring <- stringr::str_replace_all(normstring, "[ゼ]", "セ")
    normstring <- stringr::str_replace_all(normstring, "[ゾ]", "ソ")
    normstring <- stringr::str_replace_all(normstring, "[ダ]", "タ")
    normstring <- stringr::str_replace_all(normstring, "[ヂ]", "チ")
    normstring <- stringr::str_replace_all(normstring, "[ヅ]", "ツ")
    normstring <- stringr::str_replace_all(normstring, "[デ]", "テ")
    normstring <- stringr::str_replace_all(normstring, "[ド]", "ト")
    normstring <- stringr::str_replace_all(normstring, "[バパ]", "ハ")
    normstring <- stringr::str_replace_all(normstring, "[ビピ]", "ヒ")
    normstring <- stringr::str_replace_all(normstring, "[ブプ]", "フ")
    normstring <- stringr::str_replace_all(normstring, "[ベペ]", "ヘ")
    normstring <- stringr::str_replace_all(normstring, "[ボポ]", "ホ")
    normstring <- stringr::str_remove_all(normstring, "[ー]")
  }
  normstring <- stringr::str_remove_all(normstring, "[:punct:]")
  normstring <- stringr::str_squish(normstring)
  normstring <- utf8::utf8_normalize(normstring)
  return(normstring)
}