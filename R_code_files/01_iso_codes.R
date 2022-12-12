#ISO-Codes####

#Read in iso-codes
country_iso_cont <- read.csv(paste(source_data,"country_codes.csv",sep=""))

#Keep and rename selected columns
country_iso_cont <- subset(country_iso_cont, select = c(official_name_en, ISO3166.1.Alpha.2, ISO3166.1.Alpha.3, Continent))

colnames(country_iso_cont)[colnames(country_iso_cont)=="official_name_en"] <- "country"
colnames(country_iso_cont)[colnames(country_iso_cont)=="ISO3166.1.Alpha.2"] <- "iso_2"
colnames(country_iso_cont)[colnames(country_iso_cont)=="ISO3166.1.Alpha.3"] <- "iso_3"
colnames(country_iso_cont)[colnames(country_iso_cont)=="Continent"] <- "continent"

#Replace continent abbreviation 'NA' (North America) to 'NO' (R does not recognize 'NA' as a character)
country_iso_cont$continent <- as.character(country_iso_cont$continent)
country_iso_cont$continent <- if_else(is.na(country_iso_cont$continent),"NO", country_iso_cont$continent)

#Drop the jurisdiction "Sark" (the island is fiscally autonomous but has no company registry, no company law, and also no ISO-code)
country_iso_cont <- subset(country_iso_cont, country_iso_cont$country != "Sark")

#Add the jurisdictions Netherland Antilles (was split into different jurisdictions in 2010) and Kosovo (has not yet officially been assigned a country code)
country_iso_cont$country <- as.character(country_iso_cont$country)
country_iso_cont$iso_2 <- as.character(country_iso_cont$iso_2)
country_iso_cont$iso_3 <- as.character(country_iso_cont$iso_3)

country_iso_cont[nrow(country_iso_cont) + 1,] = list("Kosovo, Republic of", "XK", "XKX", "EU")
country_iso_cont[nrow(country_iso_cont) + 1,] = list("Netherlands Antilles", "AN", "ANT", "NO")

#Correct country names that were read in incorrectly (mostly because R does not recognize accents)

country_iso_cont$country <- as.character(country_iso_cont$country)

country_iso_cont$country[country_iso_cont$iso_3 == "ALA"] <- "Aland Islands"

country_iso_cont$country[country_iso_cont$iso_3 == "CIV"] <- "Cote d'Ivoire"

country_iso_cont$country[country_iso_cont$iso_3 == "CUW"] <- "Curacao"

country_iso_cont$country[country_iso_cont$iso_3 == "REU"] <- "Reunion" 

country_iso_cont$country[country_iso_cont$iso_3 == "BLM"] <- "Saint Barthelemy"

country_iso_cont$country[country_iso_cont$iso_3 == "TWN"] <- "Taiwan"

#New dataframe that includes columns that define if a country belongs to a certain country group

country_iso_cont_groups <- country_iso_cont

country_iso_cont_groups$oecd <- ifelse(country_iso_cont$iso_3 == "AUS"
                                       | country_iso_cont$iso_3 == "AUT"
                                       | country_iso_cont$iso_3 == "BEL"
                                       | country_iso_cont$iso_3 == "CAN"
                                       | country_iso_cont$iso_3 == "CHL"
                                       | country_iso_cont$iso_3 == "COL"
                                       | country_iso_cont$iso_3 == "CRI"
                                       | country_iso_cont$iso_3 == "CZE"
                                       | country_iso_cont$iso_3 == "DNK"
                                       | country_iso_cont$iso_3 == "EST"
                                       | country_iso_cont$iso_3 == "FIN"
                                       | country_iso_cont$iso_3 == "FRA"
                                       | country_iso_cont$iso_3 == "DEU"
                                       | country_iso_cont$iso_3 == "GRC"
                                       | country_iso_cont$iso_3 == "HUN"
                                       | country_iso_cont$iso_3 == "ISL"
                                       | country_iso_cont$iso_3 == "IRL"
                                       | country_iso_cont$iso_3 == "ISR"
                                       | country_iso_cont$iso_3 == "ITA"
                                       | country_iso_cont$iso_3 == "JPN"
                                       | country_iso_cont$iso_3 == "KOR"
                                       | country_iso_cont$iso_3 == "LTU"
                                       | country_iso_cont$iso_3 == "LUX"
                                       | country_iso_cont$iso_3 == "LVA"
                                       | country_iso_cont$iso_3 == "MEX"
                                       | country_iso_cont$iso_3 == "NLD"
                                       | country_iso_cont$iso_3 == "NZL"
                                       | country_iso_cont$iso_3 == "NOR"
                                       | country_iso_cont$iso_3 == "POL"
                                       | country_iso_cont$iso_3 == "PRT"
                                       | country_iso_cont$iso_3 == "SVK"
                                       | country_iso_cont$iso_3 == "SVN"
                                       | country_iso_cont$iso_3 == "ESP"
                                       | country_iso_cont$iso_3 == "SWE"
                                       | country_iso_cont$iso_3 == "CHE"
                                       | country_iso_cont$iso_3 == "TUR"
                                       | country_iso_cont$iso_3 == "GBR"
                                       | country_iso_cont$iso_3 == "USA"
                                       ,1,0)

country_iso_cont_groups$eu27 <- ifelse(country_iso_cont$iso_3 == "AUT"
                                       | country_iso_cont$iso_3 == "BEL"
                                       | country_iso_cont$iso_3 == "BGR"
                                       | country_iso_cont$iso_3 == "CZE"
                                       | country_iso_cont$iso_3 == "CYP"
                                       | country_iso_cont$iso_3 == "DNK"
                                       | country_iso_cont$iso_3 == "EST"
                                       | country_iso_cont$iso_3 == "FIN"
                                       | country_iso_cont$iso_3 == "FRA"
                                       | country_iso_cont$iso_3 == "DEU"
                                       | country_iso_cont$iso_3 == "GRC"
                                       | country_iso_cont$iso_3 == "HUN"
                                       | country_iso_cont$iso_3 == "HRV"
                                       | country_iso_cont$iso_3 == "IRL"
                                       | country_iso_cont$iso_3 == "ITA"
                                       | country_iso_cont$iso_3 == "LTU"
                                       | country_iso_cont$iso_3 == "LUX"
                                       | country_iso_cont$iso_3 == "LVA"
                                       | country_iso_cont$iso_3 == "MLT"
                                       | country_iso_cont$iso_3 == "NLD"
                                       | country_iso_cont$iso_3 == "POL"
                                       | country_iso_cont$iso_3 == "PRT"
                                       | country_iso_cont$iso_3 == "ROU"
                                       | country_iso_cont$iso_3 == "SVK"
                                       | country_iso_cont$iso_3 == "SVN"
                                       | country_iso_cont$iso_3 == "ESP"
                                       | country_iso_cont$iso_3 == "SWE"
                                       ,1,0)


country_iso_cont_groups$gseven <- ifelse(country_iso_cont$iso_3 == "CAN"
                                         | country_iso_cont$iso_3 == "FRA"
                                         | country_iso_cont$iso_3 == "DEU"
                                         | country_iso_cont$iso_3 == "ITA"
                                         | country_iso_cont$iso_3 == "JPN"
                                         | country_iso_cont$iso_3 == "GBR"
                                         | country_iso_cont$iso_3 == "USA"
                                         ,1,0)

country_iso_cont_groups$gtwenty <- ifelse(country_iso_cont$iso_3 == "ARG"
                                          | country_iso_cont$iso_3 == "AUS"
                                          | country_iso_cont$iso_3 == "BRA"
                                          | country_iso_cont$iso_3 == "CAN"
                                          | country_iso_cont$iso_3 == "CHN"
                                          | country_iso_cont$iso_3 == "FRA"
                                          | country_iso_cont$iso_3 == "DEU"
                                          | country_iso_cont$iso_3 == "IND"
                                          | country_iso_cont$iso_3 == "IDN"
                                          | country_iso_cont$iso_3 == "ITA"
                                          | country_iso_cont$iso_3 == "JPN"
                                          | country_iso_cont$iso_3 == "KOR"
                                          | country_iso_cont$iso_3 == "MEX"
                                          | country_iso_cont$iso_3 == "RUS"
                                          | country_iso_cont$iso_3 == "SAU"
                                          | country_iso_cont$iso_3 == "ZAF"
                                          | country_iso_cont$iso_3 == "TUR"
                                          | country_iso_cont$iso_3 == "GBR"
                                          | country_iso_cont$iso_3 == "USA"
                                          ,1,0)

country_iso_cont_groups$brics <- ifelse(country_iso_cont$iso_3 == "BRA"
                                        | country_iso_cont$iso_3 == "CHN"
                                        | country_iso_cont$iso_3 == "IND"
                                        | country_iso_cont$iso_3 == "RUS"
                                        | country_iso_cont$iso_3 == "ZAF"
                                        ,1,0)


