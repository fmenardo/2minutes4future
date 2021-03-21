# Data


## Temperature

### 1850 AD - present

Data from 1850 onward was obtained from HadCRUT4 (https://www.metoffice.gov.uk/hadobs/hadcrut4/). HadCRUT4 is a gridded dataset of global historical surface temperature anomalies relative to a 1961-1990 reference period. Data are available for each month since January 1850, on a 5 degree grid.

Citation: Morice, C. P., Kennedy, J. J., Rayner, N. A., and Jones, P. D. (2012), Quantifying uncertainties in global and regional temperature change using an ensemble of observational estimates: The HadCRUT4 data set, J. Geophys. Res., 117, D08101, doi:10.1029/2011JD017187. 

Download global yearly data: https://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/time_series/HadCRUT.4.6.0.0.annual_ns_avg.txt

File format: https://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/series_format.html

File name: HadCRUT.4.6.0.0.annual_ns_avg.txt

### ~9,300 BC - 1900 AD

The estimates of the temperature anomaly in the Holocene was obtained from Marcott et al. 2013

Citation: A Reconstruction of Regional and Global Temperature for the Past 11,300 Years Shaun A. Marcott et al. Science 339 , 1198 (2013); DOI: 10.1126/science.1228026

Download data from supplementary table S1: https://science.sciencemag.org/highwire/filestream/594506/field_highwire_adjunct_files/1/Marcott.SM.database.S1.xlsx

File name: Marcott.SM.database.S1.xlsx (original file)

File name: Marcott_2013_data.tsv (subset of the original file including the global stack Standard 5x5 grid with 1σ uncertainty)

*"This study includes 73 records derived from multiple paleoclimate archives and temperature proxies (Fig. S1; Table S1): alkenone (n=31), planktonic foraminifera Mg/Ca (n=19), TEX86 (n=4), fossil chironomid transfer function (n=4),fossil pollen modern analog technique (MAT) (n=4), ice-core stable isotopes (n=5), other microfossil assemblages(MATand Transfer Function)(n=5), and Methylation index of Branched Tetraethers(MBT)(n=1) \[...\] The 73 globally distributed temperature records used in our analysis are based on a variety of paleotemperature proxies and have sampling resolutions ranging from 20 to 500 years,with a median resolution of 120 years"*.

An important limitation of this data is that it does not fully resolve variability at periods shorter than 2000 years, with essentially no variability preserved at periods shorter than 300 years, ~50% preserved at 1000-year periods,and nearly all of the variability preserved for periods longer than 2000 years

## Atmospheric CO2 concentration

### 1959 AD - present

Data from 1959 through 1979 have been obtained by C. David Keeling of the Scripps Institution of Oceanography (SIO) and were obtained from the Scripps website (scrippsco2.ucsd.edu). Data from 1980 onwards is sourced from NOAA's Mauna Loa monitoring station

Download: https://www.esrl.noaa.gov/gmd/webdata/ccgg/trends/co2/co2_annmean_mlo.txt

File name: co2_annmean_mlo.txt

### ~800,000 BC - 1958 AD

Long-term data were compiled by Our world in data: data from ice cores – specifically the Dome C core – has been made available from the NOAA here: https://www.ncdc.noaa.gov/paleo-search/study/17975. In this original dataset, some years had multiple measurements (taken at different points of the year). To normalize this to a single year, where several measurements were available, we took the average of these concentration values. Dome C data has been used until the year 1958.

Citation: Bereiter, B., Eggleston, S., Schmitt, J., Nehrbass‐Ahles, C., Stocker, T. F., Fischer, H., ... & Chappellaz, J. (2015). Revision of the EPICA Dome C CO2 record from 800 to 600 kyr before present. Geophysical Research Letters, 42(2), 542-549.

Download: https://ourworldindata.org/co2-and-other-greenhouse-gas-emissions/

File name: co2-concentration-long-term.csv

## Yearly CO2 emissions

Data obtained from Friedlingstein et al. 2020. It includes emissions from fossil fuel combustion, oxidation, and cement production. 

Citation: Friedlingstein et al. 2020. Earth Syst. Sci. Data, 12, 3269–3340, 2020 https://doi.org/10.5194/essd-12-3269-2020

Download: https://data.icos-cp.eu/licence_accept?ids=%5B%226QlPjfn_7uuJtAeuGGFXuPwz%22%5D

File name: Global_Carbon_Budget_2020v1.0.xlsx (original file)

File name: annual_emission.tsv (text file obtained from original spreadsheet)


## Sea level

### 1993 AD - present (satellite)

From 1993 there is satellite data available from NASA on the sea level (https://climate.nasa.gov/vital-signs/sea-level/)

Citation: GSFC. 2020. Global Mean Sea Level Trend from Integrated Multi-Mission Ocean Altimeters TOPEX/Poseidon, Jason-1, OSTM/Jason-2, and Jason-3 Version 5.0 Ver. 5.0 PO.DAAC, CA, USA. Dataset accessed [2021-03-04] at http://dx.doi.org/10.5067/GMSLM-TJ150.

Download: https://podaac-tools.jpl.nasa.gov/drive/files/allData/merged_alt/L2/TP_J1_OSTM/global_mean_sea_level/GMSL_TPJAOS_5.0_199209_202010.txt (needs login)

File name: GMSL_TPJAOS_5.0_199209_202010.txt (original file)

File name: GMSL.txt (header removed)


### 1900 AD - 2018 (tide gauge)

Long term data were taken from Frederikse et al. (2020) and derive from tide gauge records

Citation: Frederikse, T., Landerer, F., Caron, L. et al. The causes of sea-level rise since 1900. Nature 584, 393–397 (2020). https://doi.org/10.1038/s41586-020-2591-3

Download: https://zenodo.org/record/3862995/files/global_basin_timeseries.xlsx?download=1

File name: global_basin_timeseries.xlsx (original file)

File name: GMSL_long_term.txt (text file obtained from original spreadsheet)

## Total solar irradiance 

### 1979-2019 Satellites data

This series is composed by measurements from several instruments over the years which are modeled with a neural network

Citation: Mauceri, S., Coddington, O., Lyles, D. et al. Neural Network for Solar Irradiance Modeling (NN-SIM). Sol Phys 294, 160 (2019). https://doi.org/10.1007/s11207-019-1555-y

Download: https://lasp.colorado.edu/lisird/data/nn_sim_tsi/

File name: nn_sim_tsi.csv 


