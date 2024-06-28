## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----include = FALSE----------------------------------------------------------


## ----setup--------------------------------------------------------------------
library(dynamicSDM)

## ----check Google, eval=FALSE-------------------------------------------------
#  library(rgee)
#  rgee::ee_check()
#  
#  library(googledrive)
#  googledrive::drive_user()
#  
#  # Set your user email here
#  #user.email<-"your_google_email_here"

## ----create directories-------------------------------------------------------
project_directory <- file.path(file.path(tempdir(), "dynamicSDM_vignette"))

dir.create(project_directory)

variablenames<-c("eight_sum_prec","year_sum_prec","grass_crop_percentage")

extraction_directories <- file.path(file.path(project_directory,"extraction"))
dir.create(extraction_directories)

extraction_directory_1 <- file.path(file.path(project_directory,variablenames[1]))
dir.create(extraction_directory_1)

extraction_directory_2 <- file.path(file.path(project_directory,variablenames[2]))
dir.create(extraction_directory_2)

extraction_directory_3 <- file.path(file.path(project_directory,variablenames[3]))
dir.create(extraction_directory_3)


## ----load data----------------------------------------------------------------
# sample_filt_data<-read.csv(paste0(project_directory,"/filtered_quelea_occ.csv"))
data(sample_filt_data)

## ----example-extract_dynamic_coords week, eval=F------------------------------
#  # 8-week total precipitation
#  extract_dynamic_coords(occ.data=sample_filt_data,
#                         datasetname = "UCSB-CHG/CHIRPS/DAILY",
#                         bandname="precipitation",
#                         spatial.res.metres = 5566 ,
#                         GEE.math.fun = "sum",
#                         temporal.direction = "prior",
#                         temporal.res = 56,
#                         save.method = "split",
#                         varname = variablenames[1],
#                         save.directory = extraction_directory_1)
#  

## ----example-extract_dynamic_coords annual,eval=F-----------------------------
#  # 52-week total precipitation
#  extract_dynamic_coords(occ.data=sample_filt_data,
#                         datasetname = "UCSB-CHG/CHIRPS/DAILY",
#                         bandname = "precipitation",
#                         spatial.res.metres = 5566 ,
#                         GEE.math.fun = "sum",
#                         temporal.direction = "prior",
#                         temporal.res = 364,
#                         save.method = "combined",
#                         varname = variablenames[2],
#                         save.directory = extraction_directory_2)

## ----example-get_moving_window------------------------------------------------
matrix <- get_moving_window(radial.distance = 10000,
                                        spatial.res.degrees = 0.05,
                                        spatial.ext = c(-35, -6, 10, 40))
matrix

## ----example-extract_buffered_coords,eval=F-----------------------------------
#  # Total grassland and cereal cropland cells in surrounding area
#  extract_buffered_coords(occ.data=sample_filt_data,
#                          datasetname = "MODIS/006/MCD12Q1",
#                          bandname="LC_Type5",
#                          spatial.res.metres = 500,
#                          GEE.math.fun = "sum",
#                          moving.window.matrix=matrix,
#                          user.email= user.email,
#                          save.method="split",
#                          temporal.level="year",
#                          categories=c(6,7),
#                          agg.factor = 12,
#                          varname = variablenames[3],
#                          save.directory=extraction_directory_3)

## ----combine extracted data,eval=F--------------------------------------------
#  complete.dataset <- extract_coords_combine(varnames = variablenames,
#                                             local.directory = c(extraction_directory_1,
#                                                                 extraction_directory_2,
#                                                                 extraction_directory_3))

## ----save extracted data,eval=F-----------------------------------------------
#  # Set NA values as zero
#  complete.dataset[is.na(complete.dataset$grass_crop_percentage),"grass_crop_percentage"]<-0
#  
#  write.csv(complete.dataset, file = paste0(project_directory, "/extracted_quelea_occ.csv"))
#  

