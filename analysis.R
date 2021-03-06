install.packages(c("devtools", "rjson", "bit64", "httr"))

#RESTART R session!

library(devtools)

install_github("twitteR", username="geoffjentry", force=TRUE)
library(twitteR)
library(ROAuth)
library(plyr)
library(dplyr)
library(stringr)
library(ggplot2)
api_key <- "slqTANJBxjkXLNXxQxT2zjMHT"

api_secret <- "N2z6keYEoKlNbHWi05jMNHjZmBG5ni59HsVO6vCoRdQKonDSd7"

access_token <- "403250636-qzXEhfwYb3HzMMSVmCUOiftLRmMp2ZjqC21ZjZui"

access_token_secret <- "kNYdkH92S2wvcWOKn6XOsXyFKsaJyaefYezk80xYanNsf"

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
download.file(url='http://curl.haxx.se/ca/cacert.pem', destfile='cacert.pem')
reqURL <- 'https://api.twitter.com/oauth/request_token'
accessURL <- 'https://api.twitter.com/oauth/access_token'
authURL <- 'https://api.twitter.com/oauth/authorize'
Cred <- OAuthFactory$new(consumerKey=api_key,
                         consumerSecret=api_secret,
                         requestURL=reqURL,
                         accessURL=accessURL,
                         authURL=authURL)
Cred$handshake(cainfo = system.file('CurlSSL', 'cacert.pem', package = 'RCurl'))
save(Cred, file='twitter authentication.Rdata')
load('twitter authentication.Rdata')
registerTwitterOAuth(Cred)
searchTwitter("iphone")
searchTwitter("#SwachhBharat")


 
  list <- searchTwitter('#Kejriwal', n=1500)
  df <- twListToDF(list)
  df <- df[, order(names(df))]
  df$created <- strftime(df$created, '%Y-%m-%d')
   write.csv(df, file='C:/Users/PARTH/Desktop/Kejriwal.csv', row.names=F)
  #merge last access with cumulative file and remove duplicates
  
  
  #evaluation tweets function
  install.packages("plyr")
  install.packages("stringr")
  library(plyr)
  library(stringr)
  score.sentiment <- function(sentences, pos.words, neg.words, .progress='none')
  {
    require(plyr)
    require(stringr)
    scores <- laply(sentences, function(sentence, pos.words, neg.words){
      sentence <- gsub('[[:punct:]]', "", sentence)
      sentence <- gsub('[[:cntrl:]]', "", sentence)
      sentence <- gsub('\\d+', "", sentence)
      sentence <- tolower(sentence)
      word.list <- str_split(sentence, '\\s+')
      words <- unlist(word.list)
      pos.matches <- match(words, pos.words)
      neg.matches <- match(words, neg.words)
      pos.matches <- !is.na(pos.matches)
      neg.matches <- !is.na(neg.matches)
      score <- sum(pos.matches) - sum(neg.matches)
      return(score)
    }, pos.words, neg.words, .progress=.progress)
    scores.df <- data.frame(score=scores, text=sentences)
    return(scores.df)
  }
  pos <- scan('C:/Users/PARTH/Desktop/positive-words.txt', what='character', comment.char=';') #folder with positive dictionary
  neg <- scan('C:/Users/PARTH/Desktop/negative-words.txt', what='character', comment.char=';') #folder with negative dictionary
  pos.words <- c(pos, 'upgrade')
  neg.words <- c(neg, 'wtf', 'wait', 'waiting', 'epicfail')
  Dataset <- read.csv("C:/Users/PARTH/Desktop/Kejriwal.csv")
  Dataset$text <- as.factor(Dataset$text)
  scores <- score.sentiment(Dataset$text, pos.words, neg.words, .progress='text')
  write.csv(scores, file="C:/Users/PARTH/Desktop/Kejriwalscores.csv", row.names=TRUE) #save evaluation results into the file
  #total evaluation: positive / negative / neutral
  install.packages('RColorBrewer')
  library(RColorBrewer)
hist(scores$score, xlab = "Scoreof tweets",col = brewer.pal(9,"Set3"))
install.packages('ggplot2')
library(ggplot2)
qplot(scores$score,xlab="Scoresof.Tweets")
install.packages('tm')
library(tm)
install.packages('wordcloud')
library(wordcloud)
?Source()
K=Corpus(DirSource("C:/Users/PARTH/Desktop/Kejriwal"),readerControl=list(language="eng"))
inspect(K)
K <-tm_map(K,tolower)
K <-tm_map(K,stripWhitespace)
K <-tm_map(K,removePunctuation)
K <-tm_map(K,removeWords,c("Kejriwal"))
corpus_clean <- tm_map(K, PlainTextDocument)
inspect(K)

tdm<-TermDocumentMatrix(corpus_clean)
tdm
m1<-as.matrix(tdm)
m1
v1<-sort(rowSums(m1),decreasing = TRUE)
v1
d1<-data.frame(word=names(v1),freq=v1)
d1
wordcloud(d1$word,d1$freq,col=brewer.pal(8,"Set2"),min.freq="1")
