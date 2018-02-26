library(rvest)
library(data.table)
library(jsonlite)
library(httr)
source('my_functions.R')

#lets start with index.hu
#get the news from our friend Gyuri bacsi

get_index_search <- function(url){

#url <- "https://index.hu/24ora/?s=soros+gy%C3%B6rgy&tol=1999-01-01&ig=2018-02-23&profil=&rovat=&cimke=&word=1&pepe=1"
my_page <- read_html(url)

cim<- 
my_page%>%
  html_nodes('.cim a')%>%
  html_text()

link<-
my_page%>%
  html_nodes('.cim a')%>%
  html_attr('href')

ajanlo<- 
my_page%>%
  html_nodes('.ajanlo')%>%
  html_text()

t <- data.frame('cim'= cim, 'link'= link, 'ajanlo'= ajanlo, stringsAsFactors = F)
return(t)
}
adat <- get_index_search('https://index.hu/24ora/?s=Soros+György&tol=1999-01-01&ig=2018-02-23&profil=&rovat=&cimke=&word=1&pepe=1')

get_wordcloud(c(adat$cim, adat$ajanlo))
##################################################################################
# otthonterkep
get_otthonterkaep_page <- function(url){
#url <- "https://otthonterkep.hu/elad%C3%B3-lak%C3%A1s/Budapest?ex=1&sort=rd&lv=list-only&oldal=2"
m_page <- read_html(url)
#check if everything is in the page
#write_html(m_page, "t.html")

arak <- 
m_page%>%
  html_nodes('.prop-fullprice')%>%
  html_text()
arak <- as.numeric(gsub(' M Ft','',gsub(',','.',trimws(arak))))*1000000

meret <- 
  m_page%>%
  html_nodes('.prop-fullsize')%>%
  html_text()
meret <- as.numeric(gsub(' m2','',trimws(meret), fixed = T))

link <- 
  m_page%>%
  html_nodes('.prop-card a')%>%
  html_attr('href')



t <- data.frame('meret'= meret,'arak'= arak, linkek= link)
return(t)

}

linkek <- paste0("https://otthonterkep.hu/elad%C3%B3-lak%C3%A1s/Budapest?ex=1&sort=rd&lv=list-only&oldal=", 2:5)

oldalak <- lapply(linkek, get_otthonterkaep_page)

df <- rbindlist(oldalak)

#################################################################################
# coinmarketcap

m_url <- "https://coinmarketcap.com/"

tablak <- read_html(m_url)%>%
  html_table()

df <- tablak[[1]]

# now with api
adat <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?limit=0")


#get_some prices
adat <- fromJSON("https://www.cryptocompare.com/api/data/coinlist/")
tablak <- lapply(adat$Data, data.frame)
coinok <- rbindlist(tablak, fill = T)
coinok


adat <- fromJSON('https://min-api.cryptocompare.com/data/histohour?fsym=BTC&tsym=USD&aggregate=3&e=CCCAGG')
adat <- adat$Data
adat$time <- as.POSIXct(adat$time, origin="1970-01-01")

View(adat)






