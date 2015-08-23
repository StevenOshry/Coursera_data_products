
if(!require(devtools)) install.packages("devtools")
if(!require(leaflet)) install_github("rstudio/leaflet")

library(leaflet)
require(leaflet)


# world_citiesi1 <- read.csv("./cities_for_project.csv", header = TRUE, stringsAsFactors =FALSE )
# world_citiesi2<-world_citiesi1[world_citiesi1$latitude != 0 & world_citiesi1$longitude !=0, ]
# world_citiesi<-world_citiesi2[complete.cases(world_citiesi2),]
# save(world_citiesi, file="world_citiesi.Rdata")


shinyServer(
  function(input, output) {
    load("world_citiesi.Rdata")
    world_cities <- world_citiesi
    output$cntry <- renderUI({
      cntries <- unique(world_cities$country)
      selectInput('country', 'Country', as.list(cntries), selected="United States" )
    })
    output$stte <- renderUI({
      if(is.null(input$country)) {
        selectInput('state', 'State', "None", selected="None" )
        
      }
    else  if(input$country=="United States") {
        states<- subset(world_cities, country == input$country)
        states  <- states[order(states$state),]
        states2 <- unique(states$state)
        selectInput('state', 'State', as.list(states2), selected="NY" )
        
      } else {
        selectInput('state', 'State', "None", selected="None" )
        
      }
      
    })  
    
    output$cty <- renderUI({
      cities<- subset(world_cities, country == input$country & state==input$state)
      cities  <- cities[order(cities$city),]
      citys2 <-unique(cities$city)
      selectInput('city', 'City', as.list(citys2),selected="New York" )
    })
    
    values <- reactiveValues()
    
    observe({
     
      if (is.null(input$city)) {
        values$obj <--73.5
      } else {
        values$obj <- world_cities$longitude[world_cities$country==input$country & world_cities$state==input$state & 
                                               world_cities$city==input$city][1]
        
      }
      if (is.null(input$city)) {
        values$obj2 <-41
      } else {
        
        values$obj2 <- world_cities$latitude[world_cities$country==input$country & world_cities$state==input$state & 
                                               world_cities$city==input$city][1]
              }
    
    })
    
    
    output$mymap <- renderLeaflet({
      leaflet() %>%
        addProviderTiles(input$map_type,
                         options = providerTileOptions(noWrap = TRUE)       
        ) %>%  
        # set view(long, lat)
        setView(as.numeric(values$obj), as.numeric(values$obj2), input$zoom)    %>%
        addMarkers(lng=as.numeric(values$obj), lat=as.numeric(values$obj2), popup=input$city)
      
    })  
 
  }
)
