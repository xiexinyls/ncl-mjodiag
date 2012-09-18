
load "$MJO_CODE/utils/load.ncl"

begin

boolreverse = True

TARGETDIR=getenv("TARGETDIR")
PLOTDIR=getenv("PLOTDIR")
TEST=getenv("TEST")
OBS=getenv("OBS")
OBSDIR=getenv("OBSDIR")

latn =  15
lats = -15

;read in the MEOF data.

infccr  = addfile(TARGETDIR+"/"+TEST+".plot.meofts-obs.nc" , "r")

ccr_12 = infccr->ccr_12

mxlag = 25
lag = ispan( -mxlag, mxlag, 1)
lag@long_name = "lag(days)"
 
;plotting
res = True
res@xyLineThicknessF = 8
res@gsnYRefLine  = 0.

;res@vpHeightF = 0.40  ; Changes the aspect ratio
;res@vpWidthF  = 0.85
;res@vpXF      = 0.10  ; change start locations
;res@vpYF      = 0.75  ; the plot

;eofres@pmLegendDisplayMode    = "Always"            ; turn on legend
;eofres@pmLegendSide           = "Top"               ; Change location of 
;eofres@pmLegendParallelPosF   = 0.92                ; move units right
;eofres@pmLegendOrthogonalPosF = -0.4                ; move units down
;eofres@pmLegendWidthF         = 0.1                 ; Change width and
;eofres@pmLegendHeightF        = 0.1                 ; height of legend.
;eofres@lgLabelFontHeightF     = 0.015
res@trYMaxF =  1
res@trYMinF = -1

wks = gsn_open_wks("ps", PLOTDIR+"/"+TEST+"-plot-meof-ccr")

res@gsnLeftString  = "Cross Correlation of PC1 and PC2 ("+TEST+")"
;res@gsnRightString = "From "+(yearstrt)+" to "+(yearlast)
;setviewratio(eofres, 3,False)

plot = gsn_csm_xy(wks, lag, ccr_12, res)


end

