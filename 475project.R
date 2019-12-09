library(ggplot2)
library(tidyr)
library(tidyverse)
library(knitr)

data = read.csv("data.csv", )
#dropping na from csv
data = na.omit(data)
nrow(data)

# Accuracy by opponent
data %>%
  group_by(opponent) %>%
  summarise(FG=mean(shot_made_flag == 1)) %>%
  ggplot(aes(x=reorder(opponent, -FG), y=FG)) + 
  geom_bar(stat="identity") +
  scale_fill_brewer()
  labs(title="Field Goal % vs teams", x="team")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Frequency for each shot zone range
data %>%
  ggplot(aes(x=fct_inorder(shot_zone_range))) + 
  geom_bar(aes(fill=shot_zone_range)) +
  labs(title = 'Shots taken by zone range', y="Frequency", x="shot range")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#field goal percentage by shot range
data %>%
  group_by(shot_zone_range) %>%
  summarise(FG=mean(shot_made_flag == 1)) %>%
  ggplot(aes(x=reorder(shot_zone_range, -FG), y=FG)) +
  geom_bar(stat="identity", aes(fill=shot_zone_range)) +
  labs(title="Field Goal % by shot range", x="shot range", y = 'field goal %')+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#field goal % by shot type
data %>%
  group_by(action_type) %>%
  summarise(FG=mean(shot_made_flag == 1),
            counts=n()) %>%
  ggplot(aes(x=reorder(action_type, FG), y=FG)) + 
  geom_point(aes(colour=FG)) +
  scale_colour_gradient(low="red", high="green") +
  labs(title="Field Goal % by shot type", x='type of shot', y = 'field goal %')+
  theme(text = element_text(size=8),axis.text.x = element_text(angle = 45, hjust = 1))

#field goal # by quarter
data %>%
  group_by(period) %>%
  summarise(FG=mean(shot_made_flag == 1)) %>%
  ggplot(aes(x=period, y=FG)) +
  geom_point(aes(colour=FG)) +
  labs(title="Field Goal % by period", x="Period")

#field goal % by season
data %>%
  group_by(season) %>%
  summarise(FG=mean(shot_made_flag == 1)) %>%
  ggplot(aes(x=season, y=FG, group=1)) +
  geom_line(aes(colour=FG)) +
  scale_colour_gradient(low="red", high="green") +
  labs(title="Field goal % by season", x="Season", y = "Field goal %")+
  theme(text = element_text(size=10),axis.text.x = element_text(angle = 45, hjust = 1))

