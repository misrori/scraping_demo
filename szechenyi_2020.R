library(rvest)
library(data.table)
library(jsonlite)
library(httr)
# szechenyi 2020
#https://emir.palyazat.gov.hu/nyertes/

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


