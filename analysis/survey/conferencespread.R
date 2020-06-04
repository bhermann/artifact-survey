# This script produces a chart indicating the size of AE committees at the inspected conferences.
# Overlayed are the number of respondents from the inspected AECs.

if (!require("readxl")) install.packages("readxl")
if (!require("dplyr")) install.packages("dplyr")
if (!require("tidyr")) install.packages("tidyr")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("tibble")) install.packages("tibble")

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(tibble)

# Read in the complete survey result data
SurveyData <- read_excel("../../results/results-survey54231.xlsx")

# remove unusable replies from ID 99 and 218
SurveyData <- SurveyData %>% filter(id != 99 & id != 218)

# The sequences of conferences as asked in the survey
Conferences <- list("ICSE", "FSE","ISSTA","SAS","VISSOFT","OOPSLA","ECOOP","POPL","PLDI","SLE", "PPoPP","ICFP","CGO", "MODELS", "CAV", "TACAS")

# Tabulates the summarized results by conference/year
ConferenceMatrix <-
  rename(
    add_column(
      as.data.frame(do.call(rbind, split.default(colSums(select(SurveyData, `g0[CICSE_Y2011]`:`g0[CTACAS_Y2019]`), na.rm = TRUE), rep(1:16, each=9)))),
      ConferenceId = 1:16, Conference = unlist(Conferences), .before = 1),
    `2011` = `g0[CICSE_Y2011]`, `2012` = `g0[CICSE_Y2012]`, `2013` = `g0[CICSE_Y2013]`,
    `2014` = `g0[CICSE_Y2014]`, `2015` = `g0[CICSE_Y2015]`, `2016` = `g0[CICSE_Y2016]`,
    `2017` = `g0[CICSE_Y2017]`, `2018` = `g0[CICSE_Y2018]`, `2019` = `g0[CICSE_Y2019]`
    )

CommitteeData <- rename(separate(tally(group_by(read_excel("../../results/aec.xlsx"), Conference)),
                          Conference, sep = " ", into = c("Conference", "year")),
                        `committee_size` = `n`)


ConferencePlotData <- filter(gather(ConferenceMatrix, key="year", value="value", `2011`:`2019`), value > 0)
FullPlotData <- mutate(full_join(CommitteeData, ConferencePlotData, by = c("Conference", "year")),
                       committee_size = ifelse(is.na(committee_size), 0, committee_size),
                       value = ifelse(is.na(value), 0, value),
                       ConferenceId = ifelse(is.na(ConferenceId), match(Conference, Conferences), ConferenceId))

lconf <- function(index) { return (Conferences[index]) }
ConferencePlot <- ggplot(FullPlotData, aes(x = year, y = ConferenceId)) +
  geom_point(aes(size = (committee_size)), color = "green", alpha=.4, show.legend = FALSE) +
  geom_point(aes(size = (ifelse(value == 0, NA, value))), alpha=.7, color = "red", show.legend = FALSE) +
  geom_text(aes(label = paste(value, "/", committee_size)), size = 2.5, position = position_nudge(y = -0.2, x = 0.32)) +
  scale_y_discrete(limits = 1:16, breaks = 1:16, labels = lconf, drop = FALSE, position = "right", name = "") +
  scale_size_area(max_size=15)
#show(ConferencePlot)
ggsave(ConferencePlot, filename="output/ConferencePlot.pdf")
