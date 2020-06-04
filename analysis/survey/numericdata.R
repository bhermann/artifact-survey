# This script analyses the questions with numerical answers from the survey.
# It outputs a file numericresults.txt which contains textual representations of the answers given.
# It also produces a chart (au-matrices.svg) on the prevalence of artifact usage.

if (!require("readxl")) install.packages("readxl")
if (!require("dplyr")) install.packages("dplyr")
if (!require("tidyr")) install.packages("tidyr")
if (!require("stringr")) install.packages("stringr")
if (!require("ggplot2")) install.packages("ggplot2")

library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)

full_results <- read_excel("../../results/results-survey54231.xlsx")
questions <- read_excel("../../questionnaire/survey-questions.xlsx")

unlink( "output/numericresults.txt")
sink("output/numericresults.txt")

# remove unusable replies from ID 99 and 218
full_results <- full_results %>% filter(id != 99 & id != 218)

lookupQuestionText <- function(questionCode) {
  return (filter(questions, Code == questionCode)$Text)
}

# YES/NO questions
g1 <- select(full_results, g1) %>% group_by(g1) %>% tally
ae6 <- select(full_results, ae6) %>% group_by(ae6) %>% tally
ae10 <- select(full_results, ae10) %>% group_by(ae10) %>% tally
au3 <- select(full_results, au3) %>% group_by(au3) %>% tally
au6 <- select(full_results, au6) %>% group_by(au6) %>% tally
au9 <- select(full_results, au9) %>% group_by(au9) %>% tally
au10 <- select(full_results, au10) %>% group_by(au10) %>% tally
f0 <- select(full_results, f0) %>% group_by(f0) %>% tally

artifact.printYNresults <- function(questionCode, data) {
  questionText <- lookupQuestionText(questionCode)
  missing <- data[1,2]
  negative <- data[2,2]
  positive <- data[3,2]
  present <- negative + positive
  positivePercentage <- round(positive / present * 100, digits = 2)
  negativePercentage <- round(negative / present * 100, digits = 2)
  total <- present + missing
  print(str_glue("{questionCode}: {questionText}"))
  print(str_glue("We received {present} answers. {positive} ({positivePercentage} %) were positive. {negative} ({negativePercentage} %) were negative."))
}

artifact.printYNresults("g1", g1)
artifact.printYNresults("ae6", ae6)
artifact.printYNresults("ae10", ae10)
artifact.printYNresults("au3", au3)
artifact.printYNresults("au6", au6)
artifact.printYNresults("au9", au9)
artifact.printYNresults("au10", au10)
artifact.printYNresults("f0", f0)

# Matrix questions
g2 <- select(full_results, `g2[SQ001]`) %>% group_by(`g2[SQ001]`) %>% tally
au1 <- select(full_results, artifact_counts = `au1[SQ001]`) %>% group_by(artifact_counts) %>% tally %>% rename(Code = n)
au4 <- select(full_results, artifact_counts = `au4[SQ001]`) %>% group_by(artifact_counts) %>% tally %>% rename(Proofs = n)
au7 <- select(full_results, artifact_counts = `au7[SQ001]`) %>% group_by(artifact_counts) %>% tally %>% rename(Data = n)

au <- full_join(au1, au4, by = "artifact_counts") %>% full_join(au7, by = "artifact_counts") %>% mutate_all(~replace(., is.na(.), 0)) %>% gather("au","Count",-artifact_counts)
au$artifact_counts <- factor(au$artifact_counts, levels = c("None","1-5","5-10","10-20","20-30","0"))

auMatrixQuestions <- full_results %>% select(au1 = `au1[SQ001]`, au4 = `au4[SQ001]`, au7 = `au7[SQ001]`)

# number of participants who answered artifact usage questions
nAU <- nrow(auMatrixQuestions %>% filter(!is.na(au1) & !is.na(au4) & !is.na(au7)))

# number of particpiants with artifact usage experience
eAU <- nrow(auMatrixQuestions %>% filter(au1 != "None" | au4 != "None" | au7 != "None"))

sprintf("%d out of %d participants indicated experience with artifact usage of any artifact type.", eAU, nAU)

au_matrix_plot <- ggplot(au[au$artifact_counts != 0,], aes(x = au, y = Count, fill = au)) +
  facet_grid(cols = vars(artifact_counts)) +
  geom_bar(stat = "identity") +
  geom_text(aes(y=Count, label = Count), position = position_dodge(0.9), vjust = -0.3, size = 3) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(axis.title.x = element_blank()) +
  scale_fill_brewer(type = "qual", palette = "Dark2") +
  labs(fill = "Artifact\nType")
ggsave("output/au-matrices.svg")
