
load "$MJO_CODE/utils/load.ncl"

;------------------------------------------------------
; A NCL data-processing script by Xin XIE
; This script is used to generate the daily anomaly
; NC data for plotting.
; The daily climatology is removed.
;------------------------------------------------------

begin

OLRvarstr  = "OLR"
U200varstr = "U200"
U850varstr = "U850"

WORKDIR = getenv("WORKDIR")
TEST    = getenv("TEST")
YEARST  = getenv("MODELYEARST")
YEAREND = getenv("MODELYEAREND")

ifnprect = TEST+".OLR.anom.noanucyc.nc"
ifnu200  = TEST+".U200.anom.noanucyc.nc"
ifnu850  = TEST+".U850.anom.noanucyc.nc"
ifnprectbpf = TEST+".OLR.anom.noanucyc.bpf.nc"
ifnu200bpf  = TEST+".U200.anom.noanucyc.bpf.nc"
ifnu850bpf  = TEST+".U850.anom.noanucyc.bpf.nc"

ifileprect = addfile(WORKDIR+"/"+TEST+".raw.ext/"+ifnprect, "r")
ifileu200  = addfile(WORKDIR+"/"+TEST+".raw.ext/"+ifnu200 , "r")
ifileu850  = addfile(WORKDIR+"/"+TEST+".raw.ext/"+ifnu850 , "r")
ifileprectbpf = addfile(WORKDIR+"/"+TEST+".raw.ext/"+ifnprectbpf, "r")
ifileu200bpf  = addfile(WORKDIR+"/"+TEST+".raw.ext/"+ifnu200bpf , "r")
ifileu850bpf  = addfile(WORKDIR+"/"+TEST+".raw.ext/"+ifnu850bpf , "r")

;get time dimension info into yyyyddd from PRECT data file.
;but we assume that all the vars share the time dimension.
ymd   = ut_calendar(ifileprect->time,0)
year  = ymd(:,0)
ntim  = dimsizes(year)
yrstrt = year(0)
yrlast = year(ntim-1)
indtim = ind( (year .gt. yrstrt) .and. (year .lt. yrlast) )

print("read in all data...")
;read the data.
prectnm = OLRvarstr+"_anom"
u200nm  = U200varstr+"_anom"
u850nm  = U850varstr+"_anom"
prect = ifileprect->$prectnm$( time|indtim, lat|:, lon|:)
u200  = ifileu200->$u200nm$( time|indtim, lat|:, lon|:)
u850  = ifileu850->$u850nm$( time|indtim, lat|:, lon|:)

delete(ymd)
ymd   = ut_calendar(prect&time,0)
month = floattointeger( ymd(:,1) )

;get the index for both summer and winter.
isummer = ind( month.ge.5 .and. month.le.10)
iwinter = ind( (month.ge.1  .and. month.le.4) .or. \
               (month.ge.11 .and. month.le.12) )

prectbpfnm = OLRvarstr+"_anom_bpf"
u200bpfnm  = U200varstr+"_anom_bpf"
u850bpfnm  = U850varstr+"_anom_bpf"
prectBPF = ifileprectbpf->$prectbpfnm$
u200BPF  = ifileu200bpf->$u200bpfnm$
u850BPF  = ifileu850bpf->$u850bpfnm$

;deal with zero zonel wind in the pole.
if( (TEST .eq. "gamil2") ) then
  print("dealing with zero zonel wind in the pole in GAMIL...")
  nlatu200 = dimsizes(ifileu200->lat)
  u200(:, 0, :) = u200(:, 1, :)
  u200(:, nlatu200-1, :) = u200(:, nlatu200-2, :)
  nlatu850 = dimsizes(ifileu850->lat)
  u850(:, 0, :) = u850(:, 1, :)
  u850(:, nlatu850-1, :) = u850(:, nlatu850-2, :)
end if

;calculate the variance
;raw one
print("calculating the raw variance...")
prect_var_all    = dim_variance_Wrap( prect( lat|:, lon|:, time|:) )
prect_var_summer = dim_variance_Wrap( prect( lat|:, lon|:, time|isummer) )
prect_var_winter = dim_variance_Wrap( prect( lat|:, lon|:, time|iwinter) )
u200_var_all     = dim_variance_Wrap( u200( lat|:, lon|:, time|:) )
u200_var_summer  = dim_variance_Wrap( u200( lat|:, lon|:, time|isummer) )
u200_var_winter  = dim_variance_Wrap( u200( lat|:, lon|:, time|iwinter) )
u850_var_all     = dim_variance_Wrap( u850( lat|:, lon|:, time|:) )
u850_var_summer  = dim_variance_Wrap( u850( lat|:, lon|:, time|isummer) )
u850_var_winter  = dim_variance_Wrap( u850( lat|:, lon|:, time|iwinter) )

;bandpass one
print("calculating the bandpass-filtered variance...")
prectBPF_var_all    = dim_variance_Wrap( prectBPF( lat|:, lon|:, time|:) )
prectBPF_var_summer = dim_variance_Wrap( prectBPF( lat|:, lon|:, time|isummer) )
prectBPF_var_winter = dim_variance_Wrap( prectBPF( lat|:, lon|:, time|iwinter) )
u200BPF_var_all     = dim_variance_Wrap( u200BPF( lat|:, lon|:, time|:) )
u200BPF_var_summer  = dim_variance_Wrap( u200BPF( lat|:, lon|:, time|isummer) )
u200BPF_var_winter  = dim_variance_Wrap( u200BPF( lat|:, lon|:, time|iwinter) )
u850BPF_var_all     = dim_variance_Wrap( u850BPF( lat|:, lon|:, time|:) )
u850BPF_var_summer  = dim_variance_Wrap( u850BPF( lat|:, lon|:, time|isummer) )
u850BPF_var_winter  = dim_variance_Wrap( u850BPF( lat|:, lon|:, time|iwinter) )


print("calculating the variance percent...")
;for (bandpass one)/(raw one)
prect_varratio_all    = (prectBPF_var_all/prect_var_all)*100
prect_varratio_summer = (prectBPF_var_summer/prect_var_summer)*100
prect_varratio_winter = (prectBPF_var_winter/prect_var_winter)*100
u200_varratio_all     = (u200BPF_var_all/u200_var_all)*100
u200_varratio_summer  = (u200BPF_var_summer/u200_var_summer)*100
u200_varratio_winter  = (u200BPF_var_winter/u200_var_winter)*100
u850_varratio_all     = (u850BPF_var_all/u850_var_all)*100
u850_varratio_summer  = (u850BPF_var_summer/u850_var_summer)*100
u850_varratio_winter  = (u850BPF_var_winter/u850_var_winter)*100

copy_VarCoords( prect_var_all, prect_varratio_all)
copy_VarCoords( prect_var_all, prect_varratio_summer)
copy_VarCoords( prect_var_all, prect_varratio_winter)
copy_VarCoords( prect_var_all, u200_varratio_all)
copy_VarCoords( prect_var_all, u200_varratio_summer)
copy_VarCoords( prect_var_all, u200_varratio_winter)
copy_VarCoords( prect_var_all, u850_varratio_all)
copy_VarCoords( prect_var_all, u850_varratio_summer)
copy_VarCoords( prect_var_all, u850_varratio_winter)

;output
print("output the variance in "+WORKDIR+"/"+TEST+".raw.ext/"+TEST+".plot.var.nc...")
ifileout = addfile(WORKDIR+"/"+TEST+".raw.ext/"+TEST+".plot.var.nc", "c")
;ifileout->PRECT_var_all = prect_var_all
;ifileout->PRECT_var_summer = prect_var_summer
;ifileout->PRECT_var_winter = prect_var_winter

ifileout->OLR_var_all = prect_var_all
ifileout->OLR_var_summer = prect_var_summer
ifileout->OLR_var_winter = prect_var_winter

ifileout->U200_var_all = u200_var_all
ifileout->U200_var_summer = u200_var_summer
ifileout->U200_var_winter = u200_var_winter
ifileout->U850_var_all = u850_var_all
ifileout->U850_var_summer = u850_var_summer
ifileout->U850_var_winter = u850_var_winter

;ifileout->PRECTBPF_var_all = prectBPF_var_all
;ifileout->PRECTBPF_var_summer = prectBPF_var_summer
;ifileout->PRECTBPF_var_winter = prectBPF_var_winter

ifileout->OLRBPF_var_all = prectBPF_var_all
ifileout->OLRBPF_var_summer = prectBPF_var_summer
ifileout->OLRBPF_var_winter = prectBPF_var_winter

ifileout->U200BPF_var_all = u200BPF_var_all
ifileout->U200BPF_var_summer = u200BPF_var_summer
ifileout->U200BPF_var_winter = u200BPF_var_winter
ifileout->U850BPF_var_all = u850BPF_var_all
ifileout->U850BPF_var_summer = u850BPF_var_summer
ifileout->U850BPF_var_winter = u850BPF_var_winter

;ifileout->PRECT_varratio_all = prect_varratio_all
;ifileout->PRECT_varratio_summer = prect_varratio_summer
;ifileout->PRECT_varratio_winter = prect_varratio_winter

ifileout->OLR_varratio_all = prect_varratio_all
ifileout->OLR_varratio_summer = prect_varratio_summer
ifileout->OLR_varratio_winter = prect_varratio_winter

ifileout->U200_varratio_all = u200_varratio_all
ifileout->U200_varratio_summer = u200_varratio_summer
ifileout->U200_varratio_winter = u200_varratio_winter
ifileout->U850_varratio_all = u850_varratio_all
ifileout->U850_varratio_summer = u850_varratio_summer
ifileout->U850_varratio_winter = u850_varratio_winter

end

