#' @title Get xslt stylesheet
#' @rdname stylesheets
#' @description `get_stylesheet_extdata` gets an xslt stylesheet
#' from the external data folder.
#'
#' @param name The name of the stylesheet.
#' @return Loaded xslt stylesheet
#' @format `get_stylesheet_extdata` - path to stylesheet
#' @import xml2
#' @import xslt
#' @export
get_stylesheet_extdata <- function(name = NULL) {
  sname <- paste0(name, ".xsl", sep = "")
  path <- system.file("extdata", sname, package = "viafr")
  return(path)
}

#' @title vc_summary XSL stylesheet makes a summary of
#' a VIAF cluster viaf.xml output
#'
#' @docType data
#' @keywords xsl
#' @name vc_summary
#'
#' @rdname stylesheets
#' @details 'vc_summary' produces an xml file with one row.
#' Example:
#' \preformatted{
#' <summary viafid="22826335"
#' viafrVersion="0.4.0" processDate="2024-04-26 06:04:26.381083">
#' <row>
#' <viafID class="character">22826335</viafID>
#' <viafType class="character">Personal</viafType>
#' <name class="character">Hotez, Peter J.</name>
#' <gender class="character">male</gender>
#' <birthDate class="Date">1958-05-05</birthDate>
#' <deathDate class="Date">0</deathDate>
#' <dateType class="character">lived</dateType>
#' <nationalities class="character">US,XX</nationalities> # 2-letter codes only
#' <affiliations class="integer">5</affiliations>
#' <sourceCount class="integer">15</sourceCount>
#' <uniqueISBNs class="integer">31</uniqueISBNs>
#' <coauthorsPersonal class="integer">12</coauthorsPersonal>
#' <coauthorsCorp class="integer">0</coauthorsCorp>
#' <viaf-update class="POSIXct">2024-04-09T07:46:16.176845+00:00</viaf-update>
#' </row>
#' </summary>
#' }
#' 
#' @seealso
#' \link{cluster_summary}
#' @usage vc_summary
#' @format 'vc_summary' An xsl stylesheet as an object of
#' class character of length 1.
"vc_summary"

#' @title vc_sources XSL stylesheet extracts source ids from
#' a VIAF cluster viaf.xml record
#'
#' @docType data
#' @keywords xsl
#' @name vc_sources
#'
#' @rdname stylesheets
#' @details 'vc_sources' produces an xml file with multiple rows.
#' A viaf.xml record repeats the same source ids throughout. In this package,
#' the source ids are extracted with this xsl only. The user must extract these
#' source ids to link to processed source marc21.xml files.
#' Example:
#' \preformatted{
#' <summary viafid="2556873"
#' viafrVersion="0.4.1" processDate="2024-05-01 02:55:08.434356">
#' <row>
#' <viafID class="character">2556873</viafID>
#' <nsid class="character">ncf11461894</nsid>
#' <sparse class="logical"/>
#' <s class="character">CAOONL</s>
#' <sid class="character">CAOONL|ncf11461894</sid>
#' <viaf-update class="POSIXct">2024-01-21T21:31:37.205257+00:00</viaf-update>
#' </row>
#' ...
#' </summary>
#' }
#'
#' @seealso
#' \link{cluster_sources}
#' @usage vc_sources
#' @format 'vc_sources' An xsl stylesheet as an object
#' of class character of length 1.
"vc_sources"

#' @title vc_authorship XSL stylesheet extracts authorship
#' data from a VIAF cluster viaf.xml record
#'
#' @docType data
#' @keywords xsl
#' @name vc_authorship
#'
#' @rdname stylesheets
#' @details 'vc_authorship' produces an xml file with multiple rows. It combines
#' corporate joint author, personal joint author, ISBN, covers, and titles data
#' in a single output. Because they have the same columns, they can be combined
#' in a single tibble. In the example below, tag ''pos'' is the position of the
#' element in the ''relType'' listing and is included because the VIAF cluster
#' appears to descendingly rank these by the number of sources.
#' Example:
#' \preformatted{
#' <authorship viafid="2556873"
#' viafrVersion="0.4.1" processDate="2024-05-01 02:55:08.434356">
#' <row>
#' <viafID class="character">2556873</viafID>
#' <viafType class="character">Personal</viafType>
#' <relType class="character">person</relType>
#' <pos class="integer">1</pos>
#' <source class="character">BNF</source>
#' <value class="character">Halsey, Susan D.</value>
#' <viaf-update class="POSIXct">2024-01-21T21:31:37.205257+00:00</viaf-update>
#' </row>
#' ...
#' <row>
#' <viafID class="character">2556873</viafID>
#' <viafType class="character">Personal</viafType>
#' <relType class="character">isbn</relType>
#' <pos class="integer">1</pos>
#' <source class="character">BNF</source>
#' <value class="character">9780444015600</value>
#' <viaf-update class="POSIXct">2024-01-21T21:31:37.205257+00:00</viaf-update>
#' </row>
#' ...
#' </authorship>
#' }
#'
#' @seealso
#' \link{cluster_authorship}
#' @usage vc_authorship
#' @format 'vc_authorship' An xsl stylesheet as an object
#' of class character of length 1.
"vc_authorship"

#' vc_covers XSL stylesheet extracts covers data from a
#' VIAF cluster viaf.xml record
#'
#' @docType data
#' @keywords xsl
#' @name vc_covers
#'
#' @rdname stylesheets
#' @details 'vc_covers' produces an xml file with multiple rows. Because
#' corporate joint author, personal joint author, ISBN, covers, and titles
#' data they have the same columns, they can be combined
#' in a single tibble. In the example below, tag ''pos'' is the position of the
#' element in the ''relType'' listing and is included because the VIAF cluster
#' appears to descendingly rank these by the number of sources.
#' Example:
#' \preformatted{
#' <covers viafid="2556873" viafrVersion="0.4.1"
#' processDate="2024-05-01 03:10:59.403286">
#' <row>
#' <viafID class="character">2556873</viafID>
#' <viafType class="character">Personal</viafType>
#' <relType class="character">cover</relType>
#' <pos class="integer">1</pos>
#' <source class="character">LC</source>
#' <value class="character">0761806997</value>
#' <viaf-update class="POSIXct">2024-01-21T21:31:37.205257+00:00</viaf-update>
#' </row>
#' <row>
#' <viafID class="character">2556873</viafID>
#' <viafType class="character">Personal</viafType>
#' <relType class="character">cover</relType>
#' <pos class="integer">2</pos>
#' <source class="character">LC</source>
#' <value class="character">0761806989</value>
#' <viaf-update class="POSIXct">2024-01-21T21:31:37.205257+00:00</viaf-update>
#' </row>
#' </covers>
#' }
#'
#' @seealso
#' \link{cluster_covers}
#' @usage vc_covers
#' @format 'vc_covers' An xsl stylesheet as an object of class
#' character of length 1.
"vc_covers"

#' vc_ISBNs XSL stylesheet extracts unique ISBN data
#' from a VIAF cluster viaf.xml record
#'
#' @docType data
#' @keywords xsl
#' @name vc_ISBNs
#'
#' @rdname stylesheets
#' @details 'vc_ISBNs' produces an xml file with multiple rows. Because
#' corporate joint author, personal joint author, ISBN, covers, and titles
#' data they have the same columns, they can be combined
#' in a single tibble. In the example below, tag ''pos'' is the position of the
#' element in the ''relType'' listing and is included because the VIAF cluster
#' appears to descendingly rank these by the number of sources.
#' Example:
#' \preformatted{
#' <ISBNs viafid="2556873" viafrVersion="0.4.1"
#' processDate="2024-05-01 03:28:32.76746">
#' <row>
#' <viafID class="character">2556873</viafID>
#' <viafType class="character">Personal</viafType>
#' <relType class="character">isbn</relType>
#' <pos class="integer">1</pos>
#' <source class="character">BNF</source>
#' <value class="character">9780444015600</value>
#' <viaf-update class="POSIXct">2024-01-21T21:31:37.205257+00:00</viaf-update>
#' </row>
#' ...
#' </ISBNs>
#' }
#' 
#' @seealso
#' \link{cluster_ISBNs}
#' @usage vc_ISBNs
#' @format 'vc_ISBNs' An xsl stylesheet as an object of class
#' character of length 1.
"vc_ISBNs"

#' vc_jointcorps XSL stylesheet extracts corporate coauthor
#' data from a VIAF cluster viaf.xml record
#'
#' @docType data
#' @keywords xsl
#' @name vc_jointcorps
#'
#' @rdname stylesheets
#' @details 'vc_jointcorp' produces an xml file with multiple rows. Because
#' corporate joint author, personal joint author, ISBN, covers, and titles
#' data they have the same columns, they can be combined
#' in a single tibble. In the example below, tag ''pos'' is the position of the
#' element in the ''relType'' listing and is included because the VIAF cluster
#' appears to descendingly rank these by the number of sources.
#' Example:
#' \preformatted{
#' <jointcorps viafid="2556873" viafrVersion="0.4.1"
#' processDate="2024-05-01 03:31:22.394016">
#' <row>
#' <viafID class="character">2556873</viafID>
#' <viafType class="character">Personal</viafType>
#' <relType class="character">corporate</relType>
#' <pos class="integer">1</pos>
#' <source class="character">ISNI</source>
#' <value class="character">
#' International symposium on coastal ocean space utilization 01 1989
#' </value>
#' <viaf-update class="POSIXct">2024-01-21T21:31:37.205257+00:00</viaf-update>
#' </row>
#' ...
#' </jointcorps>
#' }
#' 
#' @seealso
#' \link{cluster_jointcorps}
#' @usage vc_jointcorps
#' @format 'vc_jointcorps' An xsl stylesheet as an object
#' of class character of length 1.
"vc_jointcorps"

#' vc_jointpersons XSL stylesheet extracts person coauthor
#' data from a VIAF cluster viaf.xml record
#'
#' @docType data
#' @keywords xsl
#' @name vc_jointpersons
#'
#' @rdname stylesheets
#' @details 'vc_jointperson' produces an xml file with multiple rows. Because
#' corporate joint author, personal joint author, ISBN, covers, and titles
#' data they have the same columns, they can be combined
#' in a single tibble. In the example below, tag ''pos'' is the position of the
#' element in the ''relType'' listing and is included because the VIAF cluster
#' appears to descendingly rank these by the number of sources.
#' Example:
#' \preformatted{
#' <jointpersons viafid="2556873" viafrVersion="0.4.1"
#' processDate="2024-05-01 03:37:00.178212">
#' <row>
#' <viafID class="character">2556873</viafID>
#' <viafType class="character">Personal</viafType>
#' <relType class="character">person</relType>
#' <pos class="integer">1</pos>
#' <source class="character">BNF</source>
#' <value class="character">Halsey, Susan D.</value>
#' <viaf-update class="POSIXct">2024-01-21T21:31:37.205257+00:00</viaf-update>
#' </row>
#' ...
#' </jointpersons>
#' }
#' 
#' @seealso
#' \link{cluster_jointpersons}
#' @usage vc_jointpersons
#' @format 'vc_jointpersons' An xsl stylesheet as an object
#' of class character of length 1.
"vc_jointpersons"

#' vc_viaflinks XSL stylesheet extracts links data
#' from a VIAF cluster viaf.xml record
#'
#' @docType data
#' @keywords xsl
#' @name vc_viaflinks
#'
#' @rdname stylesheets
#' @details 'vc_viaflinks' produces an xml file with multiple rows. These links
#' make up the VIAF cluster.
#' Example:
#' \preformatted{
#' <viaflinks viafid="2556873" viafrVersion="0.4.1"
#' processDate="2024-05-01 03:40:28.592271">
#' <row>
#' <viafID class="character">2556873</viafID>
#' <viafType class="character">Personal</viafType>
#' <namevalue class="character">Abel, Robert Berger</namevalue>
#' <tag class="character">200</tag>
#' <fromSource class="character">BNF</fromSource>
#' <toSource class="character">DNB</toSource>
#' <matchtype class="character">forced single date</matchtype>
#' <viaf-update class="POSIXct">2024-01-21T21:31:37.205257+00:00</viaf-update>
#' </row>
#' ...
#' </viaflinks>
#' }
#'
#' @seealso
#' \link{cluster_links}
#' @usage vc_viaflinks
#' @format 'vc_viaflinks' An xsl stylesheet as an object
#' of class character of length 1.
"vc_viaflinks"

#' vc_names XSL stylesheet extracts names data
#' from a VIAF cluster viaf.xml record
#'
#' @docType data
#' @keywords xsl
#' @name vc_names
#'
#' @rdname stylesheets
#' @details 'vc_names' produces an xml file with multiple rows. The 'inCluster'
#' variable is TRUE if a preferred form, FALSE if an alternate form.
#' Example:
#' \preformatted{
#' <names viafid="2556873" viafrVersion="0.4.1"
#' processDate="2024-05-01 04:58:49.644222">
#' <row>
#' <viafID class="character">2556873</viafID>
#' <viafType class="character">Personal</viafType>
#' <inCluster class="logical">TRUE</inCluster>
#' <tag class="character">200</tag>
#' <namevalue class="character">Abel, Robert Berger</namevalue>
#' <source class="character">BNF</source>
#' <linkcount class="integer">7</linkcount>
#' <viaf-update class="POSIXct">2024-01-21T21:31:37.205257+00:00</viaf-update>
#' </row>
#' ...
#' </names>
#' }
#' 
#' @seealso
#' \link{cluster_names}
#' @usage vc_names
#' @format 'vc_names' An xsl stylesheet as an object
#' of class character of length 1.
"vc_names"

#' vc_titles XSL stylesheet extracts titles data from a VIAF cluster viaf.xml record
#'
#' @docType data
#' @keywords xsl
#' @name vc_titles
#'
#' @rdname stylesheets
#' @details 'vc_titles' produces an xml file with multiple rows.
#' Example:
#' \preformatted{
#' <titles viafid="2556873" viafrVersion="0.4.1"
#' processDate="2024-05-01 05:08:02.309578">
#' <row>
#' <viafID class="character">2556873</viafID>
#' <viafType class="character">Personal</viafType>
#' <relType class="character">title</relType>
#' <pos class="integer">1</pos>
#' <source class="character">BNF</source>
#' <value class="character">
#' Coastal ocean space utilization proceedings of the First International
#' symposium on coastal ocean space utilization (COSU '89) held
#' May 8-10, 1989 in New York
#' </value>
#' <viaf-update class="POSIXct">2024-01-21T21:31:37.205257+00:00</viaf-update>
#' </row>
#' ...
#' </titles>
#' }
#' 
#' @seealso
#' \link{cluster_titles}
#' @usage vc_titles
#' @format 'vc_titles' An xsl stylesheet as an object
#' of class character of length 1.
"vc_titles"

