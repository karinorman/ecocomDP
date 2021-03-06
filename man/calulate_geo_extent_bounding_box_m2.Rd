% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_dataset_summary.R
\name{calulate_geo_extent_bounding_box_m2}
\alias{calulate_geo_extent_bounding_box_m2}
\title{Calculate geo_extent_bounding_box_m2 of the dataset_summary table}
\usage{
calulate_geo_extent_bounding_box_m2(lon_west, lon_east, lat_north, lat_south)
}
\arguments{
\item{lon_west}{(numeric) West longitude in decimal degrees and negative if west of the 
prime meridian.}

\item{lon_east}{(numeric) East longitude in decimal degrees and negative if west of the 
prime meridian.}

\item{lat_north}{(numeric) North latitude in decimal degrees.}

\item{lat_south}{(numeric) North latitude in decimal degrees.}
}
\value{
(numeric) Area in square meters.
}
\description{
Calculate geo_extent_bounding_box_m2 of the dataset_summary table
}
