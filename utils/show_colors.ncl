;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   
;************************************************
begin
; replace amwg.rgb with your own rgb file
 wks = gsn_open_wks("x11","rgb")            
 cmap = RGBtoCmap("/disk1/xiexin/mjo_code/utils/mjocm_18lev.rgb")
 gsn_define_colormap(wks, cmap)
 gsn_draw_colormap(wks)             
end
