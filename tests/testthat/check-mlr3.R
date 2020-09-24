library("mlr3")
library("iml")
credit.task = tsk("german_credit")
lrn = lrn("classif.rpart", predict_type = "prob")
model = lrn$train(credit.task)
data = credit.task$data()

# write a measure that just prints the `predicted` that will be used to calculate the measure
measure_print_predicted = function(actual, predicted) {
  cat(head(predicted)) # have a look at how predicted looks like
}

pred = Predictor$new(model, data = data, y = "credit_risk", class = "good")
imp = FeatureImp$new(pred, loss = measure_print_predicted, n.repetitions = 1)
# 1 2 1 2 2 1



