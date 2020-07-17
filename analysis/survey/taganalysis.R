
if (!require("readxl")) install.packages("readxl", repos="https://cloud.r-project.org")
if (!require("dplyr")) install.packages("dplyr", repos="https://cloud.r-project.org")
if (!require("tidyr")) install.packages("tidyr", repos="https://cloud.r-project.org")
if (!require("stringr")) install.packages("stringr", repos="https://cloud.r-project.org")

library(readxl)
library(dplyr)
library(tidyr)
library(stringr)

resultsDir <- "../../results/"

source("respondent-profiling.R")

unlink("output/tagresults.txt")
sink("output/tagresults.txt")

plIDs <- as.vector(serviceByID %>% filter(pl == TRUE) %>% select(id))$id
seIDs <- as.vector(serviceByID %>% filter(se == TRUE) %>% select(id))$id
crossIDs <- as.vector(serviceByID %>% filter(cross == TRUE) %>% select(id))$id
plOnlyIDs <- as.vector(serviceByID %>% filter(pl == TRUE & se == FALSE) %>% select(id))$id
seOnlyIDs <- as.vector(serviceByID %>% filter(se == TRUE & pl == FALSE) %>% select(id))$id



g4 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-G4.xlsx")))
ae1 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-AE1.xlsx")))
ae2 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-AE2.xlsx")))
ae3 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-AE3.xlsx")))
ae4 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-AE4.xlsx")))
ae5 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-AE5.xlsx")))
ae7 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-AE7.xlsx")))
ae8 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-AE8.xlsx")))
ae9 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-AE9.xlsx")))
ae11 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-AE11.xlsx")))
au2 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-AU2.xlsx")))
au5 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-AU5.xlsx")))
au8 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-AU8.xlsx")))
au11 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-AU11.xlsx")))
au12 <- suppressMessages(read_excel(paste0(resultsDir,"AEC-Survey-AU12.xlsx")))
questions <- suppressMessages(read_excel("../../questionnaire/survey-questions.xlsx"))


artifact.datareport <- function(rawData, full = FALSE, community = 'all') {
  questionCode <- colnames(rawData)[2]
  questionText <- filter(questions, Code == questionCode)$Text
  rawData <- switch(community,
                    'all' = rawData,
                    'pl' = rawData %>% filter(id %in% plIDs),
                    'se' = rawData %>% filter(id %in% seIDs),
                    'cross' = rawData %>% filter(id %in% crossIDs),
                    'plOnly' = rawData %>% filter(id %in% plOnlyIDs),
                    'seOnly' = rawData %>% filter(id %in% plIDs)
                    )
  answerCount <- sum(!is.na(rawData[,2]))
  onlyTags <-  select(rawData, 3:ncol(rawData))
  tags <- arrange(unique(select(drop_na(gather(onlyTags, key="var", value="tag", 1:ncol(onlyTags))), tag)),tag)
  countUsage <- function(tag) {
    return (sum(str_count(onlyTags, fixed(tag))))
  }
  tagUsage <- arrange(mutate(tags, usage = sapply(tag, countUsage)), desc(usage))

  if (community == 'all') {
    communityText <- ""
  } else {
    communityText <- str_glue(" in the {community} community")
  }

  print(str_glue("{questionCode}: {questionText}"))
  print(str_glue("For question code {questionCode}{communityText} we received {answerCount} answers."))

  if (full) {
    numberOfElements <- 1000
  } else {
    numberOfElements <- 20
  }
  print(str_glue("Top {numberOfElements} tags were:"))
  print(tagUsage, n = numberOfElements)
  print(str_glue("\n"))

  tagUsage <- data.frame(tagUsage)
  return(tagUsage[order(tagUsage$usage,decreasing = TRUE),])
}

print(str_glue("---- G4   ----"))
g4all <- artifact.datareport(g4, TRUE)
g4PL <- artifact.datareport(g4, TRUE, 'pl')
g4SE <- artifact.datareport(g4, TRUE, 'se')
g4 <- merge(g4all,merge(g4PL,g4SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(g4PL$tag,10)==head(g4SE$tag,10))) { print("g4 differs across communities") }
print(str_glue("--------------\n\n"))

print(str_glue("---- AE1  ----"))
ae1all <- artifact.datareport(ae1, TRUE)
ae1PL <- artifact.datareport(ae1, TRUE, 'pl')
ae1SE <- artifact.datareport(ae1, TRUE, 'se')
ae1 <- merge(ae1all,merge(ae1PL,ae1SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(ae1PL$tag,10)==head(ae1SE$tag,10))) { print("ae1 differs across communities") }
print(str_glue("--------------\n\n"))

print(str_glue("---- AE2  ----"))
ae2all <- artifact.datareport(ae2, TRUE)
ae2PL <- artifact.datareport(ae2, TRUE, 'pl')
ae2SE <- artifact.datareport(ae2, TRUE, 'se')
ae2 <- merge(ae2all,merge(ae2PL,ae2SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(ae2PL$tag,10)==head(ae2SE$tag,10))) { print("ae2 differs across communities") }
print(str_glue("--------------\n\n"))

print(str_glue("---- AE3  ----"))
ae3all <- artifact.datareport(ae3, TRUE)
ae3PL <- artifact.datareport(ae3, TRUE, 'pl')
ae3SE <- artifact.datareport(ae3, TRUE, 'se')
ae3 <- merge(ae3all,merge(ae3PL,ae3SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(ae3PL$tag,10)==head(ae3SE$tag,10))) { print("ae3 differs across communities") }
print(str_glue("--------------\n\n"))

print(str_glue("---- AE4  ----"))
ae4all <- artifact.datareport(ae4, TRUE)
ae4PL <- artifact.datareport(ae4, TRUE, 'pl')
ae4SE <- artifact.datareport(ae4, TRUE, 'se')
ae4 <- merge(ae4all,merge(ae4PL,ae4SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(ae4PL$tag,10)==head(ae4SE$tag,10))) { print("ae4 differs across communities") }
print(str_glue("--------------\n\n"))

print(str_glue("---- AE5  ----"))
ae5all <- artifact.datareport(ae5, TRUE)
ae5PL <- artifact.datareport(ae5, TRUE, 'pl')
ae5SE <- artifact.datareport(ae5, TRUE, 'se')
ae5 <- merge(ae5all,merge(ae5PL,ae5SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(ae5PL$tag,10)==head(ae5SE$tag,10))) { print("ae5 differs across communities") }
print(str_glue("--------------\n\n"))

print(str_glue("---- AE7  ----"))
ae7all <- artifact.datareport(ae7, TRUE)
ae7PL <- artifact.datareport(ae7, TRUE, 'pl')
ae7SE <- artifact.datareport(ae7, TRUE, 'se')
ae7 <- merge(ae7all,merge(ae7PL,ae7SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(ae7PL$tag,10)==head(ae7SE$tag,10))) { print("ae7 differs across communities") }
print(str_glue("--------------\n\n"))

print(str_glue("---- AE8  ----"))
ae8all <- artifact.datareport(ae8, TRUE)
ae8PL <- artifact.datareport(ae8, TRUE, 'pl')
ae8SE <- artifact.datareport(ae8, TRUE, 'se')
ae8 <- merge(ae8all,merge(ae8PL,ae8SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(ae8PL$tag,10)==head(ae8SE$tag,10))) { print("ae8 differs across communities") }
print(str_glue("--------------\n\n"))

print(str_glue("---- AE9  ----"))
ae9all <- artifact.datareport(ae9, TRUE)
ae9PL <- artifact.datareport(ae9, TRUE, 'pl')
ae9SE <- artifact.datareport(ae9, TRUE, 'se')
ae9 <- merge(ae9all,merge(ae9PL,ae9SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(ae9PL$tag,10)==head(ae9SE$tag,10))) { print("ae9 differs across communities") }
print(str_glue("--------------\n\n"))

print(str_glue("---- AE11 ----"))
ae11all <- artifact.datareport(ae11, TRUE)
ae11PL <- artifact.datareport(ae11, TRUE, 'pl')
ae11SE <- artifact.datareport(ae11, TRUE, 'se')
ae11 <- merge(ae11all,merge(ae11PL,ae11SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(ae11PL$tag,10)==head(ae11SE$tag,10))) { print("ae11 differs across communities") }
print(str_glue("--------------\n\n"))

print(str_glue("---- AU2  ----"))
au2all <- artifact.datareport(au2, TRUE)
au2PL <- artifact.datareport(au2, TRUE, 'pl')
au2SE <- artifact.datareport(au2, TRUE, 'se')
au2 <- merge(au2all,merge(au2PL,au2SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(au2PL$tag,10)==head(au2SE$tag,10))) { print("au2 differs across communities") }
print(str_glue("--------------\n\n"))

print(str_glue("---- AU5  ----"))
au5all <- artifact.datareport(au5, TRUE)
au5PL <- artifact.datareport(au5, TRUE, 'pl')
au5SE <- artifact.datareport(au5, TRUE, 'se')
au5 <- merge(au5all,merge(au5PL,au5SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(au5PL$tag,10)==head(au5SE$tag,10))) { print("au5 differs across communities") }
print(str_glue("--------------\n\n"))

print(str_glue("---- AU8  ----"))
au8all <- artifact.datareport(au8, TRUE)
au8PL <- artifact.datareport(au8, TRUE, 'pl')
au8SE <- artifact.datareport(au8, TRUE, 'se')
au8 <- merge(au8all,merge(au8PL,au8SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(au8PL$tag,10)==head(au8SE$tag,10))) { print("au8 differs across communities") }
print(str_glue("--------------\n\n"))

print(str_glue("---- AU11 ----"))
au11all <- artifact.datareport(au11, TRUE)
au11PL <- artifact.datareport(au11, TRUE, 'pl')
au11SE <- artifact.datareport(au11, TRUE, 'se')
au11 <- merge(au11all,merge(au11PL,au11SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(au11PL$tag,10)==head(au11SE$tag,10))) { print("au11 differs across communities") }
print(str_glue("--------------\n\n"))

print(str_glue("---- AU12 ----"))
au12all <- artifact.datareport(au12, TRUE)
au12PL <- artifact.datareport(au12, TRUE, 'pl')
au12SE <- artifact.datareport(au12, TRUE, 'se')
au12 <- merge(au12all,merge(au12PL,au12SE,all=TRUE,by="tag"),all=TRUE,by="tag")
if (!all(head(au12PL$tag,10)==head(au12SE$tag,10))) { print("au12 differs across communities") }
print(str_glue("--------------\n\n"))
