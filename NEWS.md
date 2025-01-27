# viafr 0.3.2

* Change error handling for server errors


# viafr 0.3.1

* Split given name and family name in DESCRIPTION
* Use of `.data` in tidyselect expressions was deprecated in version 1.2.0


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
