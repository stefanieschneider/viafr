## code to prepare `vc_summary_xsl` dataset goes here
library(xml2)

get_summary_xsl <- function() {
  xsl <- xml2::read_xml("inst/extdata/vc_summary.xsl")
  return(xsl)
}

vc_summary_xsl <- get_summary_xsl()
usethis::use_data(vc_summary_xsl, overwrite = TRUE)
