#' @useDynLib shapeconnect
#' @importFrom Rcpp sourceCpp
NULL

#' Calculate connectivity index
#'
#' Calculate a connectivity index from a binary habitat raster, which considers
#' the distances among among the fragments, as well as the fragment areas
#' and shapes (May et al. 2013).
#'
#' @param lsc Landscape raster with habitat and matrix cells. Habitat cells are
#' marked by integer number and matrix cells by NA values. The habitat values
#' are considered as fragment identities, i.e. each contagious fragments
#' should be labelled with a unique ID number. The lsc argument
#' can be either a integer matrix of a \code{\link[sp]{SpatialGridDataFrame}}
#'
#' @param alpha Parameter that specifies the decay of connectivity with distance.
# Can be interpreted as mean dispersal distance of the focal species (May et al. 2013)
#'
#' @param cell_size Cell size of the input raster (side length in meter)
#'
#' @return Dataframe with three columns
#'
#' @export
#'
#' @examples
#' library(sp)
#' lsc_raster <- read.asciigrid(system.file("extdata", "lachish_20m.txt", package = "shapeconnect"))
#' plot(lsc_raster)
#' connect_dat <- get_connect(lsc_raster, alpha = 50, cell_size = 10)
#'
#' @references May et al. (2013). Metacommunity, mainland-island system or
#' island communities? - Assessing the regional dynamics of plant communities
#' in a fragmented landscape. Ecography, 36, 842–853.
#'
get_connect <- function(lsc, alpha, cell_size)
{
  if (!any(class(lsc) %in% c("matrix", "SpatialGridDataFrame")))
    stop("lsc needs to be of class matrix or SpatialGridDataFrame")

  if (any(class(lsc) == "SpatialGridDataFrame"))
    mat1 <- matrix(lsc@data[[1]],
                   nrow = lsc@grid@cells.dim[1],
                   ncol = lsc@grid@cells.dim[2])

  if (any(class(lsc) == "matrix"))
    mat1 <- lsc

  connect_dat <- calc_connect(mat1, alpha = alpha, cell_size = cell_size)

  return(connect_dat)
}


