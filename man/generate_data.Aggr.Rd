% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DataSetList.R
\name{generate_data.Aggr}
\alias{generate_data.Aggr}
\title{Generate dataframe of a single function/dimension pair}
\usage{
generate_data.Aggr(dsList, aggr_on = "funcId", targets = NULL, which = "by_RT")
}
\arguments{
\item{dsList}{The DataSetList object}

\item{aggr_on}{Which attribute to use for aggregation. Either 'funcId' or 'DIM'}

\item{targets}{Optional list of target values (Runtime or target value)}

\item{which}{Whether to use a fixed-target 'by_RT' perspective or fixed-budget 'by_FV'}
}
\description{
This function generates a dataframe which can be easily plotted using the `plot_general_data`-function
}
\examples{
generate_data.Aggr(dsl)
}
