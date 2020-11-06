###Worldwide Corporate Tax Rates - 2020###

#general set-up
using<-function(...,prompt=TRUE){
  libs<-sapply(substitute(list(...))[-1],deparse)
  req<-unlist(lapply(libs,require,character.only=TRUE))
  need<-libs[req==FALSE]
  n<-length(need)
  installAndRequire<-function(){
    install.packages(need)
    lapply(need,require,character.only=TRUE)
  }
  if(n>0){
    libsmsg<-if(n>2) paste(paste(need[1:(n-1)],collapse=", "),",",sep="") else need[1]
    if(n>1){
      libsmsg<-paste(libsmsg," and ", need[n],sep="")
    }
    libsmsg<-paste("The following packages count not be found: ",libsmsg,"n\r\n\rInstall missing packages?",collapse="")
    if(prompt==FALSE){
      installAndRequire()
    }else if(winDialog(type=c("yesno"),libsmsg)=="YES"){
      installAndRequire()
    }
  }
}

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

using(gtools)
using(plyr)
using(reshape2)
using(OECD)
using(readxl)
using(rvest)
using(htmltab)
using(tidyverse)
using(stringr)
using(dplyr)
using(naniar)
using(IMFData)


#ISO-Codes####

#Read in iso-codes
country_iso_cont <- read.csv("source-data/country_codes.csv")

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

country_iso_cont_groups$eu28 <- ifelse(country_iso_cont$iso_3 == "AUT"
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
                                | country_iso_cont$iso_3 == "GBR"
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


#OECD Data####

#Read in dataset
dataset_list<-get_datasets()
search_dataset("Corporate", data= dataset_list)
dataset <- ("TABLE_II1")
dstruc <- get_data_structure(dataset)
str(dstruc, max.level = 1)
dstruc$VAR_DESC
dstruc$CORP_TAX

oecd_data_2020 <- get_dataset("TABLE_II1", start_time = 2020, end_time = 2020)

#Keep and rename selected columns

oecd_data_2020 <- subset(oecd_data_2020, oecd_data_2020$CORP_TAX=="COMB_CIT_RATE")
oecd_data_2020 <- subset(oecd_data_2020, select = -c(CORP_TAX,TIME_FORMAT,obsTime))

colnames(oecd_data_2020)[colnames(oecd_data_2020)=="obsValue"] <- "2020"
colnames(oecd_data_2020)[colnames(oecd_data_2020)=="COU"] <- "iso_3"


#KPMG Data####

#Read in dataset
kpmg_data_2020 <- read_excel("source-data/kpmg_dataset_2010_2020.xlsx")

#Keep and rename selected columns
kpmg_data_2020 <- kpmg_data_2020[,-c(2:11)]
colnames(kpmg_data_2020)[colnames(kpmg_data_2020)=="LOCATION"] <- "country"

#Change KPMG country names to match official ISO-names

kpmg_data_2020$country[kpmg_data_2020$country == "Bolivia"] <- "Bolivia (Plurinational State of)"

kpmg_data_2020$country[kpmg_data_2020$country == "Bonaire, Saint Eustatius and Saba"] <- "Bonaire, Sint Eustatius and Saba"

kpmg_data_2020$country[kpmg_data_2020$country == "Ivory Coast"] <- "Cote d'Ivoire"

kpmg_data_2020$country[kpmg_data_2020$country == "Hong Kong SAR"] <- "China, Hong Kong Special Administrative Region"

kpmg_data_2020$country[kpmg_data_2020$country == "Macau"] <- "China, Macao Special Administrative Region"

kpmg_data_2020$country[kpmg_data_2020$country == "Congo (Democratic Republic of the)"] <- "Democratic Republic of the Congo"

kpmg_data_2020$country[kpmg_data_2020$country == "Czech Republic"] <- "Czechia"

kpmg_data_2020$country[kpmg_data_2020$country == "Korea, Republic of"] <- "Republic of Korea"

kpmg_data_2020$country[kpmg_data_2020$country == "Macedonia"] <- "The former Yugoslav Republic of Macedonia"

kpmg_data_2020$country[kpmg_data_2020$country == "Moldova"] <- "Republic of Moldova"

kpmg_data_2020$country[kpmg_data_2020$country == "Palestinian Territory"] <- "State of Palestine"

kpmg_data_2020$country[kpmg_data_2020$country == "Russia"] <- "Russian Federation"

kpmg_data_2020$country[kpmg_data_2020$country == "St Maarten"] <- "Saint Martin (French Part)"

kpmg_data_2020$country[kpmg_data_2020$country == "Syria"] <- "Syrian Arab Republic"

kpmg_data_2020$country[kpmg_data_2020$country == "Tanzania"] <- "United Republic of Tanzania"

kpmg_data_2020$country[kpmg_data_2020$country == "United Kingdom"] <- "United Kingdom of Great Britain and Northern Ireland"

kpmg_data_2020$country[kpmg_data_2020$country == "United States"] <- "United States of America"

kpmg_data_2020$country[kpmg_data_2020$country == "Venezuela"] <- "Venezuela (Bolivarian Republic of)"

kpmg_data_2020$country[kpmg_data_2020$country == "Vietnam"] <- "Viet Nam"


#Add ISO-Code to KPMG Data
kpmg_data_iso <- merge(kpmg_data_2020, country_iso_cont, by="country", all=T)

#Remove continent averages
kpmg_data_iso <- kpmg_data_iso[!grepl("average", kpmg_data_iso$country),]


#Merge OECD and KPMG Data####

oecd_kpmg_2020 <- merge(oecd_data_2020, kpmg_data_iso, by="iso_3", all=T)
oecd_kpmg_2020$`2020.x` <- if_else(is.na(oecd_kpmg_2020$`2020.x`), oecd_kpmg_2020$`2020.y`, oecd_kpmg_2020$`2020.x`)
oecd_kpmg_2020 <- subset(oecd_kpmg_2020, select = -c(`2020.y`,iso_2))

colnames(oecd_kpmg_2020)[colnames(oecd_kpmg_2020)=="2020.x"] <- "2020"

oecd_kpmg_2020 <- oecd_kpmg_2020[, c("2020", "iso_3", "country", "continent")]


#Dataset for previous years####

#Read in dataset Tax Foundation has compiled over the years for 1980-2019
previous_years <- read_csv("source-data/data_rates_1980_2019.csv")

#Drop column that is not needed
previous_years <- subset(previous_years, select = -c(X1))

#Combine 2020 data ("oecd_kpmg_2020") with data from previous years ("previous_years")

oecd_kpmg_2020 <- subset(oecd_kpmg_2020, select = -c(country, continent))

all_years_preliminary <- merge(previous_years, oecd_kpmg_2020, by="iso_3", all=T)

all_years_preliminary <- all_years_preliminary[, c("iso_2", "iso_3", "continent", "country", 1980, 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020)]

write.csv(all_years_preliminary,"intermediate-outputs/rates_preliminary.csv")


#Add Missing Corporate Rates Manually###

#ALA - Aland Islands
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "ALA",] <- 20

#ARE - United Arab Emirates (correction: rate set to zero for all years as CIT only levied on certain industries and this dataset captures general corporate tax systems)
all_years_preliminary[c("1980", 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020)][all_years_preliminary$iso_3 == "ARE",] <- 0

#ASM - American Samoa
all_years_preliminary[c("2014")][all_years_preliminary$iso_3 == "ASM",] <- 44
all_years_preliminary[c("2015")][all_years_preliminary$iso_3 == "ASM",] <- 44
all_years_preliminary[c("2016")][all_years_preliminary$iso_3 == "ASM",] <- 44
all_years_preliminary[c("2017")][all_years_preliminary$iso_3 == "ASM",] <- 34
all_years_preliminary[c("2018")][all_years_preliminary$iso_3 == "ASM",] <- 34
all_years_preliminary[c("2019")][all_years_preliminary$iso_3 == "ASM",] <- 34
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "ASM",] <- 34

#BES - Bonaire, Sint Eustatius and Saba
all_years_preliminary[c("2012")][all_years_preliminary$iso_3 == "BES",] <- 0
all_years_preliminary[c("2013")][all_years_preliminary$iso_3 == "BES",] <- 0
all_years_preliminary[c("2014")][all_years_preliminary$iso_3 == "BES",] <- 0
all_years_preliminary[c("2015")][all_years_preliminary$iso_3 == "BES",] <- 0
all_years_preliminary[c("2016")][all_years_preliminary$iso_3 == "BES",] <- 0
all_years_preliminary[c("2017")][all_years_preliminary$iso_3 == "BES",] <- 25

#BLM - Saint Barthelemy
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "BLM",] <- 0

#BTN - Bhutan
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "BTN",] <- 30

#CAF - Central African Republic
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "CAF",] <- 30

#COK - Cook Islands
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "COK",] <- 20

#COM - Comoros
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "COM",] <- 50

#CPV - Cabo Verde
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "CPV",] <- 22

#ERI - Eritrea
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "ERI",] <-  30

#FLK - Falkland Islands (Malvinas)
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "FLK",] <- 26

#FRO - Faroe Islands
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "FRO",] <- 18

#FSM - Micronesia (Federated States of)
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "FSM",] <- 30
all_years_preliminary[c("2019")][all_years_preliminary$iso_3 == "FSM",] <- 21
all_years_preliminary[c("2018")][all_years_preliminary$iso_3 == "FSM",] <- 21
all_years_preliminary[c("2017")][all_years_preliminary$iso_3 == "FSM",] <- 21
all_years_preliminary[c("2016")][all_years_preliminary$iso_3 == "FSM",] <- 21
all_years_preliminary[c("2015")][all_years_preliminary$iso_3 == "FSM",] <- 21
all_years_preliminary[c("2014")][all_years_preliminary$iso_3 == "FSM",] <- 21
all_years_preliminary[c("2013")][all_years_preliminary$iso_3 == "FSM",] <- 21
all_years_preliminary[c("2012")][all_years_preliminary$iso_3 == "FSM",] <- 21
all_years_preliminary[c("2011")][all_years_preliminary$iso_3 == "FSM",] <- 21

#GIN - Guinea
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "GIN",] <- 35

#GNB - Guinea-Bissau
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "GNB",] <- 25

#GNQ - Equatorial Guinea
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "GNQ",] <- 35

#GRC - Greece (correction: 1992 rate is "46 -- 35," it should be 40.5%)
all_years_preliminary[c("1992")][all_years_preliminary$iso_3 == "GRC",] <- 40.5

#GRL - Greenland
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "GRL",] <- 26.5
  
#GUM - Guam
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "GUM",] <- 21

#GUY - Guyana
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "GUY",] <- 25

#HTI - Haiti
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "HTI",] <- 30

#IMN - Isle of Man (correction: rate was 15% between 2003-2006)
all_years_preliminary[c("2003")][all_years_preliminary$iso_3 == "IMN",] <- 15
all_years_preliminary[c("2004")][all_years_preliminary$iso_3 == "IMN",] <- 15
all_years_preliminary[c("2005")][all_years_preliminary$iso_3 == "IMN",] <- 15
all_years_preliminary[c("2006")][all_years_preliminary$iso_3 == "IMN",] <- 15

#IRN - Iran (Islamic Republic of)
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "IRN",] <- 25

#JEY - Jersey (correction for year 2018: although certain businesses may be taxed at 20%, the general rate is 0%)
all_years_preliminary[c("2018")][all_years_preliminary$iso_3 == "JEY",] <- 0

#KIR - Kiribati
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "KIR",] <- 35

#LAO - Lao People's Democratic Republic
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "LAO",] <- 24

#LBR - Liberia
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "LBR",] <- 25

#LSO - Lesotho
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "LSO",] <- 25

#MCO - Monaco (correction for 2018: rate was 33.33% instead of 33%)
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "MCO",] <- 28
all_years_preliminary[c("2018")][all_years_preliminary$iso_3 == "MCO",] <- 33.33

#MDV - Maldives
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "MDV",] <- 15
  
#MLI - Mali
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "MLI",] <- 30

#MNP - Northern Mariana Islands
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "MNP",] <- 21

#MRT - Mauritania
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "MRT",] <- 25

#MSR - Montserrat
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "MSR",] <- 30

#NCL - New Caledonia
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "NCL",] <- 30

#NER - Niger
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "NER",] <- 30

#NIU - Niue
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "NIU",] <- 30

#NPL - Nepal
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "NPL",] <- 25

#NRU - Nauru (correct previous years and set 2016 to NA as we don't have a source)
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "NRU",] <- 25
all_years_preliminary[c("2019")][all_years_preliminary$iso_3 == "NRU",] <- 25
all_years_preliminary[c("2018")][all_years_preliminary$iso_3 == "NRU",] <- 25
all_years_preliminary[c("2017")][all_years_preliminary$iso_3 == "NRU",] <- 20
all_years_preliminary[c("2016")][all_years_preliminary$iso_3 == "NRU",] <- NA

#PAK - Pakistan (correction: rate was 29% in 2019 and 2020)
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "PAK",] <- 29
all_years_preliminary[c("2019")][all_years_preliminary$iso_3 == "PAK",] <- 29

#PLW - Palau (set previous years to NA as Palau has a gross receipts tax)
all_years_preliminary[c("2018")][all_years_preliminary$iso_3 == "PLW",] <- NA
all_years_preliminary[c("2017")][all_years_preliminary$iso_3 == "PLW",] <- NA
all_years_preliminary[c("2016")][all_years_preliminary$iso_3 == "PLW",] <- NA

#PRI - Puerto Rico
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "PRI",] <- 37.5

#PYF - French Polynesia
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "PYF",] <- 25

#REU - Reunion (set previous year to NA as Reunion is an overseas départements of France)
all_years_preliminary[c("2018")][all_years_preliminary$iso_3 == "REU",] <- NA

#SHN - Saint Helena
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "SHN",] <- 25
  
#SMR - San Marino
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "SMR",] <- 17

#SSD - 	South Sudan
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "SSD",] <- 25

#STP - Sao Tome and Principe
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "STP",] <- 25

#SYC - Seychelles
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "SYC",] <- 33
all_years_preliminary[c("2003")][all_years_preliminary$iso_3 == "SYC",] <- 40
all_years_preliminary[c("2000")][all_years_preliminary$iso_3 == "SYC",] <- 40

#TCD - Chad
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "TCD",] <- 35

#TGO - Togo
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "TGO",] <- 27
  
#TJK - Tajikistan
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "TJK",] <- 23

#TKL - Tokelau
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "TKL",] <- 0
all_years_preliminary[c("2019")][all_years_preliminary$iso_3 == "TKL",] <- 0

#TKM - Turkmenistan
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "TKM",] <- 8

#TLS - Timor-Leste
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "TLS",] <- 10

#TON - Tonga
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "TON",] <- 25

#TTO - Trinidad and Tobago (correction: rate was increased to 30% in 2017 already)
all_years_preliminary[c("2019")][all_years_preliminary$iso_3 == "TTO",] <- 30
all_years_preliminary[c("2018")][all_years_preliminary$iso_3 == "TTO",] <- 30
all_years_preliminary[c("2017")][all_years_preliminary$iso_3 == "TTO",] <- 30

#VGB - British Virgin Islands
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "VGB",] <- 0

#VIR - 	United States Virgin Islands (correction: 10% surtax imposed)
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "VIR",] <- 23.1
all_years_preliminary[c("2019")][all_years_preliminary$iso_3 == "VIR",] <- 23.1
all_years_preliminary[c("2018")][all_years_preliminary$iso_3 == "VIR",] <- 23.1
all_years_preliminary[c("2017")][all_years_preliminary$iso_3 == "VIR",] <- 38.5
all_years_preliminary[c("2016")][all_years_preliminary$iso_3 == "VIR",] <- 38.5
all_years_preliminary[c("2015")][all_years_preliminary$iso_3 == "VIR",] <- 38.5
all_years_preliminary[c("2014")][all_years_preliminary$iso_3 == "VIR",] <- 38.5

#VUT - Vanuatu
all_years_preliminary[c("2013")][all_years_preliminary$iso_3 == "VUT",] <- 0
all_years_preliminary[c("2012")][all_years_preliminary$iso_3 == "VUT",] <- 0
all_years_preliminary[c("2011")][all_years_preliminary$iso_3 == "VUT",] <- 0
all_years_preliminary[c("2010")][all_years_preliminary$iso_3 == "VUT",] <- 0

#WLF - Wallis and Futuna Islands
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "WLF",] <- 0

#XKX - Kosovo, Republic of
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "XKX",] <- 10

#ZWE - Zimbabwe (correction: tax change in 2020; years 2018 and 2019 were missing 3% surtax)
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "ZWE",] <- 24.72
all_years_preliminary[c("2019")][all_years_preliminary$iso_3 == "ZWE",] <- 25.75
all_years_preliminary[c("2018")][all_years_preliminary$iso_3 == "ZWE",] <- 25.75


#Define final corporate tax rate data###
all_years_final <- all_years_preliminary

#Write final corporate tax rate data
write.csv(all_years_final,"intermediate-outputs/rates_final.csv")


#GDP Data####
#using(imfr)
#imf_ids(return_raw = FALSE, times = 3)
#imf_codelist(database_id, return_raw = FALSE, times = 3)


#databaseID <- 'IFS'
#checkquery = FALSE
#IFS.available.codes <- DataStructureMethod('IFS')
## All OECD Countries Gross Fixed Capital Formation Millions in National Currency
#queryfilter <- list(CL_FREQ="A", CL_INDICATOR_IFS =c("NGDP_USD"))

#gdp_usd <- data.frame(CompactDataMethod(databaseID, queryfilter, '01-01-2000', '01-01-2020', checkquery))

#IFS.available.codes <- DataStructureMethod("IFS")

#databaseID <- "IFS"
#queryfilter <- list(CL_FREQ="A", CL_AREA_IFS="W00", CL_INDICATOR_IFS = c("NGDP_USD"))
#startdate = "2000"
#enddate = "2017"
#checkquery = FALSE

## Germany, Norminal GDP in Euros, Norminal GDP in National Currency

#GR.NGDP.query <- data.frame(CompactDataMethod(databaseID, queryfilter, startdate, enddate, 
#                                   checkquery))

#GFCF_2018<- data.frame(CompactDataMethod(databaseID, queryfilter, '2018-01-01', '2018-12-31', checkquery))
#GFCF_2018<-data.frame(GFCF_2018$X.REF_AREA,unnest(GFCF_2018$Obs))

#GR.NGDP.query[, 1:5]

#, CL_AREA_IFS=ISO_2
#NGDP_USD

#gdp_imf <- 
#  WEO

#Reading in GDP data
gdp_historical <- read_excel("source-data/gdp_historical.xlsx", range = "A11:AM232")
gdp_projected <- read_excel("source-data/gdp_projected.xlsx", range = "A11:K232")

#Merging historical and projected data
gdp_projected <- gdp_projected[,-c(2:9)]
gdp <- merge(gdp_historical,gdp_projected,by="Country")
colnames(gdp)[colnames(gdp)=="Country"] <- "country"

#Renaming countries in gdp dataset to match iso-codes
gdp$country[gdp$country == "AntiguaBarbuda"] <- "Antigua and Barbuda"
gdp$country[gdp$country == "Bolivia"] <- "Bolivia (Plurinational State of)"
gdp$country[gdp$country == "BosniaHerzegovina"] <- "Bosnia and Herzegovina"
gdp$country[gdp$country == "Brunei"] <- "Brunei Darussalam"
gdp$country[gdp$country == "BurkinaFaso"] <- "Burkina Faso"
gdp$country[gdp$country == "CaboVerde"] <- "Cabo Verde"
gdp$country[gdp$country == "CentralAfrRep"] <- "Central African Republic"
gdp$country[gdp$country == "HongKong"] <- "China, Hong Kong Special Administrative Region"
gdp$country[gdp$country == "Macau"] <- "China, Macao Special Administrative Region"
gdp$country[gdp$country == "CostaRica"] <- "Costa Rica"
gdp$country[gdp$country == "CotedIvoire"] <- "Cote d'Ivoire"
gdp$country[gdp$country == "CzechRepublic"] <- "Czechia"
gdp$country[gdp$country == "DemRepCongo"] <- "Democratic Republic of the Congo"
gdp$country[gdp$country == "DominicanRep"] <- "Dominican Republic"
gdp$country[gdp$country == "ElSalvador"] <- "El Salvador"
gdp$country[gdp$country == "EquatorialGuinea"] <- "Equatorial Guinea"
gdp$country[gdp$country == "GuineaBissau"] <- "Guinea-Bissau"
gdp$country[gdp$country == "Iran"] <- "Iran (Islamic Republic of)"
gdp$country[gdp$country == "Korea"] <- "Republic of Korea"
gdp$country[gdp$country == "Laos"] <- "Lao People's Democratic Republic"
gdp$country[gdp$country == "Macedonia"] <- "The former Yugoslav Republic of Macedonia"
gdp$country[gdp$country == "Moldova"] <- "Republic of Moldova"
gdp$country[gdp$country == "NewZealand"] <- "New Zealand"
gdp$country[gdp$country == "PapuaNewGuinea"] <- "Papua New Guinea"
gdp$country[gdp$country == "PuertoRico"] <- "Puerto Rico"
gdp$country[gdp$country == "RepCongo"] <- "Congo"
gdp$country[gdp$country == "Russia"] <- "Russian Federation"
gdp$country[gdp$country == "SaoTomePrincipe"] <- "Sao Tome and Principe"
gdp$country[gdp$country == "SaudiArabia"] <- "Saudi Arabia"
gdp$country[gdp$country == "SierraLeone"] <- "Sierra Leone"
gdp$country[gdp$country == "SolomonIslands"] <- "Solomon Islands"
gdp$country[gdp$country == "SouthAfrica"] <- "South Africa"
gdp$country[gdp$country == "SriLanka"] <- "Sri Lanka"
gdp$country[gdp$country == "StKittsNevis"] <- "Saint Kitts and Nevis"
gdp$country[gdp$country == "StLucia"] <- "Saint Lucia"
gdp$country[gdp$country == "StVincentGrenadines"] <- "Saint Vincent and the Grenadines"
gdp$country[gdp$country == "Syria"] <- "Syrian Arab Republic"
gdp$country[gdp$country == "Tanzania"] <- "United Republic of Tanzania"
gdp$country[gdp$country == "TrinTobago"] <- "Trinidad and Tobago"
gdp$country[gdp$country == "UK"] <- "United Kingdom of Great Britain and Northern Ireland"
gdp$country[gdp$country == "UnitedArabEmirates"] <- "United Arab Emirates"
gdp$country[gdp$country == "UnitedStates"] <- "United States of America"
gdp$country[gdp$country == "Venezuela"] <- "Venezuela (Bolivarian Republic of)"
gdp$country[gdp$country == "Vietnam"] <- "Viet Nam"


#Drop rows that contain data of regions
gdp$country <- as.character(gdp$country)
gdp <- subset(gdp, gdp$country != "Africa"
              & gdp$country != "Asia"
              & gdp$country != "AsiaandOceania"
              & gdp$country != "AsiaLessJapan"
              & gdp$country != "BelgiumLuxembourg"
              & gdp$country != "EastAsia"
              & gdp$country != "EastAsiaLessJapan"
              & gdp$country != "Europe"
              & gdp$country != "EuropeanUnion15"
              & gdp$country != "EuropeanUnion28"
              & gdp$country != "EuroZone"
              & gdp$country != "FormerSovietUnion"
              & gdp$country != "LatinAmerica"
              & gdp$country != "MiddleEast"
              & gdp$country != "NorthAfrica"
              & gdp$country != "NorthAmerica"
              & gdp$country != "Oceania"
              & gdp$country != "OtherAsiaOceania"
              & gdp$country != "OtherCaribbeanCentralAmerica"
              & gdp$country != "OtherCentralEurope"
              & gdp$country != "OtherEastAsia"
              & gdp$country != "OtherEurope"
              & gdp$country != "OtherFormerSovietUnion"
              & gdp$country != "OtherMiddleEast"
              & gdp$country != "OtherNorthAfrica"
              & gdp$country != "OtherOceania"
              & gdp$country != "OtherSouthAmerica"
              & gdp$country != "OtherSouthAsia"
              & gdp$country != "OtherSoutheastAsia"
              & gdp$country != "OtherSubSaharanAfrica"
              & gdp$country != "OtherWestAfricanCommunity"
              & gdp$country != "OtherWesternEurope"
              & gdp$country != "RecentlyAccededCountries"
              & gdp$country != "SouthAmerica"
              & gdp$country != "SouthAsia"
              & gdp$country != "SoutheastAsia"
              & gdp$country != "SubSaharanAfrica"
              & gdp$country != "World"
              & gdp$country != "WorldLessUSA")

#Merge gdp data with iso-codes
gdp_iso <- merge(country_iso_cont,gdp,by="country")

#Write gdp data
write.csv(gdp_iso,"intermediate-outputs/gdp_iso.csv")



#Reshaping the data from wide to long###

rates_final_long <- (melt(all_years_final, id=c("iso_2","iso_3","continent","country")))
colnames(rates_final_long)[colnames(rates_final_long)=="variable"] <- "year"
colnames(rates_final_long)[colnames(rates_final_long)=="value"] <- "rate"
rates_final_long <- subset(rates_final_long, year != 1996.1)

gdp_iso_long <- (melt(gdp_iso, id=c("iso_2","iso_3","continent","country")))
colnames(gdp_iso_long)[colnames(gdp_iso_long)=="variable"] <- "year"
colnames(gdp_iso_long)[colnames(gdp_iso_long)=="value"] <- "gdp"
gdp_iso_long <- subset(gdp_iso_long, year != 1996.1)

#Merge rates and gdp###
rates_gdp <- merge(rates_final_long, gdp_iso_long, by =c("iso_2","iso_3", "continent","country", "year"), all=T)

#Merge 'rate and gdp' dataset with country groups
rates_gdp <- merge(rates_gdp, country_iso_cont_groups, by =c("iso_2","iso_3", "continent","country"), all=T)
final_data <- rates_gdp[order(rates_gdp$iso_3, rates_gdp$year),]

#Write as final data file
write.csv(final_data,"final-data/final_data_long.csv", row.names = FALSE)


#Summary statistics###

#Drop if no gdp or rate data
complete_data <- final_data[complete.cases(final_data),]

#Creating the 2019 dataset that includes only countries for which we have gdp data
data2019 <- subset(complete_data, year==2019, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu, gseven, gtwenty, brics))
write.csv(data2019, "final-data/final_data_2019.csv")

#Creating the 2019 dataset that includes countries with missing gdp data as well
data2019_gdp_mis <- subset(final_data, year==2019, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu, gseven, gtwenty, brics))
data2019_gdp_mis <- subset(data2019_gdp_mis, !is.na(data2019_gdp_mis$rate))
write.csv(data2019_gdp_mis, "final-data/final_data_2019_gdp_incomplete.csv")


#2019 simple mean (including only countries with gdp data)
  data2019$rate <- as.numeric(data2019$rate)
  simple_mean_19 <- mean(data2019$rate, na.rm = TRUE)
  
  #2019 simple mean (including countries with missing gdp data)
  data2019_gdp_mis$rate <- as.numeric(data2019_gdp_mis$rate)
  simple_mean_19_gdp_mis <- mean(data2019_gdp_mis$rate, na.rm = TRUE)
  
  #2019 weighted mean (including only countries with gdp data)
  weighted_mean_19 <- weighted.mean(data2019$rate, data2019$gdp, na.rm = TRUE)
  
  #2019 number of rates (including only countries with gdp data)
  numrates_19 <- NROW(data2019$rate)
  numgdp_19 <- NROW(data2019$gdp)
  
  #2019 number of rates (including countries with missing gdp data)
  numrates_19_gdp_mis <- NROW(data2019_gdp_mis$rate)
  numgdp_19_gdp_mis <- NROW(data2019_gdp_mis$gdp)
  
  #2019 distribution (including countries with missing gdp data)
  dist <- hist(data2019_gdp_mis$rate, breaks=c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60), main="2019 Corporate Income Tax Rates", xlab="Rate", col="dodgerblue", las=1)
  distdata <- data.frame(dist$counts,dist$breaks[1:12])
  write.csv(distdata, "final-outputs/distribution_2019.csv")
  
#Top, Bottom, and Zero Rates
    
    #Top
    toprate<-arrange(data2019_gdp_mis, desc(rate))
    toprate<-toprate[1:21,]
    
    toprate$continent <- if_else(toprate$continent == "EU","Europe",toprate$continent)
    toprate$continent <- if_else(toprate$continent == "OC","Oceania",toprate$continent)
    toprate$continent <- if_else(toprate$continent == "AF","Africa",toprate$continent)
    toprate$continent <- if_else(toprate$continent == "AS","Asia",toprate$continent)
    toprate$continent <- if_else(toprate$continent == "NO","North America",toprate$continent)
    toprate$continent <- if_else(toprate$continent == "SA","South America",toprate$continent)
    
    toprate <- subset(toprate, select = c(country, continent, rate))
    
    colnames(toprate)[colnames(toprate)=="country"] <- "Country"
    colnames(toprate)[colnames(toprate)=="continent"] <- "Continent"
    colnames(toprate)[colnames(toprate)=="rate"] <- "Rate"
    
    toprate <- toprate[order(-toprate$Rate, toprate$Country),]
    
    #bottom
    bottomrate<-arrange(data2019_gdp_mis, rate)
    bottomrate<-subset(bottomrate, rate > 0)
    bottomrate <- bottomrate[1:21,]
    
    bottomrate$continent <- if_else(bottomrate$continent == "EU","Europe",bottomrate$continent)
    bottomrate$continent <- if_else(bottomrate$continent == "OC","Oceania",bottomrate$continent)
    bottomrate$continent <- if_else(bottomrate$continent == "AF","Africa",bottomrate$continent)
    bottomrate$continent <- if_else(bottomrate$continent == "AS","Asia",bottomrate$continent)
    bottomrate$continent <- if_else(bottomrate$continent == "NO","North America",bottomrate$continent)
    bottomrate$continent <- if_else(bottomrate$continent == "SA","South America",bottomrate$continent)
    
    bottomrate <- subset(bottomrate, select = c(country, continent, rate))
    
    colnames(bottomrate)[colnames(bottomrate)=="country"] <- "Country"
    colnames(bottomrate)[colnames(bottomrate)=="continent"] <- "Continent"
    colnames(bottomrate)[colnames(bottomrate)=="rate"] <- "Rate"
    
    bottomrate <- bottomrate[order(bottomrate$Rate, bottomrate$Country),]
    
    #zero
    zerorate <- arrange(data2019_gdp_mis, rate)
    zerorate <- subset(zerorate, rate==0)
    
    zerorate$continent <- if_else(zerorate$continent == "EU","Europe",zerorate$continent)
    zerorate$continent <- if_else(zerorate$continent == "OC","Oceania",zerorate$continent)
    zerorate$continent <- if_else(zerorate$continent == "AF","Africa",zerorate$continent)
    zerorate$continent <- if_else(zerorate$continent == "AS","Asia",zerorate$continent)
    zerorate$continent <- if_else(zerorate$continent == "NO","North America",zerorate$continent)
    zerorate$continent <- if_else(zerorate$continent == "SA","South America",zerorate$continent)
    
    zerorate <- subset(zerorate, select = c(country, continent, rate))
    
    colnames(zerorate)[colnames(zerorate)=="country"] <- "Country"
    colnames(zerorate)[colnames(zerorate)=="continent"] <- "Continent"
    colnames(zerorate)[colnames(zerorate)=="rate"] <- "Rate"
    
    zerorate <- zerorate[order(zerorate$Country),]
      
    #exporting top, bottom, and zero rate
    write.csv(toprate, "final-outputs/top_rates.csv")
    write.csv(bottomrate, "final-outputs/bottom_rates.csv")
    write.csv(zerorate, "final-outputs/zero_rates.csv")
      
    
    
#Regional distribution###
    
#2019 by region
      #Creating regional sets (including only countries with gdp data)
      africa <- subset(data2019, continent=="AF")
      africa$rate <- as.numeric(africa$rate)
      africa$gdp <- as.numeric(africa$gdp)
      
      asia <- subset(data2019, continent=="AS")
      asia$rate <- as.numeric(asia$rate)
      asia$gdp <- as.numeric(asia$gdp)
      
      europe <- subset(data2019, continent=="EU")
      europe$rate <- as.numeric(europe$rate)
      europe$gdp <- as.numeric(europe$gdp)
      
      northa <- subset(data2019, continent=="NO")
      northa$rate <- as.numeric(northa$rate)
      northa$gdp <- as.numeric(northa$gdp)
      
      southa <- subset(data2019, continent=="SA")
      southa$rate <- as.numeric(southa$rate)
      southa$gdp <- as.numeric(southa$gdp)
      
      oceania <- subset(data2019, continent=="OC")
      oceania$rate <- as.numeric(oceania$rate)
      oceania$gdp <- as.numeric(oceania$gdp)
      
      eu <- subset(data2019, eu==1)
      eu$rate <- as.numeric(eu$rate)
      eu$gdp <- as.numeric(eu$gdp)
      
      brics <- subset(data2019, brics==1)
      brics$rate <- as.numeric(brics$rate)
      brics$gdp <- as.numeric(brics$gdp)
      
      g7 <- subset(data2019, gseven==1)
      g7$rate <- as.numeric(g7$rate)
      g7$gdp <- as.numeric(g7$gdp)
      
      g20 <- subset(data2019, gtwenty==1)
      g20$rate <- as.numeric(g20$rate)
      g20$gdp <- as.numeric(g20$gdp)
      
      oecd <- subset(data2019, oecd==1)
      oecd$rate <- as.numeric(oecd$rate)
      oecd$gdp <- as.numeric(oecd$gdp)
      
      #Creating regional sets (including countries with missing gdp data)
      africa_gdp_mis <- subset(data2019_gdp_mis, continent=="AF")
      asia_gdp_mis <- subset(data2019_gdp_mis, continent=="AS")
      europe_gdp_mis <- subset(data2019_gdp_mis, continent=="EU")
      northa_gdp_mis <- subset(data2019_gdp_mis, continent=="NO")
      southa_gdp_mis <- subset(data2019_gdp_mis, continent=="SA")
      oceania_gdp_mis <- subset(data2019_gdp_mis, continent=="OC")
      eu_gdp_mis <- subset(data2019_gdp_mis, eu==1)
      brics_gdp_mis <- subset(data2019_gdp_mis, brics==1)
      g7_gdp_mis <- subset(data2019_gdp_mis, gseven==1)
      g20_gdp_mis <- subset(data2019_gdp_mis, gtwenty==1)
      oecd_gdp_mis <- subset(data2019_gdp_mis, oecd==1)
      
      #Simple Means
      africa_mean <- mean(africa$rate, na.rm=TRUE)
      asia_mean <- mean(asia$rate, na.rm=TRUE)
      europe_mean <- mean(europe$rate, na.rm=TRUE)
      northa_mean <- mean(northa$rate, na.rm=TRUE)
      southa_mean <- mean(southa$rate, na.rm=TRUE)
      oceania_mean <- mean(oceania$rate, na.rm=TRUE)
      eu_mean <- mean(eu$rate, na.rm=TRUE)
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
      eu_wmean <- weighted.mean(eu$rate, eu$gdp, na.rm=TRUE)
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
      eu_count <- NROW(eu$gdp)
      brics_count <- NROW(brics$gdp)
      g7_count <- NROW(g7$gdp)
      g20_count <- NROW(g20$gdp)
      oecd_count <- NROW(oecd$gdp)
      
      #compile
      region <- c("Africa","Asia","Europe","North America","Oceania","South America","G7","OECD",
                  "BRICS","EU","G20","World")
      avgrate19 <- c(africa_mean,asia_mean,europe_mean,northa_mean,
                          oceania_mean,southa_mean, g7_mean,oecd_mean,brics_mean,
                          eu_mean,g20_mean,simple_mean_19)
      wavgrate19 <-c(africa_wmean,asia_wmean,europe_wmean,northa_wmean,
                             oceania_wmean,southa_wmean,g7_wmean,oecd_wmean,brics_wmean,
                             eu_wmean,g20_wmean,weighted_mean_19)
      count19 <-c(africa_count,asia_count,europe_count,northa_count,oceania_count,southa_count,
                                g7_count,oecd_count,brics_count,eu_count,g20_count, numgdp_19)
      regional19 <- data.frame(region,avgrate19,wavgrate19,count19)
      
      
      
#Historical rates by every decade
      
#2010 by region
      data2010 <- subset(complete_data, year==2010, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu, gseven, gtwenty, brics))
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
      
      eu10 <- subset(data2010, eu==1)
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
      
      #distribution graph
      dist10 <- hist(data2010$rate, breaks=c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60), main="2010 Corporate Income Tax Rates", xlab="Rate", col="dodgerblue", las=1)
      dist10data <- data.frame(dist10$counts,dist10$breaks[1:12])
      write.csv(dist10data, "final-outputs/distribution_2010.csv")
      
      #compile
      region <- c("Africa","Asia","Europe","North America","Oceania","South America","G7","OECD",
                  "BRICS","EU","G20","World")
      avgrate10 <- c(africa_mean10,asia_mean10,europe_mean10,northa_mean10,
                     oceania_mean10,southa_mean10, g7_mean10,oecd_mean10,brics_mean10,
                     eu_mean10,g20_mean10,mean10)
      wavgrate10 <-c(africa_wmean10,asia_wmean10,europe_wmean10,northa_wmean10,
                     oceania_wmean10,southa_wmean10,g7_wmean10,oecd_wmean10,brics_wmean10,
                     eu_wmean10,g20_wmean10,wmean10)
      count10 <-c(africa_count10,asia_count10,europe_count10,northa_count10,oceania_count10,southa_count10,
                  g7_count10,oecd_count10,brics_count10,eu_count10,g20_count10, numgdp_10)
      regional10<-data.frame(region,avgrate10,wavgrate10,count10)
      
#2000 by region
      data2000 <- subset(complete_data, year==2000, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu, gseven, gtwenty, brics))
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
      
      eu00 <- subset(data2000, eu==1)
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
      
      #distribution graph
      dist00 <- hist(data2000$rate, breaks=c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60), main="2000 Corporate Income Tax Rates", xlab="Rate", col="dodgerblue", las=1)
      dist00data <- data.frame(dist00$counts,dist00$breaks[1:12])
      write.csv(dist00data, "final-outputs/distribution_2000.csv")
      
      #compile
      region <- c("Africa","Asia","Europe","North America","Oceania","South America","G7","OECD",
                  "BRICS","EU","G20","World")
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
      data1990 <- subset(complete_data, year==1990, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu, gseven, gtwenty, brics))
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
      
      eu90 <- subset(data1990, eu==1)
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
      
      #distribution graph
      dist90 <- hist(data1990$rate, breaks=c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80), main="1990 Corporate Income Tax Rates", xlab="Rate", col="dodgerblue", las=1)
      dist90data <- data.frame(dist90$counts,dist90$breaks[1:16])
      write.csv(dist90data, "final-outputs/distribution_1990.csv")
      
      #compile
      region <- c("Africa","Asia","Europe","North America","Oceania","South America","G7","OECD",
                  "BRICS","EU","G20","World")
      avgrate90 <- c(africa_mean90,asia_mean90,europe_mean90,northa_mean90,
                     oceania_mean90,southa_mean90, g7_mean90,oecd_mean90,brics_mean90,
                     eu_mean90,g20_mean90,mean90)
      wavgrate90 <-c(africa_wmean90,asia_wmean90,europe_wmean90,northa_wmean90,
                     oceania_wmean90,southa_wmean90,g7_wmean90,oecd_wmean90,brics_wmean90,
                     eu_wmean90,g20_wmean90,wmean90)
      count90 <-c(africa_count90,asia_count90,europe_count90,northa_count90,oceania_count90,southa_count90,
                  g7_count90,oecd_count90,brics_count90,eu_count90,g20_count90, numgdp_90)
      regional90<-data.frame(region,avgrate90,wavgrate90,count90)
      
      
      
#1980 by region
      data1980 <- subset(complete_data, year==1980, select = c(iso_3, continent, country, year, rate, gdp, oecd, eu, gseven, gtwenty, brics))
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
      
      eu80 <- subset(data1980, eu==1)
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
      
      #distribution graph
      dist80 <- hist(data1980$rate, breaks=c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65), main="1980 Corporate Income Tax Rates", xlab="Rate", col="dodgerblue", las=1)
      dist80data <- data.frame(dist80$counts,dist80$breaks[1:13])
      write.csv(dist80data, "final-outputs/distribution_1980.csv")
      
      #compile
      region <- c("Africa","Asia","Europe","North America","Oceania","South America","G7","OECD",
                  "BRICS","EU","G20","World")
      avgrate80 <- c(africa_mean80,asia_mean80,europe_mean80,northa_mean80,
                     oceania_mean80,southa_mean80, g7_mean80,oecd_mean80,brics_mean80,
                     eu_mean80,g20_mean80,mean80)
      wavgrate80 <-c(africa_wmean80,asia_wmean80,europe_wmean80,northa_wmean80,
                     oceania_wmean80,southa_wmean80,g7_wmean80,oecd_wmean80,brics_wmean80,
                     eu_wmean80,g20_wmean80,wmean80)
      count80 <-c(africa_count80,asia_count80,europe_count80,northa_count80,oceania_count80,southa_count80,
                  g7_count80,oecd_count80,brics_count80,eu_count80,g20_count80, numgdp_80)
      regional80 <- data.frame(region,avgrate80,wavgrate80,count80)
  
      
#Regional decade data
      allregional <- data.frame(merge(regional19, regional10, by = c("region"), all = TRUE))
      allregional <- data.frame(merge(allregional, regional00, by = c("region"), all= TRUE))
      allregional <- data.frame(merge(allregional, regional90, by = c("region"), all = TRUE))
      allregional <- data.frame(merge(allregional, regional80, by = c("region"), all = TRUE))
      write.csv(allregional, "final-outputs/regional_all_data.csv")


#Data for world map showing increases/decreases
      rate_changes <- all_years_final
      rate_changes <- subset(rate_changes, select = c(iso_3, continent, country, `2000`, `2019`))
      rate_changes <- rate_changes[complete.cases(rate_changes),]
      rate_changes$rate_change <- (rate_changes$`2019` - rate_changes$`2000`)
      rate_changes$change <- if_else(rate_changes$`2019` == rate_changes$`2000`,"No Change",if_else(rate_changes$`2019` > rate_changes$`2000`, "Increase", "Decrease"))
      write.csv(rate_changes, "final-outputs/rate_changes.csv")
      

#Rates by region table
      colnames(regional19)[colnames(regional19)=="region"] <- "Region"
      colnames(regional19)[colnames(regional19)=="avgrate19"] <- "Average Rate"
      colnames(regional19)[colnames(regional19)=="wavgrate19"] <- "Weighted Average Rate"
      colnames(regional19)[colnames(regional19)=="count19"] <- "Number of Countries"
      write.csv(regional19, "final-outputs/rates_regional.csv")
      
#Time series graph
      complete_data$rate <- as.numeric(complete_data$rate)
      complete_data$gdp <- as.numeric(complete_data$gdp)
      
      timeseries <- ddply(complete_data, .(year),summarize, weighted.average = weighted.mean(rate,gdp, na.rm = TRUE), average = mean(rate, na.rm = TRUE),n = length(rate[is.na(rate) == FALSE]))
      colnames(timeseries)[colnames(timeseries)=="n"] <- "country_count"
    
      write.csv(timeseries, "final-outputs/rate_time_series.csv", row.names = FALSE)