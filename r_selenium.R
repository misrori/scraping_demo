library(RSelenium)
# https://cran.r-project.org/web/packages/RSelenium/vignettes/RSelenium-basics.html
# java -jar /home/mihaly/R_codes/github/selenium-server-standalone-3.5.2.jar &

remDr <- remoteDriver(remoteServerAddr = "localhost" 
                      , port = 4444L
                      , browserName = "chrome"
)

remDr$open()
remDr$navigate('https://fiokesatmkereso.mnb.hu/web/index.html')

Sys.sleep(8)




page_html <- read_html(remDr$getPageSource()[[1]])

# go back to rvest
page_html%>%
  html_nodes('.list-item-data-title')%>%
  html_text()

page_html%>%
  html_nodes('.list-item-data-details')%>%
  html_text()
#the lenght is not the same! 


#####
#Now with rselenium

for(i in c(1:6)) {

titlek <- remDr$findElements("css", ".list-item-data-title")
print(unlist(sapply(titlek, function(x) x$getElementText())))


next_button <- remDr$findElement(using = "id", value = "pager-control-next")

next_button$clickElement()
Sys.sleep(5)

}





remDr$close()
