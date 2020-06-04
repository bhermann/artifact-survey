sourceDir <- getSrcDirectory(function(dummy) {dummy})
setwd(paste0(sourceDir,"/"))

source("conferencespread.R")
source("participant_stats.R")
source("numericdata.R")
source("taganalysis.R")
