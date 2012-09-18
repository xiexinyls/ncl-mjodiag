
load "$MJO_CODE/utils/load.ncl"

;------------------------------------------------------
; A NCL data-processing script by Xin XIE
; This script is used to plot the variablility and its ratio
; of major MJO variables
;------------------------------------------------------

begin

TARGETDIR=getenv("TARGETDIR")
PLOTDIR=getenv("PLOTDIR")
TEST=getenv("TEST")

ifile = addfile(TARGETDIR+"/"+TEST+".plot.var.nc", "r")

wks = gsn_open_wks("pdf", PLOTDIR+"/"+TEST+"-var")
MJO_CODE=getenv("MJO_CODE")
cmap = RGBtoCmap(MJO_CODE+"/utils/mjocm_p.rgb")
gsn_define_colormap( wks, cmap)



resv = True
resv@gsnDraw  = False
resv@gsnFrame = False
resv@gsnStringFontHeightF = 0.015
resv@cnFillOn = True
resv@cnLinesOn = False
resv@cnLevelSelectionMode = "ExplicitLevels"
resv@mpCenterLonF = 180.
resv@mpMinLatF = -30
resv@mpMaxLatF = 30
resv@mpMinLonF = 30
resv@mpMaxLonF = 330
resv@gsnMajorLatSpacing   = 15

resv@mpGeophysicalLineThicknessF = 0.5
resv@tmXBLabelFontHeightF = 0.012
resv@tmYLLabelFontHeightF = 0.012
resv@cnSmoothingOn = True
;lower the label bar a little.
resv@pmLabelBarOrthogonalPosF = 0.1
resv@pmLabelBarHeightF = 0.07

setviewratio(resv, 3, True)



resr = True
resr@gsnDraw  = False
resr@gsnFrame = False
resr@cnLevelSelectionMode = "ManualLevels"
resr@cnLineLabelFontHeightF = 0.008
;resr@cnLineLabelBackgroundColor = -1

resr@cnInfoLabelPerimOn = False
resr@cnInfoLabelFontHeightF = 0.008
resr@cnInfoLabelString = "Contour Plot: from $CMN$ by $CIU$"
resr@cnInfoLabelOrthogonalPosF = -0.05

resr@cnLevelSelectionMode = "ManualLevels"
resr@cnMinLevelValF = 10.
resr@cnLevelSpacingF = 5

resr@cnMonoLineThickness = False
;resr@cnLineThicknessF   = 2
resr@cnLineThicknesses = (/2, 1, 1, 1, 2/)
resr@cnLineLabelPlacementMode = "Computed"
resr@cnLineLabelFontHeightF = 0.006




vars    = (/"OLR", "U200", "U850"/)
seasons = (/"all", "summer", "winter"/)

nvars    = dimsizes(vars)
nseasons = dimsizes(seasons)

plot = new(6, "graphic")
do ivar = 0, nvars-1

  varname_all = vars(ivar)+"_var_all"
  varrationame_all = vars(ivar)+"_varratio_all"
  varname_summer = vars(ivar)+"_var_summer"
  varrationame_summer = vars(ivar)+"_varratio_summer"
  varname_winter = vars(ivar)+"_var_winter"
  varrationame_winter = vars(ivar)+"_varratio_winter"

  var_all = ifile->$varname_all$
  varratio_all = ifile->$varrationame_all$
  var_summer = ifile->$varname_summer$
  varratio_summer = ifile->$varrationame_summer$
  var_winter = ifile->$varname_winter$
  varratio_winter = ifile->$varrationame_winter$

if ( vars(ivar) .eq. "OLR") then
  resv@gsnRightString  = "variance unit:mm~S~2~N~/day~S~-2"
  resv@cnLevels = (/ 400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000 /)
end if

if ( vars(ivar) .eq. "PRECT") then
  resv@gsnRightString  = "variance unit:mm~S~2~N~/day~S~-2"
  resv@cnLevels = (/ 20, 40, 60, 80, 100, 120, 140, 160, 180, 300, 450 /)
end if
 
if ( vars(ivar) .eq. "U200") then
  resv@gsnRightString  = "m~S~2~N~/s~S~-2"
  resv@cnLevels = (/ 40, 60, 80, 100, 120, 140, 160, 180, 200 /)
end if

if ( vars(ivar) .eq. "U850") then
  resv@gsnRightString  = "m~S~2~N~/s~S~-2"
  resv@cnLevels = (/ 4, 8, 12, 16, 20, 24, 28, 32, 36 /)
end if
  
resv@gsnLeftString   = "variance of "+vars(ivar)+"(contour) and its bandpass variance ratio(shaded) ("+TEST+")~C~in all season ("+TEST+")"
plot(0) = gsn_csm_contour_map( wks, var_all, resv)
plot(1) = gsn_csm_contour( wks, varratio_all, resr)

resv@gsnLeftString   = "variance of "+vars(ivar)+"(contour) and its basspass variance ratio(shaded) ("+TEST+")~C~in summer"
plot(2) = gsn_csm_contour_map( wks, var_summer, resv)
plot(3) = gsn_csm_contour( wks, varratio_summer, resr)

resv@gsnLeftString   = "variance of "+vars(ivar)+"(contour) and its basspass variance ratio(shaded) ("+TEST+")~C~in winter"
plot(4) = gsn_csm_contour_map( wks, var_winter, resv)
plot(5) = gsn_csm_contour( wks, varratio_winter, resr)

overlay( plot(0), plot(1) )
overlay( plot(2), plot(3) )
overlay( plot(4), plot(5) )

panelres = True

gsn_panel( wks, (/ plot(0), plot(2), plot(4) /), (/3,1/), panelres)
delete(resv@cnLevels)

end do

end

