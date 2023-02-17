## ---- include = FALSE---------------------------------------------------------


## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(dynamicSDM)

## ----check Google, eval=FALSE-------------------------------------------------
#  library(rgee)
#  rgee::ee_check()
#  
#  library(googledrive)
#  googledrive::drive_user()
#  #user.email<-"your_google_email_here"

## ----create directories-------------------------------------------------------
variablenames <- c("eight_sum_prec", "year_sum_prec", "grass_crop_percentage")

project_directory <- file.path(tempdir(), "dynamicSDM_vignette")
# project_directory<-"your_path_here"
dir.create(project_directory, showWarnings = FALSE)

projection_directories <- file.path(project_directory, "projection")
dir.create(project_directory, showWarnings = FALSE)

projectionrasters <- file.path(project_directory, "projectionrasters")
dir.create(project_directory, showWarnings = FALSE)

projection_covariates <- file.path(project_directory, "projectioncovariates")
dir.create(project_directory, showWarnings = FALSE)

projection_GIF <- file.path(project_directory, "projection_GIF")
dir.create(project_directory, showWarnings = FALSE)

## ----example-dynamic_proj_dates-----------------------------------------------
# 5 day intervals
dynamic_proj_dates(startdate = "2018-01-01",
                   enddate = "2018-12-01",
                   interval = 5, 
                   interval.level = "day")

# 2 week intervals
dynamic_proj_dates(startdate = "2018-01-01",
                   enddate = "2018-12-01",
                   interval = 2, 
                   interval.level = "week")

## ----case study dynamic_proj_dates--------------------------------------------
projectiondates <- dynamic_proj_dates(startdate = "2018-01-01",
                                      enddate = "2018-12-01",
                                      interval = 3,
                                      interval.level = "month")

## ----example-extract_dynamic_raster , eval=F----------------------------------
#  data("sample_extent_data")
#  
#  extract_dynamic_raster(dates=projectiondates,
#                         datasetname = "UCSB-CHG/CHIRPS/DAILY",
#                         bandname="precipitation",
#                         user.email = user.email,
#                         spatial.res.metres = 5566,
#                         GEE.math.fun = "sum",
#                         temporal.direction = "prior",
#                         temporal.res = 56,
#                         spatial.ext = sample_extent_data,
#                         varname = variablenames[1],
#                         save.directory=projectionrasters)
#  
#  extract_dynamic_raster(dates=projectiondates,
#                         datasetname = "UCSB-CHG/CHIRPS/DAILY",
#                         bandname="precipitation",
#                         user.email = user.email,
#                         spatial.res.metres = 5566,
#                         GEE.math.fun = "sum",
#                         temporal.direction = "prior",
#                         temporal.res = 364,
#                         spatial.ext = sample_extent_data,
#                         varname = variablenames[2],
#                         save.directory=projectionrasters)
#  
#  matrix<-dynamicSDM::get_moving_window(radial.distance = 10000,
#                                        spatial.res.degrees = 0.05,
#                                        spatial.ext = sample_extent_data)
#  
#  extract_buffered_raster(dates=projectiondates,
#                          datasetname = "MODIS/006/MCD12Q1",
#                          bandname="LC_Type5",
#                          spatial.res.metres = 500,
#                          GEE.math.fun = "sum",
#                          moving.window.matrix=matrix,,
#                          user.email=user.email,
#                          categories=c(6,7),
#                          agg.factor = 12,
#                          spatial.ext = sample_extent_data,
#                          varname = variablenames[3],
#                          save.directory=projectionrasters)

## ----example-dynamic_proj_covariates, eval=F----------------------------------
#  dynamic_proj_covariates(dates=projectiondates,
#             varnames=variablenames,
#             local.directory=projectionrasters,
#             spatial.ext=sample_extent_data,
#             spatial.mask=sample_extent_data,
#             spatial.res.degrees = 0.05,
#             resample.method = c("bilinear","bilinear","ngb"),
#             cov.file.type = "csv",
#             prj="+proj=longlat +datum=WGS84",
#             save.directory = projection_covariates)

## ----example-dynamic_proj, eval=F---------------------------------------------
#  #sample_brt_models<- readRDS(paste0(project_directory, "/fitted_quelea_SDMs.rds"))
#  data("sample_explan_data")
#  sample_explan_data$weights <- (1 - sample_explan_data$REL_SAMP_EFFORT)
#  
#  sample_brt_models <- brt_fit(sample_explan_data,
#                    response.col = "presence.absence",
#                    varnames = variablenames,
#                    block.col = "BLOCK.CATS",
#                    weights.col = "weights",
#                    distribution = "bernoulli")
#  
#  dynamic_proj(dates = projectiondates,
#               projection.method = c("proportional"),
#               local.directory = projection_covariates,
#               cov.file.type = "csv",
#               sdm.mod = sample_brt_models,
#               spatial.mask = sample_extent_data,
#               save.directory = projection_directories)

## ----plot projections, eval=F-------------------------------------------------
#  sp::plot(raster::raster(list.files(projection_directories)[1]))
#  sp::plot(raster::raster(list.files(projection_directories)[2]))
#  sp::plot(raster::raster(list.files(projection_directories)[3]))
#  sp::plot(raster::raster(list.files(projection_directories)[4]))

## ----example-dynamic_proj_GIF, eval=F-----------------------------------------
#  dynamic_proj_GIF(dates = projectiondates,
#                   projection.type = "proportional",
#                   local.directory = projection_directories,
#                   save.directory = projection_GIF,
#                   legend.max = 1,
#                   legend.min = 0,
#                   width = 650,
#                   legend.name = "Distribution\n suitability")

