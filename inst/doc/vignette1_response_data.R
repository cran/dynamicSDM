## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----install package GitHub---------------------------------------------------
# devtools::install_github('r-a-dobson/dynamicSDM')

## ----install package CRAN-----------------------------------------------------
#install.packages("dynamicSDM")
library(dynamicSDM)
library(terra)

## ----check Google, eval=FALSE-------------------------------------------------
#  library(rgee)
#  #rgee::ee_install()
#  rgee::ee_check()
#  
#  library(googledrive)
#  #googledrive::drive_auth_configure()
#  googledrive::drive_user()

## ----create directory---------------------------------------------------------
project_directory <- file.path(file.path(tempdir(), "dynamicSDM_vignette"))
dir.create(project_directory)

## ----import occurrence--------------------------------------------------------
data("sample_occ_data")

## ----example-convert_gbif-----------------------------------------------------
sample_occ <- convert_gbif(sample_occ_data)

## ----example-spatiotemp_check-------------------------------------------------
sample_occ_filtered <- spatiotemp_check(occ.data = sample_occ,
                                               na.handle = "exclude",
                                               date.handle = "exclude",
                                               date.res = "day",
                                               coord.handle = "exclude",
                                               duplicate.handle = "exclude")
nrow(sample_occ_filtered)

## ----example-spatiotemp_check with Coordinate Cleaner,eval=F------------------
#  sample_occ_filtered <- spatiotemp_check(occ.data = sample_occ,
#                                          na.handle = "exclude",
#                                          date.handle = "exclude",
#                                          date.res = "day",
#                                          coord.handle = "exclude",
#                                          duplicate.handle = "exclude",
#                                          coordclean = TRUE,
#                                          coordclean.species = "quelea",
#                                          coordclean.handle = "exclude")

## ----example-spatiotemp_extent,fig.width=4, fig.height=4----------------------
data("sample_extent_data")

sample_occ_cropped <- spatiotemp_extent(occ.data = sample_occ_filtered,
                                               temporal.ext = c("2001-01-01", "2018-12-01"),
                                               spatial.ext = terra::ext(sample_extent_data),
                                               prj = "+proj=longlat +datum=WGS84 +no_defs")


## Lets plot the change
#terra::plot(sample_extent_data$geometry)
terra::plot(terra::vect(sample_occ_filtered[, c("x", "y")],
                        geom = c("x", "y"),
                        crs = "+proj=longlat +datum=WGS84 +no_defs"))

#terra::plot(sample_extent_data$geometry)
terra::plot(terra::vect(sample_occ_cropped[, c("x", "y")],
                        geom = c("x", "y"),
                        crs = "+proj=longlat +datum=WGS84 +no_defs"))

## ----example-spatiotemp_resolution--------------------------------------------
sample_occ_cropped<-spatiotemp_resolution(occ.data = sample_occ_cropped,
                                          spatial.res = 4,
                                          temporal.res = "day")

nrow(sample_occ_cropped) # Even more records have been removed!

## ----example-spatiotemp_bias simple-------------------------------------------
bias_results <- spatiotemp_bias(occ.data = sample_occ_cropped,
                                temporal.level = c("year"),
                                plot = FALSE,
                                spatial.method = "simple",
                                prj = "+proj=longlat +datum=WGS84")
bias_results

## ----example-spatiotemp_bias core---------------------------------------------
bias_results <- spatiotemp_bias(occ.data = sample_occ_cropped,
                                temporal.level = c("year"),
                                plot = FALSE,
                                spatial.method = "core",
                                prj = "+proj=longlat +datum=WGS84")
bias_results

## ----example-spatiotemp_thin,fig.width=4, fig.height=4------------------------
occ_thin <- spatiotemp_thin(occ.data = sample_occ_cropped,
                                   temporal.method = "day",
                                   temporal.dist = 30,
                                   spatial.split.degrees = 3,
                                   spatial.dist = 100000,
                                   iterations = 5)

# Plot the difference in spatial distribution after thinning
# Non-thinned
terra::plot(sample_extent_data$geometry)
terra::plot(terra::vect(sample_occ_cropped[, c("x", "y")],
                        geom = c("x", "y"),
                        crs = "+proj=longlat +datum=WGS84 +no_defs"),add=T)

# Thinned
terra::plot(sample_extent_data$geometry)
terra::plot(terra::vect(occ_thin[, c("x", "y")],
                        geom = c("x", "y"),
                        crs = "+proj=longlat +datum=WGS84 +no_defs"),add=T)

## ----example-spatiotemp_weights-----------------------------------------------
data("sample_events_data")
sample_occ_cropped <- spatiotemp_weights(occ.data = sample_occ_cropped,
                                       samp.events = sample_events_data,
                                       spatial.dist = 100000,
                                       temporal.dist = 30,
                                       prj = "+proj=longlat +datum=WGS84")

## ----example-spatiotemp_pseudoabs,fig.width=4, fig.height=4-------------------
# Pseudo-absences generated within spatial and temporal buffer
pseudo_abs_buff <- spatiotemp_pseudoabs(occ.data = sample_occ_cropped,
                                        spatial.method = "buffer",
                                        temporal.method = "buffer",
                                        spatial.ext = sample_extent_data,
                                        spatial.buffer = c(250000, 500000),
                                        temporal.buffer = c(42, 84),
                                        n.pseudoabs = nrow(sample_occ_cropped))

# Pseudo-absences generated randomly across given spatial and temporal extent
pseudo_abs_rand <- spatiotemp_pseudoabs(occ.data = sample_occ_cropped,
                                        spatial.method = "random",
                                        temporal.method = "random",  
                                        spatial.ext = sample_extent_data,
                                        temporal.ext = c("2002-01-01", "2019-12-01"),
                                        n.pseudoabs = nrow(sample_occ_cropped))

# Plot the spatial distribution of pseudo-absences (red) compared to occurrence records for:
# Buffered
terra::plot(sample_extent_data$geometry)
terra::plot(terra::vect(sample_occ_cropped[, c("x", "y")],
                        geom = c("x", "y"),
                        crs = "+proj=longlat +datum=WGS84 +no_defs"),col = "black",add=T)
terra::plot(terra::vect(pseudo_abs_buff[, c("x", "y")],
                        geom = c("x", "y"),
                        crs = "+proj=longlat +datum=WGS84 +no_defs"),col = "red", add=T)

# Random
terra::plot(sample_extent_data$geometry)
terra::plot(terra::vect(sample_occ_cropped[, c("x", "y")],
                        geom = c("x", "y"),
                        crs = "+proj=longlat +datum=WGS84 +no_defs"),col = "black",add=T)
terra::plot(terra::vect(pseudo_abs_rand[, c("x", "y")],
                        geom = c("x", "y"),
                        crs = "+proj=longlat +datum=WGS84 +no_defs"),col = "red", add=T)

## ----complete_dataset,eval=F--------------------------------------------------
#  pseudo_abs_buff$decimalLatitude <- pseudo_abs_buff$y
#  pseudo_abs_buff$decimalLongitude <- pseudo_abs_buff$x
#  pseudo_abs_buff$occurrenceStatus <- rep("absent", nrow(pseudo_abs_buff))
#  pseudo_abs_buff$source <- rep("dynamicSDM", nrow(pseudo_abs_buff))
#  pseudo_abs_buff<-spatiotemp_weights(occ.data = pseudo_abs_buff,
#                                         samp.events = sample_events_data,
#                                         spatial.dist = 100000,
#                                         temporal.dist = 30,
#                                         prj = "+proj=longlat +datum=WGS84")
#  
#  complete.dataset <- as.data.frame(rbind(sample_occ_cropped, pseudo_abs_buff))

## ----export_dataset,eval=F----------------------------------------------------
#  write.csv(complete.dataset, file = paste0(project_directory, "/filtered_quelea_occ.csv"))

