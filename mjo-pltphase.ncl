
load "$MJO_CODE/utils/load.ncl"

begin

boolmovie = True

TARGETDIR = getenv("TARGETDIR")
PLOTDIR   = getenv("PLOTDIR")

YRSTRT = getenv("MODELYEARST")
YRLAST = getenv("MODELYEAREND")
ymdstrt = "19810101"
ymdlast = "19811231"

TEST = getenv("TEST")
OBS  = getenv("OBS")

;varstrs = (/"OLR", "U850", "U200"/)
var = "OLR"

;read in the MEOF data.
;infmjo = addfile(TARGETDIR+"/"+TEST+".plot.meofts-obs.nc" , "r")
infmjo = addfile(TARGETDIR+"/"+TEST+".plot.meofts.nc" , "r")

ymd   = ut_calendar(infmjo->time, -2)
istrt = ind( ymd .eq. ymdstrt)
ilast = ind( ymd .eq. ymdlast)
print(istrt+"")
print(ilast+"")

mjo_index = infmjo->mjo_index(istrt:ilast)
pc1 = infmjo->eof_ts_cdata_std(0, istrt:ilast)
pc2 = infmjo->eof_ts_cdata_std(1, istrt:ilast)

time   = mjo_index&time
ymdhms = ut_calendar( time,  0)
ntim   = dimsizes(time)
mon = floattoint( ymdhms(:, 1) )
day = floattoint( ymdhms(:, 2) )

namMonth = (/ "Jan","Feb","Mar","Apr","May","June", "July","Aug","Sep","Oct","Nov","Dec" /)
colMonth = (/     2,    3,    5,    6,    7,     8,     10,   11,   12,   13,   18,   20 /)

wks = gsn_open_wks( "ps", PLOTDIR+"/"+TEST+"-plot-phase")
gsn_define_colormap(wks,"mjo_color")

xbegin = pc1(0)
ybegin = pc1(0)

nmon = 0
moninfo = new( (/12,2/), string)
moninfo(nmon,0) = namMonth( mon(0)-1 )
moninfo(nmon,1) = colMonth( mon(0)-1 )

label_opt   = 5
label_color = True

opt  = True
opt@gsnFrame = False
opt@gsnDraw  = False
opt@tiMainString = "MJO Phase: 15S-15N: "+ymdstrt+"-"+ymdlast+"("+TEST+")"

plLine = True
plLine@gsLineThicknessF = 2

txres = True
txres@txFontColor = "black"
txres@txFontHeightF = 0.01

plmark = True
plmark@gsMarkerIndex = 16
plmark@gsMarkerSizeF = 0.005
plmark@gsMarkerThicknessF = 2

plmark@gsMarkerColor = "black"
plmark@gsMarkerSizeF = 2.5*plmark@gsMarkerSizeF

plot = mjo_phase_background( wks, opt)
plot@$unique_string("dum")$ = gsn_add_polymarker(wks, plot, xbegin, ybegin, plmark)
plmark@gsMarkerSizeF = plmark@gsMarkerSizeF/2.5

if ( boolmovie .eq. True ) then
  draw(plot)
  frame(wks)
end if


do i = 1, ntim-1

  plLine@gsLineColor = colMonth( mon(i)-1 )

  plot@$unique_string("dum")$ = gsn_add_polyline( wks, plot, (/ xbegin, pc1(i) /), (/ybegin, pc2(i)/), plLine)

  if ( label_opt .eq. 0) then
    plmark@gsMarkerColor   = plLine@gsLineColor
    plot@$unique_string("dum")$ = gsn_add_polymarker( wks, plot, xbegin, ybegin, plmark)
  else
    if ( day(i)%label_opt .eq. 0 ) then
      plot@$unique_string("dum")$ = gsn_add_text( wks, plot, day(i)+"", xbegin, ybegin, txres)
    else
      plmark@gsMarkerColor = plLine@gsLineColor
      plot@$unique_string("dum")$ = gsn_add_polymarker( wks, plot, xbegin, ybegin, plmark)
    end if
  end if

if (boolmovie .eq. True) then
  print("draw a page "+(i+1)+"..")
  draw(plot)
  frame(wks)
else

end if

  xbegin = pc1(i)
  ybegin = pc2(i)

end do

if ( boolmovie .eq. False) then
  print("drawing...")
  draw(plot)
  frame(wks)
end if

end

