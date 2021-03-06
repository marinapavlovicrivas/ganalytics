% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Sequence-generics.R
\name{First}
\alias{First}
\title{First.}
\usage{
First(object, ...)
}
\arguments{
\item{object}{An expression that should be at the start of a sequence
expression.}

\item{...}{Any other expressions that should immediately follow the first
expression.}
}
\value{
a gaSegmentSequenceStep object, with the immediate flag set.
}
\description{
If used at the beginning of a sequence, indicates that this step must match
the first interaction of included sessions and users within the select date
range. First expressly means 'first interaction' within the date range.
}
\seealso{
\code{\link{Sequence}}
}

