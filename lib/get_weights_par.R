#' weights based on intersection area of two `sf` polygon at different resolution
#' @description obtain area-weights that add up to 1 in each polygon of x_poly_sf. Weights correspond to intersection with y_poly_sf. 
#' 
#' @param x_poly_sf object of `sf`class, with corresponding geometry class `sfc_POLYGON`, `sfc_MULTIPOLYGON`, `sfc_GEOMETRY`.
#' @param y_poly_sf object of `sf`class, with corresponding geometry class `sfc_POLYGON`, `sfc_MULTIPOLYGON`, `sfc_GEOMETRY`.
#' @param y_id name of variable in `y_poly_sf` that contains the polygon IDs.
#' @param x_id name of variable in `x_poly_sf` that contains the polygon IDs.
#'
#' @return A `data.frame` containing a polygon ID in `x_poly_sf`, a polygon ID in `y_poly_sf` and an associated weight which is obtained based on their intersection area.
#' 
#' 


get_weights_par = function(x_poly_sf, 
                           y_poly_sf,
                           x_id,
                           y_id,
                           cores){
  
  ## crop polygons within same bounding box ---- 
  x_poly_sf <- st_make_valid(x_poly_sf)
  x_poly_sf <- st_crop(x_poly_sf, st_bbox(y_poly_sf))
  
  # assign 1s to zipcode polygons ----
  x_poly_sf$w <- 1
  
  ## run aggregations ----
  w_list = mclapply(x_poly_sf[[x_id]], function(i) {
    
    x_i_sf <- dplyr::select(x_poly_sf[x_poly_sf[[x_id]] == i, ], c("w", "geometry"))
    y_i_sf <- dplyr::select(st_crop(y_poly_sf, extent(x_i_sf)), c(y_id, "geometry"))
    
    y_i_w <- st_drop_geometry(st_interpolate_aw(x_i_sf, y_i_sf, extensive = T))
    
    x_to_y_i <- data.frame(
      x_id = i, 
      y_id = y_i_sf[[y_id]][as.numeric(rownames(y_i_w))],
      w = y_i_w$w)
    
    return(x_to_y_i)
    
  }, mc.cores = cores)
  
  x_to_y <- bind_rows(w_list)
  colnames(x_to_y) <- c(x_id, y_id, "w")
  
  return(x_to_y)
}