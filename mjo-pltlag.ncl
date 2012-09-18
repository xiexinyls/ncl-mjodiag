
load "$MJO_CODE/utils/load.ncl"

;------------------------------------------------------
; A NCL data-processing script by Xin XIE
; This script is used to plot the MJO propogating features.
; NCL MJO function is used.
;------------------------------------------------------

begin

TARGETDIR=getenv("TARGETDIR")
PLOTDIR=getenv("PLOTDIR")
TEST=getenv("TEST")

ifile = addfile(TARGETDIR+"/"+TEST+".plot.lag.nc", "r")

;read in lag correalation for certain season.
ccr_p_laglonbpf_name = "ccr_p_laglonbpf_"+season
ccr_u_laglonbpf_name = "ccr_u_laglonbpf_"+season
ccr_p_laglatbpf_name = "ccr_p_laglatbpf_"+season
ccr_u_laglatbpf_name = "ccr_u_laglatbpf_"+season
ccr_p_laglonbpf = ifile->$ccr_p_laglonbpf_name$
ccr_u_laglonbpf = ifile->$ccr_u_laglonbpf_name$
ccr_p_laglatbpf = ifile->$ccr_p_laglatbpf_name$
ccr_u_laglatbpf = ifile->$ccr_u_laglatbpf_name$

optplot   = True
optplot@colorTable = "mjocm_18lev"

;optplot@panelLabelBaron = False

print("plotting for "+season+"...")
if ( season .eq. "allseason") then
  optplot@txString  = "all season upon "+ifile@nameregion+" ("+TEST+")"
else
  optplot@txString  = season+" upon "+ifile@nameregion+" ("+TEST+")"
end if
print("computing...")
printVarSummary(ccr_p_laglonbpf)
printVarSummary(ccr_u_laglonbpf)
printVarSummary(ccr_p_laglatbpf)
printVarSummary(ccr_u_laglatbpf)
mjo_xcor_lag_ovly_panel( ccr_p_laglonbpf, ccr_u_laglonbpf, ccr_p_laglatbpf, ccr_u_laglatbpf, "ps", PLOTDIR, TEST+"-lag-"+season, optplot)

end

