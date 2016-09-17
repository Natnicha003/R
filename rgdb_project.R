#rgdb_project

library(RPostgreSQL)
con <- dbConnect(PostgreSQL(), user="postgres",
                 password="1234", dbname="rgdb")
dbGetQuery(con, "SHOW client_encoding;")
dbGetQuery(con, "SET CLIENT_ENCODING TO 'windows-874'")
dbGetQuery(con, "SHOW client_encoding;")
sql = "SELECT gid, st_astext(geom) as wkt, 
st_y(geom) as lat ,st_x(geom) as lon,vill_code, vill_nam_t FROM dpc9_village_4326"
sql_tampop = "select * from tam_pop"
#tampop <- dbGetQuery(con, sql_tampop)
tbl1 <- dbGetQuery(con, sql)
res <- dbDisconnect(con)

mm="หมู่บ้าน:"
nn="รหัส:"


#library(leaflet)
#data(tbl1)
#rgdbIcon <- makeIcon(
 # iconUrl= "F://R_16-9-59/r_day/marker-512.png",
  #iconWidth=25, iconHeight=24)


#library(htmltools)
#leaflet(data=tbl1[1:100,]) %>% addTiles() %>%
#addMarkers(~lon, ~lat, popup= ~htmlEscape(vill_nam_t),icon=rgdbIcon)


#Popup show info from 2 fields
library(leaflet)
data(tbl1)
rgdbIcon <- makeIcon(
  iconUrl= "F://R_16-9-59/r_day/marker-512.png",
  iconWidth=25, iconHeight=24 
)

  leaflet(data=tbl1[,]) %>% addTiles() %>%
    
  addWMSTiles("http://map.nu.ac.th/geoserver-hgis/wms?",
   layers = "hgis:dpc9_province_4326",
   options=WMSTileOptions(format="image/png", transparent=TRUE)
    )%>%
    
    addWMSTiles("http://map.nu.ac.th/geoserver-hgis/wms?",
                layers = "hgis:dpc9_tambon_4326",
                options=WMSTileOptions(format="image/png", transparent=TRUE)
    ) %>%
  addMarkers(~lon, ~lat, popup= paste(mm, as.character(tbl1$vill_nam_t),
                                    nn, as.character(tbl1$vill_code)),
           clusterOptions = markerClusterOptions()
    ) 
   

