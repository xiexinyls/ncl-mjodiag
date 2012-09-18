
load "$MJO_CODE/utils/load.ncl"

;------------------------------------------------------
; A NCL data-processing script by Xin XIE
; This script is used to plot the wave-num spectra plots.
; NCL MJO functions are used.
;------------------------------------------------------

begin

TARGETDIR=getenv("TARGETDIR")
PLOTDIR=getenv("PLOTDIR")
TEST=getenv("TEST")

infile = addfile(TARGETDIR+"/"+TEST+"."+var+".anom.noanucyc.nc", "r")

latn = 10
lats = -10

varname = var+"_anom"
indata = infile->$varname$

date = ut_calendar(infile->time, -2)

x = dim_avg_Wrap( indata(time|:, lon|:, {lat|lats:latn}) )

optwavefreq   = False
optplot       = True
optplot@smth9 = False
optplot@debug = True
optplot@cnLevelSelectionMode = "ExplicitLevels"

if ( var .eq. "OLR" ) then
  optplot@cnLevels = (/ 0.2, 0.3, 0.4, 0.6, 0.8, 1.0, 1.4, 1.8, 2.4  /)
end if
if ( var .eq. "PRECT" ) then
  optplot@cnLevels = (/0.006, 0.01, 0.016, 0.024, 0.03, 0.036, 0.042, 0.05/)
end if
if ( var .eq. "U200" ) then
  optplot@cnLevels = (/ 0.04, 0.08, 0.1, 0.12, 0.18, 0.24, 0.3, 0.5/)
end if
if ( var .eq. "U850" ) then
  optplot@cnLevels = (/ 0.006, 0.01, 0.026, 0.032, 0.042, 0.056, 0.072/)
end if

nameseason = (/ "summer", "winter" /)
ns = dimsizes(nameseason)

do is = 0, ns-1
  wavefreq = mjo_wavenum_freq_season( x, date, nameseason(is), optwavefreq)
  optplot@tiMainString = var+" wavenumber-frequency spectra ("+TEST+")~C~"+nameseason(is)
  optplot@gsnLeftString = ""
  mjo_wavenum_freq_season_plot( wavefreq, nameseason(is), PLOTDIR, "pdf", TEST+"-wavefreq-"+var, optplot)
  delete(wavefreq)
end do

end

