#Corporate Tax Rates Around the World, 2019

The Tax Foundation’s publication [Corporate Tax Rates Around the World](https://taxfoundation.org/publications/corporate-tax-rates-around-the-world/) shows how statutory corporate income tax rates have developed since 1980, with data for over 200 jurisdictions for the year 2019. The dataset we compiled for the years 1980 to 2019 can be used as a resource for further research.

## Explanation of Files in Repository

### /main directory

Location of the R code, the source documentation, and this README.

The R code reads in and downloads the necessary data, cleans the data, adds missing data manually, merges datasets, and produces intermediate and final output datasets and tables.

The source documentation cites all the sources used.

### /source-data

Location of **input** files to .R code file including:

- `country_codes.csv`: Dataset that includes all 249 sovereign states and dependent territories that have been assigned a country code by the International Organization for Standardization (ISO). Includes official country names in various languages, ISO country codes, continents, and further geographical information.

- `data_rates_1980-2018.csv`: Tax Foundation's dataset of statutory corporate income tax rates for the years 1980 to 2019. This dataset has been built since 2015.

- `gdp_historical.xlsx`: U.S. Department of Agriculture's dataset that includes the historical Real Gross Domestic Product (GDP) and Growth Rates of GDP for 176 countries and regions (in billions of 2010 dollars) for the years 1980 to 2017.

- `gdp_projected.xlsx`: U.S. Department of Agriculture's dataset that includes projected Real Gross Domestic Product (GDP) and Growth Rates of GDP for 176 countries and regions (in billions of 2010 dollars) for the years 2010 to 2030.

- `kpmg_dataset.xlsx`: KPMG's dataset of statutory corporate income tax rates for 171 jurisdictions for the years 2003 to 2019.

### /intermediate-outputs

Location of **intermediate output** files of .R code file including:

- `gdp_iso.csv`: GDP data paired with ISO country codes for the years 1980 to 2019.

- `rates_final.csv`: Statutory corporate income tax rates for the years 1980 to 2019. Includes 2019 rates of all countries for which data was available (data from OECD, KPMG, and researched individually).

- `rates_preliminary.csv`: Statutory corporate income tax rates for the years 1980 to 2019. Includes 2019 rates of countries for which OECD and KPMG data was available. Does not include countries for which the rate was researched and added individually.

### /final-data
Location of **final output** file of .R code file including

- `final_data_long.csv`: Statutory corporate income tax rates and GDP levels of all countries paired with ISO country codes, continents, and country groups for the years 1980 to 2019. Includes all countries that have an ISO country code, including the ones for which corporate rates or GDP data were not available. In long format.

- `final_data_2019.csv`: Statutory corporate income tax rates and GDP levels of countries paired with ISO country codes, continents, and country groups for the year 2019. Only includes countries for which both the corporate rate and GDP data was available.

- `final_data_2019_gdp_incomplete.csv`: Statutory corporate income tax rates and GDP levels of countries paired with ISO country codes, continents, and country groups for the year 2019. Includes all countries for which we have data for the corporate rate, including countries for which we do not have GDP data.

### /final-outputs
Location of **output tables** that are included in the publication.

- `bottomrates.csv`: Table of the 21 countries with the lowest corporate income tax rates in the world in 2019 (excluding countries without a corporate tax).

- `distribution1980.csv`: Table showing the distribution of corporate income tax rates in 1980.

- `distribution1990.csv`: Table showing the distribution of corporate income tax rates in 1990.

- `distribution2000.csv`: Table showing the distribution of corporate income tax rates in 2000.

- `distribution2010.csv`: Table showing the distribution of corporate income tax rates in 2010.

- `distribution2019.csv`: Table showing the distribution of corporate income tax rates in 2019.

- `rate_changes.csv`: Table showing by how much the corporate income tax rate changed between 2000 and 2019, by country.

- `rate_timeseries.csv`: Table showing the weighted and unweighted worldwide average of corporate income tax rates by year between 1980 and 2019.

- `rates_regional.csv`: Table showing the weighted and unweighted averages of corporate income tax rates by continent and country groups for the year 2019.

- `regional_all_data.csv`: Table showing the weighted and unweighted averages of corporate income tax rates by continent and country groups for the years 1980, 1990, 2000, and 2019.

- `toprates.csv`: Table of the 21 countries with the highest corporate income tax rates in the world in 2019.

- `zerorates.csv`: Table of countries without a corporate income tax in 2019.