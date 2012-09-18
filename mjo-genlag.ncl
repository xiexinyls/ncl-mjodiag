
load "$MJO_CODE/utils/load.ncl"

;------------------------------------------------------
; A NCL data-processing script by Xin XIE
; This script is used to generate NC data
; for diagnosing the MJO propogating features.
; NCL MJO ploting function is used.
;------------------------------------------------------

begin

TARGETDIR=getenv("TARGETDIR")
PLOTDIR=getenv("PLOTDIR")
TEST=getenv("TEST")

;select a key-area regin for lag-correlation.
nameregion = "IO"
latS_ka = -10.
latN_ka =   5.
lonL_ka =  75.
lonR_ka = 100.
;select a lat or lon averaged band
;to see the northward or eastward propagation.
latn =  10.
lats = -10.
lonl =  80.
lonr = 100.

pltlatn = 40.
pltlats = -40.

uvar = "U850"


ifprect = addfile(TARGETDIR+"/"+TEST+".OLR.anom.noanucyc.nc", "r")
ifu  = addfile(TARGETDIR+"/"+TEST+"."+uvar+".anom.noanucyc.nc", "r")

;make sure time series matched
time_prect = ifprect->time
date_prect = ut_calendar(time_prect, -2)
ymd_prect  = ut_calendar(time_prect, 0)
month_prect= floattointeger( ymd_prect(:,1) )
time_u     = ifu->time
date_u     = ut_calendar(time_u, -2)
ymd_u      = ut_calendar(time_u, 0)
month_u    = floattointeger( ymd_u(:,1) )
if ( .not. all(date_prect .eq. date_u) ) then
  print("date mismatch! exiting...")
  exit
end if

isummer = ind( month_prect.ge.5 .and. month_prect.le.10)
iwinter = ind( (month_prect.ge.1  .and. month_prect.le.4) .or. \
               (month_prect.ge.11 .and. month_prect.le.12) ) 

;read in data.
name_varu = uvar+"_anom"
varprect = ifprect->OLR_anom
varu     = ifu->$name_varu$



;create a BandPass Filter for time
ihp   = 2       ; type of filter, here bandpass.
nwgt  = 201
sigma = 1.      ; power of the sigma factor.
fca   = 1./100. ; assign the pass lower bound.
fcb   = 1./20.  ; assign the pass upper bound.
wgt   = filwgts_lanczos(nwgt, ihp, fca, fcb, sigma)

;create a area-averaged Filter
wgtprect = ifprect->lat( {latS_ka:latN_ka} )
wgtprect = cos( 0.017459*wgtprect )
wgtu     = ifu->lat( {latS_ka:latN_ka} )
wgtu     = cos( 0.017459*wgtu )



print("computing the area average for the key area...")
;do a area weighted average for the key area.
p_keyarea  = wgt_areaave_Wrap( varprect( :, {latS_ka:latN_ka}, {lonL_ka:lonR_ka} ), wgtprect, 1., 0)
;do a time bandpass filterring for the key area.
pf_keyarea = wgt_runave_Wrap( p_keyarea, wgt, 0)

print("computing the meridinal mean...")
;get the zonal mean for both p and u.
p_timelon  = dim_avg_Wrap( varprect( time|:, lon|:, {lat|lats:latn}) )
u_timelon  = dim_avg_Wrap(     varu( time|:, lon|:, {lat|lats:latn}) )
;get the bandpass filtered zonel mean for both p and u.
p_timelonbpf  = wgt_runave_leftdim( p_timelon, wgt, 0)
u_timelonbpf  = wgt_runave_leftdim( u_timelon, wgt, 0)

print("computing the zonal mean...")
;get the meridonal mean for both p and u.
p_timelat  = dim_avg_Wrap( varprect( time|:, {lat|pltlats:pltlatn}, {lon|lonl:lonr}) )
u_timelat  = dim_avg_Wrap(     varu( time|:, {lat|pltlats:pltlatn}, {lon|lonl:lonr}) )
;get the bandpass filtered zonel mean for both p and u.
p_timelatbpf  = wgt_runave_leftdim( p_timelat, wgt, 0)
u_timelatbpf  = wgt_runave_leftdim( u_timelat, wgt, 0)


optxcor = False
mxlag   = 25

;for all season
print("computing for bandpass-filtered cross-correlation in laglon(all season)...")
ccr_p_laglonbpf = mjo_xcor_lag_season( pf_keyarea, p_timelonbpf, mxlag, optxcor)
ccr_u_laglonbpf = mjo_xcor_lag_season( pf_keyarea, u_timelonbpf, mxlag, optxcor)
print("computing for bandpass-filtered cross-correlation in laglat(all season)...")
ccr_p_laglatbpf = mjo_xcor_lag_season( pf_keyarea, p_timelatbpf, mxlag, optxcor)
ccr_u_laglatbpf = mjo_xcor_lag_season( pf_keyarea, u_timelatbpf, mxlag, optxcor)

;for summer
print("computing for bandpass-filtered cross-correlation in laglon(summer)...")
ccr_p_laglonbpf_summer = mjo_xcor_lag_season( pf_keyarea(isummer), p_timelonbpf(isummer,:), mxlag, optxcor)
ccr_u_laglonbpf_summer = mjo_xcor_lag_season( pf_keyarea(isummer), u_timelonbpf(isummer,:), mxlag, optxcor)
print("computing for bandpass-filtered cross-correlation in laglat(summer)...")
ccr_p_laglatbpf_summer = mjo_xcor_lag_season( pf_keyarea(isummer), p_timelatbpf(isummer,:), mxlag, optxcor)
ccr_u_laglatbpf_summer = mjo_xcor_lag_season( pf_keyarea(isummer), u_timelatbpf(isummer,:), mxlag, optxcor)

;for winter
print("computing for bandpass-filtered cross-correlation in laglon(winter)...")
ccr_p_laglonbpf_winter = mjo_xcor_lag_season( pf_keyarea(iwinter), p_timelonbpf(iwinter,:), mxlag, optxcor)
ccr_u_laglonbpf_winter = mjo_xcor_lag_season( pf_keyarea(iwinter), u_timelonbpf(iwinter,:), mxlag, optxcor)
print("computing for bandpass-filtered cross-correlation in laglat(winter)...")
ccr_p_laglatbpf_winter = mjo_xcor_lag_season( pf_keyarea(iwinter), p_timelatbpf(iwinter,:), mxlag, optxcor)
ccr_u_laglatbpf_winter = mjo_xcor_lag_season( pf_keyarea(iwinter), u_timelatbpf(iwinter,:), mxlag, optxcor)

print("output ccr results in "+TARGETDIR+"/"+TEST+".plot.lag.nc"+"...")
of = addfile(TARGETDIR+"/"+TEST+".plot.lag.nc", "c")
of->ccr_p_laglonbpf_allseason = ccr_p_laglonbpf
of->ccr_u_laglonbpf_allseason = ccr_u_laglonbpf
of->ccr_p_laglatbpf_allseason = ccr_p_laglatbpf
of->ccr_u_laglatbpf_allseason = ccr_u_laglatbpf
of->ccr_p_laglonbpf_summer = ccr_p_laglonbpf_summer
of->ccr_u_laglonbpf_summer = ccr_u_laglonbpf_summer
of->ccr_p_laglatbpf_summer = ccr_p_laglatbpf_summer
of->ccr_u_laglatbpf_summer = ccr_u_laglatbpf_summer
of->ccr_p_laglonbpf_winter = ccr_p_laglonbpf_winter
of->ccr_u_laglonbpf_winter = ccr_u_laglonbpf_winter
of->ccr_p_laglatbpf_winter = ccr_p_laglatbpf_winter
of->ccr_u_laglatbpf_winter = ccr_u_laglatbpf_winter
of@nameregion = nameregion

end

