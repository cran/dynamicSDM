#' extract_xy_min_max Extracts xmin,xmax,ymin,ymax from spatial extent object
#' @param x spatial extent object.
#'   listing xmin, xmax, ymin and ymax in order.
#' @noRd

extract_xy_min_max <- function(x) {

  if ("numeric" %in% class(x) && length(x) == 4) {
    xmin <- x[1]
    xmax <- x[2]
    ymin <- x[3]
    ymax <- x[4]
  }

  ### Extent object to co-ords

  if ("Extent" %in% class(x)) {
    x <- terra::ext(x)
    xmin <-  x[1]
    xmax <-  x[2]
    ymin <-  x[3]
    ymax <-  x[4]
  }


  ### RasterLayer object to co-ords

  if ("RasterLayer" %in% class(x)) {
    x <- terra::rast(x)
    xmin <-  terra::ext(x)[1]
    xmax <-  terra::ext(x)[2]
    ymin <-  terra::ext(x)[3]
    ymax <-  terra::ext(x)[4]

  }


  ### Polygon object to co-ords

  if ("Polygon" %in% class(x)) {
    stop("Please provide sf polygon.")
  }

  if ("POLYGON" %in% class(x)) {
    xmin <- as.numeric(sf::st_bbox(x)[1])
    xmax <- as.numeric(sf::st_bbox(x)[3])
    ymin <- as.numeric(sf::st_bbox(x)[2])
    ymax <- as.numeric(sf::st_bbox(x)[4])
  }

  if ("sf" %in% class(x)) {
    xmin <- as.numeric(sf::st_bbox(x)[1])
    xmax <- as.numeric(sf::st_bbox(x)[3])
    ymin <- as.numeric(sf::st_bbox(x)[2])
    ymax <- as.numeric(sf::st_bbox(x)[4])
  }


  if ("SpatialPolygonsDataFrame" %in% class(x)) {
    stop("Please provide spatial object as an sf polygon or terra extent/r")
  }


  if ("SpatRaster" %in% class(x)) {
    xmin <-  terra::ext(x)[1]
    xmax <-  terra::ext(x)[2]
    ymin <-  terra::ext(x)[3]
    ymax <-  terra::ext(x)[4]

  }


  if ("SpatExtent" %in% class(x)) {
    xmin <-  x[1]
    xmax <-  x[2]
    ymin <-  x[3]
    ymax <-  x[4]

  }

  if ("SpatVector" %in% class(x)) {
    xmin <-  terra::ext(x)[1]
    xmax <-  terra::ext(x)[2]
    ymin <-  terra::ext(x)[3]
    ymax <-  terra::ext(x)[4]

  }

  if ("sfc_POLYGON" %in% class(x)) {
    xmin <- as.numeric(sf::st_bbox(x)[1])
    xmax <- as.numeric(sf::st_bbox(x)[3])
    ymin <- as.numeric(sf::st_bbox(x)[2])
    ymax <- as.numeric(sf::st_bbox(x)[4])
  }

  if ("sfc_MULTIPOLYGON" %in% class(x)) {
    xmin <- as.numeric(sf::st_bbox(x)[1])
    xmax <- as.numeric(sf::st_bbox(x)[3])
    ymin <- as.numeric(sf::st_bbox(x)[2])
    ymax <- as.numeric(sf::st_bbox(x)[4])
  }


  return(c(xmin, xmax, ymin, ymax))
}




#' convert_to_sf Converts spatial object to an sf object
#' @param x spatial object. Object of class "Extent", "raster","SpatialPolygonsDataFrame", "sf" or
#'   "polygon" or numeric vector listing xmin, xmax, ymin and ymax in order.
#' @param prj a character string or object of class crs (package 'sp'), the coordinate reference
#'   system of occ.data co-ordinates. Default is "+proj=longlat +datum=WGS84" used by GBIF.
#' @noRd
convert_to_sf <- function(x,prj) {



  if ("SpatRaster" %in% class(x)) {
    terra::crs(x) <- prj
    spatial.ext <- terra::as.polygons(x)
    spatial.ext <- sf::st_as_sf(spatial.ext)
    spatial.ext <-  sf::st_transform(spatial.ext, 7801)
    spatial.ext <- sf::st_union(spatial.ext)
    spatial.ext <-  sf::st_transform(spatial.ext, prj)
  }

  if ("numeric" %in% class(x) && length(x) == 4) {
    raster<-terra::rast(terra::ext(x[1],x[2],x[3],x[4]),crs=prj)
    spatial.ext <- terra::as.polygons(raster)
    spatial.ext<-sf::st_as_sf(spatial.ext,CRS = sf::st_crs(prj))
  }

  ### Extent object to co-ords
  if ("Extent" %in% class(x)) {
    raster <- terra::rast(terra::ext(x), crs = prj)
    spatial.ext <- terra::as.polygons(raster)
    spatial.ext <- sf::st_as_sf(spatial.ext, CRS = sf::st_crs(prj))
  }



  if ("SpatExtent" %in% class(x)) {
    raster <- terra::rast(terra::ext(x), crs = prj)
    spatial.ext <- terra::as.polygons(raster)
    spatial.ext <- sf::st_as_sf(spatial.ext, CRS = sf::st_crs(prj))

  }


  ### RasterLayer object to co-ords

  if ("RasterLayer" %in% class(x)) {
    raster <- terra::rast(x, crs = prj)
    terra::crs(raster) <- prj
    spatial.ext <- terra::as.polygons(raster)
    spatial.ext <- sf::st_as_sf(spatial.ext)
    spatial.ext <-  sf::st_transform(spatial.ext, 7801)
    spatial.ext <- sf::st_union(spatial.ext)
    spatial.ext <-  sf::st_transform(spatial.ext, prj)
  }

  ### Polygon object to co-ords

  if ("Polygon" %in% class(x)) {
    stop("Please provide sf polygon")
  }

  if ("sf" %in% class(x)) {

    x <- sf::st_set_crs(x, prj)

    return(x)
  }

  if ("POLYGON" %in% class(x)) {
    polygon <- x %>%
      sf::st_sfc(crs = prj)
    x <- sf::st_set_crs(polygon, prj)
    return(x)
  }


  if ("sfc_POLYGON" %in% class(x)) {
    x <- sf::st_set_crs(x, prj)
    return(x)
  }


  if ("sfc_MULTIPOLYGON" %in% class(x)) {
    x <- sf::st_set_crs(x, prj)
    return(x)
  }

  if ("SpatialPolygonsDataFrame" %in% class(x)) {
    spatial.ext <- sf::st_as_sf(x)

  }



  return(spatial.ext)
}


#' sf_buffer Calculate spatial buffer around coords using sf package
#' @param x data frame, with columns x and y representing co-ordinates to buffer
#' @param buff distance in metres to buffer by
#' @param prj a character string or object of class crs (package 'sp'), the coordinate reference
#'   system of occ.data co-ordinates. Default is "+proj=longlat +datum=WGS84" used by GBIF.
#' @noRd

sf_buffer <- function(x, buff,prj) {
  # make sf coordinate object in original crs
  x <- sf::st_as_sf(x, coords = c("x", "y"), crs = prj)

  # Transform to crs that works for st_transform and is in metres
  x <- sf::st_transform(x, 7801)

  # Buffer the co-ordinates by the given distance

  x <- sf::st_buffer(x, dist = buff)
  return(x)

}
