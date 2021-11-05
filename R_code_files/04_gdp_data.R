#GDP Data####

#Reading in GDP data
gdp_historical_2010<- read_excel("source_data/gdp_historical_2010.xlsx", range = "A12:AN230")
gdp_historical_2015<- read_excel("source_data/gdp_historical_2015.xlsx", range = "A14:V234")
gdp_projected_2015 <- read_excel("source_data/gdp_projected_2015.xlsx", range = "A14:K234")

#Merging historical and projected data
gdp_historical_2010 <-gdp_historical_2010[,-c(21:40)]
gdp_projected_2015 <- gdp_projected_2015[,-c(2:9)]

gdp_historical_2010$Country[gdp_historical_2010$Country == "Antigua Barbuda"] <- "Antigua and Barbuda"
gdp_historical_2010$Country[gdp_historical_2010$Country == "Dominican Rep"] <- "Dominican Republic"
gdp_historical_2010$Country[gdp_historical_2010$Country == "St Kitts Nevis"] <- "St. Kitts and Nevis"
gdp_historical_2010$Country[gdp_historical_2010$Country == "St Lucia"] <- "St. Lucia"
gdp_historical_2010$Country[gdp_historical_2010$Country == "St Vincent Grenadines"] <- "St. Vincent and Grenadines"
gdp_historical_2010$Country[gdp_historical_2010$Country == "UK"] <- "United Kingdom"
gdp_historical_2010$Country[gdp_historical_2010$Country == "Bosnia Herzegovina"] <- "Bosnia and Herzegovina"
gdp_historical_2015$Country[gdp_historical_2015$Country == "Côte d'Ivoire"] <- "Cote d'Ivoire"
gdp_projected_2015$Country[gdp_projected_2015$Country == "Côte d'Ivoire"] <- "Cote d'Ivoire"
gdp_historical_2010$Country[gdp_historical_2010$Country == "Guinea Bissau"] <- "Guinea-Bissau"
gdp_historical_2010$Country[gdp_historical_2010$Country == "Central Afr Rep"] <- "Central African Republic"
gdp_historical_2010$Country[gdp_historical_2010$Country == "Dem Rep Congo"] <- "Democratic Republic of the Congo"
gdp_historical_2010$Country[gdp_historical_2010$Country == "Rep Congo"] <- "Republic of the Congo"
gdp_historical_2010$Country[gdp_historical_2010$Country == "Sao Tome Principe"] <- "Sao Tome and Principe"
gdp_historical_2015$Country[gdp_historical_2015$Country == "São Tomé and Príncipe"] <- "Sao Tome and Principe"
gdp_projected_2015$Country[gdp_projected_2015$Country == "São Tomé and Príncipe"] <- "Sao Tome and Principe"
gdp_historical_2015$Country[gdp_historical_2015$Country == "Swaziland/Eswatini"] <- "Swaziland"
gdp_projected_2015$Country[gdp_projected_2015$Country == "Swaziland/Eswatini"] <- "Swaziland"

#write.csv(gdp_historical_2010,"gdp_historical_2010.csv",row.names = F)
#write.csv(gdp_historical_2015,"gdp_historical_2015.csv",row.names = F)
#write.csv(gdp_projected_2015,"gdp_projected_2015.csv",row.names = F)

gdp <- merge(gdp_historical_2010, gdp_historical_2015, by="Country", All=T)
gdp <- merge(gdp, gdp_projected_2015, by="Country", All=T)

#write.csv(gdp,"gdp.csv", row.names=F)
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
gdp$country[gdp$country == "Macedonia"] <- "The former Yugoslav Republic of Macedonia"
gdp$country[gdp$country == "Moldova"] <- "Republic of Moldova"
gdp$country[gdp$country == "Republic of the Congo"] <- "Congo"
gdp$country[gdp$country == "Russia"] <- "Russian Federation"
gdp$country[gdp$country == "St. Kitts and Nevis"] <- "Saint Kitts and Nevis"
gdp$country[gdp$country == "St. Lucia"] <- "Saint Lucia"
gdp$country[gdp$country == "St. Vincent and Grenadines"] <- "Saint Vincent and the Grenadines"
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
              & gdp$country != "Belgium Luxembourg"
              & gdp$country != "East Asia"
              & gdp$country != "East Asia Less Japan"
              & gdp$country != "Europe"
              & gdp$country != "European Union 15"
              & gdp$country != "European Union 28"
              & gdp$country != "Euro Zone"
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
              & gdp$country != "Recently Acceded Countries"
              & gdp$country != "South America"
              & gdp$country != "South Asia"
              & gdp$country != "Southeast Asia"
              & gdp$country != "Sub-Saharan Africa"
              & gdp$country != "World"
              & gdp$country != "World Less USA")

#Merge gdp data with iso-codes
gdp_iso <- merge(country_iso_cont, gdp, by="country")

#Write gdp data
write.csv(gdp_iso,"intermediate_outputs/gdp_iso.csv")

