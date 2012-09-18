
load "$MJO_CODE/utils/load.ncl"

begin

boolreverse = True

TARGETDIR=getenv("TARGETDIR")
PLOTDIR=getenv("PLOTDIR")
TEST=getenv("TEST")
OBS=getenv("OBS")

;varstrs = (/"OLR", "U850", "U200"/)
var = "Q"

;read in the MEOF data.
infx   = addfile(TARGETDIR+"/"+TEST+"."+var+".anom.noanucyc.bpf.nc" , "r")
infmjo = addfile(TARGETDIR+"/"+TEST+".plot.meofts-obs.nc" , "r")

xnm = var+"_anom_bpf"
x   = dim_avg_Wrap( infx->$xnm$(time|:, lev|:, lon|:, lat|: ) )
time     = ut_calendar( x&time,  0)
yyyymmdd = ut_calendar( x&time, -2)
yrfrac   = yyyymmdd_to_yyyyfrac(yyyymmdd, 0.0)
year = time(:, 0)
mon  = time(:, 1)
day  = time(:, 2)
ntim = dimsizes(year)
yearstrt = year(0)
yearlast = year(ntim-1)


mjo_index = infmjo->mjo_index( {time|0:ntime-1} )
pc1 = infmjo->pc1(0:ntime-1)
pc2 = infmjo->pc2(0:ntime-1)


;deal with phase
nphase = 8
angbnd = new( (/2, nphase/), float )
angbnd(0,0:3) = fspan(180, 315, 4)
angbnd(1,0:3) = fspan(225, 360, 4)
angbnd(0,4:7) = fspan(  0, 135, 4)
angbnd(1,4:7) = fspan( 45, 180, 4)

r2d  = 180./(4.*atan(1.0))
ang  = atan2(pc2,pc1)*r2d  ; convert pc1, pc2 to a direction of 360
nn   = ind(ang.lt.0)
ang(nn) = ang(nn)+360


;plotting
conres = True
conres@gsnDraw  = False
conres@gsnFrame = False
conres@gsnSpreadColors = True

conres@mpFillOn             = False        ; turn off map fill
conres@mpMinLatF            = -30          ; zoom in on map
conres@mpMaxLatF            =  30
conres@mpCenterLonF         = 180.
conres@cnFillOn             = True         ; turn on color fill
conres@cnLinesOn            = True         ; True is default
conres@cnLineLabelsOn       = False        ; True is default

if ( var .eq. "OLR" ) then
  conres@cnLevelSelectionMode = "ExplicitLevels"
  conres@cnLevels          = (/ -20, -15, -10, -6, -4, -2, 0, 2, 4, 6, 10, 15, 20 /)
end if

conres@lbLabelBarOn         = False        ; turn off individual lb's
conres@gsnScalarContour     = True         ; contour 3rd array
conres@gsnMajorLatSpacing   = 15                                       
conres@gsnMajorLonSpacing   = 60                                       
conres@tmXBLabelFontHeightF = 0.01                                     
conres@tmYLLabelFontHeightF = 0.01                                     
conres@gsnContourNegLineDashPattern = 5

conres@vcMinDistanceF            = 0.01
conres@vcRefMagnitudeF           = 2.0
conres@vcRefLengthF              = 0.025
conres@vcRefAnnoOrthogonalPosF   = -1.0
conres@vcRefAnnoArrowLineColor   = "black"
conres@vcRefAnnoArrowUseVecColor = False

panelres = True
panelres@gsnMaximize = True                ; large format
panelres@txString    = "Multivariate EOF: 15S-15N: "+yearstrt+"-"+yearlast
panelres@txFontHeightF = 0.013
panelres@gsnPanelLabelBar = True

panelres@lbLabelAutoStride   = True
panelres@lbLabelFontHeightF  = 0.01
panelres@gsnPanelBottom      = 0.05
panelres@pmLabelBarWidthF    = 0.5 
panelres@pmLabelBarHeightF   = 0.05
panelres@gsnPanelFigureStringsFontHeightF = 0.0125

plot = new( nphase, graphic)
wks  = gsn_open_wks("pdf", PLOTDIR+"/"+TEST+".plot-comp")
MJO_CODE=getenv("MJO_CODE")
cmap = RGBtoCmap(MJO_CODE+"/utils/mjocm_18lev.rgb")
gsn_define_colormap( wks, cmap)


ndays  = new( nphase, integer)
plabel = "P"+ispan(1,nphase,1)+": "
 
do iseason = 1, 2
  if(iseason .eq. 1) then
    panelres@txString = yearstrt+"-"+yearlast+": May to Oct ("+TEST+")"
  else
    panelres@txString = yearstrt+"-"+yearlast+": Nov to Apr ("+TEST+")"
  end if
  do i = 0, nphase-1
    if (iseason .eq. 1) then
      nt = ind( ( mjo_index .gt. 1.0) .and. \
                ( (mon .ge. 5) .and. (mon .le. 10) ) .and. \
                ( (ang .ge. angbnd(0,i) ) .and. (ang .lt. angbnd(1,i)) ) )
    else
      nt = ind( ( mjo_index .gt. 1.0) .and. \
                ( (mon .ge. 11) .or. (mon .le. 4) ) .and. \
                ( (ang .ge. angbnd(0,i) ) .and. (ang .lt. angbnd(1,i)) ) )
    end if

    if ( .not. all(ismissing(nt)) ) then
      xavg = dim_avg_Wrap( x(lat|:, lon|:, time|nt) )
      uavg = dim_avg_Wrap( u(lat|:, lon|:, time|nt) )
      vavg = dim_avg_Wrap( v(lat|:, lon|:, time|nt) )
      ndays(i) = dimsizes(nt)
      conres@gsnRightString = "PHASE"+(i+1)+" ("+ndays(i)+" days)"
      conres@tmXBLabelsOn = False
      conres@tmXBOn = False
      if ( i .eq. (nphase-1) ) then
        conres@tmXBLabelsOn = True
        conres@tmXBOn = True
      end if
      plot(i) = gsn_csm_vector_scalar_map( wks, uavg, vavg, xavg, conres)
    else
      print("missing values!!!")
    end if
    delete(nt)
  end do

gsn_panel( wks, plot, (/nphase, 1/), panelres)

end do

end

