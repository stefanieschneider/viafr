# viafr 0.4.2

* Functionality for searching coauthor VIAF clusters

# viafr 0.4.1

* Add 'full' set of xsl stylesheets and functions
* vc_ISBNs
* vc_authorship
* vc_covers
* vc_jointcorps
* vc_jointpersons
* vc_names
* vc_sources
* vc_summary
* vc_titles
* vc_viaflinks

# viafr 0.4.0

* Add initial xml-based summary xsl stylesheet and functionality

# viafr 0.3.0

* Fix bug in `viaf_suggest()` if there are no source identifiers
* Skip tests if on CRAN or [VIAF](https://www.viaf.org/) is offline
* Fail gracefully if request failed with status code other than 200


# viafr 0.2.0

* Fix problems with upgrade of package `tibble` to version 3.0.0


# viafr 0.1.0

* Develop basic functionality (`viaf_get()`, `viaf_search()`, and `viaf_suggest()`)
* Implement unit testing with Travis and AppVeyor as well as Code Coverage tracking
* Add VIAF data sets (`authorities` and `name_types`)
* Add `NEWS.md` file to track changes to the package
* Add `LICENSE.md` and `CODE_OF_CONDUCT.md`
