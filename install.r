# package install script called via cdsw-build.sh
# https://www.cloudera.com/documentation/data-science-workbench/latest/topics/cdsw_engines_models_experiments.html#cdsw_engines_models_experiments

list.of.packages <- c("neuralnet") 
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,'Package'])] 
if (length(new.packages)) {
  install.packages(new.packages, repos='https://cran.revolutionanalytics.com/')
}
