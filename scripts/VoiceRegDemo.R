# packages <- c('tuneR', 'seewave', 'gbm', 'xgboost')
# if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
#   install.packages(setdiff(packages, rownames(installed.packages())))
# }
#install.packages("pbapply")
#install.packages("fftw")
options(warn=-1)
setwd("/Users/MandyZhang/Desktop/DATS6101-group-project-2")

# Function Definitions
checkValidArg <- function(arg) {
  if (!grepl("file=", arg)) {
    stop("Invalid Input. Expects: file=%filepath%")
  }
}

#check input arguements
args <- commandArgs(trailingOnly = TRUE);
fileArg <- args[1];
checkValidArg(fileArg)

# Run Recognition
load("models/rfModel.rda")
filepath = unlist(strsplit(fileArg, "="))[2]
cat(paste("Running Recognition on: ", filepath))
source("scripts/WavParser.R")
data <- data.frame()
row <- data.frame(filepath, 0, 0, 10)
#row <- data.frame("Track.wav", 0, 0, 10)
data <- rbind(data, row)
names(data) <- c('sound.files', 'selec', 'start', 'end')
setwd("data")
invisible(result <- specan3(data))
setwd("..")

selected = c( "meanfun","IQR","Q25","sd", "sp.ent","sfm", "meanfreq", "label" )
acoustics = result$acoustics
sample = acoustics[ , names(acoustics) %in% selected]

sample.pred = predict(rfModel,sample, type = "response")
cat("\n\nVoice Recognition Results: \n")
cat(as.character(sample.pred))
cat("\n\n")

options(warn=0)