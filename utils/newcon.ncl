; =====================================
undef("clmDayTLLL")
function clmDayTLLL (x[*][*][*][*]:numeric, yyyyddd:integer)   
;
; calculate the mean Annual Cycle from daily data. 
; The return array will gave the raw climatology at each grid point
;
;              x(time,lev,lat,lon)  <==== input dimension order
;              x!0 = "time"         <==== time is in days
;              x!1 = "lev"
;              x!2 = "lat"
;              x!3 = "lon"
;
;    non-Leap  yyyyddd
;              1905001 =>  Jan  1, 1905
;              1905032 =>  Feb  1, 1905
;              1905059 =>  Feb 28, 1905
;              1905060 =>  Mar  1, 1905
;              1905365 =>  Dec 31, 1905
;
;    Leap
;              1908001 =>  Jan  1, 1908]
;              1908032 =>  Feb  1, 1908]
;              1908059 =>  Feb 28, 1908]
;              1908060 =>  Feb 29, 1908]
;              1908061 =>  Mar  1, 1908]
;              1908366 =>  Dec 31, 1908]
;
; Usage:  xClmDay = clmDAYTLLL (x, yyyyddd)
; -------

local dimx, ntim, klev, nlat, mlon, ndys, days, clmDay, ndy, indx, year_day, nFill
begin

   dimx  = dimsizes (x)

   ntim  = dimx(0)
   klev  = dimx(1)
   nlat  = dimx(2)
   mlon  = dimx(3)
   ndys  = 366                                     ; allow for leap year

   days  = yyyyddd - (yyyyddd/1000)*1000           ; strip year info [yyyy]

   clmDay= new((/ndys,klev,nlat,mlon/),typeof(x), getFillValue(x) ) ; daily climatology
;
; Compute averages for each sequebtial day of the year. 
; This uses dimension swapping.
;
   do ndy=0,ndys-2                                 ; ndy=0->364 ==> day of year 1->365       
      indx = ind( days.eq.(ndy+1) )       
      clmDay(ndy,:,:,:) = dim_avg_n(x(indx,:,:,:), 0)
      delete(indx)                  
   end do
                                                   ; nominal day 366 
                                                   ; ave(31 Dec + 1 Jan)=leap
   clmDay(ndys-1,:,:,:) = (clmDay(0,:,:,:) + clmDay(ndys-2,:,:,:))*0.5

   nFill = num(ismissing(clmDay))
   if (nFill.eq.0) then
       delete(clmDay@_FillValue)
   end if

   clmDay@long_name   = "Daily Climatology"
   if (isatt(x,"long_name")) then
       clmDay@long_name = clmDay@long_name +": "+x@long_name
   end if
   if (isatt(x,"units")) then
       clmDay@units     = x@units
   end if
   clmDay@information = "Raw daily averages across all years"
   clmDay@smoothing   = "None"


   year_day           = ispan(1,ndys,1)
   year_day@long_name = "day of year"
   year_day@units     = "ddd"

   clmDay!0           = "year_day"
   clmDay&year_day    =  year_day
   
   copy_VarCoords(x(0,:,:,:), clmDay(0,:,:,:))   ; trick
   delete(clmDay@year_day)                   ; clean up
 
   return (clmDay)
end



undef("calcDayAnomTLLL")
function calcDayAnomTLLL (x[*][*][*][*]:numeric, yyyyddd:integer, clmDay[*][*][*][*]:numeric)   

; Remove the Annual Cycle from daily data. 
; On return x will consist of deviations from each day's long term mean.
;
;              x(time,lev,lat,lon)  <==== input dimension order
;              x!0 = "time"         <==== time is in days
;              x!1 = "lev"
;              x!2 = "lat"
;              x!3 = "lon"
;
;
;    non-Leap  yyyyddd
;              1905001 =>  Jan  1, 1905
;              1905032 =>  Feb  1, 1905
;              1905059 =>  Feb 28, 1905
;              1905060 =>  Mar  1, 1905
;              1905365 =>  Dec 31, 1905
;
;    Leap
;              1908001 =>  Jan  1, 1908]
;              1908032 =>  Feb  1, 1908]
;              1908059 =>  Feb 28, 1908]
;              1908060 =>  Feb 29, 1908]
;              1908061 =>  Mar  1, 1908]
;              1908366 =>  Dec 31, 1908]

; Usage:  xAnom = calcDayAnomTLLL (x, yyyyddd, clmDay)

local dimx, ntim, klev,nlat, mlon, ndys, days, xAnom, nt
begin

   dimx  = dimsizes (x)

   ntim  = dimx(0)
   klev  = dimx(1)
   nlat  = dimx(2)
   mlon  = dimx(3)
   ndys  = 366                               

   days  = yyyyddd - (yyyyddd/1000)*1000      ; strip year info [yyyy]

; quick check [debug]
  ;if (.not.all(days(0:ndys-2).eq.clmDay&year_day(0:ndys-2))) then
  ;    print("calcDayAnomTLL: day mismatch")
  ;end if

; loop on every day and compute difference. 

   xAnom = (/ x  /)                                 ; create xAnom
   do nt=0,ntim-1
      xAnom(nt,:,:,:) = x(nt,:,:,:) - clmDay(days(nt)-1,:,:,:)   ; -1 for 0-based subscript
   end do

   if (isatt(x,"long_name")) then
       xAnom@long_name = "Anomalies: "+x@long_name
   else
       xAnom@long_name = "Anomalies from Daily Climatology"
   end if
   if (isatt(x,"units")) then
       xAnom@units = x@units
   end if

   copy_VarCoords(x, xAnom)
   return(xAnom)
end
