#' @include utils.R
#' @include init-methods.R
#' @importFrom methods setAs validObject
#' @importFrom plyr ldply alply
NULL

## As setAs looks within the global namespace for any internall called functions within
# the definition, then the following function is likely to throw an error if used with setAs.
compileOperand <- function(from) {
  unEscapedOperand <- as(as(from, ".operand"), "character")
  comparator <- as(as(from, ".comparator"), "character")
  compiledOperand <- gsub(
    pattern = "(,|;|\\\\)", # What about _ and | used within an operand when using <> or [] comparators
    replacement = "\\\\\\1",
    x = unEscapedOperand
  )
  if (comparator == "[]") {
    compiledOperand <- paste0(compiledOperand, collapse = "|")
  } else if (from@comparator == "<>") {
    compiledOperand <- paste0(compiledOperand, collapse = "_")
  }
  compiledOperand
}

# Coercing to character
setAs(from = ".metOperand", to = "character",
      def = function(from) {
        format(from@.Data, scientific = FALSE)
      },
      replace = function(from, value) {
        from@.Data <- as.numeric(value)
        validObject(from)
        from
      }
)

## the folowing function calls another function which is not in the global namesapce
# Coercing GA expressions to GA API compatible character strings
setAs(from = ".expr", to = "character", def = function(from, to) {
  paste0(
    if (class(from) == "gaSegMetExpr") {
      if (from@metricScope != "") paste0(from@metricScope, "::")
    },
    as(from@var, to),
    as(from@comparator, to),
    as(compileOperand(from), to)
  )
})

setAs(from = "orExpr", to = "character", def = function(from, to) {
  do.call(paste, c(lapply(from, as, to), sep = ","))
})

setAs(from = "andExpr", to = "character", def = function(from, to) {
  do.call(paste, c(lapply(from, as, to), sep = ";"))
})

setAs(from = "gaSegmentConditionFilter", to = "character", def = function(from) {
  paste0(
    "condition::",
    if (from@negation) {"!"} else {""},
    as(as(from, "andExpr"), "character")
  )
})

setAs(from = "gaSegmentSequenceFilter", to = "character", def = function(from, to) {
  if (length(from) >= 1) {
    paste0(
      "sequence::",
      if (from@negation) {"!"} else {""},
      do.call(
        paste0,
        lapply(seq_along(from),
               FUN = function(sequenceStep) {
                 paste0(
                   if (sequenceStep > 1) {
                     if (from[[sequenceStep]]@immediatelyPrecedes) {";->"} else {";->>"}
                   } else {
                     if (from[[sequenceStep]]@immediatelyPrecedes) {"^"} else {""}
                   },
                   as(from[[sequenceStep]], to)
                 )
               }
        )
      )
    )
  } else {
    character(0)
  }
})

setAs(from = "gaSegmentFilterList", to = "character", def = function(from, to) {
  if (length(from) >= 1) {
    paste(
      from@scope,
      do.call(
        paste,
        c(
          lapply(from, FUN = function(compoundExpr) {
            as(compoundExpr, to)
          }),
          sep = ";"
        )
      ),
      sep = "::"
    )
  } else {
    character(0)
  }
})

setAs(from = "gaDynSegment", to = "character",
      def = function(from, to) {
        do.call(
          paste,
          c(
            lapply(from, FUN = function(segmentCondition) {
              as(segmentCondition, to)
            }),
            sep = ";"
          )
        )
      }
)

setAs(from = "gaSegmentId", to = "character",
      def = function(from) {
        as.character(from@.Data)
      },
      replace = function(from, value) {
        initialize(from, value)
      }
)

# Coercing from .metrics, .dimensions, and .sortBy to character
setAs(from = ".varList", to = "character",
      def = function(from) {
        paste(from@.Data, collapse = ",")
      },
      replace = function(from, value) {
        initialize(from, unlist(strsplit(value, split = ",")))
      }
)

setAs(from = ".sortBy", to = "character",
      def = function(from) {
        varNames <- sapply(from@.Data, FUN = function(varName) {
          as(varName, "character")
        })
        descChar <- ifelse(from@desc, "-", "")
        paste0(descChar, varNames, collapse = ",")
      },
      replace = function(from, value) {
        as(value, class(from))
      }
)

# Coercion to matrix
setAs(
  from = "gaQuery",
  to = "matrix",
  def = function(from) {
    viewsDatesSegments <- expand.grid(
      list(
        viewId = as(from, "viewId"),
        dateRange = alply(data.frame(
          startDate = StartDate(from),
          endDate = EndDate(from)
        ), 1),
        segment = as(from, "gaSegmentList")
      ),
      stringsAsFactors = FALSE,
      KEEP.OUT.ATTRS = FALSE
    )
    viewsDatesSegments <- c(
      list(
        viewId = viewsDatesSegments$viewId,
        segment = viewsDatesSegments$segment
      ),
      ldply(viewsDatesSegments$dateRange, .id = NULL)
    )
    params <- mapply(
      FUN = function(startDate, endDate, viewId, segment) {
        metrics <- as(from, ".metrics")
        dimensions <- as(from, ".dimensions")
        sortBy <- as(from, ".sortBy")
        tableFilter <- as(from, ".tableFilter")
        c(
          "ids" = as(viewId, "character"),
          "start-date" = as.character(startDate),
          "end-date" = as.character(endDate),
          "metrics" = as(metrics, "character"),
          "dimensions" = if (length(dimensions) >= 1) {
            as(dimensions, "character")
          },
          "sort" = if (length(sortBy) >= 1) {
            as(sortBy, "character")
          },
          "filters" = if (length(tableFilter) >= 1) {
            as(tableFilter, "character")
          },
          "segment" = if (length(segments) >= 1) {
            as(segment, "character")
          },
          "samplingLevel" = as(from@samplingLevel, "character"),
          "include-empty-rows" = "false"
        )
      },
      viewsDatesSegments$startDate,
      viewsDatesSegments$endDate,
      viewsDatesSegments$viewId,
      viewsDatesSegments$segment
    )
  }
)

setAs(
  from = "mcfQuery",
  to = "matrix",
  def = function(from) {
    views <- as(from, "viewId")
    dateRange <- as(from, "dateRange")
    startDates <- dateRange@startDate
    endDates <- dateRange@endDate
    viewsDates <- do.call(
      what = rbind,
      args = lapply(
        X = views,
        FUN = function(viewId) {
          data.frame(
            startDate = startDates,
            endDate = endDates,
            viewId = viewId,
            stringsAsFactors = FALSE
          )
        }
      )
    )
    params <- mapply(
      FUN = function(startDate, endDate, viewId) {
        metrics <- as(from, ".metrics")
        dimensions <- as(from, ".dimensions")
        sortBy <- as(from, ".sortBy")
        tableFilter <- as(from, ".tableFilter")
        c(
          "ids" = as(viewId, "character"),
          "start-date" = as.character(startDate),
          "end-date" = as.character(endDate),
          "metrics" = as(metrics, "character"),
          "dimensions" = if (length(dimensions) >= 1) {
            as(dimensions, "character")
          },
          "sort" = if (length(sortBy) >= 1) {
            as(sortBy, "character")
          },
          "filters" = if (length(tableFilter) >= 1) {
            as(tableFilter, "character")
          },
          "samplingLevel" = as(from@samplingLevel, "character")
        )
      },
      viewsDates$startDate,
      viewsDates$endDate,
      viewsDates$viewId
    )
  }
)

setAs(
  from = "rtQuery",
  to = "matrix",
  def = function(from) {
    views <- do.call(
      what = rbind,
      args = lapply(
        X = as(from, "viewId"),
        FUN = function(viewId) {
          data.frame(
            viewId = viewId,
            stringsAsFactors = FALSE
          )
        }
      )
    )
    params <- mapply(
      FUN = function(viewId) {
        metrics <- as(from, ".metrics")
        dimensions <- as(from, ".dimensions")
        sortBy <- as(from, ".sortBy")
        tableFilter <- as(from, ".tableFilter")
        c(
          "ids" = as(viewId, "character"),
          "metrics" = as(metrics, "character"),
          "dimensions" = if (length(dimensions) >= 1) {
            as(dimensions, "character")
          },
          "sort" = if (length(sortBy) >= 1) {
            as(sortBy, "character")
          },
          "filters" = if (length(tableFilter) >= 1) {
            as(tableFilter, "character")
          }
        )
      },
      views$viewId
    )
  }
)
