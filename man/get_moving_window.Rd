% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_moving_window.R
\name{get_moving_window}
\alias{get_moving_window}
\title{Generate a “moving window” matrix of optimal size}
\usage{
get_moving_window(
  radial.distance,
  spatial.res.degrees,
  spatial.res.metres,
  spatial.ext
)
}
\arguments{
\item{radial.distance}{a numeric value, the radius of interest in metres.}

\item{spatial.res.degrees}{a numeric value, the spatial resolution in degrees of explanatory
variable data.}

\item{spatial.res.metres}{a numeric value, the spatial resolution in metres of explanatory
variable data.}

\item{spatial.ext}{the spatial extent of the study. Object from which extent
can be extracted of class \code{SpatExtent}, \code{SpatRaster}, \code{sf} polygon or
numeric vector listing xmin, xmax, ymin and ymax in order.}
}
\value{
Returns "moving window" matrix with an odd number of sides and equal weights.
}
\description{
Calculates an optimal “moving window” matrix size for use when extracting spatially buffered
explanatory variables, by using the radius of interest and spatial resolution of environmental
data.
}
\section{Importance for other functions in \code{dynamicSDM} To extract spatially buffered explanatory}{
variable data using dynamicSDM functions \code{extract_buffered_coords()} or
\code{extract_buffered_raster()}, a “moving window” matrix specifying the neighbourhood of cells to
include in the calculation is required.

For example, by using a three by three “moving window” matrix of equal weights, the explanatory
variable would be calculated across the nine grid cells neighbouring the cell of interest and the
cell of interest.
}

\section{Why use a moving window matrix instead of circular buffer?}{
The benefit of using a “moving window” over calculating explanatory
variable values across a set radius from each record co-ordinate, is that when
generating projection rasters at high spatial and temporal resolution, these
can be generated much faster as the “moving windows” standardise the
calculation.
}

\section{Function calculation}{
\itemize{
\item 
\enumerate{
\item To calculate the “moving window” matrix size, the \code{get_moving_window()} function first
calculates the circular area of interest, using the user-specified radius of interest and the
equation for area of a circle.
}
}

This radius should be chosen to represent the radial distance from species occurrence record
co-ordinates that the explanatory variable data might be relevant and impact species presence.
\itemize{
\item 
\enumerate{
\item Then, the average grid cell area of the explanatory variable data (derived from user-provided
spatial resolution and extent) is calculated. If \code{spatial.res.degrees} is given then \code{spatial.ext}
is required to calculate average cell area size. If \code{spatial.res.metres} is given then average
cell area is calculated by squaring this value to get cell area in square metres.
}
\item 
\enumerate{
\item Finally, the function then calculates the optimal “moving window” matrix that best matches
circular area of interest with the “moving window” matrix area. The matrix of weights will have an
odd number of sides.
}
}
}

\examples{
get_moving_window(radial.distance = 100000, spatial.res.metres = 111320)

}
