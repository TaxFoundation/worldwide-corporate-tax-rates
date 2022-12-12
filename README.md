# Corporate Tax Rates around the World, 2020

The Tax Foundation’s publication [Corporate Tax Rates around the World](https://taxfoundation.org/publications/corporate-tax-rates-around-the-world/) shows how statutory corporate income tax rates have developed since 1980, with data for over 200 jurisdictions for the year 2022. The dataset we compiled for the years 1980 to 2022 is made available as a resource for research.

## The Dataset

### Scope
The dataset compiled for this publication includes the 2020 statutory corporate income tax rates of 223 sovereign states and dependent territories around the world. Tax rates were researched only for jurisdictions that are among the around 250 sovereign states and dependent territories that have been assigned a country code by the International Organization for Standardization (ISO). (The jurisdictions Netherland Antilles (which was split into different jurisdictions in 2010) and Kosovo (which has not yet officially been assigned a country code) were added to the dataset.) As a result, zones or territories that are independent taxing jurisdictions but do not have their own country code are generally not included in the dataset.

In addition, the dataset includes historic statutory corporate income tax rates for the time period 1980 to 2019. However, these years cover tax rates of fewer than 223 jurisdictions due to missing data points. Please let Tax Foundation know if you are aware of any sources for historic corporate tax rates that are not mentioned in this report, as we constantly strive to improve our datasets.

To be able to calculate average statutory corporate income tax rates weighted by GDP, the dataset includes GDP data for 177 jurisdictions. When used to calculate average statutory corporate income tax rates, either weighted by GDP or unweighted, only these 177 jurisdictions are included (to ensure the comparability of the unweighted and weighted averages).


### Definition of Selected Corporate Income Tax Rate
The dataset captures *standard top statutory corporate income tax rates* levied on domestic businesses. This means:
- The dataset does not reflect special tax regimes, including but not limited to patent boxes, offshore regimes, or special rates for specific industries. 
- A number of countries levy lower rates for businesses below a certain revenue threshold. The dataset does not capture these lower rates.
- A few countries levy gross revenue taxes on businesses instead of corporate income taxes. Since the tax rates of a corporate income tax and a gross revenue tax are not comparable, these countries are excluded from the dataset.
- Some countries have a separate tax rate for nonresident companies. This dataset does not consider nonresident tax rates that differ from the general corporate rate.


## Explanation of Files in Repository

### /main directory

Location of the R code, the source documentation, and this README.

The R code reads in and downloads the necessary data, cleans the data, adds missing data manually, merges datasets, and produces intermediate and final output datasets and tables.

The source documentation cites all the sources used.

### /source-data

Location of **input** files to .R code file including:

- `country_codes.csv` Dataset that includes all 249 sovereign states and dependent territories that have been assigned a country code by the International Organization for Standardization (ISO). Includes official country names in various languages, ISO country codes, continents, and further geographical information.

- `data_rates_1980_2021.csv` Tax Foundation's dataset of statutory corporate income tax rates for the years 1980 to 2019. This dataset has been built in stages since 2015.

- `gdp_historical.xlsx` U.S. Department of Agriculture's dataset of historical real Gross Domestic Product (GDP) and growth rates of GDP for 179 countries and various regions (in billions of 2010 dollars) for the years 1980 to 2018.

- `gdp_projected.xlsx` U.S. Department of Agriculture's dataset of projected real Gross Domestic Product (GDP) and growth rates of GDP for 179 countries and various regions (in billions of 2010 dollars) for the years 2011 to 2031.

### /intermediate-outputs

Location of **intermediate output** files of .R code file including:

- `gdp_iso.csv` GDP data paired with ISO country codes for the years 1980 to 2020.

- `rates_final.csv` Statutory corporate income tax rates for the years 1980 to 2020. Includes rates of all countries for which data was available in 2020 (data from OECD, KPMG, and researched individually).

- `rates_preliminary.csv` Statutory corporate income tax rates for the years 1980 to 2020. Includes rates of countries for which OECD and KPMG data was available for the year 2020. Does not include countries for which the rate was researched and added individually.

### /final-data
Location of **final output** files of .R code file including

- `final_data_2022.csv` Statutory corporate income tax rates and GDP levels of countries paired with ISO country codes, continents, and country groups for the year 2020. Only includes countries for which both the corporate income tax rates and GDP data were available.

- `final_data_2022_gdp_incomplete.csv` Statutory corporate income tax rates and GDP levels of countries paired with ISO country codes, continents, and country groups for the year 2020. Includes all countries for which we have data for the corporate income tax rate, including countries for which we do not have GDP data.

- `final_data_long.csv` Statutory corporate income tax rates and GDP levels of all countries paired with ISO country codes, continents, and country groups for the years 1980 to 2020. Includes all countries that have an ISO country code, including the ones for which corporate income tax rates and/or GDP data was not available. In long format.

### /final-outputs
Location of **output tables** that are included in the publication (either as tables or as charts).

- `all_rates_2022.csv` Table showing the 2020 corporate tax rates for all countries we have data for (223 countries). This is the appendix table in the report.

- `bottom_rates.csv` Table of the 20 countries with the lowest corporate income tax rates in the world in 2020 (excluding countries without a corporate tax).

- `distribution_2022_count.csv` Table showing the distribution of corporate income tax rates in 2020 (as number of countries in each bracket rather than as share of countries in each bracket).

- `distribution_all_decades.csv` Table showing the distribution of corporate income tax rates as shares for each decade between 1980 and 2020.

- `rate_changes.csv` Table showing countries that changed their corporate income tax rates between 2019 and 2020.

- `rate_time_series.csv` Table showing the weighted and unweighted worldwide average of corporate income tax rates by year between 1980 and 2020.

- `rates_regional.csv` Table showing the weighted and unweighted averages of corporate income tax rates by continent and country groups for the year 2020.

- `regional_all_data.csv` Table showing the weighted and unweighted averages of corporate income tax rates by continent and country groups for the years 1980, 1990, 2000, 2010, and 2020.

- `top_rates.csv` Table of the 20 countries with the highest corporate income tax rates in the world in 2020.

- `year_count.csv` Table showing the number of countries for which the dataset includes a corporate income tax rate in each year. (This is an appendix chart in the report.)

- `zero_rates.csv` Table of countries without a corporate income tax in 2020.