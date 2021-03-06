% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Query-generics.R, R/GaView-methods.R
\docType{methods}
\name{GaView}
\alias{GaView}
\alias{GaView,ANY-method}
\alias{GaView<-}
\alias{GaView<-,.query-method}
\title{GaView.}
\usage{
GaView(object, value)

GaView(object) <- value

\S4method{GaView}{ANY}(object)

\S4method{GaView}{.query}(object) <- value
}
\arguments{
\item{object}{An object to coerce to a gaView class object or to get the
gaView of, such as a query, default view of a web property, or the default
view of the first web property in a Google Analytics account.}

\item{value}{The optional replacement view if the object supplied is a query,
in which case GaView will return the modified query.}
}
\description{
Get the viewId of the query

Set the viewId for the query.
}
\section{Methods (by class)}{
\itemize{
\item \code{ANY}: Returns the ID of the supplied view, or the first view
within the supplied property or the first view within the first property of
the supplied account, or get the view ID of the supplied query, or coerce a
numeric or character into a viewId.

\item \code{.query}: Replace the view being used by a query.
}}

