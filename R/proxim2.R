#' @useDynLib proximity2
#' @importFrom Rcpp sourceCpp


library(sp)

# read

# 1030 x 810 cells
# sp_grid_df <- sp::read.asciigrid("data/lachish_5m_pid1.txt")

# 1644 x 1381 cells
sp_grid_df <- sp::read.asciigrid("data/lachish_20m.txt")
plot(sp_grid_df)

mat1 <- matrix(sp_grid_df@data[[1]],
               nrow = sp_grid_df@grid@cells.dim[1],
               ncol = sp_grid_df@grid@cells.dim[2])

dim(mat1)

#mat2 <- mat1[1:500, 1:500]
#rm(mat1)
#gc()

# n_frag <- length(table(mat1))
#
# system.time(test <- calc_prox2(mat1, alpha = 20, cell_size = sp_grid_df@grid@cellsize[1], n_frag = n_frag))
# str(test)

# Test with my lachish data set and calc_prox2: 3202 seconds

system.time(test <- calc_prox(mat1, alpha = 100, cell_size = sp_grid_df@grid@cellsize[1]))
str(test)

# Test with my lachish data set and calc_prox: 3625 seconds

# Test with Sichongs larger Lachish data set and calc_prox: 12340 seconds: 3.4 h
# Test with Sichongs 10 m x 10 m Lachish data set and calc_prox: 1087 seconds
# Test with Sichongs 20 m x 20 m Lachish data set and calc_prox: 76 seconds
write.table(test,"Lachish_connectivity_20m.txt",row.names=F, col.names=T, sep = "\t")

testhead(test)
hist(log(test$area_ha))
hist(log(test$connectivity))
plot(connectivity ~ area_ha, data = test)
plot(connectivity ~ area_ha, data = test, log = "xy")
