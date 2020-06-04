"This file contains R code to extract and summarize information from a (mostly) manually conducted analysis
 of calls for artifacts in SE and PL conferences. The call analysis data can be found in the file callAnalysisResults.csv.
"

if (!require("dplyr")) install.packages("dplyr")
if (!require("stringr")) install.packages("stringr")
if (!require("readxl")) install.packages("readxl")
if (!require("gsubfn")) install.packages("gsubfn")

library(dplyr)
library(readxl)
library(stringr)
library(gsubfn)

sourceDir <- getSrcDirectory(function(dummy) {dummy})
sourceDir <- paste0(sourceDir,"/")
setwd(sourceDir)

SEConfs <- c("ICSE","FSE","ISSTA","VISSOFT","MODELS","CAV")
PLConfs <- c("OOPSLA","PLDI","POPL","ECOOP","SAS","SLE","PPoPP","CGO","ICFP","TACAS")

CallData <- read.csv2(paste0(sourceDir,"analysis.csv"))

extractAnalysisData <- function(dataFrame,column){
    extractedData <- as.vector(str_split(dataFrame[[column]],",",simplify = TRUE))
    columnSE <- dataFrame %>% filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% SEConfs) %>% select(column)
    extractedDataSE <- as.vector(str_split(columnSE[[column]],",",simplify = TRUE))
    columnPL <- dataFrame %>% filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% PLConfs) %>% select(column)
    extractedDataPL <- as.vector(str_split(columnPL[[column]],",",simplify = TRUE))
    return(list(extractedData,extractedDataSE,extractedDataPL,columnSE,columnPL))
}

# extract information on AE purpose from call data
list[purposeData, purposeDataSE, purposeDataPL, purposeSE, purposePL] <-
    extractAnalysisData(CallData,"purpose")

# extract information on badges from call data
list[badgesData, badgesDataSE, badgesDataPL, badgesSE, badgesPL] <-
    extractAnalysisData(CallData,"badges")

# extract information on AE criteria from call data
list[evaluationCriteriaData, evaluationCriteriaDataSE, evaluationCriteriaDataPL, evaluationCriteriaSE, evaluationCriteriaPL] <-
    extractAnalysisData(CallData,"evaluation_criteria")

# extract information on artifact types from call data
list[artifactTypesData, artifactTypesDataSE, artifactTypesDataPL, artifactTypesSE, artifactTypesPL] <-
    extractAnalysisData(CallData,"artifact_types")

# extract information on per-artifact-type criteria from call data
list[perTypeCriteriaData, perTypeCriteriaDataSE, perTypeCriteriaDataPL, perTypeCriteriaSE, perTypeCriteriaPL] <-
    extractAnalysisData(CallData,"per_type_criteria")

# split submissionCriteriaTags that share 'documentation for' prefix

splitCriteria <- function(dataFrame){
    criteriaSplit <- as.vector(str_split(dataFrame$submission_criteria,",",simplify = TRUE))
    criteriaSplit <- str_split(criteriaSplit,"/",simplify = TRUE)
    xForTags <- grepl(".+ for .+",criteriaSplit[,1])
    criteriaSplit[xForTags,-1][which(criteriaSplit[xForTags,-1] != "")] <-
         paste0(str_match(criteriaSplit[xForTags,1],"(.+ for )")[,2],
         criteriaSplit[xForTags,-1][which(criteriaSplit[xForTags,-1] != "")])
    criteriaData <- as.vector(criteriaSplit)
    return(criteriaData)
}

submissionCriteriaData <- splitCriteria(CallData)

submissionCriteriaSE <- CallData %>%
    filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% SEConfs) %>%
    select(submission_criteria)
submissionCriteriaDataSE <- splitCriteria(submissionSE)

submissionCriteriaPL <- CallData %>%
    filter(str_match(conference,"(.+)[:digit:]{2}")[,2] %in% PLConfs) %>%
    select(submission_criteria)
submissionCriteriaDataPL <- splitCriteria(submissionPL)

# calculation of frequencies for discussion in the paper; the frequencies are organized in individual data frames

frequencies <- function(data,subdata,basedata,col){
  return(as.data.frame(table(subdata,dnn=list(col)),responseName="count") %>%
           mutate(byNumberTags = ifelse(eval(as.name(col)) == "",NA,count/sum(subdata != "")),
                  byAllCalls = ifelse(eval(as.name(col)) == "",sum(data[[col]] == "")/nrow(basedata),count/nrow(basedata)),
                  byCallsWithTags = ifelse(eval(as.name(col)) == "",NA,count/sum(data[[col]] != ""))))
}

purposeFreqs <- frequencies(CallData,purposeData,CallData,"purpose")
purposeFreqsSE <- frequencies(purposeSE,purposeDataSE,CallData,"purpose")
purposeFreqsPL <- frequencies(purposePL,purposeDataPL,CallData,"purpose")

badgesFreqs <- frequencies(CallData,badgesData,CallData,"badges")
badgesFreqsSE <- frequencies(badgesSE,badgesDataSE,CallData,"badges")
badgesFreqsPL <- frequencies(badgesPL,badgesDataPL,CallData,"badges")

evaluationFreqs <- frequencies(CallData,evaluationCriteriaData,CallData,"evaluation_criteria")
evaluationFreqsSE <- frequencies(evaluationCriteriaSE,evaluationCriteriaDataSE,CallData,"evaluation_criteria")
evaluationFreqsPL <- frequencies(evaluationCriteriaPL,evaluationCriteriaDataPL,CallData,"evaluation_criteria")

submissionFreqs <- frequencies(CallData,submissionCriteriaData,CallData,"submission_criteria")
submissionFreqsSE <- frequencies(submissionCriteriaSE,submissionCriteriaDataSE,CallData,"submission_criteria")
submissionFreqsPL <- frequencies(submissionCriteriaPL,submissionCriteriaDataPL,CallData,"submission_criteria")

artifactTypeFreqs <- frequencies(CallData,artifactTypesData,CallData,"artifact_types")
artifactTypeFreqsSE <- frequencies(artifactTypesSE,artifactTypesDataSE,CallData,"artifact_types")
artifactTypeFreqsPL <- frequencies(artifactTypesPL,artifactTypesDataPL,CallData,"artifact_types")

perTypeCriteriaFreqs <- frequencies(CallData,perTypeCriteriaData,CallData,"per_type_criteria")
perTypeCriteriaFreqsSE <- frequencies(perTypeCriteriaSE,perTypeCriteriaDataSE,CallData,"per_type_criteria")
perTypeCriteriaFreqsPL <- frequencies(perTypeCriteriaPL,perTypeCriteriaDataPL,CallData,"per_type_criteria")
