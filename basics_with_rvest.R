#lets start with index.hu
library(rvest)
library(data.table)
library(jsonlite)
library(httr)
#source()

#lets get the news from our friend Gyuri bacsi

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

t <- data.frame('cim'= cim, 'link'= link, 'ajanlo'= ajanlo)
return(t)
}
adat <- get_index_search('https://index.hu/24ora/?s=Orb%C3%A1n+viktor&tol=1999-01-01&ig=2018-02-23&profil=&rovat=&cimke=&word=1&pepe=1')


###########################################################################################################
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



t <- data.frame('meret'= meret,'arak'= arak, linkek= 'link')
return(t)

}

linkek <- paste0("https://otthonterkep.hu/elad%C3%B3-lak%C3%A1s/Budapest?ex=1&sort=rd&lv=list-only&oldal=", 2:5)

oldalak <- lapply(linkek, get_otthonterkaep_page)

df <- rbindlist(oldalak)



adat = POST('https://emir.palyazat.gov.hu/nyertes/index.php?node=get_select&name=op_nev&forras=1420')

my_params = list('ttipus'='',
                   'tkod'='',
                   'forras'=1420,
                   'forras_uj'='',
                   'op_type'='op_nev',
                   'op_nev'='',
                   'kitoresi_pont'='',
                   'eupik_nev'='',
                   'kiiras_eve'='',
                   'palyazo_nev'='',
                   'print'=0,
                   'id_szerv'=0,
                   '_search'=FALSE,
                   'rows'=100,
                   'page'=4,
                   'sidx'='DONTES_DATUM',
                   'sord'='asc')
r <- POST("http://emir.nfu.hu/nyertes/?node=list", body = my_params)
adat <- fromJSON( content(r, 'text' ))

adat$rows[[1]][1]



# my_params = list('node'='get_select',
# 'name'='place',
# 'sqltype'='place',
# 'tkod'='',
# 'ttype'='all')
# r <- GET("https://emir.palyazat.gov.hu/nyertes/index.php?node=get_select&name=place&sqltype=place&tkod=&ttype=all")




