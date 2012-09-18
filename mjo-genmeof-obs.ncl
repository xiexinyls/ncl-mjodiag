
load "$MJO_CODE/utils/load.ncl"

begin

TARGETDIR=getenv("TARGETDIR")
OBSDIR=getenv("OBSDIR")
PLOTDIR=getenv("PLOTDIR")
TEST=getenv("TEST")
OBS=getenv("OBS")

varstrs = (/"OLR", "U850", "U200"/)

latn =  15
lats = -15

infile_olr    = addfile(TARGETDIR+"/"+TEST+"."+varstrs(0)+".anom.noanucyc.nc", "r")
infile_u850   = addfile(TARGETDIR+"/"+TEST+"."+varstrs(1)+".anom.noanucyc.nc", "r")
infile_u200   = addfile(TARGETDIR+"/"+TEST+"."+varstrs(2)+".anom.noanucyc.nc", "r")
infile_obseof = addfile(OBSDIR+"/"+OBS+".plot.meof.nc","r")

varname_olr  = varstrs(0)+"_anom"
varname_u850 = varstrs(1)+"_anom"
varname_u200 = varstrs(2)+"_anom"

data_olr  = infile_olr->$varname_olr$( :, {lats:latn}, :)
data_u200 = infile_u200->$varname_u200$( :, {lats:latn}, :)
data_u850 = infile_u850->$varname_u850$( :, {lats:latn}, :)

date_olr  = ut_calendar(infile_olr->time, -2)
date_u200 = ut_calendar(infile_u200->time, -2)
date_u850 = ut_calendar(infile_u850->time, -2)

if( .not. (all(date_olr .eq. date_u200) .and. all(date_u200 .eq. date_u850)) ) then
  print("date mismatch! exitting...")
  exit
end if

if( .not. (all(dimsizes(data_olr) .eq. dimsizes(data_u200)) .and. all(dimsizes(data_u200) .eq. dimsizes(data_u850) )) ) then
  print("data dimension mismatch! exitting...")
  exit
end if

time = infile_olr->time
lon  = infile_olr->lon
timeinfo = ut_calendar(time, 0)
year = timeinfo(:,0)
ntim = dimsizes(time)
nlon = dimsizes(lon)
oldyearstrt = year(0)
oldyearlast = year(ntim-1)
newyearstrt = oldyearstrt+1
newyearlast = oldyearlast-1
timeind = ind( (year .ge. newyearstrt) .and. (year .le. newyearlast) )
newntim = dimsizes(timeind)
newtime = time(timeind)

;computing the meridianal mean.
data_olr_merimean  = dim_avg_Wrap( data_olr(  time|:, lon|:, lat|:) )
data_u200_merimean = dim_avg_Wrap( data_u200( time|:, lon|:, lat|:) )
data_u850_merimean = dim_avg_Wrap( data_u850( time|:, lon|:, lat|:) )

print("filterring and averaging...")
;choose a bandpass filter.
ihp   = 2
nwgt  = 201
sigma = 1.0
fca   = 1./100.
fcb   = 1./20.
wgt   = filwgts_lancos(nwgt, ihp, fca, fcb, sigma)

;apply the filter to the time series.
data_olr_tmp  = wgt_runave_Wrap( data_olr_merimean(  lon|:, time|:), wgt, 0)
data_u200_tmp = wgt_runave_Wrap( data_u200_merimean( lon|:, time|:), wgt, 0)
data_u850_tmp = wgt_runave_Wrap( data_u850_merimean( lon|:, time|:), wgt, 0)

print("extracted "+newyearstrt+"-"+newyearlast+" from "+oldyearstrt+"-"+oldyearlast+"...")
data_olr_merimeanbpf  = data_olr_tmp(  lon|:, time|timeind)
data_u200_merimeanbpf = data_u200_tmp( lon|:, time|timeind)
data_u850_merimeanbpf = data_u850_tmp( lon|:, time|timeind)

data_olr_merimeanbpf  = dim_rmvmean(data_olr_merimeanbpf)
data_u200_merimeanbpf = dim_rmvmean(data_u200_merimeanbpf)
data_u850_merimeanbpf = dim_rmvmean(data_u850_merimeanbpf)

;compute the variance
var_olr  = dim_variance_Wrap( data_olr_merimeanbpf )
var_u200 = dim_variance_Wrap( data_u200_merimeanbpf  )
var_u850 = dim_variance_Wrap( data_u850_merimeanbpf  )

zavg_var_olr  = dim_avg_Wrap( var_olr)
zavg_var_u200 = dim_avg_Wrap( var_u200 )
zavg_var_u850 = dim_avg_Wrap( var_u850 )

data_olr_merimeanbpf  = data_olr_merimeanbpf/sqrt(zavg_var_olr)
data_u200_merimeanbpf = data_u200_merimeanbpf/sqrt(zavg_var_u200)
data_u850_merimeanbpf = data_u850_merimeanbpf/sqrt(zavg_var_u850)

;preparing for multi-variable fields.
print("preparing for multi-variable fields...")
nvar = 3
cdata = new( (/nvar, nlon, newntim/), typeof(data_olr), getFillValue(data_olr) )
cdata!0 = "var"
cdata(0, :, :) = data_olr_merimeanbpf
cdata(1, :, :) = data_u850_merimeanbpf
cdata(2, :, :) = data_u200_merimeanbpf



;compute the EOF PC and time coefficients.
print("compute the time series based on OBS EOF...")
neof = 3
eof_cdata    = infile_obseof->eof_cdata
eof_ts_cdata = eofunc_ts_Wrap( cdata, eof_cdata, False)

;extract each var from the multi-variable results.
nvar = 3
;ceof = new( (/nvar, neof, nlon/), typeof(cdata), getFillValue(cdata) )
ceof = eof_cdata( var|:, evn|:, lon|:)

print("compute the time series for individual variable based on OBS...")
;extract the real EOF time series.
olr_merimeanbpf_ts  = eofunc_ts_Wrap( data_olr_merimeanbpf, ceof(0, :, :), False)
u850_merimeanbpf_ts = eofunc_ts_Wrap( data_u850_merimeanbpf , ceof(1, :, :), False)
u200_merimeanbpf_ts = eofunc_ts_Wrap( data_u200_merimeanbpf , ceof(2, :, :), False)



;standardize the time series for both EOF1 and EOF2
eof_ts_cdata_std = eof_ts_cdata
eof_ts_cdata_std(0, :) = eof_ts_cdata(0, :)/stddev(eof_ts_cdata(0,:))
eof_ts_cdata_std(1, :) = eof_ts_cdata(1, :)/stddev(eof_ts_cdata(1,:))

;a MJO index is calculated
mjo_ts_index     = eof_ts_cdata_std(0,:)^2 + eof_ts_cdata_std(1,:)^2
mjo_ts_index_smt = runave(mjo_ts_index, 91, 0)

ngood   = num( .not.ismissing(mjo_ts_index) )
nstrong = num( mjo_ts_index .ge. 1.0)
print("ngood="+ngood+"  nstrong="+nstrong+"  nother="+(ngood-nstrong) )

mjo_ts_index!0    = "time"
mjo_ts_index&time = newtime
mjo_ts_index@long_name = "MJO PC INDEX"
mjo_ts_index@info      = "(PC1^2+PC2^2)"

pc1     = eof_ts_cdata(0, :)
pc1!0   = "time"
pc1&time      = newtime
pc1@long_name = "PC1"
pc1@info      = "PC1/stddev(PC1)"

pc2     = eof_ts_cdata(1, :)
pc2!0   = "time"
pc2&time      = newtime
pc2@long_name = "PC2"
pc2@info      = "PC2/stddev(PC2)"



print("computing the cross correlation...")
;compute the zero-lag cross-correlation
;for individual-variable time series.
r_olr_u850 = escorc( olr_merimeanbpf_ts, u850_merimeanbpf_ts )
r_olr_u200 = escorc( olr_merimeanbpf_ts, u850_merimeanbpf_ts )
r_u850_u200  = escorc( u850_merimeanbpf_ts , u200_merimeanbpf_ts )

;compute the cross correlation of the MEOF; EOF 1 vs EOF 2.
print("computing the correlation...")
mxlag = 25
rlag_01 = esccr( pc1, pc2, mxlag)
rlag_10 = esccr( pc2, pc1, mxlag)

ccr_12  = new( (/2*mxlag+1/), float)
ccr_12(mxlag:)  = rlag_10(0:mxlag)
ccr_12(0:mxlag) = rlag_01(::-1)
ccr_12@long_name = "Correlation"
ccr_12!0 = "lagday"
ccr_12&lagday = ispan(-mxlag, mxlag, 1)
ccr_12&lagday@long_name = "Lag (day)"



;output to two nc files.
print("output "+TEST+".plot.meofts-obs.nc...")
outputdir = PLOTDIR
ofnts  = TEST+".plot.meofts-obs.nc"

outfts  = addfile(TARGETDIR+"/"+ofnts , "c")
outfts->eof_ts_cdata = eof_ts_cdata
outfts->eof_ts_cdata_std = eof_ts_cdata_std
outfts->mjo_index  = mjo_ts_index
outfts->pc1 = pc1
outfts->pc2 = pc2
outfts->olr_merimeanbpf_ts = olr_merimeanbpf_ts
outfts->u850_merimeanbpf_ts  = u850_merimeanbpf_ts
outfts->u200_merimeanbpf_ts  = u200_merimeanbpf_ts
outfts->ccr_12 = ccr_12

outfts->r_olr_u850  = r_olr_u850
outfts->r_olr_u200  = r_olr_u200
outfts->r_u850_u200 = r_u850_u200

end

