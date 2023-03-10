% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{sample_cov_data}
\alias{sample_cov_data}
\title{Sample projection covariates three variables across for southern Africa.}
\format{
A data frame with 225 rows and 6 variables
\describe{
\item{X}{row name}
\item{x}{grid cell longitude}
\item{y}{grid cell latitude}
\item{eight_sum_prec}{sum Climate Hazards Group InfraRed Precipitation With Station Data
(Funk et al., 2015) total daily precipitation at record co-ordinate across 52-weeks prior to
"2018-04-01" (mm).}
\item{grass_crop_percentage}{total number of MODIS Land Cover Type Yearly 500m (Friedl et al.,
2019) "cereal cropland" and "grassland" cells in surrounding area of record co-ordinate in
2018.}
\item{year_sum_prec}{sum Climate Hazards Group InfraRed Precipitation With Station Data (Funk
et al., 2015) total daily precipitation at record co-ordinate across 52-weeks prior to
"2018-04-01" (mm).}
}
}
\usage{
sample_cov_data
}
\description{
Data frame of co-ordinates and associated dynamic explanatory variable values for "2018-04-01"
cropped to southern Africa at 2 degree resolution.
}
\references{
Friedl, M., Sulla-Menashe, D. (2019). MCD12Q1 MODIS/Terra+Aqua Land Cover Type Yearly L3 Global
500m SIN Grid V006. NASA EOSDIS Land Processes DAAC. Accessed 2022-11-24 from

Funk, Chris, Pete Peterson, Martin Landsfeld, Diego Pedreros, James Verdin, Shraddhanand Shukla,
Gregory Husak, James Rowland, Laura Harrison, Andrew Hoell & Joel Michaelsen. "The climate
hazards infrared precipitation with stations-a new environmental record for monitoring extremes".
Scientific Data 2, 150066.
}
\keyword{datasets}
