
# HadCRUT4 is a gridded dataset of global historical surface temperature anomalies relative to a 1961-1990 reference period. Data are available for each month since January 1850, on a 5 degree grid.
#More information here: https://www.metoffice.gov.uk/hadobs/hadcrut4/

#Citation: Morice, C. P., Kennedy, J. J., Rayner, N. A., and Jones, P. D. (2012), Quantifying uncertainties in global and regional temperature change using an ensemble of observational estimates: The HadCRUT4 data set, J. Geophys. Res., 117, D08101, doi:10.1029/2011JD017187. 

# Download data yearly global: https://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/time_series/HadCRUT.4.6.0.0.annual_ns_avg.txt

#Column 1 is the date.
#Column 2 is the median of the 100 ensemble member time series.
#Columns 3 and 4 are the lower and upper bounds of the 95% confidence interval of bias uncertainty computed from the 100 member ensemble.
#Columns 5 and 6 are the lower and upper bounds of the 95% confidence interval of measurement and sampling uncertainties around the ensemble median. These are the combination of fully uncorrelated measurement and sampling uncertainties and partially correlated uncertainties described by the HadCRUT4 error covariance matrices.
#Columns 7 and 8 are the lower and upper bounds of the 95% confidence interval of coverage uncertainties around the ensemble median.
#Columns 9 and 10 are the lower and upper bounds of the 95% confidence interval of the combination of measurement and sampling and bias uncertainties.
#Columns 11 and 12 are the lower and upper bounds of the 95% confidence interval of the combined effects of all the uncertainties described in the HadCRUT4 error model (measurement and sampling, bias and coverage uncertainties).


HC<- read.table("data/HadCRUT.4.6.0.0.annual_ns_avg.txt",header=F) # 

colnames(HC)=c("Year","Median","","","","","","","","","CI_low","CI_high")


temp <- subset(HC, HC$Year<1901)
mean(temp$Median)

HC_not_rescaled=HC


HC$Median = HC$Median-mean(temp$Median)
HC$CI_low = HC$CI_low-mean(temp$Median)
HC$CI_high = HC$CI_high-mean(temp$Median)


library("ggplot2")

# plot T anomaly last 170 years

ylabel="T anomaly in °C compared to 1850-1900"

p<- ggplot(data=HC, aes(x=Year, y=Median))  + geom_line (col="red") + xlim(1849,2021) + ylab(ylabel) +
  geom_ribbon(aes(ymin=CI_low, ymax=HC$CI_high), linetype=2, alpha=0.3, fill="red") +
  geom_hline(yintercept=0, linetype=3)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        panel.border = element_rect(color = "black",fill = NA,size = 1))
                                                                                                                   
p

ggsave(filename="plots_pdf/T_anomaly_last_170_years.pdf",width =11, height =6)
ggsave(filename="plots_png/T_anomaly_last_170_years.png",width =11, height =6)





# Reconstruction of temperature anomaly during the Holocene, based on 73 globally distributed records.
#The 73 globally distributed temperature records used in our analysis are based on a variety
#of paleotemperature proxies and have sampling resolutions ranging from 20 to 500 years, 
#with a median resolution of 120 years

#This study includes 73 records derived from multiple paleoclimate archive sand temperature proxies(Fig. S1; Table S1):
#alkenone (n=31), planktonic foraminifera Mg/Ca (n=19), TEX86 (n=4), fossil chironomid transfer function (n=4), 
#fossil pollen modern analog technique (MAT) (n=4), ice-core stable isotopes (n=5), 
#other microfossil assemblages(MATand Transfer Function)(n=5), and Methylation index of Branched Tetraethers(MBT)(n=1)


# An important limitation of this data is that it does not fully resolve variability at periods shorter than 2000 years,
# with essentially no variability preserved at periods shorter than 300 years, ~50% preserved at 1000-year periods, 
# and nearly all of the variability preserved for periods longer than 2000 years

# Citation: A Reconstruction of Regional and Global Temperature for the Past 11,300 Years Shaun A. Marcott et al. Science 339 , 1198 (2013); DOI: 10.1126/science.1228026

#Download data from supplementary table S1: https://science.sciencemag.org/highwire/filestream/594506/field_highwire_adjunct_files/1/Marcott.SM.database.S1.xlsx


# Read global T anomaly (compared to 1960-1990 instrumental average) reconstruction 5x5 grid 

Marcott<- read.table("data/Marcott_2013_data.tsv",header=TRUE) # This file includes the global stack Standard 5x5 grid from database S1 with 1σ uncertainty

#Without filling data gaps, our Standard 5×5 reconstruction (Fig. 1A) exhibits 0.6°C greater warming over the past ~60 yr B.P.
#(1890 to 1950 CE) than our equivalent infilled 5° × 5° area-weighted mean stack (Fig. 1, C andD). 
#However, considering the temporal resolution of our data set and the small number of records 
#that cover this interval (Fig. 1G), this difference is probably not robust

M<-subset(Marcott, Marcott$Year>60) # exclude years after 1890, later reconstruction are based on a single data point => not robust according to the authors

M$Year=1950-M$Year # by convention 1950 is set as year 0, here the data is converted in classic caledar year 

Merged_T<-merge(x = M, y = HC, by = "Year", all = TRUE) # merge Marcot and HADcrut4 datasets


temp <- subset(HC_not_rescaled, HC$Year<1901)
mean(temp$Median)
Merged_T_not_rescaled=Merged_T

Merged_T$T = Merged_T$T-mean(temp$Median)



# plot T anomaly from Marcott and HadCRUT at different times  
ylabel="T anomaly in °C compared to 1850-1900"

years=c(12000,5000,2000,1000,500)
options(scipen=999)
for (i in years) {
  
  if (i == 12000){bre=c(-10000,-8000,-6000,-4000,-2000,0,2000)}else {bre=waiver()}

  p<- ggplot(data=subset(Merged_T,!is.na(T)),aes(x = Year, y = T,colour="Marcott et al. 2013"))  + geom_line ()  + ylab(ylabel) + xlab("Year")+
    scale_x_continuous(breaks=bre,limits=c(2021-i,2021)) +
    geom_ribbon(data=subset(Merged_T,!is.na(T)),aes(ymin=T-T_uncertainty, ymax=T+T_uncertainty, fill="Marcott et al. 2013",colour="Marcott et al. 2013"), linetype=0, alpha=0.3) +   
    geom_line(data=subset(Merged_T,!is.na(Median)),aes(y=Median,x=Year,colour="HadCRUT4"),alpha=0.7) +
    geom_hline(yintercept=0, linetype=3)+
    geom_ribbon(data=subset(Merged_T,!is.na(Median)),aes(x=Year,ymin=CI_low, ymax=CI_high,colour="HadCRUT4",fill="HadCRUT4"),linetype=0, alpha=0.3) +
    scale_colour_manual("", 
                        breaks = c("Marcott et al. 2013", "HadCRUT4"),
                        values = c("black", "red")) +
    scale_fill_manual("", 
                      breaks = c("Marcott et al. 2013", "HadCRUT4"),
                      values = c("black", "red")) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          panel.border = element_rect(color = "black",fill = NA,size = 1)) + 
          theme(legend.position = c(0.11, 0.91),legend.text = element_text(size=14))
  

ggsave(filename=paste0("plots_pdf/T_anomaly_Marcott_last_",i,"_years_and_170_years_HC.pdf"),width=11,height=6)
ggsave(filename=paste0("plots_png/T_anomaly_Marcott_last_",i,"_years_and_170_years_HC.png"),width=11,height=6)

}


#CO2 atmospheric concentration

#data from 1959 from NOOA: Data from 1959 through 1979 have been obtained by C. David Keeling of the Scripps Institution of Oceanography (SIO) and were obtained from the Scripps website (scrippsco2.ucsd.edu).
#Data from 1980 onwards is sourced from NOAA's Mauna Loa monitoring station
# Download: https://www.esrl.noaa.gov/gmd/webdata/ccgg/trends/co2/co2_annmean_mlo.txt


CO2_recent<-read.table("data/co2_annmean_mlo.txt",header=F)

# 
#Very long-term data were compiled by Our world in data: data from ice cores – specifically the Dome C core – 
#has been made available from the NOAA here: https://www.ncdc.noaa.gov/paleo-search/study/17975. 
#In this original dataset, some years had multiple measurements (taken at different points of the year). 
#To normalize this to a single year, where several measurements were available, 
#we took the average of these concentration values. Dome C data has been used until the year 1958.

#Citation: Bereiter, B., Eggleston, S., Schmitt, J., Nehrbass‐Ahles, C., Stocker, T. F., Fischer, H., ... & Chappellaz, J. (2015). Revision of the EPICA Dome C CO2 record from 800 to 600 kyr before present. Geophysical Research Letters, 42(2), 542-549.

# Download: https://ourworldindata.org/co2-and-other-greenhouse-gas-emissions

CO2_old<-read.csv("data/co2-concentration-long-term.csv")


# the recent and old data use a differnt CO2 scale, conversion can be done with following formula:  
#X2019 = 1.00079 * X2007 - 0.142 (https://www.esrl.noaa.gov/gmd/ccl/scale_conversion.html), 
#the conversion is reccomended only between 250 and 520 ppm,

CO2_o <- subset(CO2_old,CO2_old$Year<1959)

CO2_o$CO2.concentrations..NOAA..2018. <-(CO2_o$CO2.concentrations..NOAA..2018.*1.00079)-0.142  # rescale

CO2_r <- CO2_recent[,-3]

colnames (CO2_r) <-c("year","mean")

colnames (CO2_o) <-c("year","mean")

CO2<- rbind(CO2_o,CO2_r)

colnames (CO2) <-c("Year","mean")

Merged_T_C<-merge(x = Merged_T, y = CO2, by = "Year", all = TRUE) # merge CO2 and T data


years=c(810000,12000,5000,2000,1000,500,170)

for (i in years) {
  if (i == 12000){bre=c(-8000,-6000,-4000,-2000,0,2000)}else {bre=waiver()}
  


p<- ggplot(data=subset(Merged_T_C,!is.na(mean)), aes(x=Year, y=mean))  + geom_line () + ylab(bquote(bold('Atmospheric ' ~CO[2]~ '(ppm)'))) +
  scale_x_continuous(breaks=bre,limits=c(2021-i,2021)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        panel.border = element_rect(color = "black",fill = NA,size = 1))

ggsave(filename=paste0("plots_pdf/CO2_atmospheric_conc_last_",i,"_years.pdf"),width=11,height=6)
ggsave(filename=paste0("plots_png/CO2_atmospheric_conc_last_",i,"_years.png"),width=11,height=6)


}


p
#plot T and CO2 together 

library(gridExtra)
library(ggpubr)

ylabel="T anomaly in °C"

years=c(12000,5000,2000,1000,500)

for (i in years) {
  if (i == 12000){bre=c(-8000,-6000,-4000,-2000,0,2000)}else {bre=waiver()}
  
  p1<- ggplot(data=subset(Merged_T_C,!is.na(mean)), aes(x=Year, y=mean))  + geom_line () + ylab(bquote(bold('Atmospheric ' ~CO[2]~ '(ppm)'))) +  ylim(225,450)+
    scale_x_continuous(breaks=bre,limits=c(2021-i,2021)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          panel.border = element_rect(color = "black",fill = NA,size = 1))
  
  p<- ggplot(data=subset(Merged_T,!is.na(T)),aes(x = Year, y = T,colour="Marcott et al. 2013"))  + geom_line () + ylab(ylabel) + xlab("")+
    scale_x_continuous(breaks=bre,limits=c(2021-i,2021)) +
    geom_hline(yintercept=0, linetype=3)+
    geom_ribbon(data=subset(Merged_T,!is.na(T)),aes(ymin=T-T_uncertainty, ymax=T+T_uncertainty, fill="Marcott et al. 2013",colour="Marcott et al. 2013"), linetype=0, alpha=0.3) +   
    geom_line(data=subset(Merged_T,!is.na(Median)),aes(y=Median,x=Year,colour="HadCRUT4"),alpha=0.7) +
    geom_ribbon(data=subset(Merged_T,!is.na(Median)),aes(x=Year,ymin=CI_low, ymax=CI_high,colour="HadCRUT4",fill="HadCRUT4"),linetype=0, alpha=0.3) +
    scale_colour_manual("", 
                        breaks = c("Marcott et al. 2013", "HadCRUT4"),
                        values = c("black", "red")) +
    scale_fill_manual("", 
                      breaks = c("Marcott et al. 2013", "HadCRUT4"),
                      values = c("black", "red")) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          panel.border = element_rect(color = "black",fill = NA,size = 1)) + 
    theme(legend.position = c(0.08, 0.9),legend.text = element_text(size=10),
          legend.background = element_blank(),
          legend.box.background = element_blank())
  
  
  ggarrange(p,p1, ncol = 1, nrow = 2)
  
  
  
  ggsave(paste0("plots_pdf/T_CO2_last_",i,"_years.pdf"),width=11,height=6)
  ggsave(paste0("plots_png/T_CO2_last_",i,"_years.png"),width=11,height=6)
  
  
}


# plot T and C only instrumental T


p1<- ggplot(data=subset(Merged_T_C,!is.na(mean)), aes(x=Year, y=mean))  + geom_line () + xlim(1850,2021) + ylab(bquote(bold('Atmospheric ' ~CO[2]~ '(ppm)'))) +  ylim(225,450)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        panel.border = element_rect(color = "black",fill = NA,size = 1))

p<- ggplot(data=subset(Merged_T,!is.na(Median)),aes(x = Year, y = Median))  + geom_line (colour="red") + xlim(1850,2021) + ylab(ylabel) + xlab("")+
  geom_ribbon(data=subset(Merged_T,!is.na(Median)),aes(ymin=CI_low, ymax=CI_high), linetype=0, alpha=0.3,fill="red") +   
  geom_hline(yintercept=0, linetype=3)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        panel.border = element_rect(color = "black",fill = NA,size = 1))


ggarrange(p,p1, ncol = 1, nrow = 2)

ggsave("plots_pdf/T_CO2_last_170_years.pdf",width=11,height=6)

ggsave("plots_png/T_CO2_last_170_years.png",width=11,height=6)


# plot CO2 yearly emissions 
# Citation: Friedlingstein et al. 2020. Earth Syst. Sci. Data, 12, 3269–3340, 2020 https://doi.org/10.5194/essd-12-3269-2020
#All values in million tonnes of carbon per year. For values in million tonnes of CO2 per year, multiply the values below by 3.664
#Include emissions from fossil fuel combustion and oxidation and cement production 

# Download: https://data.icos-cp.eu/licence_accept?ids=%5B%226QlPjfn_7uuJtAeuGGFXuPwz%22%5D

emissions <- read.table("data/annual_emission.tsv",header=T)  # file with historical emissions (World)
emissions$emission <-(emissions$emission*3.664 )

p <- ggplot(data=emissions,aes(x = Year, y = emission))  + geom_line ()+ xlab("Year")+  ylab(bquote(bold('Gt ' ~CO[2]~ 'per year')))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        panel.border = element_rect(color = "black",fill = NA,size = 1))
p


ggsave("plots_pdf/CO2_emissions.pdf",width=11,height=6)
ggsave("plots_png/CO2_emissions.png",width=11,height=6)




# plot sea level change

#Long term data were taken from Frederikse et al. (2020) and derive from tide gauge records

#Citation: Frederikse, T., Landerer, F., Caron, L. et al. The causes of sea-level rise since 1900. Nature 584, 393–397 (2020). https://doi.org/10.1038/s41586-020-2591-3

#Download: https://zenodo.org/record/3862995/files/global_basin_timeseries.xlsx?downlo


sea_old <- read.table("data/GMSL_long_term.txt", header=T)

ref=subset(sea_old,sea_old$Year==1900)
ref
sea_o=sea_old+(-ref$GMSL_mean) # recalibrate: level of 1900 = 0
sea_o$Year <- sea_old$Year
head(sea_old)
head(sea_o)

# from 1993 there is satellite data available from nasa

# https://climate.nasa.gov/vital-signs/sea-level/
# Citation: GSFC. 2020. Global Mean Sea Level Trend from Integrated Multi-Mission Ocean Altimeters TOPEX/Poseidon, Jason-1, OSTM/Jason-2, and Jason-3 Version 5.0 Ver. 5.0 PO.DAAC, CA, USA. Dataset accessed [2021-03-04] at http://dx.doi.org/10.5067/GMSLM-TJ150.
#Download: https://podaac-tools.jpl.nasa.gov/drive/files/allData/merged_alt/L2/TP_J1_OSTM/global_mean_sea_level/GMSL_TPJAOS_5.0_199209_202010.txt (needs login)

# column description 
# 1 altimeter type 0=dual-frequency  999=single frequency (ie Poseidon-1) 
# 2 merged file cycle # 
# 3 year+fraction of year (mid-cycle) 
# 4 number of observations 
# 5 number of weighted observations 
# 6 GMSL (Global Isostatic Adjustment (GIA) not applied) variation (mm) with respect to 20-year TOPEX/Jason collinear mean reference 
# 7 standard deviation of GMSL (GIA not applied) variation estimate (mm)
# 8 smoothed (60-day Gaussian type filter) GMSL (GIA not applied) variation (mm)  
# 9 GMSL (Global Isostatic Adjustment (GIA) applied) variation (mm) with respect to 20-year TOPEX/Jason collinear mean reference 
# 10 standard deviation of GMSL (GIA applied) variation estimate (mm)
# 11 smoothed (60-day Gaussian type filter) GMSL (GIA applied) variation (mm)
# 12 smoothed (60-day Gaussian type filter) GMSL (GIA applied) variation (mm); annual and semi-annual signal removed
#
# Missing or bad value flag: 99900.000 
# 
# TOPEX/Jason 1996-2016 collinear mean reference derived from cycles 121 to 858.



sea <- read.table("data/GMSL.txt", header=F) # removed header from original file


ref=subset(sea_o,sea_o$Year==1993)
ref$GMSL_mean
ref1=sea[1,6]

sea[,13]=sea[,6]+(ref$GMSL_mean+(-ref1))

colnames(sea) <-c("","","Year","","","GMSL (Global Isostatic Adjustment (GIA) not applied) variation (mm) with respect to 20-year TOPEX/Jason collinear mean reference",
                  "","","","","","","GMSL_ref")

Merged_sea<-merge(x = sea_o, y = sea, by = "Year", all = TRUE) # merge  datasets


p<- ggplot(data=subset(Merged_sea,!is.na(GMSL_mean)),aes(x = Year, y = GMSL_mean,colour="Tide gauge (Frederikse et al. 2020)"))  + 
        geom_line ()  + ylab("Sea level change (mm)") + xlab("Year")+xlim(1900,2021)+
  geom_ribbon(data=subset(Merged_sea,!is.na(GMSL_mean)),aes(ymin=GMSL_lower, ymax=GMSL_upper,colour="Tide gauge (Frederikse et al. 2020)",fill="Tide gauge (Frederikse et al. 2020)") ,linetype=0, alpha=0.3) +   
  geom_line(data=subset(Merged_sea,!is.na(GMSL_ref)),aes(y=GMSL_ref,x=Year,colour="Satellite (NASA)"),alpha=0.7) +
  geom_hline(yintercept=100, linetype=3)+  geom_hline(yintercept=200, linetype=3)+geom_hline(yintercept=0, linetype=3)+
  geom_ribbon(data=subset(Merged_sea,!is.na(GMSL_ref)),aes(x=Year,ymin=GMSL_ref-4, ymax=GMSL_ref+4,colour="Satellite (NASA)",fill="Satellite (NASA)"),linetype=0, alpha=0.3) +   #uncertaineity 4 mm taken from https://climate.nasa.gov/vital-signs/sea-level/
  scale_colour_manual("", 
                      breaks = c("Tide gauge (Frederikse et al. 2020)", "Satellite (NASA)"),
                      values = c("black", "red")) +
  scale_fill_manual("", 
                    breaks = c("Tide gauge (Frederikse et al. 2020)", "Satellite (NASA)"),
                   values = c("black", "red")) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        panel.border = element_rect(color = "black",fill = NA,size = 1)) + 
  theme(legend.position = c(0.17, 0.96),legend.text = element_text(size=13),legend.background = element_blank(),
        legend.box.background = element_blank())

p
ggsave(filename=paste0("plots_pdf/sea_level_change.pdf"),width=11,height=6)
ggsave(filename=paste0("plots_png/sea_level_change.png"),width=11,height=6)

# plot total solar irradiance

# Data obtained by different satellites since 1979.
#The Neural Network for Solar Irradiance Modeling (NN-SIM), reconstructs total solar irradiance and solar spectral irradiance from 205 nm to 2300 nm and from 1979 to the present day. The solar-irradiance model uses an ensemble of feed-forward artificial neural networks. 

#Citation:  Mauceri, S., Coddington, O., Lyles, D. et al. Neural Network for Solar Irradiance Modeling (NN-SIM). Sol Phys 294, 160 (2019). https://doi.org/10.1007/s11207-019-1555-y


sun <- read.csv(file="data/nn_sim_tsi.csv",header=T)

colnames(sun)<-c("Year","irradiance","unc")

p <- ggplot(data=sun,aes(x =Year , y = irradiance))  + geom_point (size=0.5)+  ylab(bquote(bold('Total solar irradiance ' ~(W/m^2) )))+
  scale_x_continuous(breaks=c(10957,14610,18262,21915,25567),labels=c("1980","1990","2000","2010","2020")) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        panel.border = element_rect(color = "black",fill = NA,size = 1))

ggsave(filename=paste0("plots_pdf/Solar_irradiance.pdf"),width=11,height=6)
ggsave(filename=paste0("plots_png/Solar_irradiance.png"),width=11,height=6)

