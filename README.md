
<!-- README.md is generated from README.Rmd. Please edit that file -->

# viafr <img src="man/figures/logo.png" align="right" width="120" />

[![Lifecycle
badge](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html#maturing)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3265046.svg)](https://doi.org/10.5281/zenodo.3265046)
[![CRAN
badge](http://www.r-pkg.org/badges/version/viafr)](https://cran.r-project.org/package=viafr)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/stefanieschneider/viafr?branch=master&svg=true)](https://ci.appveyor.com/project/stefanieschneider/viafr)
[![Coverage
status](https://codecov.io/github/stefanieschneider/viafr/coverage.svg?branch=master)](https://codecov.io/github/stefanieschneider/viafr?branch=master)

## Overview

This R package uses the VIAF (Virtual International Authority File) API.
VIAF is an OCLC service that combines multiple LAM (Library, Archive,
and Museum) name authority files into a single name authority service.
It thus provides direct access to linked names for the same entity
across the world’s major name authority files, including national and
regional variations in language, character set, and spelling. For more
information go to <https://viaf.org/>.

## Installation

You can install the released version of viafr from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("viafr")
```

To install the development version from
[GitHub](https://github.com/stefanieschneider/viafr) use:

``` r
# install.packages("devtools")
devtools::install_github("stefanieschneider/viafr")
```

## Usage

The viafr package functions use the VIAF (Virtual International
Authority File) API. Optional VIAF API query parameters can be passed
into each function. For information on supported query parameters,
please see <https://www.oclc.org/developer/api/oclc-apis/viaf.en.html>.

`viaf_get()` returns a tibble, where each row contains information about
the respective VIAF identifier, whereas `viaf_search()` and
`viaf_suggest()` each produce a named list of tibbles, with each tibble
containing information about the respective search query. The MARC 21
field definitions are used, see, e.g.,
<https://www.loc.gov/marc/bibliographic/>.

### Search VIAF records

``` r
(result_search <- viaf_search("Menzel", maximumRecords = 5))
#> $Menzel
#> # A tibble: 5 × 4
#>   viaf_id                source_ids       name_type text            
#>   <chr>                  <list>           <chr>     <named list>    
#> 1 9958151474888800490000 <tibble [1 × 3]> name      <tibble [2 × 8]>
#> 2 9951148269716905230007 <tibble [1 × 3]> name      <tibble [2 × 8]>
#> 3 9924169262252109510006 <tibble [1 × 3]> name      <tibble [2 × 5]>
#> 4 9882160668064003560006 <tibble [1 × 3]> name      <tibble [1 × 3]>
#> 5 9864149198241274940009 <tibble [2 × 3]> name      <tibble [1 × 3]>

# Retrieve a tibble of all source identifiers
(source_ids <- dplyr::pull(result_search$`Menzel`, source_ids))
#> [[1]]
#> # A tibble: 1 × 3
#>   id                scheme name                     
#>   <chr>             <chr>  <chr>                    
#> 1 VIAFEXP1010942752 XR     xR Extended Relationships
#> 
#> [[2]]
#> # A tibble: 1 × 3
#>   id              scheme name                     
#>   <chr>           <chr>  <chr>                    
#> 1 VIAFEXP83155351 XR     xR Extended Relationships
#> 
#> [[3]]
#> # A tibble: 1 × 3
#>   id         scheme name                   
#>   <chr>      <chr>  <chr>                  
#> 1 1298941520 DNB    German National Library
#> 
#> [[4]]
#> # A tibble: 1 × 3
#>   id               scheme name 
#>   <chr>            <chr>  <chr>
#> 1 0000000021405403 ISNI   ISNI 
#> 
#> [[5]]
#> # A tibble: 2 × 3
#>   id        scheme name                   
#>   <chr>     <chr>  <chr>                  
#> 1 172842131 DNB    German National Library
#> 2 90818949  BIBSYS BIBSYS

# Retrieve a tibble of data for the second search result
(text <- dplyr::pull(result_search$`Menzel`, text) %>% purrr::pluck(2))
#> # A tibble: 2 × 8
#>      id count a     f     l     s     t     `0`  
#>   <int> <int> <chr> <chr> <chr> <chr> <chr> <chr>
#> 1     1     1 text  text  text  text  text  text 
#> 2     1     1 text  text  <NA>  text  text  <NA>
```

### Suggest VIAF records

``` r
(result_suggest <- viaf_suggest("austen"))
#> $austen
#> # A tibble: 10 × 5
#>    viaf_id               source_ids        name_type text                                  score
#>    <chr>                 <list>            <chr>     <chr>                                 <chr>
#>  1 102333412             <tibble [12 × 3]> name      Austen, Jane, 1775-1817               20942
#>  2 9943394               <tibble [9 × 3]>  name      Austen Henry Layard, 1817-1894        6083 
#>  3 66482160              <tibble [8 × 3]>  name      Austen Chamberlain, 1863-1937         4550 
#>  4 49253679              <tibble [10 × 3]> name      Austen, J. L., 1911-1960              3916 
#>  5 351144783162295221357 <tibble [5 × 3]>  name      Austen Ivereigh                       3303 
#>  6 76472664              <tibble [6 × 3]>  name      Austen-Leigh, James Edward, 1798-1874 2906 
#>  7 22268931              <tibble [4 × 3]>  name      Austen, Ralph A., 1937-               2600 
#>  8 69175936              <tibble [7 × 3]>  name      Austen, John                          2302 
#>  9 3256795               <tibble [4 × 3]>  name      Austen, Ernest Edward, 1867-1938      2298 
#> 10 64067073              <tibble [6 × 3]>  name      Austen, K. Frank                      2234

# Retrieve source identifiers for the most relevant search result
dplyr::filter(result_suggest$`austen`, score > 10000) %>%
  dplyr::pull(source_ids) %>% purrr::pluck(1)
#> # A tibble: 12 × 3
#>    id            scheme name                                                              
#>    <chr>         <chr>  <chr>                                                             
#>  1 n79032879     LC     Library of Congress/NACO                                          
#>  2 118505173     DNB    German National Library                                           
#>  3 207420        SELIBR National Library of Sweden                                        
#>  4 495_131061    BAV    Vatican Library                                                   
#>  5 11889603      BNF    National Library of France                                        
#>  6 500249665     JPG    Union List of Artist Names [Getty Research Institute]             
#>  7 cfiv017136    ICCU   Central Institute for the Union Catalogue of the Italian libraries
#>  8 xx1124986     BNE    National Library of Spain                                         
#>  9 vtls823272    EGAXA  Library of Alexandria                                             
#> 10 jn19990000321 NKC    National Library of the Czech Republic                            
#> 11 000035010277  NLA    National Library of Australia                                     
#> 12 8531          PTBNP  National Library of Portugal
```

## Contributing

Please report issues, feature requests, and questions to the [GitHub
issue tracker](https://github.com/stefanieschneider/viafr/issues). We
have a [Contributor Code of
Conduct](https://github.com/stefanieschneider/viafr/blob/master/CODE_OF_CONDUCT.md).
By participating in viafr you agree to abide by its terms.
