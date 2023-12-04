#GDP Data####

#Reading in GDP data
gdp<- read_excel("source_data/RealGDPValues.xlsx", range = "A14:BL234")
#gdp_historical_2010<- read_excel("source_data/gdp_historical_2010.xlsx", range = "A12:AN230")
#gdp_historical_2015<- read_excel("source_data/gdp_historical_2015.xlsx", range = "A16:V236")
#gdp_projected_2015 <- read_excel("source_data/gdp_projected_2015.xlsx", range = "A15:L235")

#Merging historical and projected data
#delete from gdp_historical_2010 the years from 2000 to 2020 (years that are in gdp_historical_2015) 
#in gdp_projected_2015 keep only the last two years
#gdp_historical_2010 <-gdp_historical_2010[,-c(22:40)]
#gdp_projected_2015 <- gdp_projected_2015[,-c(2:10)]

#gdp_historical_2010$Country[gdp_historical_2010$Country == "Antigua Barbuda"] <- "Antigua and Barbuda"
#gdp_historical_2010$Country[gdp_historical_2010$Country == "Dominican Rep"] <- "Dominican Republic"
gdp$Country[gdp$Country == "St Kitts Nevis"] <- "St. Kitts and Nevis"
#gdp_historical_2010$Country[gdp_historical_2010$Country == "St Lucia"] <- "St. Lucia"
gdp$Country[gdp$Country == "St Vincent Grenadines"] <- "St. Vincent and Grenadines"
#gdp_historical_2010$Country[gdp_historical_2010$Country == "UK"] <- "United Kingdom"
#gdp_historical_2010$Country[gdp_historical_2010$Country == "Bosnia Herzegovina"] <- "Bosnia and Herzegovina"
gdp$Country[gdp$Country == "C?te d'Ivoire"] <- "Cote d'Ivoire"
gdp$Country[gdp$Country == "Côte d'Ivoire"] <- "Cote d'Ivoire"
#gdp_historical_2010$Country[gdp_historical_2010$Country == "Guinea Bissau"] <- "Guinea-Bissau"
#gdp_historical_2010$Country[gdp_historical_2010$Country == "Central Afr Rep"] <- "Central African Republic"
#gdp_historical_2010$Country[gdp_historical_2010$Country == "Dem Rep Congo"] <- "Democratic Republic of the Congo"
gdp$Country[gdp$Country == "Democratic Republic of Congo"] <- "Democratic Republic of the Congo"
#gdp_projected_2015$Country[gdp_projected_2015$Country == "Democratic Republic of Congo"] <- "Democratic Republic of the Congo"
#gdp_historical_2010$Country[gdp_historical_2010$Country == "Rep Congo"] <- "Republic of the Congo"
gdp$Country[gdp$Country == "Republic of Congo"] <- "Republic of the Congo"
#gdp_projected_2015$Country[gdp_projected_2015$Country == "Republic of Congo"] <- "Republic of the Congo"
#gdp_historical_2010$Country[gdp_historical_2010$Country == "Sao Tome Principe"] <- "Sao Tome and Principe"
#gdp_historical_2015$Country[gdp_historical_2015$Country == "S?o Tom? and Principe"] <- "Sao Tome and Principe"
gdp$Country[gdp$Country == "São Tomé and Principe"] <- "Sao Tome and Principe"

#gdp_projected_2015$Country[gdp_projected_2015$Country == "S?o Tom? and Principe"] <- "Sao Tome and Principe"
#gdp_projected_2015$Country[gdp_projected_2015$Country == "São Tomé and Principe"] <- "Sao Tome and Principe"

#gdp_historical_2015$Country[gdp_historical_2015$Country == "Macedonia, North"] <- "Macedonia"
#gdp_projected_2015$Country[gdp_projected_2015$Country == "Macedonia, North"] <- "Macedonia"

#gdp_historical_2015$Country[gdp_historical_2015$Country == "St. Kitts Nevis"] <- "St. Kitts and Nevis"
#gdp_projected_2015$Country[gdp_projected_2015$Country == "St. Kitts Nevis"] <- "St. Kitts and Nevis"
#gdp_historical_2015$Country[gdp_historical_2015$Country == "St. Vincent Grenadines"] <- "St. Vincent and Grenadines"
#gdp_projected_2015$Country[gdp_projected_2015$Country == "St. Vincent Grenadines"] <- "St. Vincent and Grenadines"
#gdp_historical_2015$Country[gdp_historical_2015$Country == "Swaziland/Eswatini"] <- "Swaziland"
gdp$Country[gdp$Country == "Swaziland/Eswatini"] <- "Swaziland"


#Add Qatar and Zimbabwe to gdp_historical_2010
#Qatar<-c("Qatar",NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA)
#Zimbabwe<-c("Zimbabwe",NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA)

#gdp_historical_2010<-(rbind(gdp_historical_2010,Qatar))
#gdp_historical_2010<-(rbind(gdp_historical_2010,Zimbabwe))

#to check country names are correct put all csv files in an excel and check they have the same name with the function EXACT
#write.csv(gdp_historical_2010,"gdp_historical_2010.csv",row.names = F)
#write.csv(gdp_historical_2015,"gdp_historical_2015.csv",row.names = F)
#write.csv(gdp_projected_2015,"gdp_projected_2015.csv",row.names = F)

#gdp <- merge(gdp_historical_2010, gdp_historical_2015, by="Country", All=T)
#gdp <- merge(gdp, gdp_projected_2015, by="Country", All=T)

write.csv(gdp,"intermediate_outputs/gdp.csv", row.names=F)
colnames(gdp)[colnames(gdp)=="Country"] <- "country"

#Renaming countries in gdp dataset to match iso-codes
gdp$country[gdp$country == "Bolivia"] <- "Bolivia (Plurinational State of)"
gdp$country[gdp$country == "Brunei"] <- "Brunei Darussalam"
gdp$country[gdp$country == "Hong Kong"] <- "China, Hong Kong Special Administrative Region"
gdp$country[gdp$country == "Macau"] <- "China, Macao Special Administrative Region"
gdp$country[gdp$country == "Czech Republic"] <- "Czechia"
gdp$country[gdp$country == "Iran"] <- "Iran (Islamic Republic of)"
gdp$country[gdp$country == "Korea"] <- "Republic of Korea"
gdp$country[gdp$country == "Laos"] <- "Lao People's Democratic Republic"
gdp$country[gdp$country == "Macedonia, North"] <- "The former Yugoslav Republic of Macedonia"
gdp$country[gdp$country == "Moldova"] <- "Republic of Moldova"
gdp$country[gdp$country == "Republic of the Congo"] <- "Congo"
gdp$country[gdp$country == "Russia"] <- "Russian Federation"
gdp$country[gdp$country == "St. Kitts Nevis"] <- "Saint Kitts and Nevis"
gdp$country[gdp$country == "St. Lucia"] <- "Saint Lucia"
gdp$country[gdp$country == "St. Vincent Grenadines"] <- "Saint Vincent and the Grenadines"
gdp$country[gdp$country == "Syria"] <- "Syrian Arab Republic"
gdp$country[gdp$country == "Tanzania"] <- "United Republic of Tanzania"
gdp$country[gdp$country == "United Kingdom"] <- "United Kingdom of Great Britain and Northern Ireland"
gdp$country[gdp$country == "United States"] <- "United States of America"
gdp$country[gdp$country == "Venezuela"] <- "Venezuela (Bolivarian Republic of)"
gdp$country[gdp$country == "Vietnam"] <- "Viet Nam"



#Drop rows that contain data of regions
gdp$country <- as.character(gdp$country)
gdp <- subset(gdp, gdp$country != "Africa"
              & gdp$country != "Asia"
              & gdp$country != "Asia and Oceania"
              & gdp$country != "Asia Less Japan"
              & gdp$country != "Belgium and Luxembourg"
              & gdp$country != "East Asia"
              & gdp$country != "East Asia Less Japan"
              & gdp$country != "Europe"
              & gdp$country != "European Union 15"
              & gdp$country != "European Union 28"
              & gdp$country != "European Union 27"
              & gdp$country != "Euro Zone"
              & gdp$country != "Asia less Japan"
              & gdp$country != "East Asia less Japan"
              & gdp$country != "Former Soviet Union"
              & gdp$country != "Latin America"
              & gdp$country != "Middle East"
              & gdp$country != "North Africa"
              & gdp$country != "North America"
              & gdp$country != "Oceania"
              & gdp$country != "Other Asia Oceania"
              & gdp$country != "Other Caribbean Central America"
              & gdp$country != "Other Central Europe"
              & gdp$country != "Other East Asia"
              & gdp$country != "Other Europe"
              & gdp$country != "Other Former Soviet Union"
              & gdp$country != "Other Middle East"
              & gdp$country != "Other North Africa"
              & gdp$country != "Other Oceania"
              & gdp$country != "Other South America"
              & gdp$country != "Other South Asia"
              & gdp$country != "Other Southeast Asia"
              & gdp$country != "Other Sub-Saharan Africa"
              & gdp$country != "Other West African Community"
              & gdp$country != "Other Western Europe"
              & gdp$country != "Recently acceded countries"
              & gdp$country != "South America"
              & gdp$country != "South Asia"
              & gdp$country != "Southeast Asia"
              & gdp$country != "Sub-Saharan Africa"
              & gdp$country != "United States and Canada"
              & gdp$country != "World"
              & gdp$country != "World less USA")




#Merge gdp data with iso-codes
gdp_iso <- merge(country_iso_cont, gdp, by="country")

#Write gdp data
write.csv(gdp_iso,"intermediate_outputs/gdp_iso.csv")

