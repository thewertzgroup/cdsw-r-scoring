# source install.r to install required packages

library(neuralnet)

options(scipen = 999)

nn_model <- readRDS("lte_nn_model.rds")

### Declare the numeric variable(s)
num_input <- c("avg_meanthroughputul",
               "avg_meanthroughputdl",
               "min_totaldataul",
               "max_totaldataul",
               "sum_totaldataul",
               "avg_totaldataul",
               "min_totaldatadl",
               "max_totaldatadl",
               "sum_totaldatadl",
               "avg_totaldatadl",
               "avg_internetlatency",
               "avg_httpsuccessratio")

nn_scoring <- function(json, model) {
  if (missing(model)) { model <- nn_model }
  set.seed(9999)

  tmp.df <- data.frame(json)
  input.df <- tmp.df[, names(json) %in% num_input]
  output.df <- tmp.df[, !names(json) %in% num_input]
  pred.weights <- neuralnet::compute(model, input.df)$net.result
  result.df <- cbind(output.df,
                      data.frame('nn_score'=c(pred.weights[,2])))
  return(as.list(result.df))
}

### Arity of CDSW Model function must be 1
scoring <- function(args) {
  return(nn_scoring(args))
}

# sample <- '{
#   "msisdn": 632001647830,
#   "pxn_mo": 7,
#   "pxn_yr": 2018,
#   "avg_meanthroughputul": -0.36,
#   "avg_meanthroughputdl": 0.02,
#   "min_totaldataul": 0,
#   "max_totaldataul": -0.58,
#   "sum_totaldataul": -0.61,
#   "avg_totaldataul": -0.05,
#   "min_totaldatadl": 0,
#   "max_totaldatadl": 1.36,
#   "sum_totaldatadl": -0.39,
#   "avg_totaldatadl": 0.37,
#   "avg_internetlatency": -0.2,
#   "avg_httpsuccessratio": 0.37
# }'
#
# library(jsonlite)
# print(nn_scoring(fromJSON(sample)))
