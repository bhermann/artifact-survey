# This script is a helper script to allow analysis differentiation between communities.
# In particular, the 'experience' indicators after quotations in the paper have been derived from this analysis.

if (!require("dplyr")) install.packages("dplyr")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("svglite")) install.packages("svglite")
if (!require("stringr")) install.packages("stringr")

library(dplyr)
library(ggplot2)
library(readxl)
library(stringr)

SurveyData <- read_excel("../../results/results-survey54231.xlsx")
SurveyData <- SurveyData %>% filter(id != 99 & id!= 218)

# SE/PL conferences
SEConfs <- c("ICSE","FSE","ISSTA","VISSOFT","MODELS","CAV")
PLConfs <- c("OOPSLA","PLDI","POPL","ECOOP","SAS","SLE","PPoPP","PPOPP","CGO","ICFP","TACAS")

# community? cross-community?
serviceByID <- SurveyData %>%
  mutate_at(vars(starts_with("g0")),
            funs(ifelse(!is.na(.),
                        str_match(substitute(.),"g0\\[C(.+)_Y[:digit:]{4}")[,2],
                        NA)))

# participant experience: number of AECs served on

serviceByID <- serviceByID %>%
  select_if(~!all(is.na(.))) %>% # drop all NA columns
  select(id,starts_with("g0")) %>% # restrict to ID and g0 columns
  filter(rowSums(!is.na(select(., starts_with("g0")))) != 0) # get rid of rows with only NAs in the conference fields

serviceByID <- serviceByID %>%
  mutate(experienceSE=colSums(apply(serviceByID,1,'%in%',SEConfs) == TRUE, na.rm = TRUE)) %>%
  mutate(experiencePL=colSums(apply(serviceByID,1,'%in%',PLConfs) == TRUE, na.rm = TRUE))

serviceByID <- serviceByID %>%
  mutate(se=experienceSE >= 1) %>%
  mutate(pl=experiencePL >= 1) %>%
  mutate(cross=se & pl)

# experience recency: max(AEC years with !NA) - 2011

## replace all positive g0 answers with the year from the column name
serviceByID <- serviceByID %>%
  mutate_at(vars(starts_with("g0")),
            funs(ifelse(!is.na(.),
                        str_match(substitute(.),"g0\\[.+_Y([:digit:]{4})")[,2],
                        NA)))

## calculate experience recency
g0sPL <- serviceByID[,str_match(colnames(serviceByID),"g0\\[C(.+)_Y")[,2] %in% PLConfs]
g0sSE <- serviceByID[,str_match(colnames(serviceByID),"g0\\[C(.+)_Y")[,2] %in% SEConfs]
serviceByID <- serviceByID %>%
  mutate(maxyearPL=apply(g0sPL,1,max,na.rm=TRUE)) %>%
  mutate(minyearPL=apply(g0sPL,1,min,na.rm=TRUE)) %>%
  mutate(recencyPL=ifelse(!is.na(maxyearPL),2019-as.numeric(maxyearPL),NA)) %>%
  mutate(maxyearSE=apply(g0sSE,1,max,na.rm=TRUE)) %>%
  mutate(minyearSE=apply(g0sSE,1,min,na.rm=TRUE)) %>%
  mutate(recencySE=ifelse(!is.na(maxyearSE),2019-as.numeric(maxyearSE),NA))

# spread of distances between first and last AEC service (if > 1)
serviceByID <- serviceByID %>%
  mutate(spreadSE = ifelse(experienceSE > 0,as.numeric(maxyearSE) - as.numeric(minyearSE),NA)) %>%
  mutate(spreadPL = ifelse(experiencePL > 0,as.numeric(maxyearPL) - as.numeric(minyearPL),NA))

# how many participants that answered free text have answered g0?
# how many participants that answered g0 have answered free text?

SurveyData <- merge(SurveyData,serviceByID %>% select(id,experiencePL,experienceSE,recencyPL,recencySE,spreadPL,spreadSE),by="id",all = TRUE)
gFreetextQuestions <- c("g3","g4")
aeFreetextQuestions <- c("ae1","ae2","ae3","ae4","ae5","ae7","ae8","ae9","ae11")
auFreetextQuestions <- c("au2","au5","au8","au11","au12")
fFreetextQuestions <- c("f01","f02","f03","f99")

numberG0 <-nrow(serviceByID)
numberFreetextG <- nrow(SurveyData %>% select(gFreetextQuestions) %>% filter(rowSums(!is.na(.)) != 0))
numberFreetextAE <- nrow(SurveyData %>% select(aeFreetextQuestions) %>% filter(rowSums(!is.na(.)) != 0))
numberFreetextAU <- nrow(SurveyData %>% select(auFreetextQuestions) %>% filter(rowSums(!is.na(.)) != 0))
numberFreetextF <- nrow(SurveyData %>% select(fFreetextQuestions) %>% filter(rowSums(!is.na(.)) != 0))
numberG0andFreetextG <- nrow(SurveyData %>%
                               select(gFreetextQuestions,experienceSE,experiencePL) %>%
                               filter(rowSums(!is.na(select(.,gFreetextQuestions))) != 0) %>%
                               filter(!is.na(experienceSE) | !is.na(experiencePL)))
numberG0andFreetextAE <- nrow(SurveyData %>%
                                select(aeFreetextQuestions,experienceSE,experiencePL) %>%
                                filter(rowSums(!is.na(select(.,aeFreetextQuestions))) != 0) %>%
                                filter(!is.na(experienceSE) | !is.na(experiencePL)))
numberG0andFreetextAU <- nrow(SurveyData %>%
                                select(auFreetextQuestions,experienceSE,experiencePL) %>%
                                filter(rowSums(!is.na(select(.,auFreetextQuestions))) != 0) %>%
                                filter(!is.na(experienceSE) | !is.na(experiencePL)))
numberG0andFreetextF <- nrow(SurveyData %>%
                               select(fFreetextQuestions,experienceSE,experiencePL) %>%
                               filter(rowSums(!is.na(select(.,fFreetextQuestions))) != 0) %>%
                               filter(!is.na(experienceSE) | !is.na(experiencePL)))
