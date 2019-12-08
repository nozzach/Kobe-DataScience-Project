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
  summarise(Accuracy=mean(shot_made_flag == 1)) %>%
  ggplot(aes(x=reorder(opponent, -Accuracy), y=Accuracy)) + 
  geom_bar(stat="identity") +
  scale_fill_brewer()
  labs(title="Field Goal % vs teams", x="team")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Frequency for each shot zone range
data %>%
  ggplot(aes(x=fct_infreq(shot_zone_range))) + 
  geom_bar(aes(fill=shot_zone_range)) +
  labs(title = 'Shots taken by zone range', y="Frequency", x="shot range")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#field goal percentage by shot range
data %>%
  group_by(shot_zone_range) %>%
  summarise(Accuracy=mean(shot_made_flag == 1)) %>%
  ggplot(aes(x=reorder(shot_zone_range, -Accuracy), y=Accuracy)) +
  geom_bar(stat="identity", aes(fill=shot_zone_range)) +
  labs(title="Field Goal % by shot range", x="shot range", y = 'field goal %')+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#field goal % by shot type
data %>%
  group_by(action_type) %>%
  summarise(Accuracy=mean(shot_made_flag == 1),
            counts=n()) %>%
  filter(counts>50) %>%
  ggplot(aes(x=reorder(action_type, Accuracy), y=Accuracy)) + 
  geom_point(aes(colour=Accuracy)) +
  scale_colour_gradient(low="red", high="green") +
  labs(title="Field Goal % by shot type", x='type of shot', y = 'field goal %')+
  theme(text = element_text(size=8),axis.text.x = element_text(angle = 45, hjust = 1))

#field goal # by quarter
data %>%
  group_by(period) %>%
  summarise(Accuracy=mean(shot_made_flag == 1)) %>%
  ggplot(aes(x=period, y=Accuracy)) +
  geom_line(aes(colour=Accuracy)) +
  geom_point(aes(colour=Accuracy)) +
  labs(title="Field Goal % by period", x="Period")

#field goal % by season
data %>%
  group_by(season) %>%
  summarise(Accuracy=mean(shot_made_flag == 1)) %>%
  ggplot(aes(x=season, y=Accuracy, group=1)) +
  geom_line(aes(colour=Accuracy)) +
  geom_point(aes(colour=Accuracy)) +
  scale_colour_gradient(low="red", high="green") +
  labs(title="Field goal % by season", x="Season", y = "Field goal %")+
  theme(text = element_text(size=10),axis.text.x = element_text(angle = 45, hjust = 1))

