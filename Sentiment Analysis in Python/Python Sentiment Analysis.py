
# Sentiment Analysis THA
#In this THA you will perform text mining on Twitter data. You will use the same data [tmobile_sprint_merger.csv](data/tmobile_sprint_merger.csv) as you did for the ICE.
#For this assignment please upload your Word file to Canvas; upload your Python script file to GitHub.

#load necessary libraries
import pandas as pd
import matplotlib.pyplot as plt
import os
import nltk
import numpy as np

#code to show full column/row width
pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)
pd.set_option('display.max_colwidth', None)

#nltk.download('stopwords')
from nltk import word_tokenize, sent_tokenize
from nltk.corpus import stopwords
from nltk.stem import LancasterStemmer, WordNetLemmatizer, PorterStemmer

#set working directory
#os.getcwd()
os.chdir(r'C:\Users\Sam Edison\source\repos\msis5193-pds1-2020fall-online\text-mining-tha-samuel-edison\data')

#load the file into Python as a dataframe
tweets_data = pd.read_csv('tmobile_sprint_merger.csv')
tweets_data.columns
tweets_data.rename(columns={'tweet':'tweettext'}, inplace=True)

### Create a Term-Document Matrix (7 pts.)
#Using the text mining process to clean data, create a term-document matrix. Use the following steps to prepare your data using tidytext:

#Data Preprocessing
# convert text to lowercase
tweets_data['tweettext'] = tweets_data['tweettext'].apply(lambda x: " ".join(x.lower() for x in x.split()))
 #tweets_data['tweettext'][2]
 #tweets_data['tweettext'][5]

# remove the numerical values and punctuation from the words. Use Regular expressions.
    #a. numerical values
patterndigits = '\\b[0-9]+\\b'
tweets_data['tweettext'] = tweets_data['tweettext'].str.replace(patterndigits,'')
    #b. punctuation
patternpunc = '[^\w\s]'
tweets_data['tweettext'] = tweets_data['tweettext'].str.replace(patternpunc,'')

# Remove stop words
stop = stopwords.words('english')
tweets_data['tweettext'] = tweets_data['tweettext'].apply(lambda x: " ".join(x for x in x.split() if x not in stop))

#Remove the names of T-Mobile and Sprint from the data
companynames = ['t-mobile','sprint','tmobilesprint','sprinttmobil','tmobilesprintmerg','tmobil']
tweets_data['tweettext'] = tweets_data['tweettext'].apply(lambda x: " ".join(x for x in x.split() if x not in companynames))

#Stem the words
porstem = PorterStemmer()
tweets_data['tweettext'] = tweets_data['tweettext'].apply(lambda x: " ".join([porstem.stem(word) for word in x.split()]))

#create a document-term matrix with a vectorize from scikitlearn.
from sklearn.feature_extraction.text import CountVectorizer
vectorizer = CountVectorizer()
tokens_data = pd.DataFrame(vectorizer.fit_transform(tweets_data['tweettext']).toarray(), columns=vectorizer.get_feature_names())
print(tokens_data.columns.tolist())


#get frequencies of the terms into a dataframe
freq = tokens_data.sum(axis=0).values
tokens = np.array(tokens_data.columns.tolist())
tokens = np.reshape(tokens,(4834,1))
freq = np.reshape(freq,(4834,1))
combined = np.concatenate((tokens,freq),axis=1)
dtm = pd.DataFrame(data=combined,columns=["word","frequency"])
sorted_values = dtm.sort_values(by=['frequency'],ascending=False)
sorted_values.head()
### Follow-Up Analysis (3 pts.)
#1. What do you notice about the top 10 words (in terms of volume) in your dataset? Do these agree with what you found in the ICE?
#sorted_values.head(10)
#1. Now look at the top 20 terms. Take any 8 terms/words (different from what you selected in the ICE) and explain why they are justified as being in the top 20.
#sorted_values.head(20)

#Begin Sentiment Analysis
import numpy as np 
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.feature_extraction.text import CountVectorizer
from sklearn.decomposition import LatentDirichletAllocation
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.decomposition import NMF

from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score, plot_confusion_matrix

#create the document term matrix
vectorizer = CountVectorizer(max_df=0.8, min_df=4, stop_words='english')
doc_term_matrix = vectorizer.fit_transform(tweets_data['tweettext'].values.astype('U'))

#Generate the LDA with the top 4 topics in the argument. Use random seed 35.
LDA = LatentDirichletAllocation(n_components=4, random_state=35)
LDA.fit(doc_term_matrix)
#Retrieve words in the first topic, sort the indexes according to probability using argsort()
first_topic = LDA.components_[0]
top_topic_words = first_topic.argsort()[-10:]

for i in top_topic_words:
    print(vectorizer.get_feature_names()[i])

#top 10 words for each topic
for i,topic in enumerate(LDA.components_):
    print(f'Top 10 words for topic #{i}:')
    print([vectorizer.get_feature_names()[i] for i in topic.argsort()[-10:]])
    print('\n')
#1. Add a new column to the dataframe containing the LDA topic number
topic_values = LDA.transform(doc_term_matrix)
topic_values.shape
tweets_data['topic'] = topic_values.argmax(axis=1)
tweets_data.head()

#2. Generate 4 topics using NMF and add a new column to the dataframe
tfidf_vect = TfidfVectorizer(max_df=0.8, min_df=5, stop_words='english')
doc_term_matrix2 = tfidf_vect.fit_transform(tweets_data['tweettext'].values.astype('U'))
nmf = NMF(n_components=4, random_state=23)
nmf.fit(doc_term_matrix2)
first_topic = nmf.components_[0]
top_topic_words = first_topic.argsort()[-10:]
for i in top_topic_words:
    print(tfidf_vect.get_feature_names()[i])

for i,topic in enumerate(nmf.components_):
    print(f'Top 10 words for topic #{i}:')
    print([tfidf_vect.get_feature_names()[i] for i in topic.argsort()[-10:]])
    print('\n')

topic_values2 = nmf.transform(doc_term_matrix2)
tweets_data['topic2'] = topic_values2.argmax(axis=1)
tweets_data.head()

#4. Select 5 tweets from the data frame along with the LDA and NMF values.
tweets_data[['tweettext','topic','topic2']].sample(n=5)
tweets_data.sample(n=5)

#Export and push file to repository for R analysis
os.chdir(r'C:\Users\Sam Edison\source\repos\msis5193-pds1-2020fall-online\sentiment-analysis-tha-samuel-edison')
tweets_data.to_csv('tweets_data.csv')

#create training/test split of the positive/negative data
#set working directory
os.chdir(r'C:\Users\Sam Edison\source\repos\msis5193-pds1-2020fall-online\sentiment-analysis-tha-samuel-edison')
#load files from R
tweet_posneg = pd.read_csv('tweet_posneg.csv')
tweet_joysad = pd.read_csv('tweet_joysad.csv')
#tweet_posneg.head()

#6. Create a training-testing split for the positive-negative data
#first create a term-frequency inverse-document-frequency
features = tweet_posneg['word']
vectorizer = TfidfVectorizer(max_features=2500, min_df=0, max_df=0.8, stop_words=stop)
processed_features = vectorizer.fit_transform(features).toarray()

#create split for positive/negative
labels = tweet_posneg['category']
X_train, X_test, y_train, y_test = train_test_split(processed_features, labels, test_size=0.2, random_state=0)
#train a random forest model
text_classifier = RandomForestClassifier(n_estimators=200, random_state=0)
text_classifier.fit(X_train, y_train)
#generate the testing model
predictions = text_classifier.predict(X_test)
##Model Evaluation
#confusion matrix
cm = confusion_matrix(y_test,predictions)
print(cm)

print(classification_report(y_test,predictions))
print(accuracy_score(y_test, predictions))


#Create a training-testing split for the positive-negative data
#first create a term-frequency inverse-document-frequency
features = tweet_joysad['word']
vectorizer = TfidfVectorizer(max_features=2500, min_df=0, max_df=0.8, stop_words=stop)
processed_features = vectorizer.fit_transform(features).toarray()
#create split for joy/sadness
labels = tweet_joysad['category']
X_train, X_test, y_train, y_test = train_test_split(processed_features, labels, test_size=0.2, random_state=0)
#train a random forest model
text_classifier = RandomForestClassifier(n_estimators=200, random_state=0)
text_classifier.fit(X_train, y_train)
#generate the testing model
predictions = text_classifier.predict(X_test)
##Model Evaluation
#confusion matrix
cm = confusion_matrix(y_test,predictions)
print(cm)

print(classification_report(y_test,predictions))
print(accuracy_score(y_test, predictions))