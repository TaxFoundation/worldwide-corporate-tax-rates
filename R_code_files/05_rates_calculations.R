#Data reshape####

rates_final_long <- (melt(all_years_final, id=c("iso_2","iso_3","continent","country")))
colnames(rates_final_long)[colnames(rates_final_long)=="variable"] <- "year"
colnames(rates_final_long)[colnames(rates_final_long)=="value"] <- "rate"



Added this part....

#Change format of GDP data from wide to long
gdp_iso$country <- as.character(gdp_iso$country)
data$country <- as.character(data$country)
gdp_iso_long <- (melt(gdp, id=c("country")))
colnames(gdp_iso_long)[colnames(gdp_long)=="variable"] <- "year"
colnames(gdp_iso_long)[colnames(gdp_iso_long)=="value"] <- "gdp"

#delete the "y" before the year"
gdp_iso_long$year <- gsub("^.{0,1}", "", gdp_iso_long$year)

gdp_iso_long <- (melt(gdp_iso, id=c("iso_2","iso_3","continent","country")))
colnames(gdp_iso_long)[colnames(gdp_iso_long)=="variable"] <- "year"
colnames(gdp_iso_long)[colnames(gdp_iso_long)=="value"] <- "gdp"

#Merge rates and gdp
rates_gdp <- merge(rates_final_long, gdp_iso_long, by =c("iso_2","iso_3", "continent","country", "year"), all=T)

until here...





gdp_iso_long <- (melt(gdp_iso, id=c("iso_2","iso_3","continent","country")))
colnames(gdp_iso_long)[colnames(gdp_iso_long)=="variable"] <- "year"
colnames(gdp_iso_long)[colnames(gdp_iso_long)=="value"] <- "gdp"

#Merge rates and gdp
rates_gdp <- merge(rates_final_long, gdp_iso_long, by =c("iso_2","iso_3", "continent","country", "year"), all=T)

#Merge 'rate and gdp' dataset with country groups
rates_gdp <- merge(rates_gdp, country_iso_cont_groups, by =c("iso_2","iso_3", "continent","country"), all=T)
final_data <- rates_gdp[order(rates_gdp$iso_3, rates_gdp$year),]

#Write as final data file
write.csv(final_data,"final_data/final_data_long.csv", row.names = FALSE)


#Summary statistics####

#Drop if no gdp or rate data
complete_data <- final_data[complete.cases(final_data$rate, final_data$gdp),]
complete_data$rate <- as.numeric(complete_data$rate)
complete_data$gdp <- as.numeric(complete_data$gdp)


#Creating the 2022 dataset that includes only countries for which we have gdp data
data2022 <- subset(complete_data, year==2022, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu27, gseven, gtwenty, brics))
write.csv(data2022, "final_data/final_data_2022.csv")

#Creating the 2022 dataset that includes countries with missing gdp data as well
data2022_gdp_mis <- subset(final_data, year==2022, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu27, gseven, gtwenty, brics))
data2022_gdp_mis <- subset(data2022_gdp_mis, !is.na(data2022_gdp_mis$rate))
write.csv(data2022_gdp_mis, "final_data/final_data_2022_gdp_incomplete.csv")

#2022 simple mean (including only countries with gdp data)
data2022$rate <- as.numeric(data2022$rate)
simple_mean_22 <- mean(data2022$rate, na.rm = TRUE)

#2022 simple mean (including countries with missing gdp data)
data2022_gdp_mis$rate <- as.numeric(data2022_gdp_mis$rate)
simple_mean_22_gdp_mis <- mean(data2022_gdp_mis$rate, na.rm = TRUE)

#2022 weighted mean (including only countries with gdp data)
weighted_mean_22 <- weighted.mean(data2022$rate, data2022$gdp, na.rm = TRUE)

#2022 number of rates (including only countries with gdp data)
numrates_22 <- NROW(data2022$rate)
numgdp_22 <- NROW(data2022$gdp)

#2022 number of rates (including countries with missing gdp data)
numrates_22_gdp_mis <- NROW(data2022_gdp_mis$rate)
numgdp_22_gdp_mis <- NROW(data2022_gdp_mis$gdp)

#Table showing rate changes between 2021 and 2022
rate_changes <- all_years_final
rate_changes <- subset(rate_changes, select = c("iso_3", "country", "continent", 2021, 2022))
rate_changes <- rate_changes[complete.cases(rate_changes),]

rate_changes$'2021'<- as.numeric(rate_changes$'2021')
rate_changes$'2022'<- as.numeric(rate_changes$'2022')

rate_changes$change <- (rate_changes$'2022' - rate_changes$'2021')

#Drop countries with no changes
rate_changes <- subset(rate_changes, change!=0)

#Drop countries with only minor changes
rate_changes <- subset(rate_changes, rate_changes$change > 0.5 | rate_changes$change < -0.5)

#Rename continents and column names
rate_changes$continent <- if_else(rate_changes$continent == "EU", "Europe", rate_changes$continent)
rate_changes$continent <- if_else(rate_changes$continent == "OC", "Oceania", rate_changes$continent)
rate_changes$continent <- if_else(rate_changes$continent == "AF", "Africa", rate_changes$continent)
rate_changes$continent <- if_else(rate_changes$continent == "AS", "Asia", rate_changes$continent)
rate_changes$continent <- if_else(rate_changes$continent == "NO", "North America", rate_changes$continent)
rate_changes$continent <- if_else(rate_changes$continent == "SA", "South America", rate_changes$continent)

colnames(rate_changes)[colnames(rate_changes)=="iso_3"] <- "ISO_3"
colnames(rate_changes)[colnames(rate_changes)=="country"] <- "Country"
colnames(rate_changes)[colnames(rate_changes)=="continent"] <- "Continent"
colnames(rate_changes)[colnames(rate_changes)=="2021"] <- "2021 Tax Rate"
colnames(rate_changes)[colnames(rate_changes)=="2022"] <- "2022 Tax Rate"
colnames(rate_changes)[colnames(rate_changes)=="change"] <- "Change from 2021 to 2022"

#Order and write table
rate_changes <- rate_changes[order(rate_changes$Continent, rate_changes$Country),]

write.csv(rate_changes, "final_outputs/rate_changes.csv")


#Top, Bottom, and Zero Rates

#Top
toprate <- arrange(data2022_gdp_mis, desc(rate))
toprate <- toprate[1:20,]

toprate$continent <- if_else(toprate$continent == "EU", "Europe", toprate$continent)
toprate$continent <- if_else(toprate$continent == "OC", "Oceania", toprate$continent)
toprate$continent <- if_else(toprate$continent == "AF", "Africa", toprate$continent)
toprate$continent <- if_else(toprate$continent == "AS", "Asia", toprate$continent)
toprate$continent <- if_else(toprate$continent == "NO", "North America", toprate$continent)
toprate$continent <- if_else(toprate$continent == "SA", "South America", toprate$continent)

toprate <- subset(toprate, select = c(country, continent, rate))

colnames(toprate)[colnames(toprate)=="country"] <- "Country"
colnames(toprate)[colnames(toprate)=="continent"] <- "Continent"
colnames(toprate)[colnames(toprate)=="rate"] <- "Rate"

toprate <- toprate[order(-toprate$Rate, toprate$Country),]

#bottom
bottomrate <- arrange(data2022_gdp_mis, rate)
bottomrate <- subset(bottomrate, rate > 0)
bottomrate <- bottomrate[1:20,]

bottomrate$continent <- if_else(bottomrate$continent == "EU", "Europe", bottomrate$continent)
bottomrate$continent <- if_else(bottomrate$continent == "OC", "Oceania", bottomrate$continent)
bottomrate$continent <- if_else(bottomrate$continent == "AF", "Africa", bottomrate$continent)
bottomrate$continent <- if_else(bottomrate$continent == "AS", "Asia", bottomrate$continent)
bottomrate$continent <- if_else(bottomrate$continent == "NO", "North America", bottomrate$continent)
bottomrate$continent <- if_else(bottomrate$continent == "SA", "South America", bottomrate$continent)

bottomrate <- subset(bottomrate, select = c(country, continent, rate))

colnames(bottomrate)[colnames(bottomrate)=="country"] <- "Country"
colnames(bottomrate)[colnames(bottomrate)=="continent"] <- "Continent"
colnames(bottomrate)[colnames(bottomrate)=="rate"] <- "Rate"

bottomrate <- bottomrate[order(bottomrate$Rate, bottomrate$Country),]

#zero
zerorate <- arrange(data2022_gdp_mis, rate)
zerorate <- subset(zerorate, rate==0)

zerorate$continent <- if_else(zerorate$continent == "EU", "Europe", zerorate$continent)
zerorate$continent <- if_else(zerorate$continent == "OC", "Oceania", zerorate$continent)
zerorate$continent <- if_else(zerorate$continent == "AF", "Africa", zerorate$continent)
zerorate$continent <- if_else(zerorate$continent == "AS", "Asia", zerorate$continent)
zerorate$continent <- if_else(zerorate$continent == "NO", "North America", zerorate$continent)
zerorate$continent <- if_else(zerorate$continent == "SA", "South America", zerorate$continent)

zerorate <- subset(zerorate, select = c(country, continent, rate))

colnames(zerorate)[colnames(zerorate)=="country"] <- "Country"
colnames(zerorate)[colnames(zerorate)=="continent"] <- "Continent"
colnames(zerorate)[colnames(zerorate)=="rate"] <- "Rate"

zerorate <- zerorate[order(zerorate$Country),]

#exporting top, bottom, and zero rate
write.csv(toprate, "final_outputs/top_rates.csv")
write.csv(bottomrate, "final_outputs/bottom_rates.csv")
write.csv(zerorate, "final_outputs/zero_rates.csv")


#Regional distribution###

#2022 by region
#Creating regional sets (including only countries with gdp data)
africa <- subset(data2022, continent=="AF")
africa$rate <- as.numeric(africa$rate)
africa$gdp <- as.numeric(africa$gdp)

asia <- subset(data2022, continent=="AS")
asia$rate <- as.numeric(asia$rate)
asia$gdp <- as.numeric(asia$gdp)

europe <- subset(data2022, continent=="EU")
europe$rate <- as.numeric(europe$rate)
europe$gdp <- as.numeric(europe$gdp)

northa <- subset(data2022, continent=="NO")
northa$rate <- as.numeric(northa$rate)
northa$gdp <- as.numeric(northa$gdp)

southa <- subset(data2022, continent=="SA")
southa$rate <- as.numeric(southa$rate)
southa$gdp <- as.numeric(southa$gdp)

oceania <- subset(data2022, continent=="OC")
oceania$rate <- as.numeric(oceania$rate)
oceania$gdp <- as.numeric(oceania$gdp)

eu27 <- subset(data2022, eu27==1)
eu27$rate <- as.numeric(eu27$rate)
eu27$gdp <- as.numeric(eu27$gdp)

brics <- subset(data2022, brics==1)
brics$rate <- as.numeric(brics$rate)
brics$gdp <- as.numeric(brics$gdp)

g7 <- subset(data2022, gseven==1)
g7$rate <- as.numeric(g7$rate)
g7$gdp <- as.numeric(g7$gdp)

g20 <- subset(data2022, gtwenty==1)
g20$rate <- as.numeric(g20$rate)
g20$gdp <- as.numeric(g20$gdp)

oecd <- subset(data2022, oecd==1)
oecd$rate <- as.numeric(oecd$rate)
oecd$gdp <- as.numeric(oecd$gdp)

#Creating regional sets (including countries with missing gdp data)
africa_gdp_mis <- subset(data2022_gdp_mis, continent=="AF")
asia_gdp_mis <- subset(data2022_gdp_mis, continent=="AS")
europe_gdp_mis <- subset(data2022_gdp_mis, continent=="EU")
northa_gdp_mis <- subset(data2022_gdp_mis, continent=="NO")
southa_gdp_mis <- subset(data2022_gdp_mis, continent=="SA")
oceania_gdp_mis <- subset(data2022_gdp_mis, continent=="OC")
eu_gdp_mis <- subset(data2022_gdp_mis, eu27==1)
brics_gdp_mis <- subset(data2022_gdp_mis, brics==1)
g7_gdp_mis <- subset(data2022_gdp_mis, gseven==1)
g20_gdp_mis <- subset(data2022_gdp_mis, gtwenty==1)
oecd_gdp_mis <- subset(data2022_gdp_mis, oecd==1)

#Simple Means
africa_mean <- mean(africa$rate, na.rm=TRUE)
asia_mean <- mean(asia$rate, na.rm=TRUE)
europe_mean <- mean(europe$rate, na.rm=TRUE)
northa_mean <- mean(northa$rate, na.rm=TRUE)
southa_mean <- mean(southa$rate, na.rm=TRUE)
oceania_mean <- mean(oceania$rate, na.rm=TRUE)
eu_mean <- mean(eu27$rate, na.rm=TRUE)
brics_mean <- mean(brics$rate, na.rm = TRUE)
g7_mean <- mean(g7$rate, na.rm = TRUE)
g20_mean <- mean(g20$rate, na.rm=TRUE)
oecd_mean <- mean(oecd$rate, na.rm=TRUE)

#Weighted Means
africa_wmean <- weighted.mean(africa$rate, africa$gdp, na.rm=TRUE)
asia_wmean <- weighted.mean(asia$rate, asia$gdp, na.rm=TRUE)
europe_wmean <- weighted.mean(europe$rate, europe$gdp, na.rm=TRUE)
northa_wmean <- weighted.mean(northa$rate, northa$gdp, na.rm=TRUE)
southa_wmean <- weighted.mean(southa$rate, southa$gdp, na.rm=TRUE)
oceania_wmean <- weighted.mean(oceania$rate, oceania$gdp, na.rm=TRUE)
eu_wmean <- weighted.mean(eu27$rate, eu27$gdp, na.rm=TRUE)
brics_wmean <- weighted.mean(brics$rate, brics$gdp, na.rm = TRUE)
g7_wmean <- weighted.mean(g7$rate, g7$gdp, na.rm = TRUE)
g20_wmean <- weighted.mean(g20$rate, g20$gdp, na.rm=TRUE)
oecd_wmean <- weighted.mean(oecd$rate, oecd$gdp, na.rm=TRUE)


#Counts
africa_count <- NROW(africa$gdp)
asia_count <- NROW(asia$gdp)
europe_count <- NROW(europe$gdp)
northa_count <- NROW(northa$gdp)
southa_count <- NROW(southa$gdp)
oceania_count <- NROW(oceania$gdp)
eu_count <- NROW(eu27$gdp)
brics_count <- NROW(brics$gdp)
g7_count <- NROW(g7$gdp)
g20_count <- NROW(g20$gdp)
oecd_count <- NROW(oecd$gdp)

#compile
region <- c("Africa","Asia","Europe","North America","Oceania","South America","G7","OECD",
            "BRICS","EU27","G20","World")
avgrate22 <- c(africa_mean,asia_mean,europe_mean,northa_mean,
               oceania_mean,southa_mean, g7_mean,oecd_mean,brics_mean,
               eu_mean,g20_mean,simple_mean_22)
wavgrate22 <-c(africa_wmean,asia_wmean,europe_wmean,northa_wmean,
               oceania_wmean,southa_wmean,g7_wmean,oecd_wmean,brics_wmean,
               eu_wmean,g20_wmean,weighted_mean_22)
count22 <-c(africa_count,asia_count,europe_count,northa_count,oceania_count,southa_count,
            g7_count,oecd_count,brics_count,eu_count,g20_count, numgdp_22)
regional22 <- data.frame(region,avgrate22,wavgrate22,count22)


#Historical rates by every decade

#2010 by region
data2010 <- subset(complete_data, year==2010, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu27, gseven, gtwenty, brics))
data2010$rate <- as.numeric(data2010$rate)
data2010$gdp <- as.numeric(data2010$gdp)
mean10 <- mean(data2010$rate, na.rm = TRUE)
wmean10 <- weighted.mean(data2010$rate, data2010$gdp, na.rm = TRUE)
numgdp_10 <- NROW(data2010$gdp)

#Creating regional sets
africa10 <- subset(data2010, continent=="AF")
africa10$rate <- as.numeric(africa10$rate)
africa10$gdp <- as.numeric(africa10$gdp)

asia10 <- subset(data2010, continent=="AS")
asia10$rate <- as.numeric(asia10$rate)
asia10$gdp <- as.numeric(asia10$gdp)

europe10 <- subset(data2010, continent=="EU")
europe10$rate <- as.numeric(europe10$rate)
europe10$gdp <- as.numeric(europe10$gdp)

northa10 <- subset(data2010, continent=="NO")
northa10$rate <- as.numeric(northa10$rate)
northa10$gdp <- as.numeric(northa10$gdp)

southa10 <- subset(data2010, continent=="SA")
southa10$rate <- as.numeric(southa10$rate)
southa10$gdp <- as.numeric(southa10$gdp)

oceania10 <- subset(data2010, continent=="OC")
oceania10$rate <- as.numeric(oceania10$rate)
oceania10$gdp <- as.numeric(oceania10$gdp)

eu10 <- subset(data2010, eu27==1)
eu10$rate <- as.numeric(eu10$rate)
eu10$gdp <- as.numeric(eu10$gdp)

brics10 <- subset(data2010, brics==1)
brics10$rate <- as.numeric(brics10$rate)
brics10$gdp <- as.numeric(brics10$gdp)

g710 <- subset(data2010, gseven==1)
g710$rate <- as.numeric(g710$rate)
g710$gdp <- as.numeric(g710$gdp)

g2010 <- subset(data2010, gtwenty==1)
g2010$rate <- as.numeric(g2010$rate)
g2010$gdp <- as.numeric(g2010$gdp)

oecd10 <- subset(data2010, oecd==1)
oecd10$rate <- as.numeric(oecd10$rate)
oecd10$gdp <- as.numeric(oecd10$gdp)

#Simple Means
africa_mean10 <- mean(africa10$rate, na.rm=TRUE)
asia_mean10 <- mean(asia10$rate, na.rm=TRUE)
europe_mean10 <- mean(europe10$rate, na.rm=TRUE)
northa_mean10 <- mean(northa10$rate, na.rm=TRUE)
southa_mean10 <- mean(southa10$rate, na.rm=TRUE)
oceania_mean10 <- mean(oceania10$rate, na.rm=TRUE)
eu_mean10 <- mean(eu10$rate, na.rm=TRUE)
brics_mean10 <- mean(brics10$rate, na.rm = TRUE)
g7_mean10 <- mean(g710$rate, na.rm = TRUE)
g20_mean10 <- mean(g2010$rate, na.rm=TRUE)
oecd_mean10 <- mean(oecd10$rate, na.rm=TRUE)

#Weighted Means
africa_wmean10 <- weighted.mean(africa10$rate, africa10$gdp, na.rm=TRUE)
asia_wmean10 <- weighted.mean(asia10$rate, asia10$gdp, na.rm=TRUE)
europe_wmean10 <- weighted.mean(europe10$rate, europe10$gdp, na.rm=TRUE)
northa_wmean10 <- weighted.mean(northa10$rate, northa10$gdp, na.rm=TRUE)
southa_wmean10 <- weighted.mean(southa10$rate, southa10$gdp, na.rm=TRUE)
oceania_wmean10 <- weighted.mean(oceania10$rate, oceania10$gdp, na.rm=TRUE)
eu_wmean10 <- weighted.mean(eu10$rate, eu10$gdp, na.rm=TRUE)
brics_wmean10 <- weighted.mean(brics10$rate, brics10$gdp, na.rm = TRUE)
g7_wmean10 <- weighted.mean(g710$rate, g710$gdp, na.rm = TRUE)
g20_wmean10 <- weighted.mean(g2010$rate, g2010$gdp, na.rm=TRUE)
oecd_wmean10 <- weighted.mean(oecd10$rate, oecd10$gdp, na.rm=TRUE)

#Counts
africa_count10 <- NROW(africa10$gdp)
asia_count10 <- NROW(asia10$gdp)
europe_count10 <- NROW(europe10$gdp)
northa_count10 <- NROW(northa10$gdp)
southa_count10 <- NROW(southa10$gdp)
oceania_count10 <- NROW(oceania10$gdp)
eu_count10 <- NROW(eu10$gdp)
brics_count10 <- NROW(brics10$gdp)
g7_count10 <- NROW(g710$gdp)
g20_count10 <- NROW(g2010$gdp)
oecd_count10 <- NROW(oecd10$gdp)

#compile
region <- c("Africa","Asia","Europe","North America","Oceania","South America","G7","OECD",
            "BRICS","EU27","G20","World")
avgrate10 <- c(africa_mean10,asia_mean10,europe_mean10,northa_mean10,
               oceania_mean10,southa_mean10, g7_mean10,oecd_mean10,brics_mean10,
               eu_mean10,g20_mean10,mean10)
wavgrate10 <- c(africa_wmean10,asia_wmean10,europe_wmean10,northa_wmean10,
                oceania_wmean10,southa_wmean10,g7_wmean10,oecd_wmean10,brics_wmean10,
                eu_wmean10,g20_wmean10,wmean10)
count10 <- c(africa_count10,asia_count10,europe_count10,northa_count10,oceania_count10,southa_count10,
             g7_count10,oecd_count10,brics_count10,eu_count10,g20_count10, numgdp_10)
regional10 <- data.frame(region,avgrate10,wavgrate10,count10)

#2000 by region
data2000 <- subset(complete_data, year==2000, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu27, gseven, gtwenty, brics))
data2000$rate <- as.numeric(data2000$rate)
mean00 <- mean(data2000$rate, na.rm = TRUE)
wmean00 <- weighted.mean(data2000$rate, data2000$gdp, na.rm = TRUE)
numgdp_00 <- NROW(data2000$gdp)

#Creating regional sets
africa00 <- subset(data2000, continent=="AF")
africa00$rate <- as.numeric(africa00$rate)
africa00$gdp <- as.numeric(africa00$gdp)

asia00 <- subset(data2000, continent=="AS")
asia00$rate <- as.numeric(asia00$rate)
asia00$gdp <- as.numeric(asia00$gdp)

europe00 <- subset(data2000, continent=="EU")
europe00$rate <- as.numeric(europe00$rate)
europe00$gdp <- as.numeric(europe00$gdp)

northa00 <- subset(data2000, continent=="NO")
northa00$rate <- as.numeric(northa00$rate)
northa00$gdp <- as.numeric(northa00$gdp)

southa00 <- subset(data2000, continent=="SA")
southa00$rate <- as.numeric(southa00$rate)
southa00$gdp <- as.numeric(southa00$gdp)

oceania00 <- subset(data2000, continent=="OC")
oceania00$rate <- as.numeric(oceania00$rate)
oceania00$gdp <- as.numeric(oceania00$gdp)

eu00 <- subset(data2000, eu27==1)
eu00$rate <- as.numeric(eu00$rate)
eu00$gdp <- as.numeric(eu00$gdp)

brics00 <- subset(data2000, brics==1)
brics00$rate <- as.numeric(brics00$rate)
brics00$gdp <- as.numeric(brics00$gdp)

g700 <- subset(data2000, gseven==1)
g700$rate <- as.numeric(g700$rate)
g700$gdp <- as.numeric(g700$gdp)

g2000 <- subset(data2000, gtwenty==1)
g2000$rate <- as.numeric(g2000$rate)
g2000$gdp <- as.numeric(g2000$gdp)

oecd00 <- subset(data2000, oecd==1)
oecd00$rate <- as.numeric(oecd00$rate)
oecd00$gdp <- as.numeric(oecd00$gdp)


#Simple Means
africa_mean00 <- mean(africa00$rate, na.rm=TRUE)
asia_mean00 <- mean(asia00$rate, na.rm=TRUE)
europe_mean00 <- mean(europe00$rate, na.rm=TRUE)
northa_mean00 <- mean(northa00$rate, na.rm=TRUE)
southa_mean00 <- mean(southa00$rate, na.rm=TRUE)
oceania_mean00 <- mean(oceania00$rate, na.rm=TRUE)
eu_mean00 <- mean(eu00$rate, na.rm=TRUE)
brics_mean00 <- mean(brics00$rate, na.rm = TRUE)
g7_mean00 <- mean(g700$rate, na.rm = TRUE)
g20_mean00 <- mean(g2000$rate, na.rm=TRUE)
oecd_mean00 <- mean(oecd00$rate, na.rm=TRUE)

#Weighted Means
africa_wmean00 <- weighted.mean(africa00$rate, africa00$gdp, na.rm=TRUE)
asia_wmean00 <- weighted.mean(asia00$rate, asia00$gdp, na.rm=TRUE)
europe_wmean00 <- weighted.mean(europe00$rate, europe00$gdp, na.rm=TRUE)
northa_wmean00 <- weighted.mean(northa00$rate, northa00$gdp, na.rm=TRUE)
southa_wmean00 <- weighted.mean(southa00$rate, southa00$gdp, na.rm=TRUE)
oceania_wmean00 <- weighted.mean(oceania00$rate, oceania00$gdp, na.rm=TRUE)
eu_wmean00 <- weighted.mean(eu00$rate, eu00$gdp, na.rm=TRUE)
brics_wmean00 <- weighted.mean(brics00$rate, brics00$gdp, na.rm = TRUE)
g7_wmean00 <- weighted.mean(g700$rate, g700$gdp, na.rm = TRUE)
g20_wmean00 <- weighted.mean(g2000$rate, g2000$gdp, na.rm=TRUE)
oecd_wmean00 <- weighted.mean(oecd00$rate, oecd00$gdp, na.rm=TRUE)

#Counts
africa_count00 <- NROW(africa00$gdp)
asia_count00 <- NROW(asia00$gdp)
europe_count00 <- NROW(europe00$gdp)
northa_count00 <- NROW(northa00$gdp)
southa_count00 <- NROW(southa00$gdp)
oceania_count00 <- NROW(oceania00$gdp)
eu_count00 <- NROW(eu00$gdp)
brics_count00 <- NROW(brics00$gdp)
g7_count00 <- NROW(g700$gdp)
g20_count00 <- NROW(g2000$gdp)
oecd_count00 <- NROW(oecd00$gdp)

#compile
region <- c("Africa","Asia","Europe","North America","Oceania","South America","G7","OECD",
            "BRICS","EU27","G20","World")
avgrate00 <- c(africa_mean00,asia_mean00,europe_mean00,northa_mean00,
               oceania_mean00,southa_mean00, g7_mean00,oecd_mean00,brics_mean00,
               eu_mean00,g20_mean00,mean00)
wavgrate00 <-c(africa_wmean00,asia_wmean00,europe_wmean00,northa_wmean00,
               oceania_wmean00,southa_wmean00,g7_wmean00,oecd_wmean00,brics_wmean00,
               eu_wmean00,g20_wmean00,wmean00)
count00 <-c(africa_count00,asia_count00,europe_count00,northa_count00,oceania_count00,southa_count00,
            g7_count00,oecd_count00,brics_count00,eu_count00,g20_count00, numgdp_00)
regional00<-data.frame(region,avgrate00,wavgrate00,count00)

#1990 by region
data1990 <- subset(complete_data, year==1990, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu27, gseven, gtwenty, brics))
data1990$rate <- as.numeric(data1990$rate)
mean90 <- mean(data1990$rate, na.rm = TRUE)
wmean90 <- weighted.mean(data1990$rate, data1990$gdp, na.rm = TRUE)
numgdp_90 <- NROW(data1990$gdp)

#Creating regional sets
africa90 <- subset(data1990, continent=="AF")
africa90$rate <- as.numeric(africa90$rate)
africa90$gdp <- as.numeric(africa90$gdp)

asia90 <- subset(data1990, continent=="AS")
asia90$rate <- as.numeric(asia90$rate)
asia90$gdp <- as.numeric(asia90$gdp)

europe90 <- subset(data1990, continent=="EU")
europe90$rate <- as.numeric(europe90$rate)
europe90$gdp <- as.numeric(europe90$gdp)

northa90 <- subset(data1990, continent=="NO")
northa90$rate <- as.numeric(northa90$rate)
northa90$gdp <- as.numeric(northa90$gdp)

southa90 <- subset(data1990, continent=="SA")
southa90$rate <- as.numeric(southa90$rate)
southa90$gdp <- as.numeric(southa90$gdp)

oceania90 <- subset(data1990, continent=="OC")
oceania90$rate <- as.numeric(oceania90$rate)
oceania90$gdp <- as.numeric(oceania90$gdp)

eu90 <- subset(data1990, eu27==1)
eu90$rate <- as.numeric(eu90$rate)
eu90$gdp <- as.numeric(eu90$gdp)

brics90 <- subset(data1990, brics==1)
brics90$rate <- as.numeric(brics90$rate)
brics90$gdp <- as.numeric(brics90$gdp)

g790 <- subset(data1990, gseven==1)
g790$rate <- as.numeric(g790$rate)
g790$gdp <- as.numeric(g790$gdp)

g2090 <- subset(data1990, gtwenty==1)
g2090$rate <- as.numeric(g2090$rate)
g2090$gdp <- as.numeric(g2090$gdp)

oecd90 <- subset(data1990, oecd==1)
oecd90$rate <- as.numeric(oecd90$rate)
oecd90$gdp <- as.numeric(oecd90$gdp)

#Simple Means
africa_mean90 <- mean(africa90$rate, na.rm=TRUE)
asia_mean90 <- mean(asia90$rate, na.rm=TRUE)
europe_mean90 <- mean(europe90$rate, na.rm=TRUE)
northa_mean90 <- mean(northa90$rate, na.rm=TRUE)
southa_mean90 <- mean(southa90$rate, na.rm=TRUE)
oceania_mean90 <- mean(oceania90$rate, na.rm=TRUE)
eu_mean90 <- mean(eu90$rate, na.rm=TRUE)
brics_mean90 <- mean(brics90$rate, na.rm = TRUE)
g7_mean90 <- mean(g790$rate, na.rm = TRUE)
g20_mean90 <- mean(g2090$rate, na.rm=TRUE)
oecd_mean90 <- mean(oecd90$rate, na.rm=TRUE)

#Weighted Means
africa_wmean90 <- weighted.mean(africa90$rate, africa90$gdp, na.rm=TRUE)
asia_wmean90 <- weighted.mean(asia90$rate, asia90$gdp, na.rm=TRUE)
europe_wmean90 <- weighted.mean(europe90$rate, europe90$gdp, na.rm=TRUE)
northa_wmean90 <- weighted.mean(northa90$rate, northa90$gdp, na.rm=TRUE)
southa_wmean90 <- weighted.mean(southa90$rate, southa90$gdp, na.rm=TRUE)
oceania_wmean90 <- weighted.mean(oceania90$rate, oceania90$gdp, na.rm=TRUE)
eu_wmean90 <- weighted.mean(eu90$rate, eu90$gdp, na.rm=TRUE)
brics_wmean90 <- weighted.mean(brics90$rate, brics90$gdp, na.rm = TRUE)
g7_wmean90 <- weighted.mean(g790$rate, g790$gdp, na.rm = TRUE)
g20_wmean90 <- weighted.mean(g2090$rate, g2090$gdp, na.rm=TRUE)
oecd_wmean90 <- weighted.mean(oecd90$rate, oecd90$gdp, na.rm=TRUE)

#Counts
africa_count90 <- NROW(africa90$gdp)
asia_count90 <- NROW(asia90$gdp)
europe_count90 <- NROW(europe90$gdp)
northa_count90 <- NROW(northa90$gdp)
southa_count90 <- NROW(southa90$gdp)
oceania_count90 <- NROW(oceania90$gdp)
eu_count90 <- NROW(eu90$gdp)
brics_count90 <- NROW(brics90$gdp)
g7_count90 <- NROW(g790$gdp)
g20_count90 <- NROW(g2090$gdp)
oecd_count90 <- NROW(oecd90$gdp)

#compile
region <- c("Africa","Asia","Europe","North America","Oceania","South America","G7","OECD",
            "BRICS","EU27","G20","World")
avgrate90 <- c(africa_mean90,asia_mean90,europe_mean90,northa_mean90,
               oceania_mean90,southa_mean90, g7_mean90,oecd_mean90,brics_mean90,
               eu_mean90,g20_mean90,mean90)
wavgrate90 <- c(africa_wmean90,asia_wmean90,europe_wmean90,northa_wmean90,
                oceania_wmean90,southa_wmean90,g7_wmean90,oecd_wmean90,brics_wmean90,
                eu_wmean90,g20_wmean90,wmean90)
count90 <- c(africa_count90,asia_count90,europe_count90,northa_count90,oceania_count90,southa_count90,
             g7_count90,oecd_count90,brics_count90,eu_count90,g20_count90, numgdp_90)
regional90 <- data.frame(region,avgrate90,wavgrate90,count90)


#1980 by region
data1980 <- subset(complete_data, year==1980, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu27, gseven, gtwenty, brics))
data1980$rate <- as.numeric(data1980$rate)
mean80 <- mean(data1980$rate, na.rm = TRUE)
wmean80 <- weighted.mean(data1980$rate, data1980$gdp, na.rm = TRUE)
numgdp_80 <- NROW(data1980$gdp)

#Creating regional sets
africa80 <- subset(data1980, continent=="AF")
africa80$rate <- as.numeric(africa80$rate)
africa80$gdp <- as.numeric(africa80$gdp)

asia80 <- subset(data1980, continent=="AS")
asia80$rate <- as.numeric(asia80$rate)
asia80$gdp <- as.numeric(asia80$gdp)

europe80 <- subset(data1980, continent=="EU")
europe80$rate <- as.numeric(europe80$rate)
europe80$gdp <- as.numeric(europe80$gdp)

northa80 <- subset(data1980, continent=="NO")
northa80$rate <- as.numeric(northa80$rate)
northa80$gdp <- as.numeric(northa80$gdp)

southa80 <- subset(data1980, continent=="SA")
southa80$rate <- as.numeric(southa80$rate)
southa80$gdp <- as.numeric(southa80$gdp)

oceania80 <- subset(data1980, continent=="OC")
oceania80$rate <- as.numeric(oceania80$rate)
oceania80$gdp <- as.numeric(oceania80$gdp)

eu80 <- subset(data1980, eu27==1)
eu80$rate <- as.numeric(eu80$rate)
eu80$gdp <- as.numeric(eu80$gdp)

brics80 <- subset(data1980, brics==1)
brics80$rate <- as.numeric(brics80$rate)
brics80$gdp <- as.numeric(brics80$gdp)

g780 <- subset(data1980, gseven==1)
g780$rate <- as.numeric(g780$rate)
g780$gdp <- as.numeric(g780$gdp)

g2080 <- subset(data1980, gtwenty==1)
g2080$rate <- as.numeric(g2080$rate)
g2080$gdp <- as.numeric(g2080$gdp)

oecd80 <- subset(data1980, oecd==1)
oecd80$rate <- as.numeric(oecd80$rate)
oecd80$gdp <- as.numeric(oecd80$gdp)


#Simple Means
africa_mean80 <- mean(africa80$rate, na.rm=TRUE)
asia_mean80 <- mean(asia80$rate, na.rm=TRUE)
europe_mean80 <- mean(europe80$rate, na.rm=TRUE)
northa_mean80 <- mean(northa80$rate, na.rm=TRUE)
southa_mean80 <- mean(southa80$rate, na.rm=TRUE)
oceania_mean80 <- mean(oceania80$rate, na.rm=TRUE)
eu_mean80 <- mean(eu80$rate, na.rm=TRUE)
brics_mean80 <- mean(brics80$rate, na.rm = TRUE)
g7_mean80 <- mean(g780$rate, na.rm = TRUE)
g20_mean80 <- mean(g2080$rate, na.rm=TRUE)
oecd_mean80 <- mean(oecd80$rate, na.rm=TRUE)

#Weighted Means
africa_wmean80 <- weighted.mean(africa80$rate, africa80$gdp, na.rm=TRUE)
asia_wmean80 <- weighted.mean(asia80$rate, asia80$gdp, na.rm=TRUE)
europe_wmean80 <- weighted.mean(europe80$rate, europe80$gdp, na.rm=TRUE)
northa_wmean80 <- weighted.mean(northa80$rate, northa80$gdp, na.rm=TRUE)
southa_wmean80 <- weighted.mean(southa80$rate, southa80$gdp, na.rm=TRUE)
oceania_wmean80 <- weighted.mean(oceania80$rate, oceania80$gdp, na.rm=TRUE)
eu_wmean80 <- weighted.mean(eu80$rate, eu80$gdp, na.rm=TRUE)
brics_wmean80 <- weighted.mean(brics80$rate, brics80$gdp, na.rm = TRUE)
g7_wmean80 <- weighted.mean(g780$rate, g780$gdp, na.rm = TRUE)
g20_wmean80 <- weighted.mean(g2080$rate, g2080$gdp, na.rm=TRUE)
oecd_wmean80 <- weighted.mean(oecd80$rate, oecd80$gdp, na.rm=TRUE)

#Counts
africa_count80 <- NROW(africa80$gdp)
asia_count80 <- NROW(asia80$gdp)
europe_count80 <- NROW(europe80$gdp)
northa_count80 <- NROW(northa80$gdp)
southa_count80 <- NROW(southa80$gdp)
oceania_count80 <- NROW(oceania80$gdp)
eu_count80 <- NROW(eu80$gdp)
brics_count80 <- NROW(brics80$gdp)
g7_count80 <- NROW(g780$gdp)
g20_count80 <- NROW(g2080$gdp)
oecd_count80 <- NROW(oecd80$gdp)

#compile
region <- c("Africa","Asia","Europe","North America","Oceania","South America","G7","OECD",
            "BRICS","EU27","G20","World")
avgrate80 <- c(africa_mean80,asia_mean80,europe_mean80,northa_mean80,
               oceania_mean80,southa_mean80, g7_mean80,oecd_mean80,brics_mean80,
               eu_mean80,g20_mean80,mean80)
wavgrate80 <- c(africa_wmean80,asia_wmean80,europe_wmean80,northa_wmean80,
                oceania_wmean80,southa_wmean80,g7_wmean80,oecd_wmean80,brics_wmean80,
                eu_wmean80,g20_wmean80,wmean80)
count80 <- c(africa_count80,asia_count80,europe_count80,northa_count80,oceania_count80,southa_count80,
             g7_count80,oecd_count80,brics_count80,eu_count80,g20_count80, numgdp_80)
regional80 <- data.frame(region,avgrate80,wavgrate80,count80)


#Regional decade data
allregional <- data.frame(merge(regional22, regional10, by = c("region"), all = TRUE))
allregional <- data.frame(merge(allregional, regional00, by = c("region"), all= TRUE))
allregional <- data.frame(merge(allregional, regional90, by = c("region"), all = TRUE))
allregional <- data.frame(merge(allregional, regional80, by = c("region"), all = TRUE))
write.csv(allregional, "final_outputs/regional_all_data.csv")


#Data for world map showing increases/decreases
#      rate_changes <- all_years_final
#      rate_changes <- subset(rate_changes, select = c(iso_3, continent, country, `2000`, `2022`))
#      rate_changes <- rate_changes[complete.cases(rate_changes),]
#      rate_changes$rate_change <- (rate_changes$`2022` - rate_changes$`2000`)
#      rate_changes$change <- if_else(rate_changes$`2022` == rate_changes$`2000`,"No Change",if_else(rate_changes$`2022` > rate_changes$`2000`, "Increase", "Decrease"))
#      write.csv(rate_changes, "final_outputs/rate_changes.csv")


#Format and write table showing rates by region
colnames(regional22)[colnames(regional22)=="region"] <- "Region"
colnames(regional22)[colnames(regional22)=="avgrate22"] <- "Average Rate"
colnames(regional22)[colnames(regional22)=="wavgrate22"] <- "Weighted Average Rate"
colnames(regional22)[colnames(regional22)=="count22"] <- "Number of Countries"
write.csv(regional22, "final_outputs/rates_regional.csv")


#Chart showing distribution of rates in 2022 (including countries with missing gdp data)
dist <- hist(data2022_gdp_mis$rate, breaks=c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50), main="2022 Corporate Income Tax Rates", xlab="Rate", col="dodgerblue", las=1)
distdata <- data.frame(dist$counts,dist$breaks[1:10])
write.csv(distdata, "final_outputs/distribution_2022_count.csv")


#Time series graph (only includes countries for which we have GDP data)
complete_data$rate <- as.numeric(complete_data$rate)
complete_data$gdp <- as.numeric(complete_data$gdp)

timeseries <- ddply(complete_data, .(year),summarize, weighted.average = weighted.mean(rate,gdp, na.rm = TRUE), average = mean(rate, na.rm = TRUE),n = length(rate[is.na(rate) == FALSE]))
colnames(timeseries)[colnames(timeseries)=="n"] <- "country_count"

write.csv(timeseries, "final_outputs/rate_time_series.csv", row.names = FALSE)


#Chart showing how distribution has changed each decade (including countries with missing gdp data)

#2022 distribution (in percent rather than country counts)
dist_percent <- hist(data2022_gdp_mis$rate, breaks=c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75), main="2022 Corporate Income Tax Rates", xlab="Rate", col="dodgerblue", las=1)
distdata_percent <- data.frame(dist_percent$counts, dist_percent$breaks[1:15])
colnames(distdata_percent)[colnames(distdata_percent)=="dist_percent.breaks.1.15."] <- "break"

distdata_percent$dist_percent.counts <- distdata_percent$dist_percent.counts / numrates_22_gdp_mis

#2010 distribution
data2010_gdp_mis <- subset(final_data, year==2010, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu27, gseven, gtwenty, brics))
data2010_gdp_mis <- subset(data2010_gdp_mis, !is.na(data2010_gdp_mis$rate))
data2010_gdp_mis$rate <- as.numeric(data2010_gdp_mis$rate)

dist10 <- hist(data2010_gdp_mis$rate, breaks=c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75), main="2010 Corporate Income Tax Rates", xlab="Rate", col="dodgerblue", las=1)
dist10data <- data.frame(dist10$counts,dist10$breaks[1:15])
numrates_10_gdp_mis <- NROW(data2010_gdp_mis$rate)
colnames(dist10data)[colnames(dist10data)=="dist10.breaks.1.15."] <- "break"

dist10data$dist10.counts <- dist10data$dist10.counts / numrates_10_gdp_mis

#2000 distribution
data2000_gdp_mis <- subset(final_data, year==2000, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu27, gseven, gtwenty, brics))
data2000_gdp_mis <- subset(data2000_gdp_mis, !is.na(data2000_gdp_mis$rate))
data2000_gdp_mis$rate <- as.numeric(data2000_gdp_mis$rate)

dist00 <- hist(data2000_gdp_mis$rate, breaks=c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75), main="2000 Corporate Income Tax Rates", xlab="Rate", col="dodgerblue", las=1)
dist00data <- data.frame(dist00$counts,dist00$breaks[1:15])
numrates_00_gdp_mis <- NROW(data2000_gdp_mis$rate)
colnames(dist00data)[colnames(dist00data)=="dist00.breaks.1.15."] <- "break"

dist00data$dist00.counts <- dist00data$dist00.counts / numrates_00_gdp_mis

#1990 distribution
data1990_gdp_mis <- subset(final_data, year==1990, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu27, gseven, gtwenty, brics))
data1990_gdp_mis <- subset(data1990_gdp_mis, !is.na(data1990_gdp_mis$rate))
data1990_gdp_mis$rate <- as.numeric(data1990_gdp_mis$rate)

dist90 <- hist(data1990_gdp_mis$rate, breaks=c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75), main="1990 Corporate Income Tax Rates", xlab="Rate", col="dodgerblue", las=1)
dist90data <- data.frame(dist90$counts,dist90$breaks[1:15])
colnames(dist90data)[colnames(dist90data)=="dist90.breaks.1.15."] <- "break"

numrates_90_gdp_mis <- NROW(data1990_gdp_mis$rate)

dist90data$dist90.counts <- dist90data$dist90.counts / numrates_90_gdp_mis

#1980 distribution
data1980_gdp_mis <- subset(final_data, year==1980, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu27, gseven, gtwenty, brics))
data1980_gdp_mis <- subset(data1980_gdp_mis, !is.na(data1980_gdp_mis$rate))
data1980_gdp_mis$rate <- as.numeric(data1980_gdp_mis$rate)

dist80 <- hist(data1980_gdp_mis$rate, breaks=c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75), main="1980 Corporate Income Tax Rates", xlab="Rate", col="dodgerblue", las=1)
dist80data <- data.frame(dist80$counts,dist80$breaks[1:15])
colnames(dist80data)[colnames(dist80data)=="dist80.breaks.1.15."] <- "break"

numrates_80_gdp_mis <- NROW(data1980_gdp_mis$rate)

dist80data$dist80.counts <- dist80data$dist80.counts / numrates_80_gdp_mis

#Compile in one dataset
alldist <- data.frame(merge(distdata_percent, dist10data, by = c("break"), all = TRUE))
colnames(alldist )[colnames(alldist)=="break."] <- "break"

alldist <- data.frame(merge(alldist, dist00data, by = c("break"), all= TRUE))
colnames(alldist )[colnames(alldist)=="break."] <- "break"

alldist <- data.frame(merge(alldist, dist90data, by = c("break"), all= TRUE))
colnames(alldist )[colnames(alldist)=="break."] <- "break"

alldist <- data.frame(merge(alldist, dist80data, by = c("break"), all= TRUE))

colnames(alldist )[colnames(alldist)=="break."] <- "Rate Category"
colnames(alldist )[colnames(alldist)=="dist_percent.counts"] <- "2022"
colnames(alldist )[colnames(alldist)=="dist10.counts"] <- "2010"
colnames(alldist )[colnames(alldist)=="dist00.counts"] <- "2000"
colnames(alldist )[colnames(alldist)=="dist90.counts"] <- "1990"
colnames(alldist )[colnames(alldist)=="dist80.counts"] <- "1980"

write.csv(alldist, "final_outputs/distribution_all_decades.csv")


#Appendix: 
#Data for chart showing number of corporate rates we have for each year

all_years_final$'1980' <- as.numeric(all_years_final$'1980')
all_years_final$'1981' <- as.numeric(all_years_final$'1981')
all_years_final$'1982' <- as.numeric(all_years_final$'1982')
all_years_final$'1983' <- as.numeric(all_years_final$'1983')
all_years_final$'1984' <- as.numeric(all_years_final$'1984')
all_years_final$'1985' <- as.numeric(all_years_final$'1985')
all_years_final$'1986' <- as.numeric(all_years_final$'1986')
all_years_final$'1987' <- as.numeric(all_years_final$'1987')
all_years_final$'1988' <- as.numeric(all_years_final$'1988')
all_years_final$'1989' <- as.numeric(all_years_final$'1989')
all_years_final$'1990' <- as.numeric(all_years_final$'1990')
all_years_final$'1991' <- as.numeric(all_years_final$'1991')
all_years_final$'1992' <- as.numeric(all_years_final$'1992')
all_years_final$'1993' <- as.numeric(all_years_final$'1993')
all_years_final$'1994' <- as.numeric(all_years_final$'1994')
all_years_final$'1995' <- as.numeric(all_years_final$'1995')
all_years_final$'1996' <- as.numeric(all_years_final$'1996')
all_years_final$'1997' <- as.numeric(all_years_final$'1997')
all_years_final$'1998' <- as.numeric(all_years_final$'1998')
all_years_final$'1999' <- as.numeric(all_years_final$'1999')
all_years_final$'2000' <- as.numeric(all_years_final$'2000')
all_years_final$'2001' <- as.numeric(all_years_final$'2001')
all_years_final$'2002' <- as.numeric(all_years_final$'2002')
all_years_final$'2003' <- as.numeric(all_years_final$'2003')
all_years_final$'2004' <- as.numeric(all_years_final$'2004')
all_years_final$'2005' <- as.numeric(all_years_final$'2005')
all_years_final$'2006' <- as.numeric(all_years_final$'2006')
all_years_final$'2007' <- as.numeric(all_years_final$'2007')
all_years_final$'2008' <- as.numeric(all_years_final$'2008')
all_years_final$'2009' <- as.numeric(all_years_final$'2009')
all_years_final$'2010' <- as.numeric(all_years_final$'2010')
all_years_final$'2011' <- as.numeric(all_years_final$'2011')
all_years_final$'2012' <- as.numeric(all_years_final$'2012')
all_years_final$'2013' <- as.numeric(all_years_final$'2013')
all_years_final$'2014' <- as.numeric(all_years_final$'2014')
all_years_final$'2015' <- as.numeric(all_years_final$'2015')
all_years_final$'2016' <- as.numeric(all_years_final$'2016')
all_years_final$'2017' <- as.numeric(all_years_final$'2017')
all_years_final$'2018' <- as.numeric(all_years_final$'2018')
all_years_final$'2019' <- as.numeric(all_years_final$'2019')
all_years_final$'2020' <- as.numeric(all_years_final$'2020')
all_years_final$'2021' <- as.numeric(all_years_final$'2021')
all_years_final$'2022' <- as.numeric(all_years_final$'2022')
all_years_final_count <- all_years_final
all_years_final_count[all_years_final_count >= 0] <- 1
all_years_final_count[is.na(all_years_final_count)] <- 0

year_count <- data.frame(apply(all_years_final_count[5:47], MARGIN=2, FUN=sum))

colnames(year_count)[colnames(year_count)=="apply.all_years_final_count.5.46...MARGIN...2..FUN...sum."] <- "Count"

write.csv(year_count, "final_outputs/year_count.csv")

#Table with all 2022 tax rates
all_rates_2022 <- data2022_gdp_mis

all_rates_2022 <- subset(all_rates_2022, year==2022, select = c(iso_3, country, continent, rate))
all_rates_2022 <- all_rates_2022[order(all_rates_2022$country),]

colnames(all_rates_2022)[colnames(all_rates_2022)=="iso_3"] <- "ISO3"
colnames(all_rates_2022)[colnames(all_rates_2022)=="country"] <- "Country"
colnames(all_rates_2022)[colnames(all_rates_2022)=="continent"] <- "Continent"
colnames(all_rates_2022)[colnames(all_rates_2022)=="rate"] <- "Corporate Tax Rate"

write.csv(all_rates_2022, "final_outputs/all_rates_2022.csv", row.names = FALSE)