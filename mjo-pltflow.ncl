
load "$MJO_CODE/utils/load.ncl"

begin

ifplot = True
ifnc   = False

WORKDIR = getenv("WORKDIR")
TEST    = getenv("TEST")
YEARST  = getenv("MODELYEARST")
YEAREND = getenv("MODELYEAREND")
MJO_CODE= getenv("MJO_CODE")

minlat = -10
maxlat =  10

plotyear = 1981

var = "U850"
varanom = var+"_anom"

ifn  = TEST+"."+var+".anom.noanucyc.bpf.nc"

ifile  = addfile(WORKDIR+"/"+TEST+".raw.ext/"+ifn, "r")

x = ifile->$varanom$

time = x&time
ymd_time  = ut_calendar(time, 0)
year_time = ymd_time(:, 0)
itime = ind( year_time .eq. plotyear)

;create a BandPass Filter for time
ihp   = 2       ; type of filter, here bandpass.
nwgt  = 201
sigma = 1.      ; power of the sigma factor.
fca   = 1./100. ; assign the pass lower bound.
fcb   = 1./20.  ; assign the pass upper bound.
wgt   = filwgts_lanczos(nwgt, ihp, fca, fcb, sigma)

x_merimean = dim_avg_Wrap( x( time|:, lon|:, {lat|-5:5}) )

print("computing bandpass filter...")
x_merimeanbpf = wgt_runave_leftdim( x_merimean, wgt, 0)

wks  = gsn_open_wks("ps", TEST+"_"+var+"_"+plotyear)
cmap = RGBtoCmap(MJO_CODE+"/utils/mjocm_18lev.rgb")
gsn_define_colormap( wks, "")

res = True

res@vpWidthF = 0.3

res@gsnLeftString = TEST
res@gsnCenterString = plotyear
res@gsnContourNegLineDashPattern = 5
res@gsnContourZeroLineThicknessF = 1.5

res@cnFillOn = True
res@cnLineThicknessF     = 0.5
res@cnLevelSelectionMode = "ManualLevels"
res@gsnSpreadColors      = True

if (var .eq. "OLR") then
  res@cnMinLevelValF  = -60.
  res@cnMaxLevelValF  = 60.
  res@cnLevelSpacingF = 15
; res@cnLevels = (/ -20, -15, -10, 5, 0, 5, 10, 15, 20 /)
end if
if (var .eq. "U850") then
  res@cnMinLevelValF  = -8.
  res@cnMaxLevelValF  = 8.
  res@cnLevelSpacingF = 1
; res@cnLevels = (/ -20, -15, -10, 5, 0, 5, 10, 15, 20 /)
end if

plot = gsn_csm_contour( wks, x_merimeanbpf( time|itime, lon|:), res)

end

