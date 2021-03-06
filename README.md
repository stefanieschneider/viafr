
<!-- README.md is generated from README.Rmd. Please edit that file -->

# viafr <img src="man/figures/logo.png" align="right" width="120" />

[![Lifecycle
badge](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3265046.svg)](https://doi.org/10.5281/zenodo.3265046)
[![CRAN
badge](http://www.r-pkg.org/badges/version/viafr)](https://cran.r-project.org/package=viafr)
[![Travis CI build
status](https://travis-ci.org/stefanieschneider/viafr.svg?branch=master)](https://travis-ci.org/stefanieschneider/viafr)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/stefanieschneider/viafr?branch=master&svg=true)](https://ci.appveyor.com/project/stefanieschneider/viafr)
[![Coverage
status](http://codecov.io/github/stefanieschneider/viafr/coverage.svg?branch=master)](http://codecov.io/github/stefanieschneider/viafr?branch=master)

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
please see
<https://www.oclc.org/developer/develop/web-services/viaf/authority-cluster.en.html>.

`viaf_get()` returns a tibble, where each row contains information about
the respective VIAF identifier, whereas `viaf_search()` and
`viaf_suggest()` each produce a named list of tibbles, with each tibble
containing information about the respective search query. The MARC 21
field definitions are used, see, e.g.,
<https://www.loc.gov/marc/bibliographic/>.

### Get Data for VIAF Identifier(s)

``` r
(result_get <- viaf_get("15873"))
#> # A tibble: 1 x 4
#>   viaf_id source_ids        name_type      text               
#>   <chr>   <list>            <chr>          <list>             
#> 1 15873   <tibble [43 x 3]> Personal Names <tibble [257 x 15]>

# Retrieve a tibble of all source identifiers
(source_ids <- dplyr::pull(result_get, source_ids) %>% purrr::pluck(1))
#> # A tibble: 43 x 3
#>    id              scheme name                                                 
#>    <chr>           <chr>  <chr>                                                
#>  1 vtls002657273   EGAXA  Library of Alexandria                                
#>  2 9658            PTBNP  National Library of Portugal                         
#>  3 a10443824       BNC    National Library of Catalonia                        
#>  4 jn19990006541   NKC    National Library of the Czech Republic               
#>  5 LNC10-000029604 LNB    National Library of Latvia                           
#>  6 500009666       JPG    Union List of Artist Names [Getty Research Institute]
#>  7 a11549853       ERRR   National Library of Estonia                          
#>  8 XX1637941       BNE    National Library of Spain                            
#>  9 00452768        NDL    National Diet Library                                
#> 10 000035422161    NLA    National Library of Australia                        
#> # ... with 33 more rows

# Retrieve a tibble of data from all sources
(text <- dplyr::pull(result_get, text) %>% purrr::pluck(1))
#> # A tibble: 257 x 15
#>       id count a            b     c     d      e     f     g     q     `4`   `5`   `7`   `8`   `9`  
#>    <int> <int> <chr>        <chr> <chr> <chr>  <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr>
#>  1     1    23 Picasso, Pa~ <NA>  <NA>  1881-~ <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#>  2     1     6 Picasso, Pa~ <NA>  <NA>  <NA>   <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#>  3     1     4 Ruiz y Pica~ <NA>  <NA>  1881-~ <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#>  4     1     4 Picasso      <NA>  <NA>  1881-~ <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#>  5     1     3 Picasso Rui~ <NA>  <NA>  1881-~ <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#>  6     1     3 Bijiasuo     <NA>  <NA>  1881-~ <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#>  7     1     3 Picasso      <NA>  <NA>  <NA>   <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#>  8     1     3 Picasso, Pa~ <NA>  <NA>  1881-~ <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#>  9     1     3 Ruiz Picass~ <NA>  <NA>  1881-~ <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#> 10     1     3 Ruiz, Pablo  <NA>  <NA>  1881-~ <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
#> # ... with 247 more rows

# Aggregate name variants and show dominant ones 
# (subfield code `a` declares personal names)
dplyr::mutate(text, name_variant = a) %>% dplyr::group_by(name_variant) %>% 
  dplyr::summarise(count = sum(count)) %>% dplyr::filter(count > 9)
#> # A tibble: 3 x 2
#>   name_variant   count
#>   <chr>          <int>
#> 1 Pablo Picasso     36
#> 2 Picasso           20
#> 3 Picasso, Pablo    34
```

### Search VIAF records

``` r
(result_search <- viaf_search("Menzel", maximumRecords = 5))
#> $Menzel
#> # A tibble: 5 x 4
#>   viaf_id                source_ids       name_type                 text            
#>   <chr>                  <list>           <chr>                     <named list>    
#> 1 9958151474888800490000 <tibble [1 x 3]> Uniform Title Expressions <tibble [2 x 8]>
#> 2 9951148269716905230007 <tibble [1 x 3]> Uniform Title Expressions <tibble [2 x 8]>
#> 3 9882160668064003560006 <tibble [1 x 3]> Personal Names            <tibble [2 x 3]>
#> 4 9864149198241274940009 <tibble [2 x 3]> Personal Names            <tibble [1 x 3]>
#> 5 9738151247971644270003 <tibble [1 x 3]> Personal Names            <tibble [1 x 3]>

# Retrieve a tibble of all source identifiers
(source_ids <- dplyr::pull(result_search$`Menzel`, source_ids))
#> [[1]]
#> # A tibble: 1 x 3
#>   id                scheme name                     
#>   <chr>             <chr>  <chr>                    
#> 1 VIAFEXP1010942752 XR     xR Extended Relationships
#> 
#> [[2]]
#> # A tibble: 1 x 3
#>   id              scheme name                     
#>   <chr>           <chr>  <chr>                    
#> 1 VIAFEXP83155351 XR     xR Extended Relationships
#> 
#> [[3]]
#> # A tibble: 1 x 3
#>   id               scheme name 
#>   <chr>            <chr>  <chr>
#> 1 0000000021405403 ISNI   ISNI 
#> 
#> [[4]]
#> # A tibble: 2 x 3
#>   id        scheme name                   
#>   <chr>     <chr>  <chr>                  
#> 1 172842131 DNB    German National Library
#> 2 90818949  BIBSYS BIBSYS                 
#> 
#> [[5]]
#> # A tibble: 1 x 3
#>   id         scheme name                   
#>   <chr>      <chr>  <chr>                  
#> 1 1146425104 DNB    German National Library

# Retrieve a tibble of data for the second search result
(text <- dplyr::pull(result_search$`Menzel`, text) %>% purrr::pluck(2))
#> # A tibble: 2 x 8
#>      id count a                   f     l      s            t                            `0`        
#>   <int> <int> <chr>               <chr> <chr>  <chr>        <chr>                        <chr>      
#> 1     1     1 Mueller-Brockman, ~ 1961  German "Menzel-Flo~ GRAPHIC ARTIST AND HIS DESI~ (viaf)3445~
#> 2     1     1 Mueller-Brockman, ~ 1961  <NA>   "Menzel-Flo~ Gestaltungsprobleme des Gra~ <NA>
```

### Suggest VIAF records

``` r
(result_suggest <- viaf_suggest("austen"))
#> $austen
#> # A tibble: 10 x 5
#>    viaf_id               source_ids        name_type     text                                  score
#>    <chr>                 <list>            <chr>         <chr>                                 <chr>
#>  1 102333412             <tibble [12 x 3]> Personal Nam~ Austen, Jane, 1775-1817               16705
#>  2 9943394               <tibble [8 x 3]>  Personal Nam~ Austen Henry Layard, 1817-1894        5688 
#>  3 66482160              <tibble [7 x 3]>  Personal Nam~ Austen Chamberlain, 1863-1937         4263 
#>  4 49253679              <tibble [9 x 3]>  Personal Nam~ Austen, J. L., 1911-1960              3656 
#>  5 76472664              <tibble [6 x 3]>  Personal Nam~ Austen-Leigh, James Edward, 1798-1874 2704 
#>  6 351144783162295221357 <tibble [5 x 3]>  Personal Nam~ Austen Ivereigh                       2365 
#>  7 3256795               <tibble [4 x 3]>  Personal Nam~ Austen, E. E. , 1867-1938             2326 
#>  8 64067073              <tibble [6 x 3]>  Personal Nam~ Austen, K. Frank                      2180 
#>  9 69175936              <tibble [7 x 3]>  Personal Nam~ Austen, John, 1886-1948               2086 
#> 10 7436310               <tibble [5 x 3]>  Personal Nam~ Austen-Leigh, Richard Arthur, 1872-1~ 1760

# Retrieve source identifiers for the most relevant search result
dplyr::filter(result_suggest$`austen`, score > 10000) %>%
  dplyr::pull(source_ids) %>% purrr::pluck(1)
#> # A tibble: 12 x 3
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
#>  9 vtls000823272 EGAXA  Library of Alexandria                                             
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
