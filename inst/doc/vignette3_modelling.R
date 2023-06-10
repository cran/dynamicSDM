## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(dynamicSDM)

## ----create directories-------------------------------------------------------
project_directory <- file.path(file.path(tempdir(), "dynamicSDM_vignette"))
# project_directory<-"your_path_here"
dir.create(project_directory)

#sample_explan_data <- read.csv(paste0(project_directory, "/extracted_quelea_occ.csv"))

## ----import explanatory data--------------------------------------------------
data("sample_explan_data")

## ----example-spatiotemp_autocorr----------------------------------------------
variablenames<-c("eight_sum_prec","year_sum_prec","grass_crop_percentage")

autocorrelation <- spatiotemp_autocorr(sample_explan_data,
                                       varname = variablenames,
                                       plot = TRUE,
                                       temporal.level = c("year")) # can choose month or day too

autocorrelation

## ----example-spatiotemp_block-------------------------------------------------
data("sample_extent_data")
random_cat_layer <- terra::rast(sample_extent_data)
random_cat_layer <- terra::setValues(random_cat_layer,
                                     sample(0:10, terra::ncell(random_cat_layer),
                                            replace = TRUE))

sample_explan_data <- spatiotemp_block(sample_explan_data,
                                     spatial.layer = random_cat_layer,
                                     spatial.split.degrees = 3,
                                     vars.to.block.by = variablenames,
                                     temporal.block = "month",
                                     n.blocks = 3,
                                     iterations = 5000)

## ----example-brt_fit----------------------------------------------------------
sample_explan_data$weights <- (1 - sample_explan_data$REL_SAMP_EFFORT)

models <- brt_fit(sample_explan_data,
                  response.col = "presence.absence",
                  varnames = variablenames,
                  block.col = "BLOCK.CATS",
                  weights.col = "weights",
                  distribution = "bernoulli",
                  interaction.depth = 2)

## ----save models, eval=F------------------------------------------------------
#  saveRDS(models, file = paste0(project_directory, "/fitted_quelea_SDMs.rds"))

