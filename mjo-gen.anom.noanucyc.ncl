
load "$MJO_CODE/utils/load.ncl"

;------------------------------------------------------
; A NCL data-processing script by Xin XIE
; This script is used to generate the daily anomaly
; NC data for plotting.
; The daily climatology is removed.
;------------------------------------------------------

begin

ifplot = True
ifnc   = False

WORKDIR = getenv("WORKDIR")
TEST    = getenv("TEST")
YEARST  = getenv("MODELYEARST")
YEAREND = getenv("MODELYEAREND")

ifn = TEST+"."+var+".nc"
ofn = TEST+"."+var+".anom.noanucyc.nc"

ifile = addfile(WORKDIR+"/"+TEST+".raw.ext/"+ifn, "r")

;getting time info into yyyyddd
ymd  = ut_calendar(ifile->time,0)
year  = floattointeger( ymd(:,0) )
month = floattointeger( ymd(:,1) )
day   = floattointeger( ymd(:,2) )
ddd   = day_of_year(year, month, day)
yyyyddd = year*1000 + ddd


if ( var .eq. "Q" ) then
  x = ifile->$var$(time|:, lev|:, {lat|-10:10}, lon|:)
  print("computing climatlogy...")
  printVarSummary(x)
  xclmday = clmDayTLLL( x, yyyyddd(:) )
  print("computing anomaly...")
  xanom   = calcDayAnomTLLL( x(time|0:3000, lev|:, {lat|-10:10}, lon|:), yyyyddd(0:3000), xclmday)
else
  x = ifile->$var$
  print("computing climatlogy...")
  xclmday    = clmDayTLL( x, yyyyddd)
  xclmday_sm = smthClmDayTLL( xclmday, 4)
  print("computing anomaly...")
  xanom      = calcDayAnomTLL( x, yyyyddd, xclmday)
  xanom_sm   = calcDayAnomTLL( x, yyyyddd, xclmday_sm)
end if

var_anom    = var+"_anom"
var_anom_sm = var+"_anom_sm"
ofile = addfile(WORKDIR+"/"+TEST+".raw.ext/"+ofn, "crw") 

if ( var .eq. "Q") then
ofile->$var_anom$    = xanom
else
ofile->$var_anom$    = xanom
ofile->$var_anom_sm$ = xanom_sm
end if

end

