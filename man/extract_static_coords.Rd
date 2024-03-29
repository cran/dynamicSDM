% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract_static_coords.R
\name{extract_static_coords}
\alias{extract_static_coords}
\title{Extract explanatory variables from static rasters}
\usage{
extract_static_coords(
  occ.data,
  varnames,
  extraction.method = "simple",
  static.rasters,
  moving.window.matrix,
  GEE.math.fun
)
}
\arguments{
\item{occ.data}{a data frame, with columns for occurrence record co-ordinates
and dates with column names as follows; record longitude as "x", latitude as
"y", and associated explanatory variable data.}

\item{varnames}{a character string or vector, the unique names for each
explanatory variable in order of layers in the SpatRaster.}

\item{extraction.method}{a character string or vector, the methods to extract
data from SpatRaster using \code{terra} package \code{extract} function. One of \code{simple}
or \code{bilinear}. If \code{simple} values for the cell a point falls in are
returned. If \code{bilinear} the returned values are interpolated from the values
of the four nearest raster cells.}

\item{static.rasters}{a \code{SpatRaster} containing one or more SpatRaster layers
to extract data from.}

\item{moving.window.matrix}{optional; a matrix of weights with an odd number
of sides, representing the spatial neighbourhood of cells (“moving
window”) to calculate \code{GEE.math.fun} across from record co-ordinate. See
details for more information.}

\item{GEE.math.fun}{optional; a character string, the mathematical function to
compute across the specified spatial matrix for each record.}
}
\value{
Returns the occurrence data frame with added columns for extracted
data.
}
\description{
Explanatory variable data are extracted from static environmental rasters at
record co-ordinate or across moving window matrix
}
\details{
Function to extract data from static rasters either at occurrence
record co-ordinates or spatially buffered using a moving window matrix.

Note:
\itemize{
\item \code{varnames} must be in the order of raster layers within the SpatRaster.
\item \code{extraction.method} must be of length one to apply to all layers, or
length equal to the number of layers in \code{static.rasters}.
}
}
\section{Spatial buffering (optional)}{
Using the \code{focal} function from \code{terra} R package (Hijmans et al., 2022),
\code{GEE.math.fun} is calculated across the spatial buffer area from the record
co-ordinate. The spatial buffer area used is specified by the argument
\code{moving.window.matrix}, which dictates the neighbourhood of cells
surrounding the cell containing the occurrence record to include in this
calculation.

See function \code{get_moving_window()} to generate appropriate
\code{moving.window.matrix}.
}

\section{Mathematical function}{
\code{GEE.math.fun} specifies the mathematical function to be calculated over the
spatial buffered area and temporal period. Options are limited to Google
Earth Engine ImageCollection Reducer functions
(\url{https://developers.google.com/earth-engine/apidocs/}) for which an
analogous R function is available. This includes: "allNonZero","anyNonZero",
"count", "first","firstNonNull", "last", "lastNonNull", "max","mean",
"median","min", "mode","product", "sampleStdDev", "sampleVariance",
"stdDev", "sum" and "variance".
}

\examples{
\donttest{
data("sample_explan_data")
random_cat_layer <- terra::rast(sample_extent_data)
random_cat_layer <- terra::setValues(random_cat_layer,
                                    sample(0:10, terra::ncell(random_cat_layer),
                                           replace = TRUE))

extract_static_coords(occ.data = sample_explan_data,
                     varnames = "random_cat_layer",
                     static.rasters = random_cat_layer)

}
}
\references{
Hijmans, R.J., Bivand, R., Forner, K., Ooms, J., Pebesma, E. and Sumner, M.D.,
2022. Package ‘terra’. Maintainer: Vienna, Austria.
}
