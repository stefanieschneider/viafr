
<!-- README.md is generated from README.Rmd. Please edit that file -->
viafr <img src="man/figures/logo.png" align="right" width="120" />
==================================================================

[![Build status](https://travis-ci.org/stefanieschneider/viafr.svg?branch=master)](https://travis-ci.org/stefanieschneider/viafr) <!-- [![Coverage status](http://codecov.io/github/stefanieschneider/viafr/coverage.svg?branch=master)](http://codecov.io/github/stefanieschneider/viafr?branch=master) --> <!-- [![CRAN badge](http://www.r-pkg.org/badges/version/viafr)](https://cran.r-project.org/package=viafr) --> [![CRAN checks](https://cranchecks.info/badges/worst/viafr)](https://cran.r-project.org/web/checks/check_results_viafr.html)

Overview
--------

This R package uses the VIAF (Virtual International Authority File) API. VIAF is an OCLC service that combines multiple LAM (Library, Archive, and Museum) name authority files into a single name authority service. It thus provides direct access to linked names for the same entity across the world's major name authority files, including national and regional variations in language, character set, and spelling. For more information go to <http://viaf.org/>.

Installation
------------

<!-- You can install the released version of viafr from [CRAN](https://CRAN.R-project.org) with: -->
<!-- ``` r -->
<!-- install.packages("viafr") -->
<!-- ``` -->
To install the development version from [GitHub](https://github.com/stefanieschneider/viafr) use:

``` r
# install.packages("devtools")
devtools::install_github("stefanieschneider/viafr")
```

Usage
-----

The viafr package functions use the VIAF (Virtual International Authority File) API. Optional VIAF API query parameters can be passed into each function. For information on supported query parameters, please see <https://www.oclc.org/developer/develop/web-services/viaf/authority-cluster.en.html>.

`viaf_get()` returns a tibble, where each row contains information about the respective VIAF identifier, whereas `viaf_search()` and `viaf_suggest()` each produce a named list of tibbles, with each tibble containing information about the respective search query. The MARC 21 field definitions are used.

``` r
library(viafr)

(result <- viaf_get("15873"))
#> # A tibble: 1 x 4
#>   viaf_id source_ids        name_type      text              
#>   <chr>   <list>            <chr>          <list>            
#> 1 15873   <tibble [43 x 3]> Personal Names <tibble [309 x 7]>

result$source_ids[1]
#> [[1]]
#> # A tibble: 43 x 3
#>    id              scheme name                                             
#>    <chr>           <chr>  <chr>                                            
#>  1 vtls000130420   RERO   RERO - Library Network of Western Switzerland    
#>  2 vtls002657273   EGAXA  Library of Alexandria                            
#>  3 9658            PTBNP  National Library of Portugal                     
#>  4 a10443824       BNC    National Library of Catalonia                    
#>  5 jn19990006541   NKC    National Library of the Czech Republic           
#>  6 LNC10-000029604 LNB    National Library of Latvia                       
#>  7 500009666       JPG    Union List of Artist Names [Getty Research Insti~
#>  8 a11549853       ERRR   National Library of Estonia                      
#>  9 XX1637941       BNE    National Library of Spain                        
#> 10 00452768        NDL    National Diet Library                            
#> # ... with 33 more rows

result$text[1]
#> [[1]]
#> # A tibble: 309 x 7
#> # Groups:   id [309]
#>       id a                      b     d        e     f                `4`  
#>    <int> <chr>                  <chr> <chr>    <chr> <chr>            <chr>
#>  1     1 Pablo Picasso          <NA>  <NA>     <NA>  <NA>             <NA> 
#>  2     2 Picasso Ruiz, Pablo    <NA>  1881-19~ <NA>  <NA>             <NA> 
#>  3     3 Picasso Ruiz, Pablo    <NA>  1881-19~ <NA>  <NA>             <NA> 
#>  4     4 Picasso Ruiz, Pablo, ~ Pablo 1881-19~ <NA>  1881-1973        <NA> 
#>  5     5 Picasso Ruiz, Pablo, ~ Pablo 1881-19~ <NA>  1881-1973, 1881~ <NA> 
#>  6     6 Pablo Picasso          <NA>  <NA>     <NA>  <NA>             <NA> 
#>  7     7 Pablo Picasso          <NA>  <NA>     <NA>  <NA>             <NA> 
#>  8     8 Pablo Picasso          <NA>  <NA>     <NA>  <NA>             <NA> 
#>  9     9 Pablo Picasso          <NA>  <NA>     <NA>  <NA>             <NA> 
#> 10    10 Picasso Ruiz, Pablo    <NA>  1881-19~ <NA>  <NA>             <NA> 
#> # ... with 299 more rows

(result <- viaf_search("Menzel", maximumRecords = 5))
#> $Menzel
#> # A tibble: 5 x 4
#>   viaf_id              source_ids      name_type              text         
#>   <chr>                <list>          <chr>                  <list>       
#> 1 9958151474888800490~ <tibble [1 x 3~ Uniform Title Express~ <tibble [2 x~
#> 2 9951148269716905230~ <tibble [1 x 3~ Uniform Title Express~ <tibble [2 x~
#> 3 9864149198241274940~ <tibble [2 x 3~ Personal Names         <tibble [1 x~
#> 4 9771155286606387180~ <tibble [1 x 3~ Personal Names         <tibble [1 x~
#> 5 9738151247971644270~ <tibble [1 x 3~ Personal Names         <tibble [1 x~

result$`Menzel`$source_ids
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
#> # A tibble: 2 x 3
#>   id        scheme name                   
#>   <chr>     <chr>  <chr>                  
#> 1 172842131 DNB    German National Library
#> 2 90818949  BIBSYS BIBSYS                 
#> 
#> [[4]]
#> # A tibble: 1 x 3
#>   id            scheme name                                         
#>   <chr>         <chr>  <chr>                                        
#> 1 vtls027534815 RERO   RERO - Library Network of Western Switzerland
#> 
#> [[5]]
#> # A tibble: 1 x 3
#>   id         scheme name                   
#>   <chr>      <chr>  <chr>                  
#> 1 1146425104 DNB    German National Library

result$`Menzel`$text
#> [[1]]
#> # A tibble: 2 x 7
#> # Groups:   id [2]
#>      id a         f     l      s            t                      `0`     
#>   <int> <chr>     <chr> <chr>  <chr>        <chr>                  <chr>   
#> 1     1 Busch, W~ 2017) Engli~ (Kleinstück~ Adolph Menzel : auf d~ (viaf)1~
#> 2     2 Busch, W~ 2017) <NA>   (Kleinstück~ Adolph Menzel : the q~ <NA>    
#> 
#> [[2]]
#> # A tibble: 2 x 8
#> # Groups:   id [2]
#>      id a          d      f     l     s       t                     `0`    
#>   <int> <chr>      <chr>  <chr> <chr> <chr>   <chr>                 <chr>  
#> 1     1 Muller-Br~ 1914-. 1961) Germ~ (Menze~ Graphic artist and h~ (viaf)~
#> 2     2 Muller-Br~ 1914-. 1961) <NA>  (Menze~ Gestaltungsprobleme ~ <NA>   
#> 
#> [[3]]
#> # A tibble: 1 x 2
#> # Groups:   id [1]
#>      id a                             
#>   <int> <chr>                         
#> 1     1 Menzel, Eckard, Menzel, Eckard
#> 
#> [[4]]
#> # A tibble: 1 x 2
#> # Groups:   id [1]
#>      id a            
#>   <int> <chr>        
#> 1     1 Menzel, Adolf
#> 
#> [[5]]
#> # A tibble: 1 x 2
#> # Groups:   id [1]
#>      id a                
#>   <int> <chr>            
#> 1     1 Menzel, Max-Peter

(result <- viaf_suggest("austen"))
#> $austen
#> # A tibble: 10 x 5
#>    viaf_id         source_ids     name_type    text                   score
#>    <chr>           <list>         <chr>        <chr>                  <chr>
#>  1 102333412       <tibble [12 x~ Personal Na~ Austen, Jane, 1775-18~ 14930
#>  2 9943394         <tibble [8 x ~ Personal Na~ Austen Henry Layard, ~ 4914 
#>  3 66482160        <tibble [7 x ~ Personal Na~ Austen Chamberlain, 1~ 3808 
#>  4 49253679        <tibble [9 x ~ Personal Na~ Austen, J. L., 1911-1~ 3443 
#>  5 76472664        <tibble [6 x ~ Personal Na~ Austen-Leigh, James E~ 2638 
#>  6 3256795         <tibble [4 x ~ Personal Na~ Austen, Ernest Edward~ 2024 
#>  7 22268931        <tibble [4 x ~ Personal Na~ Austen, Ralph A        1886 
#>  8 64067073        <tibble [5 x ~ Personal Na~ Austen, K. Frank       1803 
#>  9 69175936        <tibble [5 x ~ Personal Na~ Austen, John 1886-1948 1747 
#> 10 35114478316229~ <tibble [3 x ~ Personal Na~ Austen Ivereigh        1739

result$`austen`$source_ids
#> [[1]]
#> # A tibble: 12 x 3
#>    id           scheme name                                                
#>    <chr>        <chr>  <chr>                                               
#>  1 n79032879    LC     Library of Congress/NACO                            
#>  2 118505173    DNB    German National Library                             
#>  3 207420       SELIBR National Library of Sweden                          
#>  4 adv10179859  BAV    Vatican Library                                     
#>  5 11889603     BNF    National Library of France                          
#>  6 500249665    JPG    Union List of Artist Names [Getty Research Institut~
#>  7 cfiv017136   ICCU   Central Institute for the Union Catalogue of the It~
#>  8 xx1124986    BNE    National Library of Spain                           
#>  9 vtls0008232~ EGAXA  Library of Alexandria                               
#> 10 jn199900003~ NKC    National Library of the Czech Republic              
#> 11 000035010277 NLA    National Library of Australia                       
#> 12 8531         PTBNP  National Library of Portugal                        
#> 
#> [[2]]
#> # A tibble: 8 x 3
#>   id            scheme name                                                
#>   <chr>         <chr>  <chr>                                               
#> 1 n50039774     LC     Library of Congress/NACO                            
#> 2 118570390     DNB    German National Library                             
#> 3 adv10037622   BAV    Vatican Library                                     
#> 4 12451525      BNF    National Library of France                          
#> 5 500218501     JPG    Union List of Artist Names [Getty Research Institut~
#> 6 xx1339265     BNE    National Library of Spain                           
#> 7 mzk2008443174 NKC    National Library of the Czech Republic              
#> 8 000035294862  NLA    National Library of Australia                       
#> 
#> [[3]]
#> # A tibble: 7 x 3
#>   id           scheme name                         
#>   <chr>        <chr>  <chr>                        
#> 1 n85298947    LC     Library of Congress/NACO     
#> 2 118520016    DNB    German National Library      
#> 3 182795       SELIBR National Library of Sweden   
#> 4 adv11272813  BAV    Vatican Library              
#> 5 12029953     BNF    National Library of France   
#> 6 000036512271 NLA    National Library of Australia
#> 7 166169       PTBNP  National Library of Portugal 
#> 
#> [[4]]
#> # A tibble: 9 x 3
#>   id           scheme name                                                 
#>   <chr>        <chr>  <chr>                                                
#> 1 n79003370    LC     Library of Congress/NACO                             
#> 2 11850519x    DNB    German National Library                              
#> 3 281043       SELIBR National Library of Sweden                           
#> 4 adv10234870  BAV    Vatican Library                                      
#> 5 12097213     BNF    National Library of France                           
#> 6 cfiv023453   ICCU   Central Institute for the Union Catalogue of the Ita~
#> 7 xx952753     BNE    National Library of Spain                            
#> 8 mub20189918~ NKC    National Library of the Czech Republic               
#> 9 000035038828 NLA    National Library of Australia                        
#> 
#> [[5]]
#> # A tibble: 6 x 3
#>   id            scheme name                                  
#>   <chr>         <chr>  <chr>                                 
#> 1 no97053860    LC     Library of Congress/NACO              
#> 2 104160187     DNB    German National Library               
#> 3 13522218      BNF    National Library of France            
#> 4 jn19981000167 NKC    National Library of the Czech Republic
#> 5 000035894563  NLA    National Library of Australia         
#> 6 1555561       PTBNP  National Library of Portugal          
#> 
#> [[6]]
#> # A tibble: 4 x 3
#>   id           scheme name                         
#>   <chr>        <chr>  <chr>                        
#> 1 n87145596    LC     Library of Congress/NACO     
#> 2 117765201    DNB    German National Library      
#> 3 11298030     BNF    National Library of France   
#> 4 000035254191 NLA    National Library of Australia
#> 
#> [[7]]
#> # A tibble: 4 x 3
#>   id            scheme name                                  
#>   <chr>         <chr>  <chr>                                 
#> 1 n85372768     LC     Library of Congress/NACO              
#> 2 127117792     DNB    German National Library               
#> 3 12820708      BNF    National Library of France            
#> 4 vse2013750528 NKC    National Library of the Czech Republic
#> 
#> [[8]]
#> # A tibble: 5 x 3
#>   id            scheme name                                  
#>   <chr>         <chr>  <chr>                                 
#> 1 n50028875     LC     Library of Congress/NACO              
#> 2 1089118740    DNB    German National Library               
#> 3 174271        SELIBR National Library of Sweden            
#> 4 12278620      BNF    National Library of France            
#> 5 mub2013782281 NKC    National Library of the Czech Republic
#> 
#> [[9]]
#> # A tibble: 5 x 3
#>   id           scheme name                                                 
#>   <chr>        <chr>  <chr>                                                
#> 1 nr87000720   LC     Library of Congress/NACO                             
#> 2 129785989    DNB    German National Library                              
#> 3 14580677     BNF    National Library of France                           
#> 4 500139916    JPG    Union List of Artist Names [Getty Research Institute]
#> 5 000035840852 NLA    National Library of Australia                        
#> 
#> [[10]]
#> # A tibble: 3 x 3
#>   id        scheme name                                  
#>   <chr>     <chr>  <chr>                                 
#> 1 n94072554 LC     Library of Congress/NACO              
#> 2 15073646  BNF    National Library of France            
#> 3 xx0201499 NKC    National Library of the Czech Republic
```

<!-- ## Citation -->
<!-- To cite the viafr package, please use the citation provided at https://doi.org/10.5281/zenodo.xxx. -->
Contributing
------------

Please report issues, feature requests, and questions to the [GitHub issue tracker](https://github.com/stefanieschneider/viafr/issues). We have a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in viafr you agree to abide by its terms.
