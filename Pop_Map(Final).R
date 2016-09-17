#Add GeoJSON flie from web
library(jsonlite)
library(httr)
url <-"http://map.nu.ac.th/geoserver-hgis/hgis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=hgis:dpc9_province_4326&outputFormat=json"
json_url <- GET(url)
jsongeo <- content(json_url)

jdat<- readLines("F://R_16-9-59/r_day/shp/dpc2_tam.geojson") %>% 
  paste0(collapse="\n")

#you can also add style for jsongeo from outside leaflet
jsongeo$style= list(
  weight= 3,
  color= "#447892",
  fillOpacity=0
)

url2<-"http://map.nu.ac.th/geoserver-hgis/hgis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=hgis:dpc9_village_4326&outputFormat=json"
jsontam_url<- GET(url2)
jsontam <- content(jsontam_url)

url3<-"http://map.nu.ac.th/geoserver-hgis/hgis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=hgis:v_prev_tam&outputFormat=json"
j_prev_tam<- content(GET(url3))

library(rgdal)

jtam_pop<- readOGR("F:/R_16-9-59/r_day/shp/tam_pop.geojson", "OGRGeoJSON")

#palette shape file
#pal<- colorNumeric(
 # palette="Blues",
  #domain = j_prev_tam$pop57)

#qpal<- colorQuantile("RdPu", jtam_pop$pop57, n=7)
bpal <- colorBin("RdPu", jtam_pop$pop57, 7, pretty = FALSE)
#factpal<- colorFactor(topo.colors(5),jtam_pop$pop57 )

leaflet(jtam_pop) %>% 
  setView(lng = 100, lat=17.1, zoom=7) %>% 
  addTiles(group="OSM (default)") %>%
  addProviderTiles("Stamen.Toner", group= "Toner") %>% 
  addProviderTiles("CartoDB.Positron", group="Positron") %>% 
  addProviderTiles("Esri.WorldImagery", group="Imagery") %>%
  #addGeoJSON(jdat, weight=1, color="#447722", fillOpacity=0.5) %>%
  #addGeoJSON(jsongeo) %>%
  addGeoJSON(jsontam,
             group= "Tambon") %>%
  addPolygons(
    stroke =TRUE, 
    weight=2, 
    smoothFactor=0.2, 
    fillOpacity = 1, 
    color= ~bpal(pop57), 
    popup = paste0(as.character(jtam_pop$pop57), " คน"),
    group="Pop"
  ) %>%
  addLegend(
    "bottomright",
    pal=bpal, 
    values= ~pop57,
    title= "Population",
    labFormat= labelFormat(suffix=" คน"),
    opacity=0.8) %>%
  addLayersControl(
    baseGroups = c("OSM (default)","Toner", "Positron", "Imagery"),
    overlayGroups = c("Pop", "Tambon"),
    options = layersControlOptions(collapsed=FALSE)
  )
