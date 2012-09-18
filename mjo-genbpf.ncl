
load "$MJO_CODE/utils/load.ncl"

;------------------------------------------------------
; A NCL data-processing script by Xin XIE
; This script is used to generate band-pass filtered data
; NC data for plotting.
; A 20-100 day BPF is used.
;------------------------------------------------------

begin

WORKDIR = getenv("WORKDIR")
TEST    = getenv("TEST")
YEARST  = getenv("MODELYEARST")
YEAREND = getenv("MODELYEAREND")

ifnvar = TEST+"."+var+".anom.noanucyc.nc"

ifilevar = addfile(WORKDIR+"/"+TEST+".raw.ext/"+ifnvar, "r")

print("read in "+var+" data...")
;read the data.
nvar = var+"_anom"

vardata = ifilevar->$nvar$

;get time info.
time = ut_calendar(vardata&time, 0)
year = time(:, 0)
ntime  = dimsizes(year)
oyrstrt = year(0)
oyrlast = year(ntime-1)
nyrstrt = oyrstrt+1
nyrlast = oyrlast-1
timeind = ind( (year .ge. nyrstrt) .and. (year .le. nyrlast) )

;create a BandPass Filter
ihp   = 2       ; type of filter, here bandpass.
nwgt  = 201
sigma = 1.      ; power of the sigma factor.
fca   = 1./100. ; assign the pass lower bound.
fcb   = 1./20.  ; assign the pass upper bound.
wgt   = filwgts_lanczos(nwgt, ihp, fca, fcb, sigma)

;apply the filter
print("doing the bandpass filtering...")
if (var .eq. "Q") then
  varBPFtmp = wgt_runave_Wrap( vardata( lev|:, lat|:, lon|:, time|:), wgt, 0)
  varBPF    = varBPFtmp(time|timeind, lev|:, lat|:, lon|:)
else
  varBPFtmp = wgt_runave_Wrap( vardata( lat|:, lon|:, time|:), wgt, 0)
  varBPF    = varBPFtmp(time|timeind, lat|:, lon|:)
end if
;printVarSummary(varBPF )

;output the bandpass filtered data.
ofnvar = TEST+"."+var+".anom.noanucyc.bpf.nc"
;output the bandpass filtered data.
ofvarbpf = addfile(WORKDIR+"/"+TEST+".raw.ext/"+ofnvar , "c")
ofnvar = var+"_anom_bpf"
ofvarbpf->$ofnvar$ = varBPF

end

