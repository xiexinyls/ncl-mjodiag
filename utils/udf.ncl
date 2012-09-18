;===============================================================================
;                         COORDS
;===============================================================================
;  =**************************=
;  =     JUST NAME COORDS     =                    
;  =**************************=

undef("namecoordsTLL")
procedure namecoordsTLL(array_in:numeric)
begin
  array_in!0       = "time"
  array_in!1       = "lat"
  array_in!2       = "lon"
end

undef("namecoordsTDLL")
procedure namecoordsTDLL(array_in:numeric)
begin
  array_in!0       = "time"
  array_in!1       = "dep"
  array_in!2       = "lat"
  array_in!3       = "lon"
end

undef("namecoordsTDLat")
procedure namecoordsTDLat(array_in:numeric)
begin
  array_in!0       = "time"
  array_in!1       = "dep"
  array_in!2       = "lat"
end

undef("namecoordsTDLon")
procedure namecoordsTDLon(array_in:numeric)
begin
  array_in!0       = "time"
  array_in!1       = "dep"
  array_in!2       = "lon"
end

undef("namecoordsTPLL")
procedure namecoordsTPLL(array_in:numeric)
begin
  array_in!0       = "time"
  array_in!1       = "plv"
  array_in!2       = "lat"
  array_in!3       = "lon"
end

undef("namecoordsTPLat")
procedure namecoordsTPLat(array_in:numeric)
begin
  array_in!0       = "time"
  array_in!1       = "plv"
  array_in!2       = "lat"
end

undef("namecoordsTPLon")
procedure namecoordsTPLon(array_in:numeric)
begin
  array_in!0       = "time"
  array_in!1       = "plv"
  array_in!2       = "lon"
end

undef("namecoordsLatLon")
procedure namecoordsLatLon(array_in:numeric)
begin
  array_in!0       = "lat"
  array_in!1       = "lon"
end

;  =********************************=
;  =    ADD ATTRIBUTS TO COORDS     =
;  =********************************=

undef("addcoordsTLL")
procedure addcoordsTLL(array_in:numeric,time:numeric,\
                        lat:numeric,lon:numeric)
begin
  array_in!0                  = "time"
  array_in&time               = time
  array_in&time@long_name     = "time"
  array_in&time@standard_name = "time"
  array_in&time@axis          = "T"
  array_in&time@calendar      = "standard"  
  array_in&time@bounds        = "time_bnds"
  array_in!1                  = "lat"
  array_in&lat                = lat
  array_in&lat@units          = "degrees_north"
  array_in&lat@long_name      = "latitude"
  array_in&lat@axis           = "Y" 
  array_in&lat@bounds         = "lat_bnds"
  array_in!2                  = "lon"
  array_in&lon                = lon
  array_in&lon@units          = "degrees_east"
  array_in&lon@long_name      = "longitude" 
  array_in&lon@axis           = "X" 
  array_in&lon@bounds         = "lon_bnds"
end


undef("addcoordsTDLL")
procedure addcoordsTDLL(array_in:numeric,time:numeric,dep:numeric,\
                                        lat:numeric,lon:numeric)
begin
  array_in!0                  = "time"
  array_in&time               = time
  array_in&time@long_name     = "time"
  array_in&time@standard_name = "time"
  array_in&time@axis          = "T"
  array_in&time@calendar      = "standard"  
  array_in&time@bounds        = "time_bnds"
  array_in!1                  = "dep"
  array_in&dep                = dep
  array_in&dep@units          = "meters" 
  array_in&dep@positive       = "down"
  array_in&dep@long_name      = "Depth"
  array_in!2                  = "lat"
  array_in&lat                = lat
  array_in&lat@units          = "degrees_north"
  array_in&lat@long_name      = "latitude"
  array_in&lat@axis           = "Y" 
  array_in&lat@bounds         = "lat_bnds"
  array_in!3                  = "lon"
  array_in&lon                = lon
  array_in&lon@units          = "degrees_east"
  array_in&lon@long_name      = "longitude" 
  array_in&lon@axis           = "X" 
  array_in&lon@bounds         = "lon_bnds"
end

undef("addcoordsTDLat")
procedure addcoordsTDLat(array_in:numeric,time:numeric,\
                               dep:numeric,lat:numeric)
begin
  array_in!0                  = "time"
  array_in&time               = time
  array_in&time@long_name     = "time"
  array_in&time@standard_name = "time"
  array_in&time@axis          = "T"
  array_in&time@calendar      = "standard"  
  array_in&time@bounds        = "time_bnds"
  array_in!1                  = "dep"
  array_in&dep                = dep
  array_in&dep@units          = "meters" 
  array_in&dep@positive       = "down"
  array_in&dep@long_name      = "Depth"
  array_in!2                  = "lat"
  array_in&lat                = lat
  array_in&lat@units          = "degrees_north"
  array_in&lat@long_name      = "latitude"
  array_in&lat@axis           = "Y" 
  array_in&lat@bounds         = "lat_bnds"
end

undef("addcoordsTDLon")
procedure addcoordsTDLon(array_in:numeric,time:numeric,\
                                dep:numeric,lon:numeric)
begin
  array_in!0                  = "time"
  array_in&time               = time
  array_in&time@long_name     = "time"
  array_in&time@standard_name = "time"
  array_in&time@axis          = "T"
  array_in&time@calendar      = "standard"  
  array_in&time@bounds        = "time_bnds"
  array_in!1                  = "dep"
  array_in&dep                = dep
  array_in&dep@units          = "meters" 
  array_in&dep@positive       = "down"
  array_in&dep@long_name      = "Depth"
  array_in!2                  = "lon"
  array_in&lon                = lon
  array_in&lon@units          = "degrees_east"
  array_in&lon@long_name      = "longitude" 
  array_in&lon@axis           = "X" 
  array_in&lon@bounds         = "lon_bnds"
end

undef("addcoordsTPLL")
procedure addcoordsTPLL(array_in:numeric,time:numeric,\
                     plv:numeric,lat:numeric,lon:numeric)
begin
  array_in!0                  = "time"
  array_in&time               = time
  array_in&time@long_name     = "time"
  array_in&time@standard_name = "time"
  array_in&time@axis          = "T"
  array_in&time@calendar      = "standard"  
  array_in&time@bounds        = "time_bnds"
  array_in!1                  = "plv"
  array_in&plv                = plv
  array_in&plv@standard_name  = "air_pressure" ;
  array_in&plv@long_name      = "pressure" ;
  array_in&plv@units          = "hPa" ;
  array_in&plv@axis           = "Z" ;
  array_in&plv@positive       = "down"
  array_in!2                  = "lat"
  array_in&lat                = lat
  array_in&lat@units          = "degrees_north"
  array_in&lat@long_name      = "latitude"
  array_in&lat@axis           = "Y" 
  array_in&lat@bounds         = "lat_bnds"
  array_in!3                  = "lon"
  array_in&lon                = lon
  array_in&lon@units          = "degrees_east"
  array_in&lon@long_name      = "longitude" 
  array_in&lon@axis           = "X" 
  array_in&lon@bounds         = "lon_bnds"
end

undef("addcoordsTPLat")
procedure addcoordsTPLat(array_in:numeric,time:numeric,\
                                 plv:numeric,lat:numeric)
begin
  array_in!0                  = "time"
  array_in&time               = time
  array_in&time@long_name     = "time"
  array_in&time@standard_name = "time"
  array_in&time@axis          = "T"
  array_in&time@calendar      = "standard"  
  array_in&time@bounds        = "time_bnds"
  array_in!1                  = "plv"
  array_in&plv                = plv
  array_in&plv@standard_name  = "air_pressure" ;
  array_in&plv@long_name      = "pressure" ;
  array_in&plv@units          = "Pa" ;
  array_in&plv@axis           = "Z" ;
  array_in&plv@positive       = "down"
  array_in!2                  = "lat"
  array_in&lat                = lat
  array_in&lat@units          = "degrees_north"
  array_in&lat@long_name      = "latitude"
  array_in&lat@axis           = "Y" 
  array_in&lat@bounds         = "lat_bnds"
end

undef("addcoordsTPLon")
procedure addcoordsTPLon(array_in:numeric,time:numeric,\
                             plv:numeric ,lon:numeric)
begin
  array_in!0                  = "time"
  array_in&time               = time
  array_in&time@long_name     = "time"
  array_in&time@standard_name = "time"
  array_in&time@axis          = "T"
  array_in&time@calendar      = "standard"  
  array_in&time@bounds        = "time_bnds"
  array_in!1                  = "plv"
  array_in&plv                = plv
  array_in&plv@standard_name  = "air_pressure" ;
  array_in&plv@long_name      = "pressure" ;
  array_in&plv@units          = "Pa" ;
  array_in&plv@axis           = "Z" ;
  array_in&plv@positive       = "down"
  array_in!2                  = "lon"
  array_in&lon                = lon
  array_in&lon@units          = "degrees_east"
  array_in&lon@long_name      = "longitude" 
  array_in&lon@axis           = "X" 
  array_in&lon@bounds         = "lon_bnds"
end

undef("addcoordsLatLon")
procedure addcoordsLatLon(array_in:numeric,lat:numeric ,lon:numeric)
begin
  array_in!0                  = "lat"
  array_in&lat                = lat
  array_in&lat@standard_name  = "latitude" ;
  array_in&lat@long_name      = "latitude" ;
  array_in&lat@units          = "degrees_north"
  array_in&lat@axis           = "Y"
  array_in!1                  = "lon"
  array_in&lon                = lon
  array_in&lon@units          = "degrees_east"
  array_in&lon@long_name      = "longitude"
  array_in&lon@axis           = "X"
  array_in&lon@bounds         = "lon_bnds"
end


;===============================================================================
;  =******************************=
;  =    Remove seasonal cycle     =
;  =******************************=
undef("rmscTLL")
procedure rmscTLL(array_in:numeric)
begin
;  print(" Remove seasonal cycle:" )    
  array_monmean     = clmMonTLL(array_in)
  array_in          = (/calcMonAnomTLL(array_in,array_monmean)/)
  delete(array_monmean)
end

undef("rmscLLT")
procedure rmscLLT(array_in:numeric)
begin
;  print(" Remove seasonal cycle:" )    
  array_monmean     = clmMonLLT(array_in)
  array_in          = (/calcMonAnomLLT(array_in,array_monmean)/)
  delete(array_monmean)
end

undef("rmscTLLL")
procedure rmscTLLL(array_in:numeric)
begin
;  print(" Remove seasonal cycle:" )    
;  printVarSummary(array_in)
  array_monmean     = clmMonTLLL(array_in)
  array_in          = (/calcMonAnomTLLL(array_in,array_monmean)/)
  delete(array_monmean)
end

undef("rmscLLLT")
procedure rmscLLLT(array_in:numeric)
begin
;  print(" Remove seasonal cycle:" )    
  array_monmean     = clmMonLLLT(array_in)
  array_in          = (/calcMonAnomLLLT(array_in,array_monmean)/)
  delete(array_monmean)
end

undef("rmscTx")
procedure rmscTx (array_in:numeric)
local ndims, array_monmean
begin
  ndims               = dimsizes(dimsizes(array_in))
  if ( ndims .eq. 4 ) then
    array_monmean     = clmMonTLLL(array_in)
    array_in          = (/calcMonAnomTLLL(array_in,array_monmean)/)
    delete(array_monmean)
  else
    if ( ndims .eq. 3 ) then
      array_monmean     = clmMonTLL(array_in)
      array_in          = (/calcMonAnomTLL(array_in,array_monmean)/)
      delete(array_monmean)
    else
      print("There is no routine for dims != 3 or 4")
    end if
  end if
end
;===============================================================================
;                       RESOURCES
;===============================================================================
undef("notmYL")
procedure notmYR(res:logical)
begin
    res@tmYROn               = False
    res@tmYRLabelsOn         = False
end

undef("res_nice_1")
procedure res_nice_1(res:logical,array_in:numeric,num:numeric)
begin
  max_data = max(array_in)
  min_data = min(array_in)
  mnmxint  = nice_mnmxintvl(min_data,max_data,num,True)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = mnmxint(0)
  res@cnMaxLevelValF       = mnmxint(1)
  res@cnLevelSpacingF      = mnmxint(2)
end

undef("ExpLinearTrY")
procedure ExpLinearTrY(res:logical,Yb:numeric,Ye:numeric,pnt:numeric)
local  yaxis
begin
  res@trYMinF         = 1.0*Yb
  res@trYMaxF         = 1.0*Ye
  yaxis               = new((2),"float")
  yaxis(0)            = 1.0*Yb
  yaxis(1)            = 1.0*Ye
  
end

undef("ExpLinearTrX")
procedure ExpLinearTrX(res:logical,Xb:numeric,Xe:numeric,pnt:numeric)
local  xaxis
begin
  res@trXMinF         = Xb
  res@trXMaxF         = Xe
  xaxis               = new((2),"float")
  xaxis(0)            = Xb
  xaxis(1)            = Xe
 
end

undef("res_nice")
procedure res_nice(res:logical,array_in:numeric,num:numeric)
local point
begin
;  printVarSummary(array_in)
  max_data = max(array_in)
  min_data = min(array_in)
  point    = max_data/(min_data+0.0001)
;  print(max_data)
  if ( (point .lt. -0.2).and. ( point .gt.  -5.0) ) then
    minf   = -max( (/-min_data,max_data/))
    maxf   = -minf
  else
    minf   = min_data
    maxf   = max_data
  end if
  data_tmp = array_in
  printVarSummary(data_tmp)
;  nnum     = num( .not. ismissing( data_tmp ) )
;  nnum2    = nnum
;  nint     = (maxf-minf)/(3*num)
;  do while ( nnum2 .gt. 0.9*nnum )
;    data_tmp = where( data_tmp .gt. (maxf-nint) .and. data_tmp .lt. (minf+nint),\
;                                                data_tmp@_FillValue, data-tmp  )
;    nnum2  = num( .not.ismissing( data_tmp ) )
;    maxf   = maxf-nint
;    minf   = minf+nint
;  end do
  mnmxint  = nice_mnmxintvl(minf,maxf,num,True)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = mnmxint(0)
  res@cnMaxLevelValF       = mnmxint(1)
  res@cnLevelSpacingF      = mnmxint(2)
end    
 

undef("exabs2FillValue")
procedure exabs2FillValue(array_in:numeric,num:numeric)
local  array1d,dims
begin
  dims     =  dimsizes(array_in)
  array1d  = ndtooned(array_in)
  if ( max(abs(array1d)).gt.num  )then
    print("Remove data exceed num")
    array1d(ind(abs(array1d).gt.num)) = array_in@_FillValue
  end if
  array_in = (/onedtond(array1d,dims)/)
end 

undef("rmgtnyr")
procedure rmgtnyr3d(array_in:numeric,nave:numeric,nopt:numeric)
local array_temp
begin
  array_temp    = runave_Wrap(array_in,nave,nopt)
  array_in      = (/array_in-array_temp/)
  delete(array_temp)
end  
 

;=============================================================================
;===                           LLinDOMAIN                                  ===
;=============================================================================
undef("LLinDOMAIN")
procedure LLinDOMAIN ( string_in:string,lats:numeric,latn:numeric, \
                                       lonw:numeric,lone:numeric )
begin
  if ( string_in .eq. "NINO3+4" ) then
    lats     = -5.0
    latn     = 5.0
    lonw     = 150
    lone     = 250
  end if
;
  if ( string_in .eq. "TPAC" ) then
    lats     = -30.
    latn     = 30.
    lonw     = 120.
    lone     = 300.
  end if
;
  if ( string_in .eq. "CT" ) then
    lats     = -5. 
    latn     = 5. 
    lonw     = 160. 
    lone     = 290. 
  end if

end


undef("add_annotation")
procedure add_annotation(wks:graphic,plot:graphic,res:logical,legends:string,nx:numeric)
local xyLT,xyDP, xyLC, xtMK, xyMC, nan, ncol, xmax, xb, xe,yb,xPoseF,poseV, \
      xyLT2,xyDP2, xyLC2, xtMK2, xyMC2,icol, irow
begin
    nan    = dimsizes(legends)
    xyLT   = res@xyLineThicknesses       ; thicker line
    xyDP   = res@xyDashPatterns        
    xyLC   = res@xyLineColors          
    xb     = res@vpXF
    xwidth = res@vpWidthF 
    yb     = res@vpYF-res@vpHeightF  
 
    if ( res@xyMarkLineMode .eq. "MarkLines" ) then
      xyMK =  res@xyMarkers              ; ifferent markers
      xyMC =  res@xyMarkerColors  
    end if
    
    if ( nx .lt. 2 ) then
      xmax   = 6
    else 
      if ( nx .lt. 3 ) then
        xmax   = 5
      else
        if ( nx .lt. 4 ) then
          xmax   = 4
        else  
          xmax   = 2
        end if
      end if
    end if

    if ( nan .lt. xmax+1 )then
      nrow   = 1
    else
      if ( nan .lt. 2*xmax+1 )
        nrow   = 2
      else
        nrow   = 3
      end if
    end if
    ncol       = (nan+nrow-1)/nrow
 
    xPoseF   = fspan(-xwidth*ncol/9.0,xwidth*ncol/9.0,ncol)
    poseV    = 3.0
;Legends
    lgres                     = True
    lgres@vpWidthF            = 0.16
    lgres@vpHeightF           = 0.08
    lgres@lgPerimOn           = False
    lgres@lgLineLabelStrings  = (/"",""/)
    lgres@lgLabelFontHeightF  = 0.012 

    do icol  = 0, ncol-1      
      if ( (icol+1)*nrow .lt. nan+1 ) then
        xyLT2      = xyLT(icol*nrow:(icol+1)*nrow-1)
        xyDP2      = xyDP(icol*nrow:(icol+1)*nrow-1)
        xyLC2      = xyLC(icol*nrow:(icol+1)*nrow-1)
        if ( isatt(res,"xyMarkLineMode") ) then
          if ( res@xyMarkLineMode .eq. "MarkLines") then
            xyMK2    = xyMK(icol*nrow:(icol+1)*nrow-1)
            xyMC2    = xyMC(icol*nrow:(icol+1)*nrow-1)
          end if
        end if
        LGD        = legends(icol*nrow:(icol+1)*nrow-1)
      else
        xyLT2      = xyLT(icol*nrow-1:(icol+1)*nrow-2)
        xyDP2      = xyDP(icol*nrow-1:(icol+1)*nrow-2)
        xyLC2      = xyLC(icol*nrow-1:(icol+1)*nrow-2)
        if ( isatt(res,"xyMarkLineMode") ) then
          if ( res@xyMarkLineMode .eq. "MarkLines") then
            xyMK2    = xyMK(icol*nrow-1:(icol+1)*nrow-2)
            xyMC2    = xyMC(icol*nrow-1:(icol+1)*nrow-2)
            xyMK2(0) = 0
            xyMC2(0) = "white"
          end if
        end if
        LGD        = "      "+legends(icol*nrow-1:(icol+1)*nrow-2)
        xyLT2(0)   = 0.0
        xyDP2(0)   = 0
        xyLC2(0)   = "Transparent"
        LGD(0)     = ""
      end if

      lgres@lgLabelFontHeightF = 0.06 
      lgres@lgDashIndexes      = xyDP2 
      lgres@lgLineThicknessF   = xyLT2
      lgres@lgLineColors       = xyLC2
      if ( isatt(res,"xyMarkLineMode") ) then
;        print("get xyMarkLineMode")
        if ( res@xyMarkLineMode .eq. "MarkLines") then
          lgres@lgMarkerIndexes    = xyMK2
          lgres@lgMarkerColors     = xyMC2
          lgres@lgItemType         = res@xyMarkLineMode
          lgres@lgMarkerSizeF      = res@xyMarkerSizeF/2.2
        end if
      end if
;      print(lgres)
;      print(nrow)
;      print(LGD)
      lbid14 = gsn_create_legend(wks,nrow,LGD,lgres)

      am4res = True
      am4res@amParallelPosF   = xPoseF(icol)		       ; move legend to the right
      am4res@amOrthogonalPosF = (poseV-yb)/3                 ; move the legend down     
      annoid4 = gsn_add_annotation(plot,lbid14,am4res)         ; add legend to plot 
    end do

end

