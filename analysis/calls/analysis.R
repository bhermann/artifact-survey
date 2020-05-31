if (!require("dplyr")) install.packages("dplyr")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("svglite")) install.packages("svglite")
if (!require("stringr")) install.packages("stringr")

library(dplyr)
library(ggplot2)
library(readxl)
library(stringr)

sourceDir <- getSrcDirectory(function(dummy) {dummy})
workingdir <- paste0(sourceDir,"")
setwd(workingdir)

SEConfs <- c("ICSE","FSE","ISSTA","VISSOFT","MODELS","CAV")
PLConfs <- c("OOPSLA","PLDI","POPL","ECOOP","SAS","SLE","PPoPP","CGO","ICFP","TACAS")

CallData <- read.csv2(paste0(workingdir,"analysis.csv"))

purposeData <- as.vector(str_split(CallData$purpose,",",simplify = TRUE))
#purposeTags <- unique(purposeData)
purposeSE <- CallData %>% filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% SEConfs) %>% select(purpose)
purposeDataSE <- as.vector(str_split(purposeSE$purpose,",",simplify = TRUE))
#purposeTagsSE <- unique(purposeDataSE)
purposePL <- CallData %>% filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% PLConfs) %>% select(purpose)
purposeDataPL <- as.vector(str_split(purposePL$purpose,",",simplify = TRUE))
#purposeTagsPL <- unique(purposeDataPL)

badgesData <- as.vector(str_split(CallData$badges,",",simplify = TRUE))
#badgesTags <- unique(badgesData)
badgesSE <- CallData %>% filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% SEConfs) %>% select(badges)
badgesDataSE <- as.vector(str_split(badgesSE$badges,",",simplify = TRUE))
#badgesTagsSE <- unique(badgesDataSE)
badgesPL <- CallData %>% filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% PLConfs) %>% select(badges)
badgesDataPL <- as.vector(str_split(badgesPL$badges,",",simplify = TRUE))
#badgesTagsPL <- unique(badgesDataPL)

evaluationCriteriaData <- as.vector(str_split(CallData$evaluation_criteria,",",simplify = TRUE))
#evaluationCriteriaTags <- unique(evaluationCriteriaData)
evaluationSE <- CallData %>% filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% SEConfs) %>% select(evaluation_criteria)
evaluationCriteriaDataSE <- as.vector(str_split(evaluationSE$evaluation_criteria,",",simplify = TRUE))
#evaluationTagsSE <- unique(evaluationDataSE)
evaluationPL <- CallData %>% filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% PLConfs) %>% select(evaluation_criteria)
evaluationCriteriaDataPL <- as.vector(str_split(evaluationPL$evaluation_criteria,",",simplify = TRUE))
#evaluationTagsPL <- unique(evaluationDataPL)

submissionSE <- CallData %>% filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% SEConfs) %>% select(submission_criteria)
submissionPL <- CallData %>% filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% PLConfs) %>% select(submission_criteria)

# split submissionCriteriaTags that share 'documentation for' prefix

submissionCriteriaSplit <- as.vector(str_split(CallData$submission_criteria,",",simplify = TRUE))
submissionCriteriaSplit <- str_split(submissionCriteriaSplit,"/",simplify = TRUE)
xForTags <- grepl(".+ for .+",submissionCriteriaSplit[,1])
submissionCriteriaSplit[xForTags,-1][which(submissionCriteriaSplit[xForTags,-1] != "")] <-
  paste0(str_match(submissionCriteriaSplit[xForTags,1],"(.+ for )")[,2],
         submissionCriteriaSplit[xForTags,-1][which(submissionCriteriaSplit[xForTags,-1] != "")])
submissionCriteriaData <- as.vector(submissionCriteriaSplit)

submissionCriteriaSplitSE <- as.vector(str_split(submissionSE$submission_criteria,",",simplify = TRUE))
submissionCriteriaSplitSE <- str_split(submissionCriteriaSplitSE,"/",simplify = TRUE)
xForTags <- grepl(".+ for .+",submissionCriteriaSplitSE[,1])
submissionCriteriaSplitSE[xForTags,-1][which(submissionCriteriaSplitSE[xForTags,-1] != "")] <-
  paste0(str_match(submissionCriteriaSplitSE[xForTags,1],"(.+ for )")[,2],
         submissionCriteriaSplitSE[xForTags,-1][which(submissionCriteriaSplitSE[xForTags,-1] != "")])
submissionCriteriaDataSE <- as.vector(submissionCriteriaSplitSE)

submissionCriteriaSplitPL <- as.vector(str_split(submissionPL$submission_criteria,",",simplify = TRUE))
submissionCriteriaSplitPL <- str_split(submissionCriteriaSplitPL,"/",simplify = TRUE)
xForTags <- grepl(".+ for .+",submissionCriteriaSplitPL[,1])
submissionCriteriaSplitPL[xForTags,-1][which(submissionCriteriaSplitPL[xForTags,-1] != "")] <-
  paste0(str_match(submissionCriteriaSplitPL[xForTags,1],"(.+ for )")[,2],
         submissionCriteriaSplitPL[xForTags,-1][which(submissionCriteriaSplitPL[xForTags,-1] != "")])
submissionCriteriaDataPL <- as.vector(submissionCriteriaSplitPL)

submissionCriteriaSplit <- as.vector(str_split(CallData$submission_criteria,",",simplify = TRUE))
submissionCriteriaSplit <- str_split(submissionCriteriaSplit,"/",simplify = TRUE)
xForTags <- grepl(".+ for .+",submissionCriteriaSplit[,1])
submissionCriteriaSplit[xForTags,-1][which(submissionCriteriaSplit[xForTags,-1] != "")] <-
  paste0(str_match(submissionCriteriaSplit[xForTags,1],"(.+ for )")[,2],
         submissionCriteriaSplit[xForTags,-1][which(submissionCriteriaSplit[xForTags,-1] != "")])
submissionCriteriaData <- as.vector(submissionCriteriaSplit)

artifactTypesData <- as.vector(str_split(CallData$artifact_types,",",simplify = TRUE))
artifactTypesSE <- CallData %>% filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% SEConfs) %>% select(artifact_types)
artifactTypesDataSE <- as.vector(str_split(artifactTypesSE$artifact_types,",",simplify = TRUE))
artifactTypesPL <- CallData %>% filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% PLConfs) %>% select(artifact_types)
artifactTypesDataPL <- as.vector(str_split(artifactTypesPL$artifact_types,",",simplify = TRUE))
perTypeCriteriaData <- as.vector(str_split(CallData$per_type_criteria,",",simplify = TRUE))
perTypeCriteriaSE <- CallData %>% filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% SEConfs) %>% select(per_type_criteria)
perTypeCriteriaDataSE <- as.vector(str_split(perTypeCriteriaSE$per_type_criteria,",",simplify = TRUE))
perTypeCriteriaPL <- CallData %>% filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% PLConfs) %>% select(per_type_criteria)
perTypeCriteriaDataPL <- as.vector(str_split(perTypeCriteriaPL$per_type_criteria,",",simplify = TRUE))

# occurrences
## Debug me, I'm a generic version of the copy-paste crap below
# frequencies <- function(df,col){
#   column <- df[,col]
#   splitcolumn <- str_split(column,",",simplify = TRUE)
#   colData <- as.vector(splitcolumn)
#   return(as.data.frame(table(colData,dnn=list(col)),responseName="count") %>%
#            mutate(byNumberTags = ifelse(col == "",NA,count/sum(colData != "")),
#                   byAllCalls = ifelse(col == "",sum(column == "")/nrow(df),count/nrow(df)),
#                   byCallsWithTags = ifelse(col == "",NA,count/sum(column != ""))))
# }

purposeFreqs <- as.data.frame(table(purposeData,dnn=list("purpose")),responseName="count") %>%
  mutate(byNumberTags = ifelse(purpose == "",NA,count/sum(purposeData != "")),
         byAllCalls = ifelse(purpose == "",sum(CallData$purpose == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(purpose == "",NA,count/sum(CallData$purpose != "")))

badgesFreqs <- as.data.frame(table(badgesData,dnn=list("badges")),responseName="count") %>%
  mutate(byNumberTags = ifelse(badges == "",NA,count/sum(badgesData != "")),
         byAllCalls = ifelse(badges == "",sum(CallData$badges == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(badges == "",NA,count/sum(CallData$badges != "")))

evaluationFreqs <- as.data.frame(table(evaluationCriteriaData,dnn=list("evaluationCriteria")),responseName="count") %>%
  mutate(byNumberTags = ifelse(evaluationCriteria == "",NA,count/sum(evaluationCriteriaData != "")),
         byAllCalls = ifelse(evaluationCriteria == "",sum(CallData$evaluation_criteria == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(evaluationCriteria == "",NA,count/sum(CallData$evaluation_criteria != "")))

submissionFreqs <- as.data.frame(table(submissionCriteriaData,dnn=list("submissionCriteria")),responseName="count") %>%
  mutate(byNumberTags = ifelse(submissionCriteria == "",NA,count/sum(submissionCriteriaData != "")),
         byAllCalls = ifelse(submissionCriteria == "",sum(CallData$submission_criteria == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(submissionCriteria == "",NA,count/sum(CallData$submission_criteria != "")))

artifactTypeFreqs <- as.data.frame(table(artifactTypesData,dnn=list("artifactTypes")),responseName="count") %>%
  mutate(byNumberTags = ifelse(artifactTypes == "",NA,count/sum(artifactTypesData != "")),
         byAllCalls = ifelse(artifactTypes == "",sum(CallData$artifact_types == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(artifactTypes == "",NA,count/sum(CallData$artifact_types != "")))

perTypeCriteriaFreqs <- as.data.frame(table(perTypeCriteriaData,dnn=list("perTypeCriteria")),responseName="count") %>%
  mutate(byNumberTags = ifelse(perTypeCriteria == "",NA,count/sum(perTypeCriteriaData != "none")),
         byAllCalls = ifelse(perTypeCriteria == "",sum(CallData$per_type_criteria == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(perTypeCriteria == "",NA,count/sum(CallData$per_type_criteria != "")))

purposeFreqsSE <- as.data.frame(table(purposeDataSE,dnn=list("purpose")),responseName="count") %>%
  mutate(byNumberTags = ifelse(purpose == "",NA,count/sum(purposeDataSE != "")),
         byAllCalls = ifelse(purpose == "",sum(purposeSE$purpose == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(purpose == "",NA,count/sum(purposeSE$purpose != "")))

badgesFreqsSE <- as.data.frame(table(badgesDataSE,dnn=list("badges")),responseName="count") %>%
  mutate(byNumberTags = ifelse(badges == "",NA,count/sum(badgesDataSE != "")),
         byAllCalls = ifelse(badges == "",sum(badgesSE$badges == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(badges == "",NA,count/sum(badgesSE$badges != "")))

evaluationFreqsSE <- as.data.frame(table(evaluationCriteriaDataSE,dnn=list("evaluationCriteria")),responseName="count") %>%
  mutate(byNumberTags = ifelse(evaluationCriteria == "",NA,count/sum(evaluationCriteriaDataSE != "")),
         byAllCalls = ifelse(evaluationCriteria == "",sum(evaluationSE$evaluation_criteria == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(evaluationCriteria == "",NA,count/sum(evaluationSE$evaluation_criteria != "")))

submissionFreqsSE <- as.data.frame(table(submissionCriteriaDataSE,dnn=list("submissionCriteria")),responseName="count") %>%
  mutate(byNumberTags = ifelse(submissionCriteria == "",NA,count/sum(submissionCriteriaDataSE != "")),
         byAllCalls = ifelse(submissionCriteria == "",sum(submissionSE$submission_criteria == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(submissionCriteria == "",NA,count/sum(submissionSE$submission_criteria != "")))

artifactTypeFreqsSE <- as.data.frame(table(artifactTypesDataSE,dnn=list("artifactTypes")),responseName="count") %>%
  mutate(byNumberTags = ifelse(artifactTypes == "",NA,count/sum(artifactTypesDataSE != "")),
         byAllCalls = ifelse(artifactTypes == "",sum(artifactTypesSE$artifact_types == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(artifactTypes == "",NA,count/sum(artifactTypesSE$artifact_types != "")))

perTypeCriteriaFreqsSE <- as.data.frame(table(perTypeCriteriaDataSE,dnn=list("perTypeCriteria")),responseName="count") %>%
  mutate(byNumberTags = ifelse(perTypeCriteria == "",NA,count/sum(perTypeCriteriaDataSE != "none")),
         byAllCalls = ifelse(perTypeCriteria == "",sum(perTypeCriteriaSE$per_type_criteria == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(perTypeCriteria == "",NA,count/sum(perTypeCriteriaSE$per_type_criteria != "")))

purposeFreqsPL <- as.data.frame(table(purposeDataPL,dnn=list("purpose")),responseName="count") %>%
  mutate(byNumberTags = ifelse(purpose == "",NA,count/sum(purposeDataPL != "")),
         byAllCalls = ifelse(purpose == "",sum(purposePL$purpose == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(purpose == "",NA,count/sum(purposePL$purpose != "")))

badgesFreqsPL <- as.data.frame(table(badgesDataPL,dnn=list("badges")),responseName="count") %>%
  mutate(byNumberTags = ifelse(badges == "",NA,count/sum(badgesDataPL != "")),
         byAllCalls = ifelse(badges == "",sum(badgesPL$badges == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(badges == "",NA,count/sum(badgesPL$badges != "")))

evaluationFreqsPL <- as.data.frame(table(evaluationCriteriaDataPL,dnn=list("evaluationCriteria")),responseName="count") %>%
  mutate(byNumberTags = ifelse(evaluationCriteria == "",NA,count/sum(evaluationCriteriaDataPL != "")),
         byAllCalls = ifelse(evaluationCriteria == "",sum(evaluationPL$evaluation_criteria == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(evaluationCriteria == "",NA,count/sum(evaluationPL$evaluation_criteria != "")))

submissionFreqsPL <- as.data.frame(table(submissionCriteriaDataPL,dnn=list("submissionCriteria")),responseName="count") %>%
  mutate(byNumberTags = ifelse(submissionCriteria == "",NA,count/sum(submissionCriteriaDataPL != "")),
         byAllCalls = ifelse(submissionCriteria == "",sum(submissionPL$submission_criteria == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(submissionCriteria == "",NA,count/sum(submissionPL$submission_criteria != "")))

artifactTypeFreqsPL <- as.data.frame(table(artifactTypesDataPL,dnn=list("artifactTypes")),responseName="count") %>%
  mutate(byNumberTags = ifelse(artifactTypes == "",NA,count/sum(artifactTypesDataPL != "")),
         byAllCalls = ifelse(artifactTypes == "",sum(artifactTypesPL$artifact_types == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(artifactTypes == "",NA,count/sum(artifactTypesPL$artifact_types != "")))

perTypeCriteriaFreqsPL <- as.data.frame(table(perTypeCriteriaDataPL,dnn=list("perTypeCriteria")),responseName="count") %>%
  mutate(byNumberTags = ifelse(perTypeCriteria == "",NA,count/sum(perTypeCriteriaDataPL != "none")),
         byAllCalls = ifelse(perTypeCriteria == "",sum(perTypeCriteriaPL$per_type_criteria == "")/nrow(CallData),count/nrow(CallData)),
         byCallsWithTags = ifelse(perTypeCriteria == "",NA,count/sum(perTypeCriteriaPL$per_type_criteria != "")))

# scatterplots
