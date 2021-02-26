# Data


## Temperature

### 1850 AD - present

Data from 1850 onward was obtained from HadCRUT4 (https://www.metoffice.gov.uk/hadobs/hadcrut4/). HadCRUT4 is a gridded dataset of global historical surface temperature anomalies relative to a 1961-1990 reference period. Data are available for each month since January 1850, on a 5 degree grid.

Citation: Morice, C. P., Kennedy, J. J., Rayner, N. A., and Jones, P. D. (2012), Quantifying uncertainties in global and regional temperature change using an ensemble of observational estimates: The HadCRUT4 data set, J. Geophys. Res., 117, D08101, doi:10.1029/2011JD017187. 

Download global yearly data: https://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/time_series/HadCRUT.4.6.0.0.annual_ns_avg.txt

File format: https://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/series_format.html

### 11,300 BC - 1850 AD

The estimates of the temperature anomaly in the Holocene was obtained from Marcott et al. 2013

Citation: A Reconstruction of Regional and Global Temperature for the Past 11,300 Years Shaun A. Marcott et al. Science 339 , 1198 (2013); DOI: 10.1126/science.1228026

This reconstruction is based on 73 globally distributed records.


*"#This study includes 73 records derived from multiple paleoclimate archive sand temperature proxies(Fig. S1; Table S1): alkenone (n=31), planktonic foraminifera Mg/Ca (n=19), TEX86 (n=4), fossil chironomid transfer function (n=4),fossil pollen modern analog technique (MAT) (n=4), ice-core stable isotopes (n=5), other microfossil assemblages(MATand Transfer Function)(n=5), and Methylation index of Branched Tetraethers(MBT)(n=1) \[...\] The 73 globally distributed temperature records used in our analysis are based on a variety of paleotemperature proxies and have sampling resolutions ranging from 20 to 500 years,with a median resolution of 120 years"*.




# An important limitation of this data is thta it does not fully resolve variability at periods shorter than 2000 years,
# with essentially no variability preserved at periods shorter than 300 years, ~50% preserved at 1000-year periods, 
# and nearly all of the variability preserved for periods longer than 2000 years


#Download data from supplementary table S1: https://science.sciencemag.org/highwire/filestream/594506/field_highwire_adjunct_files/1/Marcott.SM.database.S1.xlsx


# Read global T anomaly (compared to 1960-1990 instrumental average) reconstruction 5x5 grid 

Marcott<- read.table("data/Marcott_2013_data.tsv",header=TRUE) # This file includes the global stack Standard 5x5 grid from database S1 with 1σ uncertainty

#Without filling data gaps, our Standard 5×5 reconstruction (Fig. 1A) exhibits 0.6°C greater warming over the past ~60 yr B.P.
#(1890 to 1950 CE) than our equivalent infilled 5° × 5° area-weighted mean stack (Fig. 1, C andD). 
#However, considering the temporal resolution of our data set and the small number of records 
#that cover this interval (Fig. 1G), this difference is probably not robust
