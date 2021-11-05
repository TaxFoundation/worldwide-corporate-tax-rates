###Worldwide Corporate Tax Rates###

#Clean up working environment####
rm(list=ls())
gc()

#Directory Variables####
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
R_code_files<-"C:/Github/worldwide-corporate-tax-rates/R_code_files/"
source_data<-"C:/Github/worldwide-corporate-tax-rates/source_data/"
intermediate_outputs<-"C:/Github/worldwide-corporate-tax-rates/intermediate_outputs/"
final_data<-"C:/Github/worldwide-corporate-tax-ratesfinal_data/"
final_outputs<-"C:/Github/worldwide-corporate-tax-rates/final_outputs/"


#Define Using function####
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
setwd("C:/Github/worldwide-corporate-tax-rates")
#setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

using(gtools)
using(readxl)
using(rvest)
using(htmltab)
using(stringr)
using(naniar)
using(OECD)
using(plyr)
using(dplyr)
using(reshape2)
using(countrycode)
using(tidyverse)
using(stringr)
using(IMFData)
using(readr)
using(scales)


#Run code files####
source(paste(R_code_files,"01_iso_codes.R",sep=""))
source(paste(R_code_files,"02_rates_preliminary.R",sep="")) #Scrapes the majority of rates for countries#
source(paste(R_code_files,"03_rates_final.R",sep="")) #Edit this file for individual missing countries#
source(paste(R_code_files,"04_gdp_data.R",sep="")) #Organizes GDP data for all countries#
source(paste(R_code_files,"05_rates_calculations.R",sep="")) #Runs all the calculations and outputs for the report#
