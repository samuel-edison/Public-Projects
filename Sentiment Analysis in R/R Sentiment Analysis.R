#load libraries for txt mining in R
library(tidyverse)
library(tidytext)
library(SnowballC)
#change the print to see results as desired
options(max.print=5000)

#read the data into R
tweets_data = read.csv("D:\\School\\R Projects\\sentiment-analysis-tha-samuel-edison\\tweets_data.csv")
dim(tweets_data)
#tokenize the tweets
tweets_data = unnest_tokens(tweets_data, tweettext, tweettext)

#Begin Sentiment Analysis - Generating Sentiment Scores using NRS lexicon
#load libraries
library(wordcloud)
library(udpipe)
library(lattice)
library(textdata)
#load lexicon
##to see exact values contained within each data dictionary, use the code below
get_sentiments('nrc') %>%
  distinct(sentiment)

#Generate a new variable assessing the difference between positive and negative
nrc_posneg = get_sentiments('nrc') %>%
  filter(sentiment == 'positive' | 
           sentiment == 'negative')
nrow(nrc_posneg)
#join the new variable values with the tweet dataset
tweets_data = inner_join(tweets_data, nrc_posneg, by = c("tweettext" = "word"))


#change the name of the positive and negative sentiment column
colnames(posnegjoin)
names(posnegjoin)[names(posnegjoin) == "sentiment"] = "posneg_sentiment"
#count all occurrences of each word
counts = count(posnegjoin, word, posneg_sentiment)
spread = spread(counts, posneg_sentiment, n, fill = 0)

#create contentment score for positive and negative
content_data = mutate(spread, contentment_posneg = positive - negative)
tweet_posneg = arrange(content_data, desc(contentment_posneg))
tweet_posneg$category[tweet_posneg$contentment_posneg>0] = 'positive'
tweet_posneg$category[tweet_posneg$contentment_posneg<0] = 'negative'
tweet_posneg$category[tweet_posneg$contentment_posneg==0] = 'neutral'

#write file
write.table(tweet_posneg, file = "tweet_posneg.csv", sep=",", row.names = TRUE, col.names = NA)

#Create a new variable assessing the difference between joy and sadness
nrc_joysad = get_sentiments('nrc') %>%
  filter(sentiment == 'joy' | 
           sentiment == 'sadness')
nrow(nrc_joysad)
#join the new variable values with the tweet dataset
joysadjoin = inner_join(tidy_dataset_stemmed, nrc_joysad)

#change the name of the positive and negative sentiment column
colnames(joysadjoin)
names(joysadjoin)[names(joysadjoin) == "sentiment"] = "joysad_sentiment"
#count all occurrences of each word
counts = count(joysadjoin, word, joysad_sentiment)
spread = spread(counts, joysad_sentiment, n, fill = 0)

#create contentment score for joy and sad
content_data = mutate(spread, contentment_joysad = joy - sadness)
tweet_joysad = arrange(content_data, desc(contentment_joysad))
tweet_joysad$category[tweet_joysad$contentment_joysad>0] = 'joy'
tweet_joysad$category[tweet_joysad$contentment_joysad<0] = 'sadness'
tweet_joysad$category[tweet_joysad$contentment_joysad==0] = 'neutral'
#write file
write.table(tweet_joysad, file = "tweet_joysad.csv", sep=",", row.names = TRUE, col.names = NA)

