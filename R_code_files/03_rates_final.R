#Missing rates and Final data#

#Add Missing Corporate Rates Manually###

#ALA - Aland Islands
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "ALA",] <- 20

#ARE - United Arab Emirates (correction: rate set to zero for all years as CIT only levied on certain industries and this dataset captures general corporate tax systems)
all_years_preliminary[c("1980", 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021)][all_years_preliminary$iso_3 == "ARE",] <- 0

#ARG - Argentina
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "ARG",] <- 35

#ASM - American Samoa
all_years_preliminary[c("2014")][all_years_preliminary$iso_3 == "ASM",] <- 44
all_years_preliminary[c("2015")][all_years_preliminary$iso_3 == "ASM",] <- 44
all_years_preliminary[c("2016")][all_years_preliminary$iso_3 == "ASM",] <- 44
all_years_preliminary[c("2017")][all_years_preliminary$iso_3 == "ASM",] <- 34
all_years_preliminary[c("2018")][all_years_preliminary$iso_3 == "ASM",] <- 34
all_years_preliminary[c("2019")][all_years_preliminary$iso_3 == "ASM",] <- 34
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "ASM",] <- 34
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "ASM",] <- 34

#BLM - Saint Barthelemy
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "BLM",] <- 0

#BLZ - Belize
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "BLZ",] <- 25

#BTN - Bhutan
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "BTN",] <- 25

#CAF - Central African Republic
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "CAF",] <- 30

#COK - Cook Islands
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "COK",] <- 20

#COM - Comoros
all_years_preliminary[c("2017")][all_years_preliminary$iso_3 == "COM",] <- 50
all_years_preliminary[c("2018")][all_years_preliminary$iso_3 == "COM",] <- 50
all_years_preliminary[c("2019")][all_years_preliminary$iso_3 == "COM",] <- 50
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "COM",] <- 50
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "COM",] <- 50

#CPV - Cabo Verde
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "CPV",] <- 22

#CUB - Cuba
all_years_preliminary[c("2013")][all_years_preliminary$iso_3 == "CUB",] <- 35
all_years_preliminary[c("2014")][all_years_preliminary$iso_3 == "CUB",] <- 35
all_years_preliminary[c("2015")][all_years_preliminary$iso_3 == "CUB",] <- 35
all_years_preliminary[c("2016")][all_years_preliminary$iso_3 == "CUB",] <- 35
all_years_preliminary[c("2017")][all_years_preliminary$iso_3 == "CUB",] <- 35
all_years_preliminary[c("2018")][all_years_preliminary$iso_3 == "CUB",] <- 35
all_years_preliminary[c("2019")][all_years_preliminary$iso_3 == "CUB",] <- 35
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "CUB",] <- 35
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "CUB",] <- 35

#ERI - Eritrea
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "ERI",] <-  30

#FLK - Falkland Islands (Malvinas)
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "FLK",] <- 26

#FRO - Faroe Islands
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "FRO",] <- 18

#FSM - Micronesia (Federated States of)
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "FSM",] <- 30
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

#GIB - Gibraltar
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "GIB",] <- 12.5

#GIN - Guinea
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "GIN",] <- 35

#GNB - Guinea-Bissau
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "GNB",] <- 25

#GNQ - Equatorial Guinea
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "GNQ",] <- 35

#GRL - Greenland
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "GRL",] <- 26.5

#GUM - Guam
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "GUM",] <- 21

#GUY - Guyana
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "GUY",] <- 25

#HTI - Haiti
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "HTI",] <- 30

#IRN - Iran (Islamic Republic of)
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "IRN",] <- 25

#IRQ - Iraq 
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "IRQ",] <- 15

#KIR - Kiribati
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "KIR",] <- 30

#LAO - Lao People's Democratic Republic
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "LAO",] <- 20

#LBR - Liberia
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "LBR",] <- 25

#LSO - Lesotho
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "LSO",] <- 25

#MCO - Monaco (correction for 2018: rate was 33.33% instead of 33%)
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "MCO",] <- 26.5

#MDV - Maldives
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "MDV",] <- 15

#MLI - Mali
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "MLI",] <- 30

#MNP - Northern Mariana Islands
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "MNP",] <- 21

#MRT - Mauritania
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "MRT",] <- 25

#MSR - Montserrat
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "MSR",] <- 30

#NCL - New Caledonia
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "NCL",] <- 30

#NER - Niger
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "NER",] <- 30

#NIU - Niue
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "NIU",] <- 30

#NPL - Nepal
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "NPL",] <- 25

#NRU - Nauru 
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "NRU",] <- 25

#PAK - Pakistan 
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "PAK",] <- 29

#PRI - Puerto Rico
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "PRI",] <- 37.5

#PYF - French Polynesia
all_years_preliminary[c("2018")][all_years_preliminary$iso_3 == "PYF",] <- 27
all_years_preliminary[c("2019")][all_years_preliminary$iso_3 == "PYF",] <- 27
all_years_preliminary[c("2020")][all_years_preliminary$iso_3 == "PYF",] <- 27
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "PYF",] <- 27

#SHN - Saint Helena
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "SHN",] <- 25

#SMR - San Marino
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "SMR",] <- 17

#SSD - 	South Sudan
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "SSD",] <- 25

#STP - Sao Tome and Principe
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "STP",] <- 25

#SYC - Seychelles
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "SYC",] <- 33

#TCD - Chad
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "TCD",] <- 35

#TGO - Togo
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "TGO",] <- 27

#TJK - Tajikistan
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "TJK",] <- 23

#TKL - Tokelau
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "TKL",] <- 0

#TKM - Turkmenistan
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "TKM",] <- 8

#TLS - Timor-Leste
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "TLS",] <- 10

#TON - Tonga
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "TON",] <- 25

#VGB - British Virgin Islands
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "VGB",] <- 0

#VIR - 	United States Virgin Islands (correction: 10% surtax imposed)
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "VIR",] <- 23.1

#WLF - Wallis and Futuna Islands
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "WLF",] <- 0

#XKX - Kosovo, Republic of
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "XKX",] <- 10

#ZWE - Zimbabwe (includes 3% surtax)
all_years_preliminary[c("2021")][all_years_preliminary$iso_3 == "ZWE",] <- 24.72

#Define final corporate tax rate data###
all_years_final <- all_years_preliminary

#Write final corporate tax rate data
write.csv(all_years_final,"intermediate_outputs/rates_final.csv")
