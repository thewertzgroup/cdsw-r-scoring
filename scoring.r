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

  make.result <- function(score, code, message) {
    res <- list(score, code, message)
    attr(res, "names") <- c("nn_score", "error_code", "error_message")
    return(res)
  }

  if (is.null(args$payload_type)) {
    return(make.result(-1, -1, "Missing 'payload_type'"))
  }
  if (args$payload_type == 'full') {
    return('full')
  }
  else if (args$payload_type == 'simple') {
    return('simple')
  }
  else {
    return(make.result(-1, -1, "Unknown value specified for 'payload_type'"))
  }
#  return(nn_scoring(args))
}
