# This script produces a plot of the histogram of individuals by number of AECs served in partioned by invited and responded

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

sourceDir <- getSrcDirectory(function(dummy) {dummy})

SurveyData <- read_excel(paste0(sourceDir, "../../results/results-survey54231.xlsx"))

# trim data to the same set we tagged
SurveyData <- SurveyData %>% filter(id <= 273)

# remove unusable replies from ID 99 and 218
SurveyData <- SurveyData %>% filter(id != 99 & id != 218)

survey_hist_data <- as.data.frame(rowSums(SurveyData %>% select(`g0[CICSE_Y2011]`:`g0[CTACAS_Y2019]`), na.rm = TRUE))
names(survey_hist_data) <- "served_in"

survey_hist_data <- survey_hist_data %>% group_by(served_in) %>% tally %>% filter(served_in > 0)

aec <- read_excel("../../results/aec.xlsx")

aec_hist_data <- aec %>% group_by(`Full name`) %>% tally %>% rename(served_in = n) %>% group_by(served_in) %>% tally %>% rbind(c(7, 0)) %>% arrange(served_in)

full_hist_data <- aec_hist_data %>% dplyr::left_join(survey_hist_data, by="served_in")  %>% replace_na(list(n.y = 0)) %>% rename(invited=n.x, responded=n.y)

full_plot_data <- full_hist_data %>% gather(var, val, invited, responded)

aec_hist_plot <- ggplot(data = full_plot_data, aes(x=served_in, y=val, fill=var)) +
  scale_x_discrete(limits = c(1:10)) +
  geom_bar(position="dodge", stat = "identity") +
  geom_text(position=position_dodge(width=0.9), aes(label=val), vjust=-0.8, color="black", size=3.5) +
  labs(x = "Committees served in", y = "Number of individuals", fill="") +
  theme_minimal()+ theme(legend.position = c(0.8, 0.8))

ggsave(aec_hist_plot, filename="output/aec_histogram.pdf")
