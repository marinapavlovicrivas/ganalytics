% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Comparator-generics.R, R/Comparator-methods.R
\docType{methods}
\name{Comparator}
\alias{!=,.var,.operand-method}
\alias{<,.var,.metOperand-method}
\alias{<=,.var,.metOperand-method}
\alias{==,.var,.operand-method}
\alias{>,.var,.metOperand-method}
\alias{>=,.var,.metOperand-method}
\alias{Comparator}
\alias{Comparator,ANY-method}
\alias{Comparator<-}
\alias{Comparator<-,ANY-method}
\alias{\%between\%}
\alias{\%between\%,.var,.operand-method}
\alias{\%in\%}
\alias{\%in\%,.var,.operand-method}
\alias{\%matches\%}
\alias{\%matches\%,.var,.dimOperand-method}
\alias{\%starts_with\%}
\alias{\%starts_with\%,.var,.dimOperand-method}
\title{Comparator.}
\usage{
Comparator(object, ...)

Comparator(object) <- value

var \%starts_with\% operand

var \%matches\% operand

var \%between\% operand

x \%in\% table

\S4method{\%matches\%}{.var,.dimOperand}(var, operand)

\S4method{\%starts_with\%}{.var,.dimOperand}(var, operand)

\S4method{\%between\%}{.var,.operand}(var, operand)

\S4method{\%in\%}{.var,.operand}(x, table)

\S4method{==}{.var,.operand}(e1, e2)

\S4method{!=}{.var,.operand}(e1, e2)

\S4method{>}{.var,.metOperand}(e1, e2)

\S4method{<}{.var,.metOperand}(e1, e2)

\S4method{>=}{.var,.metOperand}(e1, e2)

\S4method{<=}{.var,.metOperand}(e1, e2)

\S4method{Comparator}{ANY}(object)

\S4method{Comparator}{ANY}(object) <- value
}
\arguments{
\item{object}{The object to be coerced to a '.Comparator' class or to get the
comparator from.}

\item{...}{Used by certain methods.}

\item{value}{The value to set the comparator to.}

\item{var}{dimension or metric object}

\item{operand}{operand object}

\item{x}{Dimension or metric object}

\item{table}{Operand object}

\item{e1}{Dimension or metric object}

\item{e2}{Operand object}
}
\description{
Get or create an comparator used in an expression.

Set the comparator used in an expression.
}
\section{Methods (by class)}{
\itemize{
\item \code{ANY}: Return the comparator used within the supplied
conditional expression.

\item \code{ANY}: Replace the comparator used in the supplied
conditional expression.
}}
\section{\%starts_with\%}{

A condition where the dimension (LHS) matches values that start
  with character string given by the operand (RHS).
}

\section{\%matches\%}{

A condition where the dimension (LHS) matches a regular
  expression given by the operand (RHS).
}

\section{\%between\%}{

A condition where the dimension (LHS) is within the lower and
  uppoer bounds specified by first and second vector value (respectively) of
  the operand (RHS).
}

\section{\%in\%}{

A condition where the dimension (LHS) matches one of the
  values of a vecotr specified by the operand (RHS).
}

