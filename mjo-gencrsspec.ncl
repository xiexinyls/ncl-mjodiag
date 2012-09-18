
load "$MJO_CODE/utils/load.ncl"

begin

TARGETDIR=getenv("TARGETDIR")
PLOTDIR=getenv("PLOTDIR")
TEST=getenv("TEST")

latn =  15
lats = -15

infile_p = addfile(TARGETDIR+"/"+TEST+".OLR.anom.noanucyc.nc", "r")
infile_u = addfile(TARGETDIR+"/"+TEST+".U850.anom.noanucyc.nc", "r")

varname_p = "OLR_anom"
varname_u = "U850_anom"

data_p = infile_p->$varname_p$( :, {lats:latn}, :)
data_u = infile_u->$varname_u$( :, {lats:latn}, :)

date_p = ut_calendar(infile_p->time, -2)
date_u = ut_calendar(infile_u->time, -2)

if( .not. all(date_p .eq. date_u) ) then
  print("date mismatch! exitting...")
  exit
end if

if( .not. all(dimsizes(data_p) .eq. dimsizes(data_u)) ) then
  print("data dimension mismatch! exitting...")
  exit
end if

seglen     = 256
segoverlap = -50

stc = mjo_cross(data_p, data_u, seglen, segoverlap, False)

outfile = addfile(TARGETDIR+"/"+TEST+".plot.crsspec.nc", "c")
outfile->stc = stc

end

