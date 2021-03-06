% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DataSet.R, R/DataSetList.R
\name{get_RT_sample}
\alias{get_RT_sample}
\alias{get_RT_sample.DataSet}
\alias{get_RT_sample.DataSetList}
\title{Get RunTime Sample}
\usage{
get_RT_sample(ds, ftarget, ...)

\method{get_RT_sample}{DataSet}(ds, ftarget, output = "wide", ...)

\method{get_RT_sample}{DataSetList}(ds, ftarget, algorithm = "all", ...)
}
\arguments{
\item{ds}{A DataSet or DataSetList object}

\item{ftarget}{A Numerical vector. Function values at which runtime values are consumed}

\item{...}{Arguments passed to other methods}

\item{output}{A character determining the format of output data.table: 'wide' or 'long'}

\item{algorithm}{DEPRECATED, will be removed in next release. Which algorithms in the DataSetList to consider.}
}
\value{
A data.table containing the runtime samples for each provided target
function value
}
\description{
Get RunTime Sample
}
\examples{
get_RT_sample(dsl, 14)
get_RT_sample(dsl[[1]], 14)
}
