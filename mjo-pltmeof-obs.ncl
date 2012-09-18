
load "$MJO_CODE/utils/load.ncl"

begin

boolreverse = True

TARGETDIR=getenv("TARGETDIR")
PLOTDIR=getenv("PLOTDIR")
TEST=getenv("TEST")
OBS=getenv("OBS")
OBSDIR=getenv("OBSDIR")

varstrs = (/"OLR", "U850", "U200"/)

latn =  15
lats = -15

;read in the MEOF data.
infeof = addfile(OBSDIR+"/"+OBS+".plot.meof.nc", "r")
eof_cdata = infeof->eof_cdata
delete(eof_cdata@long_name)
lon = eof_cdata&lon

strtyr = 1981
lastyr = 1983
infts  = addfile(TARGETDIR+"/"+TEST+".plot.meofts-obs.nc" , "r")

time     = ut_calendar( infts->time,  0)
yyyymmdd = ut_calendar( infts->time, -2)
yrfrac   = yyyymmdd_to_yyyyfrac(yyyymmdd, 0.0)
year = time(:,0)
ntim = dimsizes(year)
timeind  = ind( (year .le. lastyr) .and. (year .ge. strtyr) )

yearstrt = strtyr
yearlast = lastyr

eof_ts_cdata = infts->eof_ts_cdata(:, timeind)
mjo_index    = infts->mjo_index(timeind)
pc1 = infts->pc1(timeind)
pc2 = infts->pc2(timeind)
ccr_12 = infts->ccr_12
 
neof = 2
;plotting
eofres = True
eofres@gsnDraw  = False
eofres@gsnFrame = False
eofres@xyLineThicknessF = 5
eofres@xyLineColors = (/"black", "red", "green"/)
eofres@gsnYRefLine  = 0.

eofres@vpHeightF = 0.40  ; Changes the aspect ratio
eofres@vpWidthF  = 0.85
eofres@vpXF      = 0.10  ; change start locations
eofres@vpYF      = 0.75  ; the plot

eofres@pmLegendDisplayMode    = "Always"            ; turn on legend
eofres@pmLegendSide           = "Top"               ; Change location of 
eofres@pmLegendParallelPosF   = 0.92                ; move units right
eofres@pmLegendOrthogonalPosF = -0.4                ; move units down
eofres@pmLegendWidthF         = 0.1                 ; Change width and
eofres@pmLegendHeightF        = 0.1                 ; height of legend.
eofres@lgLabelFontHeightF     = 0.015
eofres@trYMaxF = 0.14
eofres@trYMinF =-0.14


eofres@xyExplicitLegendLabels = (/"OLR", "U850", "U200" /)

plot = new( neof+1, graphic)
wks = gsn_open_wks("ps", PLOTDIR+"/"+TEST+"-plot-meof-obs")

do i = 0, neof-1
  eofres@gsnLeftString  = "EOF"+(i+1)
  eofres@gsnRightString = sprintf("%3.1f", eof_cdata@pcvar(i))  +"%"
  plot(i) = gsn_csm_xy( wks, lon, eof_cdata(i, :, :), eofres)
end do

panelres = True
panelres@gsnMaximize = True                ; large format
panelres@txString    = "Multivariate EOF: 15S-15N: ("+OBS+")"
panelres@txFontHeightF = 0.012

eofres@gsnLeftString  = "EOF time series ("+TEST+")"
eofres@gsnRightString = "From "+(yearstrt)+" to "+(yearlast)
eofres@xyExplicitLegendLabels = (/"PC1", "PC2", "PC3" /)
eofres@xyLineColors = (/"black", "black", "black"/)
eofres@trYMaxF = 30
eofres@trYMinF =-30
eofres@xyLineThicknessF = 3
;setviewratio(eofres, 3,False)
delete(eof_ts_cdata@long_name)


plot(neof)   = gsn_csm_xy(wks, yrfrac(timeind), eof_ts_cdata(0:neof-1, :), eofres)

gsn_panel( wks, plot(0:neof), (/neof+1,1/), panelres)

end

