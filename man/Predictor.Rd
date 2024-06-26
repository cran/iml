% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Predictor.R
\name{Predictor}
\alias{Predictor}
\title{Predictor object}
\description{
A \code{Predictor} object holds any machine learning model (\code{mlr}, \code{caret},
\code{randomForest}, ...) and the data to be used for analyzing the model. The
interpretation methods in the \code{iml} package need the machine learning model
to be wrapped in a \code{Predictor} object.
}
\details{
A Predictor object is a container for the prediction model and the data.
This ensures that the machine learning model can be analyzed in a robust way.

Note: In case of classification, the model should return one column per class
with the class probability.
}
\examples{
library("mlr")
task <- makeClassifTask(data = iris, target = "Species")
learner <- makeLearner("classif.rpart", minsplit = 7, predict.type = "prob")
mod.mlr <- train(learner, task)
mod <- Predictor$new(mod.mlr, data = iris)
mod$predict(iris[1:5, ])

mod <- Predictor$new(mod.mlr, data = iris, class = "setosa")
mod$predict(iris[1:5, ])

library("randomForest")
rf <- randomForest(Species ~ ., data = iris, ntree = 20)


mod <- Predictor$new(rf, data = iris, type = "prob")
mod$predict(iris[50:55, ])

# Feature importance needs the target vector, which needs to be supplied:
mod <- Predictor$new(rf, data = iris, y = "Species", type = "prob")
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{data}}{\link{data.frame}\cr
Data object with the data for the model interpretation.}

\item{\code{model}}{(any)\cr
The machine learning model.}

\item{\code{batch.size}}{\code{numeric(1)}\cr
The number of rows to be input the model for prediction at once.}

\item{\code{class}}{\code{character(1)}\cr
The class column to be returned.}

\item{\code{prediction.colnames}}{\link{character}\cr
The column names of the predictions.}

\item{\code{prediction.function}}{\link{function}\cr
The function to predict newdata.}

\item{\code{task}}{\code{character(1)}\cr
The inferred prediction task: \code{"classification"} or \code{"regression"}.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-Predictor-new}{\code{Predictor$new()}}
\item \href{#method-Predictor-predict}{\code{Predictor$predict()}}
\item \href{#method-Predictor-print}{\code{Predictor$print()}}
\item \href{#method-Predictor-clone}{\code{Predictor$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Predictor-new"></a>}}
\if{latex}{\out{\hypertarget{method-Predictor-new}{}}}
\subsection{Method \code{new()}}{
Create a Predictor object
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Predictor$new(
  model = NULL,
  data = NULL,
  predict.function = NULL,
  y = NULL,
  class = NULL,
  type = NULL,
  batch.size = 1000
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{model}}{any\cr
The machine learning model. Recommended are models from \code{mlr} and
\code{caret}. Other machine learning with a S3 predict functions work as
well, but less robust (e.g. \code{randomForest}).}

\item{\code{data}}{\link{data.frame}\cr
The data to be used for analyzing the prediction model. Allowed column
classes are: \link{numeric}, \link{factor}, \link{integer}, \link{ordered} and \link{character}
For some models the data can be extracted automatically.
\code{Predictor$new()} throws an error when it can't extract the data
automatically.}

\item{\code{predict.function}}{\link{function}\cr
The function to predict newdata. Only needed if \code{model} is not a model
from \code{mlr} or \code{caret} package. The first argument of \code{predict.fun} has to
be the model, the second the \code{newdata}:

\if{html}{\out{<div class="sourceCode">}}\preformatted{function(model, newdata)
}\if{html}{\out{</div>}}}

\item{\code{y}}{\code{character(1)} | \link{numeric} | \link{factor}\cr The target vector or
(preferably) the name of the target column in the \code{data} argument.
Predictor tries to infer the target automatically from the model.}

\item{\code{class}}{\code{character(1)}\cr
The class column to be returned. You should use the column name of the
predicted class, e.g. \code{class="setosa"}.}

\item{\code{type}}{\code{character(1)})\cr
This argument is passed to the prediction
function of the model. For regression models you usually don't have to
provide the type argument. The classic use case is to say \code{type="prob"}
for classification models. Consult the documentation of the machine
learning package you use to find which type options you have. If both
\code{predict.fun} and \code{type} are used, then type is passed as an argument
to \code{predict.fun}.}

\item{\code{batch.size}}{\code{numeric(1)}\cr
The maximum number of rows to be input the model for prediction at once.
Currently only respected for \link{FeatureImp}, \link{Partial} and \link{Interaction}.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Predictor-predict"></a>}}
\if{latex}{\out{\hypertarget{method-Predictor-predict}{}}}
\subsection{Method \code{predict()}}{
Predict new data with the machine learning model.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Predictor$predict(newdata)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{newdata}}{\link{data.frame}\cr
Data to predict on.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Predictor-print"></a>}}
\if{latex}{\out{\hypertarget{method-Predictor-print}{}}}
\subsection{Method \code{print()}}{
Print the Predictor object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Predictor$print()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Predictor-clone"></a>}}
\if{latex}{\out{\hypertarget{method-Predictor-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Predictor$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
