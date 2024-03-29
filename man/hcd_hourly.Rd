% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hcd_hourly.R
\name{hcd_hourly}
\alias{hcd_hourly}
\title{Download hourly Historical Climate Data records}
\usage{
hcd_hourly(station, year, month, collapse = TRUE, progress = TRUE, ...)
}
\arguments{
\item{station}{character or numeric; one or more HCD station IDs.}

\item{year}{numeric; vector of one or more years}

\item{month}{numeric; vector of one or months}

\item{collapse}{Logical; if \code{TRUE} and multiple \code{station}s are
requested a single data frame is returned, formed by row-binding
the data for each station and prepending a station identifier variable.}

\item{progress}{Logical; if \code{TRUE}, a bar is shown indicating progress
in downloading station data from the HCD website.}

\item{...}{Further arguments passed to [\code{\link[=read_hcd]{read_hcd()}}.}
}
\value{
A \code{\link[tibble:tbl_df-class]{tibble::tbl_df}} containing the requested hourly climate
data.
}
\description{
Hourly Historical Climate Data for stated station IDs are
downloaded from the Government of Canada's Historical Climate Data website.
}
\author{
Gavin L. Simpson
}
