## code to prepare `vc_summary_xsl` dataset goes here
library(xml2)
library(xslt)

get_summary_xsl <- function() {
  xsl <- xml2::read_xml(file.path(getwd(),"inst/extdata/vc_summary.xsl", sep=""))
  return(xsl)
}

vc_summary <- as.character(get_summary_xsl())
usethis::use_data(vc_summary, overwrite = TRUE)

get_sources_xsl <- function() {
  xsl <- xml2::read_xml(file.path(getwd(),"inst/extdata/vc_sources.xsl", sep=""))
  return(xsl)
}

vc_sources <- as.character(get_sources_xsl())
usethis::use_data(vc_sources, overwrite = TRUE)

