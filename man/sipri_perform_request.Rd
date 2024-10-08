% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sipri_request.R
\name{sipri_perform_request}
\alias{sipri_perform_request}
\title{Perform a request and retrieve response}
\usage{
sipri_perform_request(req)
}
\arguments{
\item{req}{An \code{httr2} request object created by \code{sipri_build_request}.}
}
\value{
An \code{httr2} response object containing the server's response.
}
\description{
Executes an HTTP request and retrieves the response.
}
\keyword{internal}
