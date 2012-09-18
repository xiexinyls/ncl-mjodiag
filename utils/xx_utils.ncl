;-------------------------------------------------------
; Xie Xin's NCL Utility
;-------------------------------------------------------

;-------------------------------------------------------
; Function to calculate the smoothing average
;-------------------------------------------------------
; Input Arguments:
; input: 1D numeric arrary
; start: the starting position, count from 1!!!
; finish: the end position
; length: smoothing run length
;-------------------------------------------------------

undef("smoothavg")
function smoothavg(input:numeric, start:numeric, finish:numeric, length:numeric)

local output, i, size

begin
  outputsize = finish - start + 1
  output = new((/outputsize/), typeof(input)) ; allocate for the output
  do i = start, finish
    output(i-start) = avg(input(i-length:i-1))
  end do
  return output
end


;-------------------------------------------------------
; Function to set view resource given x/y ratio.
;-------------------------------------------------------
; Input Arguments:
; input: resource needed to be modified.
; ratio; X/Y ratio.
;-------------------------------------------------------
undef("setviewratio")
procedure setviewratio(res:logical, ratio:numeric, ifmap:logical)
begin
if(ifmap .eq. True) then
  res@mpShapeMode = "FreeAspect"
end if
if(ratio .gt. 1) then
  res@vpWidthF = 0.8
  res@vpHeightF = 0.8/ratio
  res@vpXF = 0.1
  res@vpYF = 1 - (1 - res@vpHeightF)/2.0
else
  res@vpHeightF = 0.8
  res@vpWidthF = 0.8*ratio
  res@vpXF = (1 - res@vpWidthF)/2.0
  res@vpYF = 0.9
end if
;  res@mpLimitMode = "NDC"
;  res@mpLeftNDCF = res@vpXF
;  res@mpRighetNDCF = res@vpXF+res@vpWidthF
;  res@mpTopNDCF = res@vpYF
;  res@mpBottomNDCF = res@vpYF+res@vpHeightF
end
