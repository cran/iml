#' Interpretation Method
#'
#' @description Superclass container for Interpretation Method objects
#'
#' @export
InterpretationMethod <- R6Class("InterpretationMethod",
  public = list(

    #' @description Create an InterpretationMethod object
    #' @template predictor
    initialize = function(predictor) {
      checkmate::assert_class(predictor, "Predictor")
      self$predictor <- predictor
      private$sampler <- predictor$data
      private$getData <- private$sampler$get.x
    },

    #' @description Plot function. Calls `private$generatePlot()` of the
    #' respective subclass.
    #' @param ... Passed to `private$generatePlot()`.
    plot = function(...) {
      private$plotData <- private$generatePlot(...)
      if (!is.null(private$plotData)) {
        return(private$plotData)
      } else {
        warning("call run() first!")
      }
    },

    #' @description Printer for InterpretationMethod objects
    print = function() {
      cat("Interpretation method: ", class(self)[1], "\n")
      private$printParameters()
      cat("\n\nAnalysed predictor: \n")
      self$predictor$print()
      cat("\n\nAnalysed data:\n")
      print(private$sampler)
      cat("\n\nHead of results:\n")
      if (!is.null(self$results)) {
        print(head(self$results))
      }
    },

    #' @field results [data.frame]\cr
    #' The aggregated results of the experiment
    results = NULL,
    # The prediction model

    #' @field predictor
    #' Predictor object.
    predictor = NULL
  ),

  private = list(
    # The sampling object for sampling from X
    sampler = NULL,
    # Wrapper for sampler
    getData = NULL,
    # The sampled data
    dataSample = NULL,
    # The intervention on the sample
    intervene = function() private$dataSample,
    # The design matrix after intervention
    dataDesign = NULL,
    # The quantity of interest from black box model prediction
    predictResults = NULL,
    q = function(x) x,
    qResults = NULL,
    # Flag if the prediction is multiClass (more than one column)
    multiClass = NULL,
    # Weights for the aggregation step
    weightSamples = function() 1,
    # The aggregation function for the results
    aggregate = function() cbind(private$dataDesign, private$qResults),
    # Flag if the experiment is finished
    finished = FALSE,
    # Removes experiment results as preparation for running experiment again
    flush = function() {
      private$dataSample <- NULL
      private$dataDesign <- NULL
      private$qResults <- NULL
      self$results <- NULL
      private$finished <- FALSE
    },
    run = function(force = FALSE, ...) {
      if (force) private$flush()
      if (!private$finished) {
        # DESIGN experiment
        private$dataSample <- private$getData()
        private$dataDesign <- private$intervene()
        # EXECUTE experiment
        private$qResults <- private$run.prediction(private$dataDesign)
        # AGGREGATE measurements
        self$results <- data.frame(private$aggregate())
        private$finished <- TRUE
      }
    },
    run.prediction = function(dataDesign) {
      private$predictResults <- self$predictor$predict(data.frame(dataDesign))
      private$multiClass <- ifelse(ncol(private$predictResults) > 1, TRUE, FALSE)
      private$q(private$predictResults)
    },
    # The data need for plotting of results
    plotData = NULL,
    # Function to generate the plot
    generatePlot = function() NULL,
    # Feature names of X
    feature.names = NULL,
    printParameters = function() {}
  )
)
