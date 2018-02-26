library(RSelenium)
remDr <- remoteDriver(remoteServerAddr = "localhost" 
                      , port = 4444L
                      , browserName = "chrome"
)
remDr$open()
remDr$navigate("http://www.linkedin.com")

Sys.sleep(2)

username <- remDr$findElement(using = "id", value = "login-email")
username$clearElement()
username$sendKeysToElement(list("misroritozsde@gmail.com"))
Sys.sleep(20)

pass <- remDr$findElement(using = "id", value = "login-password")
pass$clearElement()
pass$sendKeysToElement(list("Beirom"))
Sys.sleep(2)

login_gomb <- remDr$findElement(using = "id", value = "login-submit")
login_gomb$sendKeysToElement(list())
login_gomb$clickElement()

Sys.sleep(5)

webElem$sendKeysToElement(list(key = "end"))
webElem$sendKeysToElement(list(key = "page_up"))