import os

import numpy as np
import matplotlib.pyplot as plt

#_Style_________________________________________________________________________
# These settings affect the layout of all plots.
# Use your favourite stylesheet (see 
# https://matplotlib.org/stable/gallery/style_sheets/style_sheets_reference.html
# for a reference of built-in styles, or create and use your own stylesheet)
style = '2minutes4future.mplstyle'
# Special case for Cartoonish XKCD style
if style == 'xkcd' :
    plt.xkcd()
else :
    plt.style.use(style)

# Plot elements
interval_kwargs = dict(alpha=0.5)
indicator_kwargs = dict(dashes=(3, 3), color='k')
# Whether to give the reference to the data directly in the title ('title'), 
# inside the plot ('plot') or not at all ('none')
give_reference = 'title'
# If `give_reference == 'plot'`, define the loacation of the reference text 
# in axis units (from 0 to 1) and the arguments for the font.
ref_x, ref_y = 0.9, 0.1
ref_kwargs = dict(fontsize=12, horizontalalignment='right')

#_Global_prameters______________________________________________________________
# These parameters are used by several or all plots.
# Check the different sections for parameters unique to each plot.

# Store figures as 'pdf', 'png' or just show the figures ('show')
save_figures = 'pdf'

datapath = './data/'
year_label = 'year relative to year 1 CE'

#_Utility functions_____________________________________________________________

def plot_line(x, y, xlabel=None, ylabel=None, title='', ref='', num=None, 
              **kwargs) :
    """ Create a new figure with a single axes and plot x vs. y. """
    # Create figure and axes
    fig = plt.figure(num=num)
    ax = fig.add_subplot(111)
    # Plot the data
    ax.plot(x, y, **kwargs)
    # Add title and labels
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    if give_reference == 'title' and ref != '' :
        title += ' (' + ref + ')'
    ax.set_title(title)
    # Write reference into plot, if specified
    if give_reference == 'plot' :
        ax.text(ref_x, ref_y, ref, transfrom=ax.transAxes, **ref_kwargs)
    return fig, ax

def indexof(value, array) :
    """ Return the closest index of *value* in a monotonically in- or 
    decreasing *array*. 
    """
    return np.argmin(np.abs(array-value))

figs = []

#_Global_temperature_anomaly_over_the_last_170_years____________________________

# HadCRUT4 is a gridded dataset of global historical surface temperature 
# anomalies relative to a 1961-1990 reference period. Data are available for 
# each month since January 1850, on a 5 degree grid.  
# More information here: 
# https://www.metoffice.gov.uk/hadobs/hadcrut4/
#
# Citation: Morice, C. P., Kennedy, J. J., Rayner, N. A., and Jones, P. D. 
# (2012), Quantifying uncertainties in global and regional temperature change 
# using an ensemble of observational estimates: The HadCRUT4 data set, J. 
# Geophys. Res., 117, D08101, doi:10.1029/2011JD017187. 
#
#
# Download data yearly global: 
# https://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/time_series/HadCRUT.4.6.0.0.annual_ns_avg.txt
#
# Column 1 is the date.
# Column 2 is the median of the 100 ensemble member time series.
# Columns 3 and 4 are the lower and upper bounds of the 95% confidence 
# interval of bias uncertainty computed from the 100 member ensemble.
# Columns 5 and 6 are the lower and upper bounds of the 95% confidence 
# interval of measurement and sampling uncertainties around the ensemble 
# median. These are the combination of fully uncorrelated measurement and 
# sampling uncertainties and partially correlated uncertainties described by 
# the HadCRUT4 error covariance matrices.
# Columns 7 and 8 are the lower and upper bounds of the 95% confidence 
# interval of coverage uncertainties around the ensemble median.
# Columns 9 and 10 are the lower and upper bounds of the 95% confidence 
# interval of the combination of measurement and sampling and bias 
# uncertainties.
# Columns 11 and 12 are the lower and upper bounds of the 95% confidence 
# interval of the combined effects of all the uncertainties described in the 
# HadCRUT4 error model (measurement and sampling, bias and coverage 
# uncertainties).

## t140 parameters
HadCRUT4_filename = 'HadCRUT.4.6.0.0.annual_ns_avg.txt'
title_t170 = 'Global temperature anomaly'
ylabel_t170 = 'Temperature deviation from average during 1961-1990 ($^\circ$C)'
ref_t170 = 'Morice et al, 2012'
figname_t170 = 'T_anomaly_last_170_years'

## t170 processing
# Load the datafile and unpack the columns
HadCRUT4 = np.loadtxt(datapath + HadCRUT4_filename)
years_t170 = HadCRUT4[:,0]
median_t170 = HadCRUT4[:,1]
CI_lower_t170 = HadCRUT4[:,-2] 
CI_upper_t170 = HadCRUT4[:,-1]

## t170 plotting
fig_t170, ax_t170 = plot_line(years_t170, median_t170, year_label, 
                              ylabel_t170, title=title_t170, ref=ref_t170, 
                              num=figname_t170)
ax_t170.fill_between(years_t170, CI_lower_t170, CI_upper_t170, 
                     **interval_kwargs)
# Add a line indicating 0
ax_t170.axhline(0, **indicator_kwargs)

figs.append((figname_t170, fig_t170))

#_Global_T_anomaly_reconstructed________________________________________________

# Reconstruction of temperature anomaly during the Holocene, based on 73 
# globally distributed records.
# The 73 globally distributed temperature records used in our analysis are 
# based on a variety of paleotemperature proxies and have sampling 
# resolutions ranging from 20 to 500 years, with a median resolution of 120 
# years
#
# This study includes 73 records derived from multiple paleoclimate archive 
# sand temperature proxies(Fig. S1; Table S1):
# alkenone (n=31), planktonic foraminifera Mg/Ca (n=19), TEX86 (n=4), fossil 
# chironomid transfer function (n=4), fossil pollen modern analog technique 
# (MAT) (n=4), ice-core stable isotopes (n=5), other microfossil 
# assemblages(MATand Transfer Function)(n=5), and Methylation index of 
# Branched Tetraethers(MBT)(n=1)
#
# An important limitation of this data is that it does not fully resolve 
# variability at periods shorter than 2000 years, with essentially no 
# variability preserved at periods shorter than 300 years, ~50% preserved at 
# 1000-year periods, and nearly all of the variability preserved for periods 
# longer than 2000 years.
#
# Citation: A Reconstruction of Regional and Global Temperature for the Past 
# 11,300 Years Shaun A. Marcott et al. Science 339 , 1198 (2013); DOI: 
# 10.1126/science.1228026

# Download data from supplementary table S1: 
# https://science.sciencemag.org/highwire/filestream/594506/field_highwire_adjunct_files/1/Marcott.SM.database.S1.xlsx

## Parameters Marcott
marcott_filename = 'Marcott_2013_data.tsv'
n_exclude = 6
ylabel_marcott = r'Global temperature anomaly ($^\circ$C)'
title_marcott = 'Reconstructed temperature anomaly'
ref_marcott = 'Marcott et al, 2013'
# Data is shown only from the year specified in *year_t*
year_t = [1850, 1500, 1000, 0, -10000][3]
delta_t = 2020 - year_t
figname_marcott = f'T_anomaly_Marcott_last_{delta_t}_years'

## Marcott processing
# Load the datafile and unpack the columns, excluding the most recent 
# *n_exclude* rows, as they are not robust according to the authors.
marcott = np.loadtxt(datapath + marcott_filename, skiprows=1)
years_marcott, T_marcott, sigma_marcott = [col[n_exclude:] for col in marcott.T]
# years are measured from 1950, shift them to 0 CE
years_marcott = 1950 - years_marcott
# Extract requested region
i_marcott = indexof(year_t, years_marcott)
years_marcott = years_marcott[:i_marcott]
T_marcott = T_marcott[:i_marcott]
sigma_marcott = sigma_marcott[:i_marcott]
# Get 95% confidence interval
lower_marcott, upper_marcott = [T_marcott + s*0.5*sigma_marcott for s in [-1, 1]]


## Marcott Plotting
fig_marcott, ax_marcott = plot_line(years_marcott, T_marcott, year_label, 
                                    ylabel_marcott, title=title_marcott, 
                                    ref=ref_marcott, num=figname_marcott)
ax_marcott.fill_between(years_marcott, lower_marcott, upper_marcott, 
                        **interval_kwargs)

# Add the data from Morice et al. for the past 140 years
ax_marcott.plot(years_t170, median_t170)

figs.append((figname_marcott, fig_marcott))

#_CO2_atmospheric_concentration_________________________________________________

# Data from 1959 from NOOA: Data from 1959 through 1979 have been obtained by 
# C. David Keeling of the Scripps Institution of Oceanography (SIO) and were 
# obtained from the Scripps website (scrippsco2.ucsd.edu).
# Data from 1980 onwards is sourced from NOAA's Mauna Loa monitoring station
# Download: 
# https://www.esrl.noaa.gov/gmd/webdata/ccgg/trends/co2/co2_annmean_mlo.txt
# 
# Very long-term data were compiled by Our world in data: data from ice cores 
# – specifically the Dome C core – has been made available from the NOAA 
# here: https://www.ncdc.noaa.gov/paleo-search/study/17975. 
# In this original dataset, some years had multiple measurements (taken at 
# different points of the year). 
# To normalize this to a single year, where several measurements were 
# available, we took the average of these concentration values. Dome C data 
# has been used until the year 1958.
#
# Citation: Bereiter, B., Eggleston, S., Schmitt, J., Nehrbass‐Ahles, C., 
# Stocker, T. F., Fischer, H., ... & Chappellaz, J. (2015). Revision of the 
# EPICA Dome C CO2 record from 800 to 600 kyr before present. Geophysical 
# Research Letters, 42(2), 542-549.
#
# Download: https://ourworldindata.org/co2-and-other-greenhouse-gas-emissions
#
# The recent and old data use a differnt CO2 scale, conversion can be done 
# with following formula:  
# X2019 = 1.00079 * X2007 - 0.142 
# (https://www.esrl.noaa.gov/gmd/ccl/scale_conversion.html), 
# The conversion is recommended only between 250 and 520 ppm but does not 
# have a large impact on the overall picture anyways.

## CO2 parameters
co2_recent_filename = 'co2_annmean_mlo.txt'
co2_old_filename = 'co2-concentration-long-term.csv'
co2_title = r'Reconstruction of CO$_2$ concentration'
co2_ylabel = r'Atmospheric CO$_2$ concentration (ppm)'
co2_ref = 'Bereiter et al, 2015'
# From which year on should the data be plotted
year_co2 = [1900, 1500, 1000, -12000, -810000][3]
delta_t_co2 = 2020 - year_co2
figname_co2 = f'CO2_atmospheric_concentration_last_{delta_t_co2}_years'

## CO2 processing
data_recent = np.loadtxt(datapath + co2_recent_filename)
years_recent = data_recent[:,0]
co2_recent = data_recent[:,1]
data_old = np.loadtxt(datapath + co2_old_filename, delimiter=',', skiprows=1)
years_old = data_old[:,0]
co2_old = data_old[:,1]

# Extract requested region
i_co2 = indexof(year_co2, years_old)
years_old = years_old[i_co2:]
co2_old = co2_old[i_co2:]

## CO2 Plotting
fig_co2, ax_co2 = plot_line(years_recent, co2_recent, xlabel=year_label, 
                            ylabel=co2_ylabel, title=co2_title, ref=co2_ref, 
                            num=figname_co2, color='k')
ax_co2.plot(years_old, co2_old, color='k')

figs.append((figname_co2, fig_co2))

#_Show/save_plots_______________________________________________________________

if save_figures == 'show' :
    plt.show()
elif save_figures in ['pdf', 'png'] :
    for figname,fig in figs :
        stylename = os.path.splitext(style)[0]
        savedir = os.path.join(f'plots_{save_figures}', f'{stylename}')
        # Create savepath if it does not exist
        if not os.path.exists(savedir) :
            os.makedirs(savedir)
        filename = os.path.join(savedir, f'{figname}.{save_figures}')
        fig.savefig(filename)

