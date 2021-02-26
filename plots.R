
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


library("ggplot2")

# plot T anomaly last 170 years

ylabel="T anomaly in °C compared to 1961-1990"

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

p  




# Reconstruction of temperature anomaly during the Holocene, based on 73 globally distributed records.
#The 73 globally distributed temperature records used in our analysis are based on a variety
#of paleotemperature proxies and have sampling resolutions ranging from 20 to 500 years, 
#with a median resolution of 120 years

#This study includes 73 records derived from multiple paleoclimate archive sand temperature proxies(Fig. S1; Table S1):
#alkenone (n=31), planktonic foraminifera Mg/Ca (n=19), TEX86 (n=4), fossil chironomid transfer function (n=4), 
#fossil pollen modern analog technique (MAT) (n=4), ice-core stable isotopes (n=5), 
#other microfossil assemblages(MATand Transfer Function)(n=5), and Methylation index of Branched Tetraethers(MBT)(n=1)


# An important limitation of this data is thta it does not fully resolve variability at periods shorter than 2000 years,
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


# plot T anomaly from Marcott and HadCRUT at different times  
ylabel="T anomaly in °C compared to 1961-1990"

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

# Download: https://ourworldindata.org/co2-and-other-greenhouse-gas-emissions/co2-concentration-long-term.csv

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
  

p<- ggplot(data=subset(Merged_T_C,!is.na(mean)), aes(x=Year, y=mean))  + geom_line () + ylab("Atmospheric CO2 (ppm)") +
  scale_x_continuous(breaks=bre,limits=c(2021-i,2021)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        panel.border = element_rect(color = "black",fill = NA,size = 1))

ggsave(filename=paste0("plots_pdf/CO2_atmospheric_conc_last_",i,"_years.pdf"),width=11,height=6)
ggsave(filename=paste0("plots_png/CO2_atmospheric_conc_last_",i,"_years.png"),width=11,height=6)


}



#plot T and CO2 together 

library(gridExtra)
library(ggpubr)

ylabel="T anomaly in °C"

years=c(12000,5000,2000,1000,500)

for (i in years) {
  if (i == 12000){bre=c(-8000,-6000,-4000,-2000,0,2000)}else {bre=waiver()}
  
  p1<- ggplot(data=subset(Merged_T_C,!is.na(mean)), aes(x=Year, y=mean))  + geom_line () + ylab("Atmospheric CO2 (ppm)") +
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


p1<- ggplot(data=subset(Merged_T_C,!is.na(mean)), aes(x=Year, y=mean))  + geom_line () + xlim(1850,2021) + ylab("Atmospheric CO2 (ppm)") +
  geom_hline(yintercept=0, linetype=3)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        panel.border = element_rect(color = "black",fill = NA,size = 1))

p<- ggplot(data=subset(Merged_T,!is.na(Median)),aes(x = Year, y = Median))  + geom_line (colour="red") + xlim(1850,2021) + ylab(ylabel) + xlab("")+
  geom_ribbon(data=subset(Merged_T,!is.na(Median)),aes(ymin=CI_low, ymax=CI_high), linetype=0, alpha=0.3,fill="red") +   
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

# Download: https://data.icos-cp.eu/licence_accept?ids=%5B%22xUUehljs1oTazlGlmigAhvfe%22%5D

emissions <- read.table("data/annual_emission.tsv",header=T)  # file with Territorial emissions (World)
emissions$emission <-((emissions$emission*3.664 )/1000)


p <- ggplot(data=emissions,aes(x = Year, y = emission))  + geom_line () + ylab("Gt CO2 per year") + xlab("Year")+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        panel.border = element_rect(color = "black",fill = NA,size = 1))
p


ggsave("plots_pdf/CO2_emissions.pdf",width=11,height=6)
ggsave("plots_png/CO2_emissions.png",width=11,height=6)



