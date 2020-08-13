% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/validate_arguments.R
\name{validate_id}
\alias{validate_id}
\title{Validate data package/product identifier}
\usage{
validate_id(id)
}
\arguments{
\item{id}{(character) A data package/product identifier for an ecocomDP dataset.}
}
\value{
\item{id}{If valid, then \code{id} is returned along with a warning
    if a newer revision exists.}
    \item{NULL}{If invalid (i.e. not listed in the return of 
    \code{search_data()}) along with a warning.}
}
\description{
Validate data package/product identifier
}
\details{
If the exact \code{id} is not indexed, but it is an EDI data package, 
    then a set of logic determines if a newer version is indexed and 
    available.
}