
load "$MJO_CODE/utils/load.ncl"

begin

ifplot = True
ifnc   = False

WORKDIR = getenv("WORKDIR")
TEST    = getenv("TEST")
YEARST  = getenv("MODELYEARST")
YEAREND = getenv("MODELYEAREND")

minlat = -5
maxlat =  5

var = "Q"
varanom = var+"_anom"

ifn  = TEST+"."+var+".anom.noanucyc.nc"
ifpn = TEST+".PMID.nc"

ifile  = addfile(WORKDIR+"/"+TEST+".raw.ext/"+ifn, "r")
ifilep = addfile(WORKDIR+"/"+TEST+".raw.ext/"+ifpn, "r")

x     = ifile->$varanom$(time|:, lev|:, {lat|minlat:maxlat}, lon|:)
ntime = dimsizes(x&time)
pin   = ifilep->PMID(time|0:ntime-1, lev|:, {lat|minlat:maxlat}, lon|:)

pout = fspan(300, 1000, 29)
pout@units = "hPa"
pout@long_name = "pressure"

printVarSummary(pin)
printVarSummary(x)
print( pout )

y = int2p_n( pin, x, pout, 2, 1)

y!0 = "time"
y!1 = "lev"
y!2 = "lat"
y!3 = "lon"
y&time = x&time
y&lev  = pout
y&lat  = x&lat
y&lon  = x&lon

of = addfile(WORKDIR+"/"+TEST+".raw.ext/"+TEST+"."+var+".pf.nc", "c")
of->Q = y

end

