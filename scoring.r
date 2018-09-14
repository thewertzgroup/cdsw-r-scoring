# source install.r to install required packages

library(neuralnet)

options(scipen = 999)

nn_model <- readRDS("lte_nn_model.rds")

### Declare the numeric label(s)
num_label <-
  c("avg_meanthroughputul",
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

### Arity of CDSW Model function must be 1
scoring <- function(args) {

  make.result <- function(score, code, message) {
    res <- list(score, code, message)
    attr(res, "names") <- c("nn_score", "error_code", "error_message")
    return(res)
  }

  if (is.null(args$payload_type)) {
    return(make.result(-1, -100, "Missing 'payload_type'"))
  }
  if (args$payload_type == 'full') {
    exists <- names(args)[names(args) %in% num_label]
    if (length(exists) != length(num_label)) {
      missing <- num_label[!num_label %in% exists]
      return(make.result(-1, -1, paste("Missing key in input `", missing, "'", sep="")))
    }
    input.vector <- list(
      args[num_label[1]][[1]], args[num_label[2]][[1]], args[num_label[3]][[1]],
      args[num_label[4]][[1]], args[num_label[5]][[1]], args[num_label[6]][[1]],
      args[num_label[7]][[1]], args[num_label[8]][[1]], args[num_label[9]][[1]],
      args[num_label[10]][[1]],args[num_label[11]][[1]],args[num_label[12]][[1]])
    attr(input.vector, "names") <- num_label
    input.df <- data.frame(input.vector)
    pred.weights <- neuralnet::compute(nn_model, input.df)$net.result
    return(make.result(pred.weights[,2], 0, "Success"))
  }
  else if (args$payload_type == 'simple') {
    if (is.null(args$body)) {
      return(make.result(-1, -101, "Missing 'body' in simple payload_type"))
    }
    else if (length(args$body) < length(num_label)) {
      return(make.result(-1, -201,
                         paste("Not enough values specified in 'body' (",
                               length(args$body), ")", sep="")))
    }
    else if (length(args$body) > length(num_label)) {
      return(make.result(-1, -202,
                         paste("Too many values specified in 'body (",
                               length(args$body), ")", sep="")))
    }
    else {
      input.vector <- as.list(args$body)
      attr(input.vector, "names") <- num_label
      input.df <- data.frame(input.vector)
      pred.weights <- neuralnet::compute(nn_model, input.df)$net.result
      return(make.result(pred.weights[,2], 0, "Success"))
    }
  }
  else {
    return(make.result(-1, -200, "Unknown value specified for 'payload_type'"))
  }
}
