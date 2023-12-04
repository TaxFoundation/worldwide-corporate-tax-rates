#Rates Preliminary#

#OECD Data: OECD Countries####

#Read in dataset
#dataset_list<-get_datasets()
#search_dataset("Corporate", data= dataset_list)
#dataset <- ("TABLE_II1")
#dstruc <- get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$CORP_TAX

oecd_data_2023 <- get_dataset("TABLE_II1", start_time = 2023, end_time = 2023)

#Keep and rename selected columns

oecd_data_2023 <- subset(oecd_data_2023, oecd_data_2023$CORP_TAX=="COMB_CIT_RATE")
oecd_data_2023 <- subset(oecd_data_2023, select = -c(CORP_TAX,TIME_FORMAT,Time))

colnames(oecd_data_2023)[colnames(oecd_data_2023)=="ObsValue"] <- "2023"
colnames(oecd_data_2023)[colnames(oecd_data_2023)=="COU"] <- "iso_3"


#Turkey's value for COMB_CIT_RATE for 2023 is missing from table TABLE_II1 but it's available in CTS_CIT
#Read in CTS_CIT OECD dataset for OECD and non-OECD Countries for the year 2023

Turkey_2023 <- get_dataset("CTS_CIT", start_time = 2023, end_time = 2023)

#Keep and rename selected columns

Turkey_2023 <- subset(Turkey_2023, Turkey_2023$CORP_TAX=="COMB_CIT_RATE")
Turkey_2023 <- subset(Turkey_2023, Turkey_2023$COU=="TUR")
Turkey_2023 <- subset(Turkey_2023, select = -c(CORP_TAX,TIME_FORMAT,Time))

colnames(Turkey_2023)[colnames(Turkey_2023)=="ObsValue"] <- "2023"
colnames(Turkey_2023)[colnames(Turkey_2023)=="COU"] <- "iso_3"

#Combine 2023 data ("oecd_data_2023") with Turkey_2023
oecd_data_2023_TUR <- merge(oecd_data_2023, Turkey_2023, by="iso_3", all=T)
oecd_data_2023_TUR$`2023.x` <- ifelse(is.na(oecd_data_2023_TUR$`2023.x`), oecd_data_2023_TUR$`2023.y`, oecd_data_2023_TUR$`2023.x`)

#Keep and rename selected columns
colnames(oecd_data_2023_TUR)[colnames(oecd_data_2023_TUR)=="2023.y"] <- "redundant"
colnames(oecd_data_2023_TUR)[colnames(oecd_data_2023_TUR)=="2023.x"] <- "2023"

oecd_data_2023_TUR <- subset(oecd_data_2023_TUR, select = -c(redundant))

oecd_data_2023 <- subset(oecd_data_2023_TUR)

#KPMG Data####

#Read in dataset
#kpmg_data_2021 <- read_excel("source_data/kpmg_dataset_2010_2021.xlsx")

#Keep and rename selected columns
#kpmg_data_2021 <- kpmg_data_2021[,-c(2:11)]
#colnames(kpmg_data_2021)[colnames(kpmg_data_2021)=="LOCATION"] <- "country"

#Change KPMG country names to match official ISO-names

#kpmg_data_2021$country[kpmg_data_2021$country == "Bolivia"] <- "Bolivia (Plurinational State of)"

#kpmg_data_2021$country[kpmg_data_2021$country == "Bonaire, Saint Eustatius and Saba"] <- "Bonaire, Sint Eustatius and Saba"

#kpmg_data_2021$country[kpmg_data_2021$country == "Ivory Coast"] <- "Cote d'Ivoire"

#kpmg_data_2021$country[kpmg_data_2021$country == "Hong Kong SAR"] <- "China, Hong Kong Special Administrative Region"

#kpmg_data_2021$country[kpmg_data_2021$country == "Macau"] <- "China, Macao Special Administrative Region"

#kpmg_data_2021$country[kpmg_data_2021$country == "Congo (Democratic Republic of the)"] <- "Democratic Republic of the Congo"

#kpmg_data_2021$country[kpmg_data_2021$country == "Czech Republic"] <- "Czechia"

#kpmg_data_2021$country[kpmg_data_2021$country == "Korea, Republic of"] <- "Republic of Korea"

#kpmg_data_2021$country[kpmg_data_2021$country == "Macedonia"] <- "The former Yugoslav Republic of Macedonia"

#kpmg_data_2021$country[kpmg_data_2021$country == "Moldova"] <- "Republic of Moldova"

#kpmg_data_2021$country[kpmg_data_2021$country == "Palestinian Territory"] <- "State of Palestine"

#kpmg_data_2021$country[kpmg_data_2021$country == "Russia"] <- "Russian Federation"

#kpmg_data_2021$country[kpmg_data_2021$country == "St Maarten"] <- "Saint Martin (French Part)"

#kpmg_data_2021$country[kpmg_data_2021$country == "Syria"] <- "Syrian Arab Republic"

#kpmg_data_2021$country[kpmg_data_2021$country == "Tanzania"] <- "United Republic of Tanzania"

#kpmg_data_2021$country[kpmg_data_2021$country == "United Kingdom"] <- "United Kingdom of Great Britain and Northern Ireland"

#kpmg_data_2021$country[kpmg_data_2021$country == "United States"] <- "United States of America"

#kpmg_data_2021$country[kpmg_data_2021$country == "Venezuela"] <- "Venezuela (Bolivarian Republic of)"

#kpmg_data_2021$country[kpmg_data_2021$country == "Vietnam"] <- "Viet Nam"


#Add ISO-Code to KPMG Data
#kpmg_data_iso <- merge(kpmg_data_2021, country_iso_cont, by="country", all=T)

#Remove continent averages
#kpmg_data_iso <- kpmg_data_iso[!grepl("average", kpmg_data_iso$country),]


#Merge OECD and KPMG Data####

#oecd_kpmg_2021 <- merge(oecd_data_2021, kpmg_data_iso, by="iso_3", all=T)
#oecd_kpmg_2021$`2021.x` <- if_else(is.na(oecd_kpmg_2021$`2021.x`), oecd_kpmg_2021$`2021.y`, oecd_kpmg_2021$`2021.x`)
#oecd_kpmg_2021 <- subset(oecd_kpmg_2021, select = -c(`2021.y`,iso_2))

#colnames(oecd_kpmg_2021)[colnames(oecd_kpmg_2021)=="2021.x"] <- "2021"

#oecd_kpmg_2021 <- oecd_kpmg_2021[, c("2021", "iso_3", "country", "continent")]

#Dataset for previous years####

#Read in dataset Tax Foundation has compiled over the years for 1980-2022
previous_years <- read_csv("source_data/data_rates_1980_2022.csv")

#Drop column that is not needed
previous_years <- subset(previous_years, select = -c(...1))


#Read in OECD dataset for OECD and non-OECD Countries

#Read in dataset
#dataset_list<-get_datasets()
#search_dataset("Corporate", data= dataset_list)
#dataset_non_OECD <- ("CTS_CIT")
#dstruc <- get_data_structure(dataset_non_OECD)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$CORP_TAX

non_oecd_data <- get_dataset("CTS_CIT", start_time = 2000, end_time = 2022)

#Keep and rename selected columns

non_oecd_data <- subset(non_oecd_data, non_oecd_data$CORP_TAX=="COMB_CIT_RATE")
non_oecd_data <- subset(non_oecd_data, select = -c(CORP_TAX,TIME_FORMAT))

colnames(non_oecd_data)[colnames(non_oecd_data)=="Time"] <- "year"
colnames(non_oecd_data)[colnames(non_oecd_data)=="ObsValue"] <- "rate"
colnames(non_oecd_data)[colnames(non_oecd_data)=="COU"] <- "iso_3"


#Add rates for historic years that OECD database covers for OECD and non-OECD countries that are missing in the historic TF dataset
previous_years_long <- (melt(previous_years, id=c("iso_2","iso_3","continent","country")))
colnames(previous_years_long)[colnames(previous_years_long)=="variable"] <- "year"
previous_years_long$value <- as.numeric(previous_years_long$value)

previous_years_long <- merge(previous_years_long, non_oecd_data, by=c("iso_3", "year"), all=T)

previous_years_long$value <- ifelse(is.na(previous_years_long$value), previous_years_long$rate, previous_years_long$value)


previous_years_long <- subset(previous_years_long, select = -c(rate))
colnames(previous_years_long)[colnames(previous_years_long)=="value"] <- "rate"

previous_years <- spread(previous_years_long, year, rate)


#Read in OECD dataset for OECD and non-OECD Countries (including Turkey) for the year 2023

non_oecd_data_2023 <- get_dataset("CTS_CIT", start_time = 2023, end_time = 2023)

#Keep and rename selected columns

non_oecd_data_2023 <- subset(non_oecd_data_2023, non_oecd_data_2023$CORP_TAX=="COMB_CIT_RATE")
non_oecd_data_2023 <- subset(non_oecd_data_2023, select = -c(CORP_TAX,TIME_FORMAT,Time))

colnames(non_oecd_data_2023)[colnames(non_oecd_data_2023)=="ObsValue"] <- "2023"
colnames(non_oecd_data_2023)[colnames(non_oecd_data_2023)=="COU"] <- "iso_3"

#Combine 2023 data ("oecd_2023") with 2022 non_OECD data
oecd_all_2023 <- merge(oecd_data_2023, non_oecd_data_2023, by="iso_3", all=T)

#Keep and rename selected columns
colnames(oecd_all_2023)[colnames(oecd_all_2023)=="2023.x"] <- "redundant"
colnames(oecd_all_2023)[colnames(oecd_all_2023)=="2023.y"] <- "2023"

oecd_all_2023 <- subset(oecd_all_2023, select = -c(redundant))


#Combine 2023 data ("oecd_all_2023") with data from previous years ("previous_years")
all_years_preliminary <- merge(oecd_all_2023, previous_years, by="iso_3", all=T)
all_years_preliminary <- all_years_preliminary[, c("iso_2", "iso_3", "continent", "country", 1980, 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023)]

write.csv(all_years_preliminary,"intermediate_outputs/rates_preliminary.csv")