
if(!require(devtools)) install.packages("devtools")
if(!require(leaflet)) install_github("rstudio/leaflet")

library(leaflet)
require(leaflet)


shinyUI(fluidPage(
  titlePanel("Illustrating Leaflet mapping capabilities from database of all US cites and select World Cities"),
  sidebarLayout(
  sidebarPanel(h5("Select country, state(USA only), and city from options below"),
    
    uiOutput("cntry" ),
  
    conditionalPanel(
      condition = "input.country =='United States'",
      uiOutput("stte" )
    ),  
uiOutput("cty" )
,
    
   selectInput("map_type", 
               label = "Choose a map type to display - Some map types will display more detail depending on what part of the world you are mapping",
               choices = list("Esri.NatGeoWorldMap","Esri.WorldStreetMap", "Hydda.Full", "MapQuestOpen.Aerial","MapQuestOpen.OSM",
                              "OpenMapSurfer.Roads", "OpenStreetMap.BlackAndWhite", "OpenStreetMap.DE",
                              "OpenStreetMap.HOT","OpenStreetMap.Mapnik",    "Stamen.TonerLite",  
                              "Thunderforest.Landscape"
               ),               selected = "MapQuestOpen.OSM"),
h6("clicking on the marker on the map will popup the city name")
  ),

  mainPanel(
    leafletOutput("mymap",height=700)
    ,
    
    sliderInput("zoom", 
                label = "zoom level",
                min = 0, max = 18, value=10, width='400px')
    
 ,
 br(),
  h6("the zoom slider above changes the view")
  )
  )
))
