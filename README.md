
<!-- README.md is generated from README.Rmd. Please edit that file -->
shapeconnect
============

The goal of shapeconnect is to calculate the connectivity index described in [May et al. 2013a](http://onlinelibrary.wiley.com/doi/10.1111/j.1600-0587.2012.07793.x/full).

As input the calculation requires a landscape raster with a unique ID for every habitat fragment. The strength of the index is that it considers fragment distance, shapes and areas. Therefore, it is well suited for landscapes with irregular fragment shapes.

See Equations 5 and 6 in May et al. 2013a for a definition of the index and see [May et al. 2013b](http://www.sciencedirect.com/science/article/pii/S1433831913000590) for another application example.

Installation
------------

You can install shapeconnect from github with:

``` r
# install.packages("devtools")
devtools::install_github("FelixMay/shapeconnect")
```

Example
-------

Here is an example for the calculation of the index

``` r
library(sp)
library(shapeconnect)
lsc_raster <- read.asciigrid(system.file("extdata", "lachish_20m.txt", package = "shapeconnect"))
connect_dat <- get_connect(lsc_raster, alpha = 50, cell_size = 10)
head(connect_dat)
#>   fragment_id area_ha connectivity
#> 1           0  104.00   54241.6665
#> 2           1    1.17     609.7545
#> 3           2    1.13     824.0707
#> 4           3    2.77    1000.5674
#> 5           6    3.64    2158.7270
#> 6           8    8.58    8828.9596
```

References
----------

May, F., Giladi, I., Ristow, M., Ziv, Y. & Jeltsch, F. (2013a). Metacommunity, mainland-island system or island communities? - Assessing the regional dynamics of plant communities in a fragmented landscape. Ecography, 36, 842–853.

May, F., Giladi, I., Ristow, M., Ziv, Y. & Jeltsch, F. (2013b). Plant functional traits and community assembly along interacting gradients of productivity and fragmentation. Perspectives in Plant Ecology, Evolution and Systematics, 15, 304–318.
