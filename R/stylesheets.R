#' Get xslt stylesheet from inst/extdata
#' 
#' @description Get an xslt stylesheet from the external data folder.
#'
#' @param name The name of the stylesheet.
#' @return Loaded xslt stylesheet
#' @import xml2
#' @export
get_stylesheet_extdata <- function(name = NULL) {
  path <- paste0("inst/extdata/", name, ".xsl", sep = "")
  xsl <- xml2::read_xml(path)
  return(xsl)
}

#' Get xslt stylesheet from package data
#' 
#' @description Get an xslt stylesheet from the package data.
#'
#' @param name The name of the stylesheet
#' @return Loaded xslt stylesheet
#' @import xml2
#' @export
get_stylesheet <- function(name = NULL) {
  xsl <- data(name)
  return(xsl)
}

#' XSL stylesheet that extracts data from the ns1:covers element of
#' VIAF cluster viaf.xml output
#'
#' @docType data
#' @keywords xsl
#' @name vc_covers_xsl
#'
#' @rdname vc_covers_xsl
#' @usage data(vc_covers_xsl)
#' @format An xsl stylesheet
"vc_covers_xsl"

#' XSL stylesheet that extracts data from the ns1:ISBNs element of
#' VIAF cluster viaf.xml output
#'
#' @docType data
#' @keywords xsl
#' @name vc_ISBNs_xsl
#'
#' @rdname vc_ISBNs_xsl
#' @usage data(vc_ISBNs_xsl)
#' @format An xsl stylesheet
"vc_ISBNs_xsl"

#' XSL stylesheet that extracts corporate joint author data from
#' the ns1:coauthors element of VIAF cluster viaf.xml output
#'
#' @docType data
#' @keywords xsl
#' @name vc_jointcorp_xsl
#'
#' @rdname vc_jointcorp_xsl
#' @usage data(vc_jointcorp_xsl)
#' @format An xsl stylesheet
"vc_jointcorp_xsl"

#' XSL stylesheet that extracts personal joint author data from
#' the ns1:coauthors element of VIAF cluster viaf.xml output
#'
#' @docType data
#' @keywords xsl
#' @name vc_jointperson_xsl
#'
#' @rdname vc_jointperson_xsl
#' @usage data(vc_jointperson_xsl)
#' @format An xsl stylesheet
"vc_jointperson_xsl"

#' XSL stylesheet that extracts source link data from
#' the ns1:mainHeadings/ns1:mainHeadingEl elements of VIAF
#' cluster viaf.xml output
#'
#' @docType data
#' @keywords xsl
#' @name vc_links_xsl
#'
#' @rdname vc_links_xsl
#' @usage data(vc_links_xsl)
#' @format An xsl stylesheet
"vc_links_xsl"

#' XSL stylesheet that extracts sources from
#' the ns1:mainHeadings/ns1:mainHeadingEl (preferred)
#' and ns1:x400s/ns1:x400 (alternate) elements of VIAF
#' cluster viaf.xml output
#'
#' @docType data
#' @keywords xsl
#' @name vc_names_xsl
#'
#' @rdname vc_names_xsl
#' @usage data(vc_names_xsl)
#' @format An xsl stylesheet
"vc_names_xsl"

#' XSL stylesheet that extracts name form data from
#' the ns1:sources elements of VIAF cluster viaf.xml output
#'
#' @docType data
#' @keywords xsl
#' @name vc_sources_xsl
#'
#' @rdname vc_sources_xsl
#' @usage data(vc_sources_xsl)
#' @format An xsl stylesheet
"vc_sources_xsl"

#' XSL stylesheet making a summary of a VIAF cluster viaf.xml output
#'
#' @docType data
#' @keywords xsl
#' @name vc_summary_xsl
#'
#' @rdname vc_summary_xsl
#' @usage data(vc_summary_xsl)
#' @format An xsl stylesheet
"vc_summary_xsl"

#' XSL stylesheet that extracts name form data from
#' the ns1:titles/ns1:work elements of VIAF cluster viaf.xml output
#'
#' @docType data
#' @keywords xsl
#' @name vc_titles_xsl
#'
#' @rdname vc_titles_xsl
#' @usage data(vc_titles_xsl)
#' @format An xsl stylesheet
"vc_titles_xsl"
