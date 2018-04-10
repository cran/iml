% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Partial.R
\name{Partial}
\alias{Partial}
\title{Partial Dependence and Individual Conditional Expectation}
\format{\code{\link{R6Class}} object.}
\description{
\code{Partial} computes and plots (individual) partial dependence functions of prediction models.
}
\section{Usage}{

\preformatted{
pd = Partial$new(predictor, feature, ice = TRUE, aggregation = "pdp", 
    grid.size = 20,  center.at = NULL, run = TRUE)

plot(pd)
pd$results
print(pd)
pd$set.feature(2)
pd$center(1)
}
}

\section{Arguments}{


For Partial$new():
\describe{
\item{predictor: }{(Predictor)\cr 
The object (created with Predictor$new()) holding the machine learning model and the data.}
\item{feature: }{(`character(1)` | `character(2)` | `numeric(1)` | `numeric(2)`) \cr The feature name or index for which to compute the partial dependencies.}
\item{ice: }{(`logical(1)`)\cr Should individual curves be calculated? Ignored in the case of two features.}
\item{center.at: }{(`numeric(1)`)\cr Value at which the plot should be centered. Ignored in the case of two features.}
\item{grid.size: }{(`numeric(1)` | `numeric(2)`)\cr The size of the grid for evaluating the predictions}
\item{run: }{(`logical(1)`)\cr Should the Interpretation method be run?}
}
}

\section{Details}{

The partial dependence plot calculates and plots the dependence of f(X) on a single or two features.
It's the aggregate of all individual conditional expectation curves, that describe how, for a single
observation, the prediction changes when the feature changes. 

To learn more about partial dependence plot, read the Interpretable Machine Learning book: 
https://christophm.github.io/interpretable-ml-book/pdp.html

And for individual conditional expectation: 
https://christophm.github.io/interpretable-ml-book/ice.html
}

\section{Fields}{

\describe{
\item{feature.index: }{(`numeric(1)` | `numeric(2)`)\cr The index of the feature(s) for which the partial dependence was computed.}
\item{feature.name: }{(`character(1)` | `character(2)`)\cr The names of the features for which the partial dependence was computed.}
\item{feature.type: }{(`character(1)` | `character(2)`)\cr The detected types of the features, either "categorical" or "numerical".}
\item{grid.size: }{(`numeric(1)` | `numeric(2)`)\cr The size of the grid.}
\item{center.at: }{(`numeric(1)` | `character(1)`)\cr The value for the centering of the plot. Numeric for numeric features, and the level name for factors.}
\item{n.features: }{(`numeric(1)`)\cr The number of features (either 1 or 2)}
\item{predictor: }{(Predictor)\cr The prediction model that was analysed.}
\item{results: }{(data.frame)\cr data.frame with the grid of feature of interest and the predicted \eqn{\hat{y}}. 
Can be used for creating custom partial dependence plots.}
}
}

\section{Methods}{

\describe{
\item{center()}{method to set the value at which the ice computations are centered. See examples.}
\item{set.feature()}{method to get/set feature(s) (by index) fpr  which to compute pdp. See examples for usage.}
\item{plot()}{method to plot the partial dependence function. See \link{plot.Partial}}
\item{\code{run()}}{[internal] method to run the interpretability method. Use \code{obj$run(force = TRUE)} to force a rerun.}
\item{\code{clone()}}{[internal] method to clone the R6 object.}
\item{\code{initialize()}}{[internal] method to initialize the R6 object.}
}
}

\examples{
# We train a random forest on the Boston dataset:
if (require("randomForest")) {
data("Boston", package  = "MASS")
rf = randomForest(medv ~ ., data = Boston, ntree = 50)
mod = Predictor$new(rf, data = Boston)

# Compute the partial dependence for the first feature
pdp.obj = Partial$new(mod, feature = "crim")

# Plot the results directly
plot(pdp.obj)

# Since the result is a ggplot object, you can extend it: 
if (require("ggplot2")) {
 plot(pdp.obj) + theme_bw()
}

# If you want to do your own thing, just extract the data: 
pdp.dat = pdp.obj$results
head(pdp.dat)

# You can reuse the pdp object for other features: 
pdp.obj$set.feature("lstat")
plot(pdp.obj)

# Only plotting the aggregated partial dependence:  
pdp.obj = Partial$new(mod, feature = "crim", ice = FALSE)
pdp.obj$plot() 

# Only plotting the individual conditional expectation:  
pdp.obj = Partial$new(mod, feature = "crim", aggregation = "none")
pdp.obj$plot() 
  
# Partial dependence plots support up to two features: 
pdp.obj = Partial$new(mod, feature = c("crim", "lstat"))  
plot(pdp.obj)


# Partial dependence plots also works with multiclass classification
rf = randomForest(Species ~ ., data = iris, ntree=50)
predict.fun = function(object, newdata) predict(object, newdata, type = "prob")
mod = Predictor$new(rf, data = iris, predict.fun = predict.fun)

# For some models we have to specify additional arguments for the predict function
plot(Partial$new(mod, feature = "Petal.Width"))

# Partial dependence plots support up to two features: 
pdp.obj = Partial$new(mod, feature = c("Sepal.Length", "Petal.Length"))
pdp.obj$plot()   

# For multiclass classification models, you can choose to only show one class:
mod = Predictor$new(rf, data = iris, predict.fun = predict.fun, class = 1)
plot(Partial$new(mod, feature = "Sepal.Length"))
}
}
\references{
Friedman, J.H. 2001. "Greedy Function Approximation: A Gradient Boosting Machine." Annals of Statistics 29: 1189-1232.

Goldstein, A., Kapelner, A., Bleich, J., and Pitkin, E. (2013). Peeking Inside the Black Box: 
Visualizing Statistical Learning with Plots of Individual Conditional Expectation, 1-22. https://doi.org/10.1080/10618600.2014.907095
}
\seealso{
\link{plot.Partial}
}